Capistrano::Configuration.instance(:must_exist).load do

  require 'capistrano/recipes/deploy/scm'
  require 'capistrano/recipes/deploy/strategy'

  # =========================================================================
  # These variables may be set in the client capfile if their default values
  # are not sufficient.
  # =========================================================================

  set :scm, :git
  set :deploy_via, :remote_cache
  _cset :branch, "master"
  set :git_enable_submodules, true

  set :drush_cmd, "drush"

  set :runner_group, "www-data"
  set :group_writable, false

  set(:deploy_to) { "/var/www/#{application}" }
  set :shared_children, ['files', 'private']

  after "deploy:update_code", "drupal:symlink_shared", "drupal_console:site_offline", "drush:updatedb", "drupal_console:site_online", "drush:cache_rebuild"

  namespace :deploy do
    desc <<-DESC
      Prepares one or more servers for deployment. Before you can use any \
      of the Capistrano deployment tasks with your project, you will need to \
      make sure all of your servers have been prepared with `cap deploy:setup'. When \
      you add a new server to your cluster, you can easily run the setup task \
      on just that server by specifying the HOSTS environment variable:

        $ cap HOSTS=new.server.com deploy:setup

      It is safe to run this task on servers that have already been set up; it \
      will not destroy any deployed revisions or data.
    DESC
    task :setup, :except => { :no_release => true } do
      dirs = [deploy_to, releases_path, shared_path].join(' ')
      run "#{try_sudo} mkdir -p #{releases_path} #{shared_path}"
      run "#{try_sudo} chown -R #{user}:#{runner_group} #{deploy_to}"
      sub_dirs = shared_children.map { |d| File.join(shared_path, d) }
      run "#{try_sudo} mkdir -p #{sub_dirs.join(' ')}"
      run "#{try_sudo} chmod 2775 #{sub_dirs.join(' ')}"
    end
  end

  namespace :drupal do

    desc "Symlink settings and files to shared directory. This allows the settings.php and \
      and sites/default/files directory to be correctly linked to the shared directory on a new deployment."
    task :symlink_shared do
    ["files", "private", "settings.php"].each do |asset|
        run "rm -rf #{app_path}/sites/default/#{asset} && ln -nfs #{shared_path}/#{asset} #{app_path}/sites/default/#{asset}"
      end
    end

  end

  namespace :git do

    desc "Place release tag into Git and push it to origin server."
    task :push_deploy_tag do
      user = `git config --get user.name`
      email = `git config --get user.email`
      tag = "release_#{release_name}"
      if exists?(:stage)
        tag = "#{stage}_#{tag}"
      end
      puts `git tag #{tag} #{revision} -m "Deployed by #{user} <#{email}>"`
      puts `git push origin tag #{tag}`
    end

   end

  namespace :drush do

    desc "Set the site offline"
    task :site_offline, :on_error => :continue do
      run "drupal --root=#{app_path} site:maintenance on"
    end

    desc "Set the site online"
    task :site_online, :on_error => :continue do
      run "drupal --root=#{app_path} site:maintenance off"
    end

    desc "Run Drupal database migrations if required"
    task :updatedb, :on_error => :continue do
      run "#{drush_cmd} -r #{app_path} updatedb -y"
    end

    desc "Rebuild the drupal cache"
    task :cache_rebuild, :on_error => :continue do
      run "#{drush_cmd} -r #{app_path} cr"
    end

    desc "Revert all features"
    task :features_revert_all, :on_error => :continue do
      run "#{drush_cmd} -r #{app_path} fr-all -y"
    end

  end

  namespace :drupal_console do

    desc "Set the site offline"
    task :site_offline, :on_error => :continue do
      run "drupal --root=#{app_path} site:maintenance on"
    end

    desc "Set the site online"
    task :site_online, :on_error => :continue do
      run "drupal --root=#{app_path} site:maintenance off"
    end

  end


end
