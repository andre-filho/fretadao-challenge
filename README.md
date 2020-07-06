
## Justificativa de tecnologias utilizadas
### Gems

### Vue.js
Para o front-end escolhi utilizar o Vue.js devido à minha já existente experiência
com a tecnologia.

### Docker
Ter o ambiente de desenvolvimento containerizado com docker ?

## Observações
- Para o encurtamento de urls acabei por faze-lo por meio de webscrapping, visto que pra vários serviços o serviço de encurtamento por API é pago e outras requerem configuração a mais. Assim, tambem se diminui a complexidade por conta da aplicação retirar informação da web de apenas uma forma.

- O campo de e-mail de um usuário no github só aparece quando se está logado, assim como é possível se observar na API do GH. A listagem de organizações também é reduzida quando se acessa sem o login.

- Na model de profile decidi manter o encurtamento de url dentro do lifecycle hook `before_validate` por conta de não encontrar muito sentido em validar um valor para mudá-lo para outro totalmente diferente. Outra vantagem que encontrei nesta forma foi aproveitar a validação, seja para o tratamento de links inválidos ou seja para garantir a presença das mesmas após a manipulação, visto que são encurtadas utilizando webscapping tambem.

- Na model de profile pensei em utilizar outras formas de tratar o problema de perfil não encontrado no github. Pesquisando qual ficaria melhor, fui convencido que a melhor forma de tratar isso seria usando o `errors` da propria ActiveRecord mesmo, o que acho que condiz com a filosofia de convention over configuration do próprio RoR.
