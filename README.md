# micro-autofmt

> Multi-language formatting plugin for the [Micro editor](https://github.com/zyedidia/micro)

## Setup

- `git clone` and `make`
- Install whichever formatters you want to use

## Usage

- Run `fmt` to format the current file.
- Files will be formatted on save, unless `fmt-onsave` is set to false (with `Ctrl-e > set fmt-onsave false`).

## Supported formatters

| Language | Formatter    |
| C/C++    | clang-format |
| Python   | yapf         |

## Credits

This project is intended as a replacement for the now-dead [fmt-micro](https://github.com/sum01/fmt-micro). o7

--- 

All contributions are welcome by pull request or issue.

micro-autofmt is licensed under GNU General Public License v3.0. See [LICENSE](../master/LICENSE) for full text.
