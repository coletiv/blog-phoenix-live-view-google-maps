const path = require('path');
const glob = require('glob');
const HardSourceWebpackPlugin = require('hard-source-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const FileManagerPlugin = require('filemanager-webpack-plugin');
const ImageminWebpWebpackPlugin = require("imagemin-webp-webpack-plugin");
const BrotliPlugin = require('brotli-webpack-plugin');
const webpack = require('webpack');
const WorkboxPlugin = require('workbox-webpack-plugin');

const handler = (percentage, message, ...args) => {
    // e.g. Output each progress message directly to the console:
    console.info(percentage, message, ...args);
};



module.exports = (env, options) => {
    const devMode = options.mode !== 'production';

    return {
        optimization: {
            minimizer: [
                new TerserPlugin({cache: true, parallel: true, sourceMap: devMode}),
                new OptimizeCSSAssetsPlugin({})
            ]
        },
        entry: {
            app: glob.sync('./vendor/**/*.js').concat(['./js/app.js']),
        },
        output: {
            filename: '[name].js',
            path: path.resolve(__dirname, '../priv/static/js')
        },
        devtool: devMode ? 'eval-cheap-module-source-map' : undefined,
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
                    test: /\.css$/,
                    use: [
                        MiniCssExtractPlugin.loader,
                        'css-loader?url=false',
                        'postcss-loader'
                    ],
                },
                  {
                    test: /\.scss$/,
                    use: [
                        MiniCssExtractPlugin.loader,
                        'css-loader?url=false',
                        'postcss-loader',
                        'sass-loader'
                    ],
                }
            ]
        },
        externals: {
            moment: 'moment'
        },
        plugins: [
            new MiniCssExtractPlugin({filename: '../css/[name].css'}),
             new WorkboxPlugin.GenerateSW({
       clientsClaim: true,
       skipWaiting: true,
     }),
            new CopyWebpackPlugin([{from: 'static/', to: '../'}]),
            new CopyWebpackPlugin([{
                from: 'node_modules/@fortawesome/fontawesome-free/css/',
                to: '../css/font-awesome/'
            }]),
            new CopyWebpackPlugin([{
                from: 'node_modules/@fortawesome/fontawesome-free/webfonts/',
                to: '../webfonts/'
            }]),
            new CopyWebpackPlugin([{
                from: 'node_modules/@fortawesome/fontawesome-free/svgs/',
                to: '../images/font-awesome/'
            }]),
            new BrotliPlugin({
                asset: '[path].br[query]',
                test: /\.(js|css|html|svg)$/,
                threshold: 10240,
                minRatio: 0.8
            }),
            new ImageminWebpWebpackPlugin()
        ]
            .concat(devMode ? [new HardSourceWebpackPlugin()] : [])
    }
};
