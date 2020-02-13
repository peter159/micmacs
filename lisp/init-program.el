;; init-program.el --- Setup programming useful packages.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

(use-package fill-column-indicator
  :preface
  (defun petmacs//change-fci-rule-color (&rest args)
    "Change the fill-column-indicator based on the background.
    ARGS is only used because we use this function as advice after
    `load-theme'."
    (setq fci-rule-color (face-attribute 'font-lock-function-name-face :foreground))
    (let* ((bufs (buffer-list)))
      (dolist (buf bufs)
	(with-current-buffer buf
          (when (bound-and-true-p fci-mode)
            (fci-make-overlay-strings)
            (fci-update-all-windows t))))))
  :hook (prog-mode . (lambda ()
		       (fci-mode 1)
		       (fci-update-all-windows t)))
  :init
  (setq fci-rule-color (face-attribute 'font-lock-function-name-face :foreground))
  (setq fci-rule-use-dashes t)
  (advice-add 'load-theme :after 'petmacs//change-fci-rule-color))

(use-package imenu-list
  :defer t
  :hook (imenu-list-major-mode . (lambda ()
				   (display-line-numbers-mode -1)
				   (hl-line-mode -1)))
  :init
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize nil)
  :init
  (evil-define-key 'normal imenu-list-major-mode-map (kbd "d") 'imenu-list-display-entry)
  (evil-define-key 'normal imenu-list-major-mode-map (kbd "r") 'imenu-list-refresh) 
  (evil-define-key 'normal imenu-list-major-mode-map (kbd "q") 'imenu-list-quit-window)
  (evil-define-key 'normal imenu-list-major-mode-map [down-mouse-1] 'imenu-list-display-entry))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package prettify-utils
  :quelpa
  (prettify-utils :repo "Ilazki/prettify-utils.el" :fetcher github))

(use-package pretty-code
  :ensure nil
  :init
  (require 'pretty-code)
  (pretty-code-add-hook 'python-mode-hook     '((:def "def")
    					        (:lambda "lambda")))
  (pretty-code-add-hook 'emacs-lisp-mode-hook '((:def "defun")
						(:lambda "lambda"))))

(use-package electric-operator
  :hook ((c-mode-common . electric-operator-mode)
         (python-mode . electric-operator-mode)
	 (go-mode . electric-operator-mode)
         (electric-operator-mode . (lambda ()
                                     (electric-operator-add-rules-for-mode 'c++-mode
									   (cons "-" nil)
									   (cons "->" nil)
                                                                           (cons "*" nil)
                                                                           (cons "&" nil))
                                     (electric-operator-add-rules-for-mode 'c-mode
									   (cons "-" nil)
									   (cons "->" nil)
                                                                           (cons "*" nil))
                                     (electric-operator-add-rules-for-mode 'go-mode
									   (cons ":" nil)
                                                                           (cons ":=" " := ")
									   (cons "==" " == "))
				     ))))

;; (use-package composite
;;   :ensure nil
;;   :init
;;   (defvar composition-ligature-table (make-char-table nil))
;;   :hook
;;   (((prog-mode conf-mode nxml-mode markdown-mode help-mode)
;;     . (lambda () (setq-local composition-function-table composition-ligature-table))))
;;   :config
;;   ;; support ligatures, some toned down to prevent hang
;;   (when (version<= "27.0" emacs-version)
;;     (let ((alist
;;            '((33 . ".\\(?:\\(==\\|[!=]\\)[!=]?\\)")
;;              (35 . ".\\(?:\\(###?\\|_(\\|[(:=?[_{]\\)[#(:=?[_{]?\\)")
;;              (36 . ".\\(?:\\(>\\)>?\\)")
;;              (37 . ".\\(?:\\(%\\)%?\\)")
;;              (38 . ".\\(?:\\(&\\)&?\\)")
;;              (42 . ".\\(?:\\(\\*\\*\\|[*>]\\)[*>]?\\)")
;;              ;; (42 . ".\\(?:\\(\\*\\*\\|[*/>]\\).?\\)")
;;              (43 . ".\\(?:\\([>]\\)>?\\)")
;;              ;; (43 . ".\\(?:\\(\\+\\+\\|[+>]\\).?\\)")
;;              (45 . ".\\(?:\\(-[->]\\|<<\\|>>\\|[-<>|~]\\)[-<>|~]?\\)")
;;              ;; (46 . ".\\(?:\\(\\.[.<]\\|[-.=]\\)[-.<=]?\\)")
;;              (46 . ".\\(?:\\(\\.<\\|[-=]\\)[-<=]?\\)")
;;              (47 . ".\\(?:\\(//\\|==\\|[=>]\\)[/=>]?\\)")
;;              ;; (47 . ".\\(?:\\(//\\|==\\|[*/=>]\\).?\\)")
;;              (48 . ".\\(?:\\(x[a-fA-F0-9]\\).?\\)")
;;              (58 . ".\\(?:\\(::\\|[:<=>]\\)[:<=>]?\\)")
;;              (59 . ".\\(?:\\(;\\);?\\)")
;;              (60 . ".\\(?:\\(!--\\|\\$>\\|\\*>\\|\\+>\\|-[-<>|]\\|/>\\|<[-<=]\\|=[<>|]\\|==>?\\||>\\||||?\\|~[>~]\\|[$*+/:<=>|~-]\\)[$*+/:<=>|~-]?\\)")
;;              (61 . ".\\(?:\\(!=\\|/=\\|:=\\|<<\\|=[=>]\\|>>\\|[=>]\\)[=<>]?\\)")
;;              (62 . ".\\(?:\\(->\\|=>\\|>[-=>]\\|[-:=>]\\)[-:=>]?\\)")
;;              (63 . ".\\(?:\\([.:=?]\\)[.:=?]?\\)")
;;              (91 . ".\\(?:\\(|\\)[]|]?\\)")
;;              ;; (92 . ".\\(?:\\([\\n]\\)[\\]?\\)")
;;              (94 . ".\\(?:\\(=\\)=?\\)")
;;              (95 . ".\\(?:\\(|_\\|[_]\\)_?\\)")
;;              (119 . ".\\(?:\\(ww\\)w?\\)")
;;              (123 . ".\\(?:\\(|\\)[|}]?\\)")
;;              (124 . ".\\(?:\\(->\\|=>\\||[-=>]\\||||*>\\|[]=>|}-]\\).?\\)")
;;              (126 . ".\\(?:\\(~>\\|[-=>@~]\\)[-=>@~]?\\)"))))
;;       (dolist (char-regexp alist)
;;         (set-char-table-range composition-ligature-table (car char-regexp)
;;                               `([,(cdr char-regexp) 0 font-shape-gstring]))))
;;     (set-char-table-parent composition-ligature-table composition-function-table))
;;   )


;; Flexible text folding
(use-package origami
  :pretty-hydra
  ((:title (pretty-hydra-title "Origami" 'octicon "fold")
    :color blue :quit-key "q")
   ("Node"
    ((":" origami-recursively-toggle-node "toggle recursively")
     ("a" origami-toggle-all-nodes "toggle all")
     ("t" origami-toggle-node "toggle current")
     ("o" origami-show-only-node "only show current"))
    "Actions"
    (("u" origami-undo "undo")
     ("d" origami-redo "redo")
     ("r" origami-reset "reset"))))
  :bind (:map origami-mode-map
         ("C-`" . origami-hydra/body))
  :hook (prog-mode . origami-mode)
  :init (setq origami-show-fold-header t)
  :config (face-spec-reset-face 'origami-fold-header-face))

;; Compilation Mode
(use-package compile
  :ensure nil
  :hook (compilation-filter . my-colorize-compilation-buffer)
  :init
  ;; ANSI Coloring
  ;; @see https://stackoverflow.com/questions/13397737/ansi-coloring-in-compilation-mode
  (defun my-colorize-compilation-buffer ()
    "ANSI coloring in compilation buffers."
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max)))))

;; Run commands quickly
(use-package quickrun
  :init (setq quickrun-focus-p nil))

;; Docker
(use-package docker
  :bind ("C-c d" . docker)
  :init (setq docker-image-run-arguments '("-i" "-t" "--rm")
              docker-container-shell-file-name "/bin/bash"))

(use-package dockerfile-mode)
(use-package docker-tramp)
(use-package csv-mode)
(use-package protobuf-mode)

(provide 'init-program)

;;; init-program.el ends here
