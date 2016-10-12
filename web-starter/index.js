'use strict';
var generators = require('yeoman-generator'),
  _ = require('lodash'),
  pkg = require('../package.json'),
  Promise = require('bluebird'),
  glob = Promise.promisify(require('glob'));

module.exports = generators.Base.extend({
  initializing : {
    async : function() {
      this.options.addDevDependency(pkg.name, '~' + pkg.version);
    }
  },
  
  prompting : function() {
    var that = this;
    var php_versions = [{ name:'5.3', value:'php' },{ name:'5.6', value:'php56u' }];
    var mysql_versions = [{ name:'5.6', value:'mysql56u' }];
    var config = _.extend({
      // Put default config values here
      php_base : 'php',
      mysql_base : 'mysql56u',
      mysql_password : 'web',
    }, this.config.getAll());

    return that.prompt([{
      // Put config prompts here
      type : 'list',
      name : 'php_base',
      choices : php_versions,
      message : 'Select a version of PHP',
      default : config.php_base
    },
    {
      // Put config prompts here
      type : 'list',
      name : 'mysql_base',
      choices : mysql_versions,
      message : 'Select a version of MySQL',
      default : config.mysql_base
    },
    {
      type: 'input',
      name: 'mysql_password',
      message: 'Input desired mysql password:',
      default : config.mysql_password
    }])
    .then(function(answers) {
      that.config.set(answers);

      // Expose the answers on the parent generator
      _.extend(that.options.parent.answers, { 'web-starter-salt' : answers });
    });
  },
  writing : {
    // Put functions to write files / directories here
    settings : function() {
      // Get current system config for this sub-generator
      var config = this.config.getAll();
      _.extend(config, this.options.parent.answers);

      var that = this;
      
      
      glob('**', { cwd : this.templatePath(''), dot: true }).then(function(files) {
          _.each(files, function(file) {
              console.log(file);
              console.log(file === "salt/roots/pillars/generated.sls");
              console.log(that.destinationPath(file));
              console.log(that.fs.exists(that.destinationPath(file)));
            if (file === "salt/roots/pillars/generated.sls" && that.fs.exists(that.destinationPath(file))){
                console.log('generated.sls file exists');
            }else{
                that.fs.copyTpl(that.templatePath(file), that.destinationPath(file), config);
            }
            
          });
        });
      
    }
  }
});
