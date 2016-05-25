// Run with Rails server like this:
// rails s -b 127.0.0.1
// cd client && babel-node server-rails-hot.js
// Note that Foreman (Procfile.dev) has also been configured to take care of this.

const path = require('path');
const webpack = require('webpack');

const config = require('./webpack.client.base.config');

const hotRailsPort = 3500;

config.entry.app.push(
  'webpack-dev-server/client?http://127.0.0.1:' + hotRailsPort,
  'webpack/hot/only-dev-server'
);

config.output = {
  filename: 'app-bundle.js',
  path: path.join(__dirname, 'public'),
  publicPath: `http://127.0.0.1:${hotRailsPort}/`,
};

config.module.loaders.push(
  {
    test: /\.elm$/,
    exclude: [/elm-stuff/, /node_modules/],
    loader: 'elm-hot!elm-webpack?warn=true'
  }
);

config.plugins.push(
  new webpack.HotModuleReplacementPlugin(),
  new webpack.NoErrorsPlugin()
);

config.devtool = 'eval-source-map';

console.log('Webpack dev build for Rails'); // eslint-disable-line no-console

module.exports = config;
