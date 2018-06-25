const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = {
  entry: './js/app.js',
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          use: [{
            loader: "css-loader"
          }, {
            loader: "postcss-loader"
          }, {
            loader: "sass-loader",
            options: {
              precision: 8,
              includePaths: [
                'node_modules/bootstrap/scss',
                'node_modules/@fortawesome/fontawesome-free/scss'
              ]
            }
          }],
          fallback: 'style-loader'
        })
      }, {
        test: /\.(svg|ttf|eot|woff|woff2)$/,
        use: {
          loader: 'file-loader',
          options: {
            name: '[name].[ext]',
            outputPath: '../fonts/',
            publicPath: '../fonts/'
          }
        }
      },
      {
        test: /\.(jpg|png|gif)$/,
        loader: "file-loader",
        options: {
          name: "[name].[ext]",
          outputPath: "../static/images/",
          publicPath: "../images/"
        }
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin('../css/app.css'),
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
}
