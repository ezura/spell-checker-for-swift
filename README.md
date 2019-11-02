# No more "Fix typo" commit...!

This command line tool can check spelling and show proposed correction.

<img src="./Images/screenshot.png" height="500">

## Installation

### Binary

We can download binary from [here](https://github.com/ezura/spell-checker-for-swift/releases).

### Makefile

```shell
$ git clone git@github.com:ezura/spell-checker-for-swift.git
$ cd spell-checker-for-swift
$ make
```

### [Mint](https://github.com/yonaskolb/mint)

```shell
$ mint install ezura/spell-checker-for-swift@1.1
```

## Usage
### Command

#### `typokana { path of file/directory }`
Show warning on Xcode when run this command at run script.

#### `--diff-only`, `-diff`
Check only files listed by `git diff --name-only`  
(`typokana --diff-only { path of file/directory }`)

#### `typokana --help`
 (`typokana --help`)
 
```
OVERVIEW: Spell check

USAGE: typokana [options] argument

OPTIONS:
--diff-only, -diff   Check only files listed by `git diff --name-only`
--help               Display available options

POSITIONAL ARGUMENTS:
path                 Path of target file
```

### How to ignore word
1. Create file named ".typokana_ignore"
1. Write ignored words with line breaks

For example, if you don't want to display warnings for "typokana", "json" and "yuka", please write following text in ".typokana_ignore".
```text:.typokana_ignore
typokana
json
yuka
```

## TODO

* [x] edit the list of words to ignore
