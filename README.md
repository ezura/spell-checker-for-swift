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
$ mint install ezura/spell-checker-for-swift@1.2
```

## Usage
### Command

#### `typokana`
Search typo in all swift files.  
Show warning for typo on Xcode when this command is run at "Run Script".

#### `typokana -diff`
This command is recommended.  
Search typo only in changed swift files (fetched with `git diff`).

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

### How to ignore words
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
