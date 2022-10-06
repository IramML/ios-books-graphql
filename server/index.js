const { ApolloServer } = require('apollo-server-express');
const connectDb = require('./db');
const resolvers = require('./resolvers');
const typeDefs = require('./typesdefs');
const {
  ApolloServerPluginLandingPageLocalDefault
} = require('apollo-server-core');
const express = require('express');

const app = express();
connectDb();



async function start() {
  const server = new ApolloServer({
      typeDefs,
      resolvers,
      csrfPrevention: true,
      cache: 'bounded',
      plugins: [
          ApolloServerPluginLandingPageLocalDefault({ embed: true }),
      ],
  });

  await server.start();
  server.applyMiddleware({ app, path: "/api" });
  app.use((req, res, next) => {
    res.status(404).send("not found");
  });

  app.listen(process.env.PORT || 3000, () =>
    console.log("Server on port", process.env.PORT || 3000)
  );
}

start()


