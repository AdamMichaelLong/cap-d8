# Capistrano Drupal 8 Tasks

D8 compatible tasks for Drupal Console and Drush 7.
Requires:
  - Drupal Console
  - PHP 5.5.9 +
  - Drush 7

Can support autoscaling via AWS Tags:

* [AWS SDK] - Supports AWS SDK v1

### Installation

```sh
$ gem install cap-drupal8
```
### Capfile
```sh
load 'deploy' if respond_to?(:namespace) # cap2 differentiator
require 'rubygems'
require 'railsless-deploy'
require 'capistrano/ext/multistage'
require 'cap-drupal8'
require 'aws-sdk-v1'
require 'awesome_print'
load 'config/deploy'
```

### Deploy files

Add your environment deploy files in config/deploy, see examples/example.dev.rb

### Usage

```sh
$ bundle exec cap your.env deploy
```


### Todos

 - Add better examples
 - Add Code Comments
 - Add Night Mode

License
----

MIT


**Free Software, Hell Yeah!**

