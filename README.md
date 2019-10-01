![](https://www.codetriage.com/craicoverflow/sailr/badges/users.svg)

# Sailr

Sailr helps you follow the [Conventional Commits](https://www.conventionalcommits.org) conventional by installing a configurable `commit-msg` into your Git projects.

## Table of Contents
+ [About](#about)
+ [Getting Started](#getting_started)
+ [Usage](#usage)

### Prerequisites

To use Sailr you must have [jq](https://stedolan.github.io/jq/download/) installed.

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

Once installed, you must run `git init` in your Git projects to (re)initialize your repository. Copy the following template into the root of your project, otherwise the hook will be ignored.

```json
{
    "enabled": true,
    "revert": true,
    "length": {
        "min": 1,
        "max": 52
    },
    "types": [
        "build",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "style",
        "test",
        "chore"
    ]
}
```

**Note**: you can disable Sailr in your project by setting `enabled` to false in `sailr.json`_
