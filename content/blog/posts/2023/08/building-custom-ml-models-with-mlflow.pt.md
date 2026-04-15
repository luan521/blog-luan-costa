---
title: "Construindo Modelos de ML Customizados com MLFlow"
date: 2023-08-03
description: "Como construir e implantar um modelo MLflow customizado que encapsula um ensemble de stacking do scikit-learn com base learners XGBoost, expondo o predict_proba para um endpoint SageMaker."
authors:
  - name: Luan Costa
---

## Introdução

Neste texto, exploraremos o processo de construção de um modelo de ML customizado usando o MLflow. Inspirados no projeto antifraude do iCarros, discutiremos como o MLflow pode nos ajudar a superar desafios específicos enfrentados durante a implantação de modelos.

No iCarros, desenvolvemos um sofisticado modelo antifraude para garantir a segurança da nossa plataforma. Como parte deste projeto, encontramos desafios ao implantar o modelo em um endpoint SageMaker. Encontramos dois problemas específicos:

1. Acesso à saída do predict_proba: Por padrão, a função log_model do MLflow registra o resultado do método predict. No entanto, no contexto do nosso projeto antifraude, precisávamos acessar o vetor de probabilidades gerado pelo método predict_proba. Para atender a esse requisito, customizamos a implementação do MLflow criando um classificador de stacking customizado, o CustomStackingClassifier. Essa classe estende a classe mlflow.pyfunc.PythonModel e modifica o método predict para retornar as previsões de probabilidade em vez dos rótulos de classe.
2. Combinando as bibliotecas XGBoost e scikit-learn: Nosso modelo antifraude utiliza tanto a biblioteca XGBoost quanto o scikit-learn. No entanto, durante o processo de implantação, encontramos dificuldades ao usar as funções mlflow.sklearn.save_model ou mlflow.xgboost.save_model do MLflow. Embora o modelo funcionasse perfeitamente localmente, enfrentamos problemas com o endpoint implantado. Para resolver esse problema, criamos uma solução alternativa usando a função log_model do MLflow junto com um wrapper de modelo customizado chamado StackingClassifierModelWrapper. Essa classe wrapper estende a classe mlflow.pyfunc.PythonModel e nos permite lidar com o carregamento do modelo customizado e seus artefatos durante a implantação. Com essa abordagem, conseguimos implantar o modelo com sucesso e garantir seu funcionamento correto no ambiente de produção.

## Construindo o Modelo Customizado

Para fornecer um exemplo prático, treinamos o modelo customizado usando o dataset de câncer de mama obtido de sklearn.datasets.load_breast_cancer. Inspirados pelo nosso projeto antifraude do iCarros, construímos um ensemble de stacking composto por três classificadores XGBoost com diferentes hiperparâmetros. O modelo foi treinado usando o StackingClassifier do scikit-learn.

O código responsável pelo treinamento do modelo está localizado no caminho src/train_model.py. Nesse arquivo, implementamos os elementos-chave que abordam efetivamente os desafios mencionados anteriormente. Vamos nos aprofundar nos detalhes desses elementos para melhor compreender como eles resolvem os problemas em questão.

```python
import mlflow
import numpy as np

class CustomStackingClassifier(mlflow.pyfunc.PythonModel):
    def __init__(self, estimators, final_estimator):
        self.estimators = estimators
        self.final_estimator = final_estimator

    def predict(self, context, model_input):
        # Carrega os modelos individuais
        xgb_models = {}
        for name, path in self.estimators.items():
            xgb_models[name] = mlflow.xgboost.load_model(path)

        # Carrega o estimador final
        final_estimator = mlflow.sklearn.load_model(self.final_estimator)
        
        # Realiza as previsões
        # Modelos individuais
        response0 = np.stack(
                             [
                              xgb_models[x].predict_proba(model_input)[:, 1] 
                              for x in xgb_models
                             ], 
                             axis=1
                            )
        # Estimador final
        predictions = final_estimator.predict_proba(response0)

        return predictions

class StackingClassifierModelWrapper(mlflow.pyfunc.PythonModel):
    def load_context(self, context):
        # Carrega o modelo customizado a partir do contexto
        estimators = {
                      'xgb1': context.artifacts["estimator-xgb1"],
                      'xgb2': context.artifacts["estimator-xgb2"],
                      'xgb3': context.artifacts["estimator-xgb3"]
                     }
        final_estimator = context.artifacts["final_estimator"]

        return CustomStackingClassifier(estimators, final_estimator)

    def predict(self, context, model_input):
        model = self.load_context(context)
        return model.predict(context, model_input)
```

Criamos a classe CustomStackingClassifier, estendendo a classe mlflow.pyfunc.PythonModel, para lidar com os desafios enfrentados. Essa classe de modelo customizado nos permite acessar o método predict_proba e combinar modelos de diferentes bibliotecas de forma transparente. Dentro da classe CustomStackingClassifier, carregamos os modelos individuais da biblioteca XGBoost usando a função mlflow.xgboost.load_model. Para o estimador final, carregamos o modelo gerado pelo scikit-learn usando a função mlflow.sklearn.load_model. Ao aproveitar essas funções e customizar a implementação do MLflow, garantimos compatibilidade e integração suave dos modelos empilhados.

Para facilitar o carregamento do modelo customizado dentro do contexto do MLflow, introduzimos a classe StackingClassifierModelWrapper. Estendendo a classe mlflow.pyfunc.PythonModel, essa classe wrapper nos permite recuperar os artefatos necessários do contexto e inicializar uma instância do CustomStackingClassifier. Essa abordagem garante que o classificador de stacking customizado possa ser integrado ao fluxo de trabalho do MLflow de forma transparente, facilitando a implantação e a geração de previsões.

```python
from utils import find_project_path
import shutil
import pandas as pd
from xgboost.sklearn import XGBClassifier
from sklearn.ensemble import StackingClassifier
def train_model():
    project_path = find_project_path()
    mlflow.set_tracking_uri(f'{project_path}/mlruns')
    mlflow.set_experiment('custom-ml')
    with mlflow.start_run(run_name='train_model') as run:
        # Carrega o dataset
        df_train = pd.read_csv(f'{project_path}/dataset/train.csv')
        X_train = df_train.drop(['target'],axis=1)
        y_train = df_train['target']
        
        # Treina o modelo
        stack0 = [
                  (
                   'xgb1', XGBClassifier(
                                         booster='gbtree', 
                                         objective='binary:logistic', 
                                         tree_method='hist', 
                                         max_depth=10, 
                                         random_state=61
                                        )
                  ),
                  (
                   'xgb2', XGBClassifier(
                                         booster='gbtree', 
                                         objective='binary:logistic', 
                                         tree_method='hist', 
                                         max_depth=8, 
                                         random_state=61
                                        )
                  ),
                  (
                   'xgb3', XGBClassifier(
                                         booster='gbtree', 
                                         objective='binary:logistic', 
                                         tree_method='hist', 
                                         max_depth=6, 
                                         random_state=61
                                        )
                  )
                 ]
        model0 = StackingClassifier(estimators=stack0, cv=3)
        model = model0.fit(X_train, y_train)
        
        # Salva os artefatos
        artifacts = {}
        # Salva os modelos classificadores XGBoost
        for n, m in model.named_estimators_.items():
            path = f"{project_path}/artifacts/{n}"
            artifacts[f'estimator-{n}'] = path
            mlflow.xgboost.save_model(m, path)
        # Salva o estimador final (modelo sklearn)
        path = f"{project_path}/artifacts/final_estimator"
        artifacts['final_estimator'] = path
        mlflow.sklearn.save_model(model.final_estimator_, path)
        
        # Registra o modelo final
        model_wrapper = StackingClassifierModelWrapper()
        mlflow.pyfunc.log_model(
                                artifact_path='custom-ml',
                                python_model=model_wrapper,
                                artifacts=artifacts,
                                code_path=[f'{project_path}/src/custom_stacking_classifier.py'],
                                conda_env=f'{project_path}/conda.yaml'
                               )
        
        # Remove os artefatos na raiz do projeto
        shutil.rmtree(f'{project_path}/artifacts')
        
        # Acessa run_id e experiment_id
        run_id = run.info.run_uuid
        experiment_id = run.info.experiment_id
        
        # Encerra a run
        mlflow.end_run()
    
    print(F'RUN ID: {run_id}')
    print(F'EXPERIMENT ID: {experiment_id}')
    return run_id, experiment_id
```

Na função train_model, incluímos o código necessário para treinar o modelo de classificador de stacking customizado. Vamos focar na explicação dos argumentos passados ao método mlflow.pyfunc.log_model durante o processo de registro do modelo:

- artifact_path='custom-ml': Este argumento especifica o caminho onde os artefatos do modelo serão armazenados dentro da run do MLflow. Nesse caso, os artefatos do modelo customizado serão salvos no diretório 'custom-ml'.
- python_model=model_wrapper: Aqui, passamos a instância model_wrapper, que é um objeto da classe StackingClassifierModelWrapper. Esse wrapper de modelo encapsula o classificador de stacking customizado e fornece a funcionalidade necessária para carregar o modelo durante a inferência.
- artifacts=artifacts: Passamos o dicionário artifacts, que contém os caminhos para os modelos classificadores XGBoost individuais e o estimador final do scikit-learn. Esses artefatos são essenciais para o carregamento e utilização bem-sucedidos do classificador de stacking customizado durante a inferência.
- code_path=[f'{project_path}/src/custom_stacking_classifier.py']: Este argumento especifica o caminho para o arquivo de código-fonte (custom_stacking_classifier.py) que define a implementação do classificador de stacking customizado. Garante que o código seja registrado junto com os artefatos do modelo, permitindo reprodutibilidade e transparência.
- conda_env=f'{project_path}/conda.yaml': Aqui, fornecemos o caminho para o arquivo conda.yaml, que contém a configuração de ambiente necessária para reproduzir o ambiente Python requerido pelo modelo. Isso garante que o ambiente de inferência corresponda ao ambiente de treinamento, evitando possíveis inconsistências.

Ao passar esses argumentos ao método mlflow.pyfunc.log_model, garantimos que o modelo de classificador de stacking customizado, juntamente com seus artefatos, código e configuração de ambiente, seja devidamente registrado dentro da run do MLflow. Esse registro abrangente permite rastreamento fácil, reprodutibilidade e utilização do modelo de ML customizado durante a inferência.

## Conclusão

Neste post, exploramos o processo de construção de um modelo de ML customizado usando o MLflow. Inspirados pelo nosso projeto antifraude do iCarros, discutimos os desafios encontrados durante o processo de implantação do modelo. Embora este projeto não cubra o código de implantação, destacamos o sucesso do iCarros em implantar o modelo em um endpoint SageMaker no nosso projeto antifraude. A combinação do MLflow, wrappers de modelo customizados e a utilização do SageMaker facilitou a implantação e garantiu o funcionamento efetivo do modelo.

Obrigado pela leitura, e esperamos que este post forneça insights sobre a construção de modelos de ML customizados usando o MLflow.
