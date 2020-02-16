# MICMACS

---

## Prerequisites
MicMacs requires fonts for better display

- Fonts
  - [Fira Code](https://github.com/tonsky/FiraCode)
  - [Fira Code Symbol](https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip)
  - [all the icons](https://github.com/domtronn/all-the-icons.el/tree/master/fonts)  

- global tools
  - [ripgrep](https://github.com/BurntSushi/ripgrep) in your $PATH
- Python related Packages
```sh
pip install pylint yapf isort
```

- lsp-mode 在python环境下使用
- download and [automatic] build mspyls, first start virtual env and then start `lsp`
- C/C++ packages
  - build [ccls](https://github.com/MaskRay/ccls) language server at $HOME path
- nodejs packages
```sh
npm install -g eslint_d prettier markdownlint-cli vmd
```

use mirror if you have timeout error.

## Install
MicMacs is trying to mimic and simplify spacemacs, and simpler for management, you can copy from the following hub using git the following way, enjoy it!!
```bash
git clone git@github.com:peter159/mimacs.git ~/.emacs.d
```

For server user, since emacs is running a deamon for server, make a short cut applying something like the below to use it(change the path to your path). Look at [wiki](https://www.emacswiki.org/emacs/EmacsMsWindowsIntegration) to see the explanation of how emacsclient works
```bash
C:\msys64\mingw64\bin\emacsclientw.exe -cna C:\msys64\mingw64\bin\runemacs.exe
<!-- make a shortcut in windows using this path -->
```
Fonts, is sometimes critical for UI thing, here recommend to use `Fira Code Retina` for English and `等距更纱黑体 SC` for Chinese, can download them from here
```bash
[Fira Code Retina-%S](https://github.com/tonsky/FiraCode/releases/download/1.206/FiraCode_1.206.zip)
[Fira Code Symbols](https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip)
[Sarasa-Gothic](https://github.com/be5invis/Sarasa-Gothic/releases/download/v0.7.2/sarasa-gothic-ttf-0.7.2.7z) #install all that with -sc-
```

## SNAPSHOT
![snapshot](./img/snapshot.png)
