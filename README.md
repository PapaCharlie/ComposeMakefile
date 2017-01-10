# ComposeMakefile
A handy Makefile that offers tab completions for 
[Docker Compose](https://docs.docker.com/compose/)

# Why?
This began as a utility for my personal website, where I use Docker Compose for 
the different services I host on the same machine. Typing `docker-compose ...` 
every time I made a small change became rather tedious very quickly, especially
without tab completions. Now it's not a problem anymore.

# Setup
Simply pull this Makefile and place it next to your `docker-compose.yml` file. 
If you need to place it in a different directory or have a different name for 
your Compose file, make sure you edit the `DOCKER_FILE` variable to point to it.
If you use another Makefile, you can include this Makefile into yours by 
renaming it to `ComposeMakefile`, and adding this line to your Makefile:
```include ComposeMakefile```

If it's not already installed, `make` is rather easy to install in most UNIX and 
UNIX-like environments. You will need it to make this work at all.

In a barebones Ubuntu environment, like, say, a fresh server instance, 
installing `make` through `apt-get` also installs the automatic tab-completions
for bash.

# HOWTO
Once you have the Makefile at hand, and `make` installed, you're good to go!
The Makefile will pick up the services you have defined in your Compose file,
so try `make TAB TAB` to see what commands are available for each service.

## Available Actions
+ `make` is a simple alias for `docker-compose up -d`. Similarily, all `up` 
  related commands are actually `up -d` commands. 
+ All `logs` related commands are in fact `logs -f`, i.e. attach to the log 
  output.
+ `reboot` is an alias for `down && up` when used by itself, and an alias for
  `stop {service} && rm {service} && up -d {service}` when used as 
  `{service}/reboot`. `rm` is used to match the behavior of `down && up` for the
  service.
+ `{service}/ssh` is an alias for `docker-compose exec {service} bash`.
+ All other commands of form `{service}/{command}` will execute 
  `docker-compose {command} {service}`

#PROTIP!!1!
You can change the line
```COMPOSE := docker-compose -f $(DOCKER_FILE)```
to something along the lines of
```COMPOSE := ssh root@yourwebsite.com docker-compose -f $(DOCKER_FILE)```
to execute all commands on a server via `ssh`.
