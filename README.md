# Sailr

## Table of Contents
+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)

## About <a name = "about"></a>

Sailr helps you follow the [Conventional Commits](https://www.conventionalcommits.org) conventional by installing a configurable `commit-msg` Git hook globally on you system.

### Installing

Here is how you can install Sailr.

```sh
git clone https://github.com/craicoverflow/sailr
cd sailr
make install
```

### Uninstalling

It's as simple as this:

```sh
make uninstall
```

## Usage <a name = "usage"></a>

Once installed, you must run `git init` in your Git projects to (re)initialize your repository. THe next time you try to make a new commit Sailr will validate the commit message and block the commit if it fails to pass the rules in `~/.sailr/config.json`.

To make adjustments to the rules, you can just edit the configuration file located at `~/.sailr/config.json`.