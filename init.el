;;; init.el ---mimic spacemac but simpler

;;; commentary

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
(require 'init-org)
(require 'init-json)
(require 'init-yaml)
(require 'init-sql)

(require 'init-eshell)
(require 'init-misc)

(require 'leader-core-functions)
(require 'leader-key-binding)

