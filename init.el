;;; init.el ---MiMacs

;;; commentary
;; This to trying to mimic spacemacs features but simpler and easy to manage

;;; code

;;; require package manager, config archives source and initialize all
(require 'package)

;; use mirror
(setq-default package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
				 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
				 ("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")))

;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path (&rest _)
  "Update `load-path'."
  (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
  (push (expand-file-name "lisp" user-emacs-directory) load-path))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory
	  (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)
(add-subdirs-to-load-path)

;; Initialize packages
(package-initialize)

;; ;; ********************************************************************************************************
;; ;;                                          for debuging usage only
;; ;; ********************************************************************************************************
;; ;; Display the total loading time in the minibuffer
(defun display-startup-echo-area-message ()
  "Display startup echo area message."
  (message "Initialized in %s" (emacs-init-time)))

;; ;; Benchmark loading time file by file and display it in the *Messages* buffer
;; (when init-file-debug
;;   (require 'benchmark)
;;   (let ((lisp-dir "~/.emacs.d/lisp"))
;;   (add-to-list 'load-path lisp-dir)
;;   (mapc (lambda (fname)
;;           (let ((feat (intern (file-name-base fname))))
;;             (if init-file-debug
;;                 (message "Feature '%s' loaded in %.2fs" feat
;;                          (benchmark-elapse (require feat fname)))
;;               (require feat fname))))
;;         (directory-files lisp-dir t "\\.el"))))

;; ;; (let ((lisp-dir "~/.emacs.d/lisp"))
;; ;;   (add-to-list 'load-path lisp-dir)
;; ;;   (mapc (lambda (fname)
;; ;;           (let ((feat (intern (file-name-base fname))))
;; ;;             (if init-file-debug
;; ;;                 (message "Feature '%s' loaded in %.2fs" feat
;; ;;                          (benchmark-elapse (require feat fname)))
;; ;;               (require feat fname))))
;; ;;         (directory-files lisp-dir t "\\.el")))
;; ;; ********************************************************************************************************
;; ;;                                            for debuging usage only 
;; ;; ********************************************************************************************************

;; requre features from lisp

(require 'init-general-functions)
(require 'init-package-management)
(require 'init-default)
(require 'init-font)
(require 'init-ui)

(require 'init-evil)
(require 'init-company)
(require 'init-dired)
(require 'init-tool)
(require 'init-ivy)
(require 'init-ibuffer)
(require 'init-window)
(require 'init-layout)

(require 'init-highlight)
(require 'init-version-control)
(require 'init-project)
(require 'init-yasnippet)
(require 'init-treemacs)

(require 'init-program)
;; (require 'init-flycheck)
;; (require 'init-lsp)
(require 'init-elisp)
(require 'init-c-c++)
(require 'init-python)
(require 'init-ess)
;; (require 'init-Ress)
;; (require 'init-org)
(require 'init-json)
(require 'init-yaml)
(require 'init-sql)

(require 'init-eshell)
(require 'init-misc)

(require 'leader-core-functions)
(require 'leader-key-binding)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (electric-spacing yasnippet-snippets yapfify yaml-mode winum which-key virtualenvwrapper vim-empty-lines-mode unicode-fonts treemacs-projectile treemacs-evil toc-org symbol-overlay sqlup-mode sql-indent smart-semicolon rg restart-emacs ranger rainbow-delimiters quelpa-use-package pyvenv prettify-utils prettier-js popwin persp-mode-projectile-bridge org-preview-html org-pomodoro org-dashboard org-bullets olivetti ob-ipython magit-todos lsp-ui json-mode ivy-yasnippet ivy-xref ivy-hydra imenu-list hungry-delete hlinum highlight-indent-guides hide-mode-line gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-gutter fontify-face font-lock+ flycheck flx fill-column-indicator expand-region evil-visualstar evil-surround evil-major-leader evil-magit evil-fringe-mark evil-escape evil-commentary evil-anzu esup ess eshell-z eshell-prompt-extras esh-help elisp-refs electric-operator editorconfig doom-themes doom-modeline diredfl diminish diffview default-text-scale daemons counsel-tramp counsel-projectile company-lsp company-anaconda centered-cursor-mode ccls carbon-now-sh browse-at-remote beacon amx aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
 '(doom-modeline-buffer-file ((t (:inherit font-lock-string-face :weight bold))))
 '(epe-pipeline-delimiter-face ((t (:foreground "#fd780f" :weight bold))))
 '(epe-pipeline-host-face ((t (:foreground "#3cd8a2" :weight bold))))
 '(epe-pipeline-time-face ((t (:foreground "#e2c504"))))
 '(epe-pipeline-user-face ((t (:foreground "#ef2d2d" :weight bold))))
 '(git-gutter:added ((t (:background "#50fa7b"))))
 '(git-gutter:deleted ((t (:background "#ff79c6"))))
 '(git-gutter:modified ((t (:background "#f1fa8c"))))
 '(hl-todo ((t (:box t :inherit (quote hl-todo)))))
 '(linum-highlight-face ((t (:inherit (quote default) :background "SystemWindow" :foreground "SystemWindowText")))))
