<div style="text-align: center;">
  <h1>
    Github profile indexer
  </h1>
</div>

## Capturas de tela
#### Criar perfil
![screenshot](./img/create.gif)
#### Editar perfil
![screenshot](./img/edit-1.gif)
<br/>
![screenshot](./img/edit-2.gif)
#### Deletar perfil
![screenshot](./img/delete-1.gif)
<br/>
![screenshot](./img/delete-2.gif)
#### Procurar perfil
![screenshot](./img/search.gif)
<br/>
![screenshot](./img/search-username.gif)
<br/>
![screenshot](./img/search-location.gif)
<br/>
![screenshot](./img/search-organizations.gif)

## Instalação
Para a execução deste projeto é necessário o Docker. Para subir o ambiente de desenvolvimento basta rodar:

```bash
  $ docker-compose up
  # ou caso queira subir com os logs separados, abra dois terminais e execute:
  $ docker-compose up api
  $ docker-compose up front
```


## Justificativa de tecnologias utilizadas
### PostgreSQL
Decidi utilizar o postgres por ele ser meu sgbd de escolha sempre que vou iniciar um projeto com RoR ou Django. Ele é extremamente optimizado, a ponto de conhecer profissionais e pesquisadores que preferem utilizá-lo para tratar de bancos escaláveis do que tecnologias NoSQL como o MongoDB. Outra vantagem tambem é a presença de gems como a `pg_search`.

### Vue.js
Para o front-end escolhi utilizar o Vue.js devido à minha já existente experiência
com a tecnologia. E por possuir extensões e bibliotecas de componentes mais fáceis de configurar, no caso estou usando o Vuetify como biblioteca de componentes.

### Docker
A maior vantagem que eu busquei ao utilizar o docker é ter um ambiente mais isolado para o desenvolvimento. Outro ponto é que com o docker-compose basta um comando para subir todo o stack.

## Limitações

- A pesquisa tem como limitação encontrar resultados semelhantes à partir do prefix dos campos `:name, :username, :location` e de cada uma das entradas do `:organizations`. Existe a possibilidade de adicionar a pesquisa por meio de um algoritmo de busca baseado em trigramas, utilizando uma extensão nativa do postgres.

- O campo de e-mail de um usuário no github só aparece quando se está logado, assim como é possível se observar na API do GH. A listagem de organizações também é reduzida quando se acessa sem o login. O valor do email não é resgatado pelo webscrapping.

## Observações e pontos de melhoria
### Back-end
- Inicialmente fiz o sistema de encurtamento de URL por meio de webscrapping, porém notei que as URLs encurtadas estavam sendo desativadas depois de aproximadamente 3h de criação. Em outro momento, a URL passou a direcionar para uma página aleatória do Facebook. Então decidi mudar a implementação desta funcionalidade para suprimir esses erros. Optei por implementar essa funcionalidade a partir da gem `shorturl` utilizando o serviço `tinyurl`.

- Na model de profile decidi manter o encurtamento de URLs assim como a execução do webscrapping dentro da chamada `before_validates`. Assim, aproveitando para fazer a validação das URLs encurtadas juntamente com alguns dos campos coletados do Github.

- Na model de profile pensei em utilizar outras formas de tratar o problema de perfil não encontrado no github. Pesquisando qual ficaria melhor, fui convencido que a melhor forma de tratar isso seria usando o `errors` da propria ActiveRecord.

- Os testes de webscrapping devem ser melhorados, tanto em desempenho quanto em escrita.

- Não estava nas especificações, porém tomei a liberdade de encurtar as URLs de imagem também. O encurtamento de URLs serve principalmente para diminuir o tamanho das entradas na tabela do banco de dados, e pensei que diminuir somente o menor link (da página de perfil é bem menor que o da imagem), não fazia muito sentido. Logo também encurtei a URL das imagens.

### Front-end
- Para o tratamento de perfis não existentes assim como outras rotas não existentes, fiz com que fosse forçado um redirecionamento à página de início da aplicação. Exibindo um card alert com mensagem.

- Considerando que antes de recuperar a imagem do usuário o request será redirecionado, decidi tratar uma possível demora de renderização da imagem de perfil do usuário com uma imagem placeholder, utilizando ferramentas já existentes no componente `v-img` do Vuetify.

- Uma melhoria no front-end também seriam os testes, que cobrem apenas o essêncial das funções dos componentes.

- Outra melhoria do front-end seria a apresentação. Por conta do tempo, mantive a exibição de forma bastante básica.

- Outra funcionalidade que planejei em fazer mas acabei não implementando seria de restringir as ações para usuários deslogados (login seria na aplicação, sem relação com os perfis do github).

- O layout do front-end exibido em dispositivos menores pode ser melhorado.
