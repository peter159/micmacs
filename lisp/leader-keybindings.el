;; leader-keybindings.el --- Setup evil-leader keybindings.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))


(use-package evil-leader
  :defer nil
  :init
  (global-evil-leader-mode))

(use-package evil-major-leader
  :quelpa
  (evil-major-leader :repo "Peter-Chou/evil-major-leader" :fetcher github)
  :init
  (global-evil-major-leader-mode))


(evil-leader/set-leader petmacs-evil-leader-key)
(evil-major-leader/set-leader petmacs-evil-major-leader-key)

;; Escape from isearch-mode("/" and "?" in evil-mode) like vim
(define-key isearch-mode-map (kbd "<escape>") 'isearch-cancel)

;; Make <escape> quit as much as possible
(define-key minibuffer-local-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-ns-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-completion-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-must-match-map (kbd "<escape>") 'keyboard-escape-quit)
(define-key minibuffer-local-isearch-map (kbd "<escape>") 'keyboard-escape-quit)

(evil-leader/set-key
  "'"   'petmacs/pop-eshell
  "?"   'counsel-descbinds
  "/"   'counsel-projectile-rg
  "v"   'er/expand-region
  "u"   'universal-argument
  "d"   'xref-pop-marker-stack
  "TAB" 'petmacs/alternate-buffer)

;; leader-T Theme family 
(petmacs//setup-default-key-name "T" "Theme")
(evil-leader/set-key
  "Ts"  'petmacs/select-theme
  "Tn"  'petmacs/cycle-theme)

;; leader-a application family
(petmacs//setup-default-key-name "a" "application")
(petmacs//setup-default-key-name "ao" "org")
(petmacs//setup-default-key-name "aC" "Clock")
(evil-leader/set-key
  "ad"  'deer
  "ap"  'list-processes
  "aP"  'proced
  "ar"  'ranger
  "ak"  'paradox-list-packages
  "au"  'paradox-upgrade-packages
  "aw"  'whitespace-cleanup

  ;;; org
  "aoa" 'org-agenda-list
  "aoc" 'org-capture
  "aoe" 'org-store-agenda-views
  "aop" 'org-projectile/capture
  "aoo" 'org-agenda
  "aol" 'org-store-link
  "aom" 'org-tags-view
  "aos" 'org-search-view
  "aot" 'org-todo-list
  "ao/" 'org-occur-in-agenda-files

  ;; ;;; org feed
  ;; "aofi" 'org-feed-goto-inbox
  ;; "aofu" 'org-feed-update-all


  ;; ;;; org clock
  ;; "aoCc" 'org-clock-cancel
  ;; "aoCg" 'org-clock-goto
  ;; "aoCi" 'org-clock-in
  ;; "aoCI" 'org-clock-in-last
  ;; "aoCj" 'petmacs/org-clock-jump-to-current-clock
  ;; "aoCo" 'org-clock-out
  ;; "aoCr" 'org-resolve-clocks
  )

;; leader-q family
(petmacs//setup-default-key-name "q" "quit")
(evil-leader/set-key
  "qq" 'petmacs/frame-killer
  "qQ" 'kill-emacs
  "qh" 'suspend-frame
  "qR" 'restart-emacs)

;; leader-f family
(petmacs//setup-default-key-name "f" "files")
(petmacs//setup-default-key-name "fy" "copy")
(petmacs//setup-default-key-name "fv" "variable")
(evil-leader/set-key
  "ff"  'counsel-find-file
  "fj"  'dired-jump
  "ft"  'treemacs
  "fB"  'treemacs-bookmark
  "fT"  'treemacs-find-file
  "fL"  'counsel-locate
  "fr"  'counsel-buffer-or-recentf
  "fR"  'petmacs/rename-current-buffer-file
  "fs"  'save-buffer
  "fS"  'evil-write-all
  "fc"  'petmacs/copy-file
  "fb"  'counsel-bookmark
  "fB"  'treemacs-bookmark

  ;;; file local variable
  "fvd" 'add-dir-local-variable
  "fvf" 'add-file-local-variable
  "fvp" 'add-file-local-variable-prop-line

  ;;; unix <-> dos
  "fCu" 'dos2unix
  "fCd" 'unix2dos

  ;;; file path copy
  "fCr" 'petmacs/save-buffer-gbk-as-utf8
  "fyy" 'petmacs/copy-file-path
  "fyY" 'petmacs/projectile-copy-file-path
  "fyd" 'petmacs/copy-directory-path
  "fyn" 'petmacs/copy-file-name

  ;;; emacs configs
  "feo" 'petmacs/find-org-global-todos
  "fec" 'petmacs/find-custom-file
  "fed" 'petmacs/find-dotfile)

;; leader-F family
(petmacs//setup-default-key-name "F" "Frame")
(evil-leader/set-key
  "Ff" 'find-file-other-frame
  "Fd" 'delete-frame
  "FD" 'delete-other-frames
  "Fb" 'switch-to-buffer-other-frame
  "FB" 'display-buffer-other-frame
  "Fo" 'other-frame
  "FO" 'dired-other-frame
  "Fn" 'make-frame)

;; leader-g family
(petmacs//setup-default-key-name "g" "git")
(evil-leader/set-key
  "gc"  'magit-clone
  "gs"  'magit-status
  "gi"  'magit-init
  "gl"  'magit-log-head
  "gL"  'magit-list-repositories
  "gm"  'magit-dispatch

  ;;; magit file
  "gff" 'magit-find-file
  "gfl" 'magit-log-buffer-file
  "gfd" 'magit-diff
  ;;; magit current file
  "gS"  'magit-stage-file
  "gU"  'magit-unstage-file

  ;;; magit browse
  "gho" 'browse-at-remote)

;; leader-i insert family
(petmacs//setup-default-key-name "i" "insert")
(evil-leader/set-key
  "is" 'ivy-yasnippet
  "if"  'insert-file
  )

;; leader-p family
(petmacs//setup-default-key-name "p" "project")
(evil-leader/set-key
  "p SPC" 'counsel-projectile
  "p'"    'petmacs/projectile-pop-eshell
  "pt"    'petmacs/treemacs-project-toggle
  "pb"    'counsel-projectile-switch-to-buffer
  "pd"    'counsel-projectile-find-dir
  "pp"    'counsel-projectile-switch-project
  "pf"    'counsel-projectile-find-file
  "pr"    'projectile-recentf
  "po"    'org-projectile/goto-todos
  "pl"    'petmacs/ivy-persp-switch-project
  "pv"    'projectile-vc)

;; leader-j family
(petmacs//setup-default-key-name "j" "jumps")
(evil-leader/set-key
  "ji" 'petmacs/counsel-jump-in-buffer
  "jw" 'evil-avy-goto-word-or-subword-1
  "jD" 'deer-jump-other-window
  "jc" 'goto-last-change
  "jd" 'deer
  "jj" 'avy-goto-char-timer
  "jJ" 'avy-goto-char-2)

;; leader-e family
(petmacs//setup-default-key-name "e" "error")
(evil-leader/set-key
  "eb" 'flycheck-buffer
  "ec" 'flycheck-clear
  "eh" 'flycheck-describe-checker
  "el" 'petmacs/toggle-flycheck-error-list
  "en" 'petmacs/next-error
  "eN" 'petmacs/previous-error
  "ep" 'petmacs/previous-error
  "es" 'flycheck-select-checker
  "eS" 'flycheck-set-checker-executable
  "ev" 'flycheck-verify-setup
  "ey" 'flycheck-copy-errors-as-kill
  "ex" 'flycheck-explain-error-at-point)

;; leader-b family
(petmacs//setup-default-key-name "b" "buffers")
(petmacs//setup-default-key-name "bp" "pop out buffer")
(evil-leader/set-key
  "bb" 'ivy-switch-buffer
  "bB" 'ibuffer
  "bd" 'kill-this-buffer
  ;; "bn" 'next-buffer
  ;; "bp" 'previous-buffer
  "bR" 'petmacs/revert-this-buffer
  "bs" 'petmacs/goto-scratch-buffer
  "bx" 'kill-buffer-and-window
  "bh" 'petmacs/goto-dashboard
  "bm" 'petmacs/switch-to-minibuffer-window
  "bY" 'petmacs/copy-whole-buffer-to-clipboard
  "ba" 'persp-add-buffer
  "br" 'persp-remove-buffer
  "bj" 'ace-window
  "bt" 'imenu-list-smart-toggle
  "bI" 'lsp-ui-imenu
  "bI" 'imenu-list

  ;;; pop out buffer
  "bpm" 'petmacs/shackle-popup-message-buffer
  "bpc" 'petmacs/shackle-popup-compilation-buffer)

;; leader-t family
(petmacs//setup-default-key-name "t" "toggle")
(which-key-add-key-based-replacements
  (format "%s t" petmacs-evil-leader-key) "toggle")
(evil-leader/set-key
  "t-" 'centered-cursor-mode
  "ts" 'flycheck-mode
  "tf" 'focus-mode
  "tF"  'toggle-frame-fullscreen
  "tM"  'maximize-window
  )

;; leader-w family
(petmacs//setup-default-key-name "w" "windows")
(evil-leader/set-key
  "w."  'hydra-frame-window/body
  "wc"  'olivetti-mode
  "wd"  'delete-window
  "wD"  'ace-delete-window
  )

;; leader-o family
(petmacs//setup-default-key-name "o" "Origami")
(evil-leader/set-key
  "o."  'origami-hydra/body
  )

;; leader-B family
(petmacs//setup-default-key-name "B" "Bookmarks")
(evil-leader/set-key
  ;; bookmarks
  "Bs" 'bookmark-set
  "Bd" 'bookmark-delete
  "Br" 'bookmark-rename
  "Bl" 'bookmark-bmenu-list)

;; leader-n family
(petmacs//setup-default-key-name "n" "narrow")
(evil-leader/set-key
  "nf" 'narrow-to-defun
  "nr" 'narrow-to-region
  "np" 'narrow-to-page
  "nw" 'widen)

;;;; major mode specific keybinding
(petmacs//setup-default-key-name "m" "major mode cmds")
(petmacs//setup-major-mode-key-name "=" "format")
(petmacs//setup-major-mode-key-name "b" "backend")
(petmacs//setup-major-mode-key-name "c" "compile")
(petmacs//setup-major-mode-key-name "d" "debug")
(petmacs//setup-major-mode-key-name "g" "goto")
(petmacs//setup-major-mode-key-name "G" "goto other window")
(petmacs//setup-major-mode-key-name "p" "peek")
(petmacs//setup-major-mode-key-name "F" "folders")
(petmacs//setup-major-mode-key-name "r" "refactor")
(petmacs//setup-major-mode-key-name "rg" "generate")
(petmacs//setup-major-mode-key-name "ra" "assign/add")
(petmacs//setup-major-mode-key-name "s" "REPL")
(petmacs//setup-major-mode-key-name "t" "test")
(petmacs//setup-major-mode-key-name "T" "toggles")
(petmacs//setup-major-mode-key-name "h" "help")
(petmacs//setup-major-mode-key-name "v" "virtualenv")
(petmacs//setup-major-mode-key-name "vp" "pipenv")

;;; lsp major mode settings
(dolist (mode petmacs-lsp-active-modes)
  (evil-leader/set-key-for-mode mode
    ;; format
    "m=b" #'lsp-format-buffer
    "m=r" #'lsp-format-region
    ;; goto
    "mgr" #'lsp-find-references
    "mgt" #'lsp-find-type-definition
    "mgd" #'xref-find-definitions
    "mgD" #'lsp-find-declaration
    "mgi" #'lsp-find-implementation
    "mgk" #'petmacs/lsp-avy-goto-word
    "mgK" #'petmacs/lsp-avy-goto-symbol
    "mgM" #'lsp-ui-imenu
    ;; goto other window
    "mGr" #'petmacs/lsp-find-references-other-window
    "mGt" #'petmacs/lsp-find-type-definition-other-window
    "mGd" #'petmacs/lsp-find-definition-other-window
    "mGD" #'petmacs/lsp-find-declaration-other-window
    "mGi" #'petmacs/lsp-find-implementation-other-window
    ;; peek
    "mpd" #'lsp-ui-peek-find-definitions
    "mpi" #'lsp-ui-peek-find-implementation
    "mpr" #'lsp-ui-peek-find-references
    "mpRn" #'lsp-ui-find-next-reference
    "mpRp" #'lsp-ui-find-prev-reference
    ;; backend
    "mba" #'lsp-execute-code-action
    "mbd" #'lsp-describe-session
    "mbr" #'lsp-restart-workspace
    "mbs" #'lsp-shutdown-workspace
    ;; refactor
    "mrr" #'lsp-rename
    ;; toggles
    "mTd" #'lsp-ui-doc-mode
    "mTs" #'lsp-ui-sideline-mode
    "mTF" #'petmacs/lsp-ui-doc-func
    "mTS" #'petmacs/lsp-ui-sideline-symb
    "mTI" #'petmacs/lsp-ui-sideline-ignore-duplicate
    "mTl" #'lsp-lens-mode
    ;; folders
    "mFs" #'lsp-workspace-folders-switch
    "mFr" #'lsp-workspace-folders-remove
    "mFa" #'lsp-workspace-folders-add)
  )

;;; json major mode
(evil-leader/set-key-for-mode 'json-mode "m=" 'prettier-js)

;;; java major mode
(evil-leader/set-key-for-mode 'java-mode
  "mpu"  'lsp-java-update-user-settings
  ;; refactoring
  "mro" 'lsp-java-organize-imports
  "mrcp" 'lsp-java-create-parameter
  "mrcf" 'lsp-java-create-field
  "mrci" 'lsp-java-conver-to-static-import
  "mrec" 'lsp-java-extract-to-constant
  "mrel" 'lsp-java-extract-to-local-variable
  "mrem" 'lsp-java-extract-method
  ;; assign/add
  "mrai" 'lsp-java-add-import
  "mram" 'lsp-java-add-unimplemented-methods
  "mrat" 'lsp-java-add-throws
  "mraa" 'lsp-java-assign-all
  "mraf" 'lsp-java-assign-to-field
  ;; generate
  "mrgt" 'lsp-java-generate-to-string
  "mrge" 'lsp-java-generate-equals-and-hash-code
  "mrgo" 'lsp-java-generate-overrides
  "mrgg" 'lsp-java-generate-getters-and-setters
  ;; create/compile
  "mcc"  'lsp-java-build-project
  ;; "mcc" 'mvn-compile
  "mcp"  'lsp-java-spring-initializr

  "man"  'lsp-java-actionable-notifications

  ;; dap-mode
  ;; debug
  "mddj" 'dap-java-debug
  "mdtt" 'dap-java-debug-test-method
  "mdtc" 'dap-java-debug-test-class
  ;; run
  "mtt" 'dap-java-run-test-method
  ;; "mtt"   'maven-test-method
  "mtc" 'dap-java-run-test-class

  ;; non-lsp configurations
  "mcC" 'mvn-clean
  "mcr" 'petmacs/mvn-clean-compile
  ;; minor mode: maven-test-mode
  "mga"  'maven-test-toggle-between-test-and-class
  "mgA"  'maven-test-toggle-between-test-and-class-other-window
  "mta"   'maven-test-all
  "mtC-a" 'maven-test-clean-test-all
  "mtb"   'maven-test-file
  "mti"   'maven-test-install)

;;; python major mode
(evil-leader/set-key-for-mode 'python-mode
  "m==" 'yapfify-buffer
  "m." 'petmacs/python-load-venv-file
  "mcc" 'petmacs/python-execute-file
  "mcC" 'petmacs/python-execute-file-focus
  "mck" 'petmacs/quit-subjob
  "mdb" 'petmacs/python-insert-breakpoint
  "mdd" 'petmacs/python-delete-breakpoint
  "mdh" 'petmacs/python-highlight-breakpoint
  "mga" 'anaconda-mode-find-assignments
  "mgg" 'anaconda-mode-find-definitions
  "mgG" 'anaconda-mode-find-definitions-other-window
  "mgu" 'anaconda-mode-find-references
  "mhh" 'anaconda-mode-show-doc
  "mri" 'petmacs/python-remove-unused-imports
  "mrI" 'py-isort-buffer
  "msB" 'petmacs/python-shell-send-buffer-switch
  "msb" 'petmacs/python-shell-send-buffer
  "msb" 'petmacs/python-shell-send-buffer
  "msF" 'petmacs/python-shell-send-defun-switch
  "msf" 'petmacs/python-shell-send-defun
  "msi" 'petmacs/python-start-or-switch-repl
  "msr" 'petmacs/python-shell-send-region
  "msR" 'petmacs/python-shell-send-region-switch
  "msk" 'petmacs/python-interrupt-repl
  "msq" 'petmacs/python-quit-repl
  "mva" 'pyvenv-activate
  "mvd" 'pyvenv-deactivate
  "mvw" 'pyvenv-workon
  "mvpa" 'pipenv-activate
  "mvpd" 'pipenv-deactivate
  "mvpi" 'pipenv-install
  "mvpo" 'pipenv-open
  "mvps" 'pipenv-shell
  "mvpu" 'pipenv-uninstall)

;;; markdown major mode
(evil-leader/set-key-for-mode 'markdown-mode
  ;; Movement
  "m{"   'markdown-backward-paragraph
  "m}"   'markdown-forward-paragraph
  ;; Completion, and Cycling
  "m]"   'markdown-complete
  ;; Indentation
  "m>"   'markdown-indent-region
  "m<"   'markdown-outdent-region
  ;; Buffer-wide commands
  "mc]"  'markdown-complete-buffer
  "mcc"  'markdown-check-refs
  "mce"  'markdown-export
  "mcm"  'markdown-other-window
  "mcn"  'markdown-cleanup-list-numbers
  ;; "mco"  'markdown-open
  "mco"  'petmacs/open-markdown-in-typora
  "mcp"  'markdown-preview
  "mcv"  'markdown-export-and-preview
  "mcw"  'markdown-kill-ring-save
  ;; headings
  "mhi"  'markdown-insert-header-dwim
  "mhI"  'markdown-insert-header-setext-dwim
  "mh1"  'markdown-insert-header-atx-1
  "mh2"  'markdown-insert-header-atx-2
  "mh3"  'markdown-insert-header-atx-3
  "mh4"  'markdown-insert-header-atx-4
  "mh5"  'markdown-insert-header-atx-5
  "mh6"  'markdown-insert-header-atx-6
  "mh!"  'markdown-insert-header-setext-1
  "mh@"  'markdown-insert-header-setext-2
  ;; Insertion of common elements
  "m-"   'markdown-insert-hr
  "mif"  'markdown-insert-footnote
  "mii"  'markdown-insert-image
  "mik"  'petmacs/insert-keybinding-markdown
  "mil"  'markdown-insert-link
  "miw"  'markdown-insert-wiki-link
  "miu"  'markdown-insert-uri
  ;; Element removal
  "mk"   'markdown-kill-thing-at-point
  ;; List editing
  "mli"  'markdown-insert-list-item
  ;; Toggles
  "mti"  'markdown-toggle-inline-images
  "mtm"  'markdown-toggle-markup-hiding
  "mtl"  'markdown-toggle-url-hiding
  "mtt"  'markdown-toggle-gfm-checkbox
  "mtw"  'markdown-toggle-wiki-links
  ;; region manipulation
  "mxb"  'markdown-insert-bold
  "mxi"  'markdown-insert-italic
  "mxc"  'markdown-insert-code
  "mxC"  'markdown-insert-gfm-code-block
  "mxq"  'markdown-insert-blockquote
  "mxQ"  'markdown-blockquote-region
  "mxp"  'markdown-insert-pre
  "mxP"  'markdown-pre-region
  ;; Following and Jumping
  "mN"   'markdown-next-link
  "mf"   'markdown-follow-thing-at-point
  "mP"   'markdown-previous-link
  "m <RET>" 'markdown-do
  "mit" 'markdown-toc-generate-toc
  "mcP" 'vmd-mode)

;;; org major mode
(evil-leader/set-key-for-mode 'org-mode
  ;; Movement
  ;; "mC"   'evil-org-recompute-clocks
  "m'" 'org-edit-special
  "mc" 'org-capture

  ;; Clock
  ;; These keybindings should match those under the "aoC" prefix (below)
  "mCc" 'org-clock-cancel
  "mCd" 'org-clock-display
  "mCe" 'org-evaluate-time-range
  "mCg" 'org-clock-goto
  "mCi" 'org-clock-in
  "mCI" 'org-clock-in-last
  "mCj" 'petmacs/org-clock-jump-to-current-clock
  "mCo" 'org-clock-out
  "mCR" 'org-clock-report
  "mCr" 'org-resolve-clocks
  "mCp" 'org-pomodoro

  "mdd" 'org-deadline
  "mds" 'org-schedule
  "mdt" 'org-time-stamp
  "mdT" 'org-time-stamp-inactive
  "mee" 'org-export-dispatch
  "mfi" 'org-feed-goto-inbox
  "mfu" 'org-feed-update-all

  "ma" 'org-agenda

  "mp" 'org-priority

  "mTc" 'org-toggle-checkbox
  "mTe" 'org-toggle-pretty-entities
  "mTi" 'org-toggle-inline-images
  "mTl" 'org-toggle-link-display
  "mTt" 'org-show-todo-tree
  "mTT" 'org-todo
  "mTV" 'space-doc-mode
  "mTx" 'org-toggle-latex-fragment

  ;; More cycling options (timestamps, headlines, items, properties)
  "mL" 'org-shiftright
  "mH" 'org-shiftleft
  "mJ" 'org-shiftdown
  "mK" 'org-shiftup

  ;; Change between TODO sets
  "m C-S-l" 'org-shiftcontrolright
  "m C-S-h" 'org-shiftcontrolleft
  "m C-S-j" 'org-shiftcontroldown
  "m C-S-k" 'org-shiftcontrolup

  ;; Subtree editing
  "msa" 'org-toggle-archive-tag
  "msA" 'org-archive-subtree
  "msb" 'org-tree-to-indirect-buffer
  "msd" 'org-cut-subtree
  "msh" 'org-promote-subtree
  "msj" 'org-move-subtree-down
  "msk" 'org-move-subtree-up
  "msl" 'org-demote-subtree
  "msn" 'org-narrow-to-subtree
  "msN" 'widen
  "msr" 'org-refile
  "mss" 'org-sparse-tree
  "msS" 'org-sort

  ;; tables
  "mta" 'org-table-align
  "mtb" 'org-table-blank-field
  "mtc" 'org-table-convert
  "mtdc" 'org-table-delete-column
  "mtdr" 'org-table-kill-row
  "mte" 'org-table-eval-formula
  "mtE" 'org-table-export
  "mth" 'org-table-previous-field
  "mtH" 'org-table-move-column-left
  "mtic" 'org-table-insert-column
  "mtih" 'org-table-insert-hline
  "mtiH" 'org-table-hline-and-move
  "mtir" 'org-table-insert-row
  "mtI" 'org-table-import
  "mtj" 'org-table-next-row
  "mtJ" 'org-table-move-row-down
  "mtK" 'org-table-move-row-up
  "mtl" 'org-table-next-field
  "mtL" 'org-table-move-column-right
  "mtn" 'org-table-create
  "mtN" 'org-table-create-with-table.el
  "mtr" 'org-table-recalculate
  "mts" 'org-table-sort-lines
  "mttf" 'org-table-toggle-formula-debugger
  "mtto" 'org-table-toggle-coordinate-overlays
  "mtw" 'org-table-wrap-region

  ;; Source blocks / org-babel
  "mbp"     'org-babel-previous-src-block
  "mbn"     'org-babel-next-src-block
  "mbe"     'org-babel-execute-maybe
  "mbo"     'org-babel-open-src-block-result
  "mbv"     'org-babel-expand-src-block
  "mbu"     'org-babel-goto-src-block-head
  "mbg"     'org-babel-goto-named-src-block
  "mbr"     'org-babel-goto-named-result
  "mbb"     'org-babel-execute-buffer
  "mbs"     'org-babel-execute-subtree
  "mbd"     'org-babel-demarcate-block
  "mbt"     'org-babel-tangle
  "mbf"     'org-babel-tangle-file
  "mbc"     'org-babel-check-src-block
  "mbj"     'org-babel-insert-header-arg
  "mbl"     'org-babel-load-in-session
  "mbi"     'org-babel-lob-ingest
  "mbI"     'org-babel-view-src-block-info
  "mbz"     'org-babel-switch-to-session
  "mbZ"     'org-babel-switch-to-session-with-code
  "mba"     'org-babel-sha1-hash
  "mbx"     'org-babel-do-key-sequence-in-edit-buffer
  "mb."     'org-babel-transient-state/body
  ;; Multi-purpose keys
  "m," 'org-ctrl-c-ctrl-c
  "m*" 'org-ctrl-c-star
  "m-" 'org-ctrl-c-minus
  "m#" 'org-update-statistics-cookies
  "m RET"   'org-ctrl-c-ret
  "m M-RET" 'org-meta-return
  ;; attachments
  "mA" 'org-attach
  ;; insertion
  "mib" 'org-insert-structure-template
  "mid" 'org-insert-drawer
  "mie" 'org-set-effort
  "mif" 'org-footnote-new
  "mih" 'org-insert-heading
  "miH" 'org-insert-heading-after-current
  "mii" 'org-insert-item
  "miK" 'petmacs/insert-keybinding-org
  "mil" 'org-insert-link
  "min" 'org-add-note
  "mip" 'org-set-property
  "mis" 'org-insert-subheading
  "mit" 'org-set-tags-command
  ;; region manipulation
  "mxo" 'org-open-at-point
  )

(evil-leader/set-key-for-mode 'org-agenda-mode
  "ma" 'org-agenda
  "mCc" 'org-agenda-clock-cancel
  "mCi" 'org-agenda-clock-in
  "mCo" 'org-agenda-clock-out
  "mCp" 'org-pomodoro
  "mdd" 'org-agenda-deadline
  "mds" 'org-agenda-schedule
  "mie" 'org-agenda-set-effort
  "mip" 'org-agenda-set-property
  "mit" 'org-agenda-set-tags
  "msr" 'org-agenda-refile
  )

(with-eval-after-load 'org-agenda
  (evil-set-initial-state 'org-agenda-mode 'normal)
  (evil-define-key 'normal org-agenda-mode-map
    "j" 'org-agenda-next-line
    "k" 'org-agenda-previous-line
    ;; C-h should not be rebound by evilification so we unshadow it manually
    ;; TODO add the rule in auto-evilification to ignore C-h (like we do
    ;; with C-g)
    (kbd "<RET>") 'org-agenda-switch-to
    (kbd "\t") 'org-agenda-goto

    "q" 'org-agenda-quit
    "r" 'org-agenda-redo
    "S" 'org-save-all-org-buffers
    "gj" 'org-agenda-goto-date
    "gJ" 'org-agenda-clock-goto
    "gm" 'org-agenda-bulk-mark
    "go" 'org-agenda-open-link
    "s" 'org-agenda-schedule
    "+" 'org-agenda-priority-up
    "," 'org-agenda-priority
    "-" 'org-agenda-priority-down
    "y" 'org-agenda-todo-yesterday
    "n" 'org-agenda-add-note
    "t" 'org-agenda-todo
    ":" 'org-agenda-set-tags
    ";" 'org-timer-set-timer
    "I" 'helm-org-task-file-headings
    "i" 'org-agenda-clock-in-avy
    "O" 'org-agenda-clock-out-avy
    "u" 'org-agenda-bulk-unmark
    "x" 'org-agenda-exit
    "j"  'org-agenda-next-line
    "k"  'org-agenda-previous-line
    "vt" 'org-agenda-toggle-time-grid
    "va" 'org-agenda-archives-mode
    "vw" 'org-agenda-week-view
    "vl" 'org-agenda-log-mode
    "vd" 'org-agenda-day-view
    "vc" 'org-agenda-show-clocking-issues
    "g/" 'org-agenda-filter-by-tag
    "o" 'delete-other-windows
    "gh" 'org-agenda-holiday
    "gv" 'org-agenda-view-mode-dispatch
    "f" 'org-agenda-later
    "b" 'org-agenda-earlier
    "c" 'helm-org-capture-templates
    "e" 'org-agenda-set-effort
    "n" nil  ; evil-search-next
    "{" 'org-agenda-manipulate-query-add-re
    "}" 'org-agenda-manipulate-query-subtract-re
    "A" 'org-agenda-toggle-archive-tag
    "." 'org-agenda-goto-today
    "0" 'evil-digit-argument-or-evil-beginning-of-line
    "<" 'org-agenda-filter-by-category
    ">" 'org-agenda-date-prompt
    "F" 'org-agenda-follow-mode
    "D" 'org-agenda-deadline
    "H" 'org-agenda-holidays
    "J" 'org-agenda-next-date-line
    "K" 'org-agenda-previous-date-line
    "L" 'org-agenda-recenter
    "P" 'org-agenda-show-priority
    "R" 'org-agenda-clockreport-mode
    "Z" 'org-agenda-sunrise-sunset
    "T" 'org-agenda-show-tags
    "X" 'org-agenda-clock-cancel
    "[" 'org-agenda-manipulate-query-add
    "g\\" 'org-agenda-filter-by-tag-refine
    "]" 'org-agenda-manipulate-query-subtract

    (kbd "C-h") nil
    (kbd "M-j") 'org-agenda-next-item
    (kbd "M-k") 'org-agenda-previous-item
    (kbd "M-h") 'org-agenda-earlier
    (kbd "M-l") 'org-agenda-later
    (kbd "gd") 'org-agenda-toggle-time-grid
    (kbd "gr") 'org-agenda-redo
    (kbd "M-RET") 'org-agenda-show-and-scroll-up
    (kbd "M-SPC") 'org-agenda-transient-state/body
    (kbd "s-M-SPC") 'org-agenda-transient-state/body
    ))

(with-eval-after-load 'org-capture
  (evil-define-minor-mode-key 'normal 'org-capture-mode
    (kbd "c") 'org-capture-finalize
    (kbd "k") 'org-capture-kill
    (kbd "a") 'org-capture-kill
    (kbd "r") 'org-capture-refile))
(with-eval-after-load 'org-src
  (evil-define-minor-mode-key 'normal 'org-src-mode
    "c" 'org-edit-src-exit
    "a" 'org-edit-src-abort
    "k" 'org-edit-src-abort))

;;;; evil jumps
;;; evil jump in python mode
(evil-define-minor-mode-key 'normal 'anaconda-mode
  (kbd "gd") 'anaconda-mode-find-definitions
  (kbd "gD") 'anaconda-mode-find-definitions-other-window)

;; evil jump in elisp mode
(evil-define-key 'normal emacs-lisp-mode-map (kbd "gD") 'petmacs/evil-goto-definition-other-window)

(provide 'leader-keybindings)

;;; leader-keybindings ends here
