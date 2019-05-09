const { override, fixBabelImports } = require('customize-cra');

const getConfig = override(
  fixBabelImports('import', {
    libraryName: 'antd',
    libraryDirectory: 'es',
    style: 'css',
  }),
);
module.exports = function (config, env) {
  const c = getConfig(config, env);
  c.output.publicPath = env === 'development' ? '/' : '/webgl-demo/';
  return c;
};
