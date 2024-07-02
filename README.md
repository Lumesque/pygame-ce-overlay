# Nix Flake Overlay for pygame-community-edition

This repository is a Nix flake meant for using [pygamece](https://pyga.me/) in your dev shells or shell environments.

This is mainly meant to serve as a flake which can be used with `nix shell` and `nix develop`, with most support made with `nix develop` in mind

This outputs a packages set with each branch/tag being added at the end of it's corresponding python version. For instance, if you want to use tag __2.5.0__ with python312, the corresponding package would be `"python312-2.5.0"`, note that the quotes are necessary as the tag has '.' in the name but '.' is an attribute getter in nix.

A simple overview:

* `pygame."python312-2.5.0"` -> default
* `pygamece.overlays.default` -> adds pygamece as a subpackage of pkgs.python312 so that it can be called with all your other python packages (see templates/init/flake.nix for an example)


## Usage
### Flake
In your `flake.nix` file:
```nix
{
  inputs.pygamece.url = "github:Lumesque/pygame-ce-overlay";

  outputs = {self, pygamece, ...}: {
    ...
  };
}
```

### In shell
```bash
 # Open a shell with default pygame
nix shell 'github:Lumesque/pygame-ce-overlay'

 # Open a shell with a specific version
nix shell 'github:Lumesque/pygame-ce-overlay#"python312-2.5.0.dev4"'
```

### Compiling it yourself
Although you can use this flake, that does not mean that you might not want to make changes, or be able to compile pygame yourself if something were to happen. You can use the template for dev in this case. Below is an example of setting that environment up in your cloned pygamece repository
```shell
# clone pygamece
$ git clone https://github.com/pygame-community/pygame-ce.git

$ cd pygame-ce

$ nix flake init -t 'github:Lumesque/pygame-ce-overlay#dev'
```

This allows you to run `nix develop` which starts a bash shell with all you need, and alternatively if you have `direnv` you can then use
```direnv
use flake
```
to auto go into that shell every time you enter the repo

## Updating
If you want to update, clone the repo and run the update script (make sure to have nix-shell installed), then add in the resulting two jsons and commit them and push
