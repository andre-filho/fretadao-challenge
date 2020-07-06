
## Justificativa de tecnologias utilizadas
### PostgreSQL
Decidi utilizar o postgres por ele ser meu sgbd de escolha sempre que vou iniciar um projeto com RoR ou Django. Ele é extremamente optimizado, a ponto de conhecer profissionais e pesquisadores que preferem utilizá-lo para tratar de bancos escaláveis do que tecnologias NoSQL como o MongoDB. Outra vantagem tambem é a presença de gems como a `pg_search`.

### Gems

### Vue.js
Para o front-end escolhi utilizar o Vue.js devido à minha já existente experiência
com a tecnologia.

### Docker
Ter o ambiente de desenvolvimento containerizado com docker ?

## Observações
- Para o encurtamento de urls acabei por faze-lo por meio de webscrapping, visto que pra vários serviços o serviço de encurtamento por API é pago e outras requerem configuração a mais. Assim, tambem se diminui a complexidade por conta da aplicação retirar informação da web de apenas uma forma.

- O campo de e-mail de um usuário no github só aparece quando se está logado, assim como é possível se observar na API do GH. A listagem de organizações também é reduzida quando se acessa sem o login.

- Na model de profile decidi manter o encurtamento de url dentro do lifecycle hook `before_save`. para garantir a validação dos dados pegos no webscrapping, criei um método de validação desdes mesmos campos que dispara a exceção de classe `ActiveRecord::RecordInvalid` caso sejam encontrados erros. as mensagens de erro são adicionadas ao à propriedade `errors` do objeto caso ocorram.

- Na model de profile pensei em utilizar outras formas de tratar o problema de perfil não encontrado no github. Pesquisando qual ficaria melhor, fui convencido que a melhor forma de tratar isso seria usando o `errors` da propria ActiveRecord mesmo, o que acho que condiz com a filosofia de convention over configuration do próprio RoR.

- A decisão de utilizar como banco de dados
