;; init-default.el --- Setup defaults.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'init-const)
  (require 'init-custom))

;; use exec-path-from-shell in linux / mac
(when (or (eq system-type 'gnu/linux) (eq system-type 'darwin))
  (use-package exec-path-from-shell
    :init
    (setq exec-path-from-shell-check-startup-files nil)
    (setq exec-path-from-shell-variables '("PATH" "MANPATH" "PYTHONPATH" "GOPATH"))
    (setq exec-path-from-shell-arguments '("-l"))
    (exec-path-from-shell-initialize)))

;; maximize emacs after initialization
;; (toggle-frame-maximized)

;; fix print gibberish when in windows system 
;; https://blog.csdn.net/sanwu2010/article/details/23994977
;; (if sys/win32p
;;     (progn
;;       (set-language-environment 'Chinese-GB)
;;       ;; default-buffer-file-coding-system变量在emacs23.2之后已被废弃，使用buffer-file-coding-system代替
;;       (set-default buffer-file-coding-system 'utf-8-unix)
;;       (set-default-coding-systems 'utf-8-unix)
;;       (setq-default pathname-coding-system 'euc-cn)
;;       (setq file-name-coding-system 'euc-cn)
;;       ;; 另外建议按下面的先后顺序来设置中文编码识别方式。
;;       ;; 重要提示:写在最后一行的，实际上最优先使用; 最前面一行，反而放到最后才识别。
;;       ;; utf-16le-with-signature 相当于 Windows 下的 Unicode 编码，这里也可写成
;;       ;; utf-16 (utf-16 实际上还细分为 utf-16le, utf-16be, utf-16le-with-signature等多种)
;;       (prefer-coding-system 'cp950)
;;       (prefer-coding-system 'gb2312)
;;       (prefer-coding-system 'cp936)
;;       (prefer-coding-system 'gb18030)
;; 					;(prefer-coding-system 'utf-16le-with-signature)
;;       (prefer-coding-system 'utf-16)
;;       ;; 新建文件使用utf-8-unix方式
;;       ;; 如果不写下面两句，只写
;;       ;; (prefer-coding-system 'utf-8)
;;       ;; 这一句的话，新建文件以utf-8编码，行末结束符平台相关
;;       (prefer-coding-system 'utf-8-dos)
;;       (prefer-coding-system 'utf-8-unix)
;;       )
;;   (progn
;;     (set-language-environment petmacs-default-language-env)
;;     (set-default-coding-systems petmacs-default-coding-env)))

;; (modify-coding-system-alist 'process "python" '(utf-8 . chinese-gbk-dos))

(if sys/win32p
    (progn
      ;; for python output chinese
      ;; Emacs buffer -> python : encoding = utf8
      ;; python output -> Eamcs : decoding = chinese-gbk-dos
      (modify-coding-system-alist 'process "python" '(chinese-gbk-dos . utf-8))
      ;; format buffer
      ;; Emacs buffer -> python : encoding = utf8
      ;; python output -> Eamcs : decoding = chinese-gbk-dos
      (modify-coding-system-alist 'process "yapf" '(utf-8 . utf-8)))
  (progn
    ;; UTF-8 as the default coding system
    (when (fboundp 'set-charset-priority)
      (set-charset-priority 'unicode))
    (set-language-environment petmacs-default-language-env)
    (set-default-coding-systems petmacs-default-coding-env))
  (set-keyboard-coding-system petmacs-default-coding-env)
  (set-clipboard-coding-system petmacs-default-coding-env)
  (set-terminal-coding-system petmacs-default-coding-env)
  (set-buffer-file-coding-system petmacs-default-coding-env)
  (set-selection-coding-system petmacs-default-coding-env)
  (modify-coding-system-alist 'process "*" petmacs-default-coding-env)
  (set-file-name-coding-system petmacs-default-coding-env)

  (setq locale-coding-system 'utf-8
	default-process-coding-system '(utf-8 . utf-8)))

(setq delete-by-moving-to-trash t)         ; Deleting files go to OS's trash folder
(setq make-backup-files nil)               ; Forbide to make backup files
(setq auto-save-default nil)               ; Disable auto save
(setq create-lockfiles nil)                ; Disable lock files .#filename

(setq-default major-mode 'text-mode)

;; Compatibility
(unless (fboundp 'caadr)
  (defun caadr (x)
    "Return the `car' of the `car' of the `cdr' of X."
    (declare (compiler-macro internal--compiler-macro-cXXr))
    (car (car (cdr x)))))

;; UI
(unless (eq window-system 'ns)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

(setq-default fill-column 80)
(use-package simple
  :ensure nil
  :hook (after-init . size-indication-mode)
  :init (setq column-number-mode t
              line-number-mode t
              kill-whole-line t              ; Kill line including '\n'
              line-move-visual nil
              track-eol t                    ; Keep cursor at end of lines. Require line-move-visual is nil.
              set-mark-command-repeat-pop t)  ; Repeating C-SPC after popping mark pops it again
  )

;; Don't open a file in a new frame
(when (boundp 'ns-pop-up-frames)
  (setq ns-pop-up-frames nil))

;; Don't use GTK+ tooltip
(when (boundp 'x-gtk-use-system-tooltips)
  (setq x-gtk-use-system-tooltips nil))

;; Mouse & Smooth Scroll
;; Scroll one line at a time (less "jumpy" than defaults)
(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil))
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000)

;; Basic modes

;; Start server
(use-package server
  :ensure nil
  :hook (after-init . server-mode))

;; History
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; revert buffer without confimation
(setq revert-without-query '(".*"))

;; Pass a URL to a WWW browser
(use-package browse-url
  :ensure nil
  :defines dired-mode-map
  :bind (("C-c C-z ." . browse-url-at-point)
         ("C-c C-z b" . browse-url-of-buffer)
         ("C-c C-z r" . browse-url-of-region)
         ("C-c C-z u" . browse-url)
         ("C-c C-z v" . browse-url-of-file))
  :init
  (with-eval-after-load 'dired
    (bind-key "C-c C-z f" #'browse-url-of-file dired-mode-map)))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :init (setq recentf-max-saved-items 300
              recentf-exclude
              '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
                "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
                "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
                "^/tmp/" "^/var/folders/.+$" ; "^/ssh:"
                (lambda (file) (file-in-directory-p file package-user-dir))))
  :config (push (expand-file-name recentf-save-file) recentf-exclude))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :init (setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
					      global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300))

;; Show number of matches in mode-line while searching
(use-package anzu
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (after-init . global-anzu-mode))

;; A comprehensive visual interface to diff & patch
(use-package ediff
  :ensure nil
  :hook(;; show org ediffs unfolded
        (ediff-prepare-buffer . outline-show-all)
        ;; restore window layout when done
        (ediff-quit . winner-undo))
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-merge-split-window-function 'split-window-horizontally))

;; Automatic parenthesis pairing
(use-package elec-pair
  :ensure nil
  :hook (after-init . electric-pair-mode)
  :init (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit))

(use-package pretty-hydra
  :bind ("<f6>" . toggles-hydra/body)
  :init
  (with-no-warnings
    (cl-defun pretty-hydra-title (title &optional icon-type icon-name
                                        &key face height v-adjust)
      "Add an icon in the hydra title."
      (let ((face (or face `(:foreground ,(face-background 'highlight))))
            (height (or height 1.0))
            (v-adjust (or v-adjust 0.0)))
        (concat
         (when (and (display-graphic-p) icon-type icon-name)
           (let ((f (intern (format "all-the-icons-%s" icon-type))))
             (when (fboundp f)
               (concat
                (apply f (list icon-name :face face :height height :v-adjust v-adjust))
                " "))))
         (propertize title 'face face))))

    ;; Global toggles
    (pretty-hydra-define toggles-hydra (:title (pretty-hydra-title "Toggles" 'faicon "toggle-on")
                                        :color amaranth :quit-key "q")
      ("Basic"
       (("n" (if (fboundp 'display-line-numbers-mode)
                 (display-line-numbers-mode (if display-line-numbers-mode -1 1))
               (global-linum-mode (if global-linum-mode -1 1)))
         "line number" :toggle (if (fboundp 'display-line-numbers-mode)
                                   display-line-numbers-mode
                                 global-linum-mode))
        ("a" global-aggressive-indent-mode "aggressive indent" :toggle t)
        ("h" global-hungry-delete-mode "hungry delete" :toggle t)
        ("e" electric-pair-mode "electric pair" :toggle t)
        ("c" flyspell-mode "spell check" :toggle t)
        ("S" prettify-symbols-mode "pretty symbol" :toggle t)
        ("L" global-page-break-lines-mode "page break lines" :toggle t)
        ("M" doom-modeline-mode "modern mode-line" :toggle t))
       "Highlight"
       (("l" global-hl-line-mode "line" :toggle t)
        ("P" show-paren-mode "paren" :toggle t)
        ("s" symbol-overlay-mode "symbol" :toggle t)
        ("r" rainbow-mode "rainbow" :toggle t)
        ("w" (setq-default show-trailing-whitespace (not show-trailing-whitespace))
         "whitespace" :toggle show-trailing-whitespace)
        ("d" rainbow-delimiters-mode "delimiter" :toggle t)
        ("i" highlight-indent-guides-mode "indent" :toggle t)
        ("T" global-hl-todo-mode "todo" :toggle t))
       "Coding"
       (("f" global-flycheck-mode "flycheck" :toggle t)
        ("F" flymake-mode "flymake" :toggle t)
        ("o" origami-mode "folding" :toggle t)
        ("O" hs-minor-mode "hideshow" :toggle t)
        ("u" subword-mode "subword" :toggle t)
        ("W" which-function-mode "which function" :toggle t)
        ("E" toggle-debug-on-error "debug on error" :toggle (default-value 'debug-on-error))
        ("Q" toggle-debug-on-quit "debug on quit" :toggle (default-value 'debug-on-quit)))
       "Version Control"
       (("v" global-diff-hl-mode "gutter" :toggle t)
        ("V" diff-hl-flydiff-mode "live gutter" :toggle t)
        ("m" diff-hl-margin-mode "margin gutter" :toggle t)
        ("D" diff-hl-dired-mode "dired gutter" :toggle t))
       "Theme"
       (("t d" (centaur-load-theme 'default) "default"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'default)))
        ("t c" (centaur-load-theme 'classic) "classic"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'classic)))
        ("t r" (centaur-load-theme 'colorful) "colorful"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'colorfult)))
        ("t k" (centaur-load-theme 'dark) "dark"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'dark)))
        ("t l" (centaur-load-theme 'light) "light"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'light)))
        ("t y" (centaur-load-theme 'day) "day"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'day)))
        ("t n" (centaur-load-theme 'night) "night"
         :toggle (eq (centuar-current-theme) (centaur--standardize-theme 'night)))
        ("t o" (ivy-read "Load custom theme: "
                         (mapcar #'symbol-name
                                 (custom-available-themes))
                         :predicate (lambda (candidate)
                                      (string-prefix-p "doom-" candidate))
                         :action #'counsel-load-theme-action
                         :caller 'counsel-load-theme)
         "others"))
       "Package Archive"
       (("p m" (progn (setq centaur-package-archives 'melpa)
                      (set-package-archives centaur-package-archives))
         "melpa" :toggle (eq centaur-package-archives 'melpa))
        ("p i" (progn (setq centaur-package-archives 'melpa-mirror)
                      (set-package-archives centaur-package-archives))
         "melpa mirror" :toggle (eq centaur-package-archives 'melpa-mirror))
        ("p c" (progn (setq centaur-package-archives 'emacs-china)
                      (set-package-archives centaur-package-archives))
         "emacs china" :toggle (eq centaur-package-archives 'emacs-china))
        ("p n" (progn (setq centaur-package-archives 'netease)
                      (set-package-archives centaur-package-archives))
         "netease" :toggle (eq centaur-package-archives 'netease))
        ("p t" (progn (setq centaur-package-archives 'tencent)
                      (set-package-archives centaur-package-archives))
         "tencent" :toggle (eq centaur-package-archives 'tencent))
        ("p u" (progn (setq centaur-package-archives 'tuna)
                      (set-package-archives centaur-package-archives))
         "tuna" :toggle (eq centaur-package-archives 'tuna)))))))

;; Treat undo history as a tree
(use-package undo-tree
  :diminish
  :hook (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
        undo-tree-enable-undo-in-region nil
        undo-tree-auto-save-history nil)

  ;; WORKAROUND:  keep the diff window
  (with-no-warnings
    (make-variable-buffer-local 'undo-tree-visualizer-diff)
    (setq-default undo-tree-visualizer-diff t)))

;; Goto last change
(use-package goto-last-change)

;; Handling capitalized subwords in a nomenclature
(use-package subword
  :ensure nil
  :diminish
  :hook ((prog-mode . subword-mode)
         (minibuffer-setup . subword-mode)))

(defun icons-displayable-p ()
  "Return non-nil if `all-the-icons' is displayable."
  (and (display-graphic-p)
       (require 'all-the-icons nil t)))

(provide 'init-default)
;;; init-default.el ends here
