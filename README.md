# micro-autofmt

> Multi-language formatting plugin for the [Micro editor](https://github.com/zyedidia/micro)

## Setup

- `git clone` and `make`
- Install whichever formatters you want to use

## Usage

- Run `fmt` to format the current file.
- Files will be formatted on save, unless `autofmt.fmt-onsave` is set to false (with `Ctrl-e > set autofmt.fmt-onsave false`).

Formatters are named command invocations. For languages with multiple formatters, choose one with `set autofmt.for-<language> <name>` (e.g. `set autofmt.for-python ruff`). Some languages have multiple formatters that run the same command with different settings, see the exact invocations below.

## Supported formatters

The first formatter listed for each language is the default.

| Language   | Formatter name(s) |
| --- | --- |
| C/C++/C# | [clang-format](https://clang.llvm.org/docs/ClangFormat.html) |
| CSS | [prettier](https://prettier.io/) |
| Go | [gofmt](https://golang.org/cmd/gofmt/) |
| HTML | [prettier](https://prettier.io/) |
| JavaScript | [prettier](https://prettier.io/) |
| JSON | [prettier](https://prettier.io/) |
| Lua | [stylua](https://github.com/JohnnyMorganz/StyLua) |
| Nix | [nixfmt](https://github.com/NixOS/nixfmt) |
| Python | [yapf](https://github.com/google/yapf), [ruff](https://docs.astral.sh/ruff/), ruff+check, [black](https://black.readthedocs.io/en/stable/) |
| Racket | [raco-fmt](https://docs.racket-lang.org/fmt/index.html) |
| Rust | [rustfmt](https://github.com/rust-lang/rustfmt), rustfmt+nightly |
| Solidity | [forge-fmt](https://book.getfoundry.sh/reference/cli/forge/fmt) |
| TypeScript | [prettier](https://prettier.io/) |

### Invocations

| Name | Invocation |
| --- | --- |
| black | `black -q` |
| clang-format | `clang-format -i` |
| forge-fmt | `forge fmt` |
| gofmt | `gofmt -w` |
| nixfmt | `nixfmt` |
| prettier | `prettier --write --log-level silent` |
| raco-fmt | `raco fmt --width 80 --max-blank-lines 2 -i` |
| ruff | `ruff format -s` |
| ruff+check | `ruff check --fix` and `ruff format -s` |
| rustfmt | `rustfmt` |
| rustfmt+nightly | `rustfmt +nightly` |
| stylua | `stylua` |
| yapf | `yapf -i` |

## Credits

This project is intended as a replacement for the now-dead [fmt-micro](https://github.com/sum01/fmt-micro). o7

---

All contributions are welcome by pull request or issue.

micro-autofmt is licensed under the GNU General Public License v3.0. See [LICENSE](../main/LICENSE) for full text.
