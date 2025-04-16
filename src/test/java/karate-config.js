function fn() {
  var env = karate.env; // obter a propriedade do sistema 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev'; // se não estiver definida, 'dev' é o padrão
  }

  var config = {
    env: env,
    myVarName: 'someValue'
  }

  // Personalizar configurações de acordo com o ambiente
  if (env == 'dev') {
    // customize para o ambiente dev
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize para o ambiente e2e
  }

  // Configurações de log para visualização de requisições e respostas
  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  return config; // retorna as configurações
}
