Files in the `.devpanel` directory control DevPanel deployment for this app.


## Startup scripts

- [`custom_package_installer.sh`](custom_package_installer.sh): Installs
  extra system software. Runs as root. This is called by
  /scripts/apache-start.sh before Apache starts.
- [`init-container.sh`](init-container.sh): Checks for a database dump and
  imports it.
- [`init.sh`](init.sh): Performs additional startup tasks. Supporting files:
  - [`wp-config.devpanel.php`](wp-config.devpanel.php): Settings for running
    WordPress as a DevPanel app.
  - [`warm`](warm): Loads any path to build caches. If no path is provided,
    defaults to /.


## Git integration

- [`config.yml`](config.yml): Defines tasks to run when Git is configured to
  update the app automatically.


## Deployment

- [`re-config.sh`](re-config.sh): Runs when container configuration is
  changed in DevPanel or the app is deployed to a hosting provider.


## Creating a Docker image

- [`create_quickstart.sh`](create_quickstart.sh): Archives the database and
  files for the _DevPanel Docker Publish Workflow_ which can be added in
  [GitHub Actions](../../actions).