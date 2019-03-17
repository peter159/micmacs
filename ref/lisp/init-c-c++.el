;; init-c-c++.el --- Setup c/c++ IDE.  -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; C/C++/Objective-C support
(use-package ccls
  :defines projectile-project-root-files-top-down-recurring
  :hook ((c-mode c++-mode objc-mode cuda-mode) . (lambda ()
                                                  (require 'ccls)
                                                  (lsp)))
  :init
  (setq ccls-executable (file-truename "~/ccls/Release/ccls"))
  (setq ccls-initialization-options
  	(if (boundp 'ccls-initialization-options)
  	    (append ccls-initialization-options `(:cache (:directory ,(expand-file-name "~/.ccls-cache"))))
  	  `(:cache (:directory ,(expand-file-name "~/.ccls-cache")))))

  ;; (setq ccls-sem-highlight-method 'overlay)  ; overlay is slow
  (setq ccls-sem-highlight-method 'font-lock)

  :config
  (with-eval-after-load 'projectile
    (setq projectile-project-root-files-top-down-recurring
  	  (append '("compile_commands.json"
  		    ".ccls")
  		  projectile-project-root-files-top-down-recurring))))

(use-package smart-semicolon
  :defer t
  :hook ((c-mode-common . smart-semicolon-mode)))

(provide 'init-c-c++)

;;; init-c-c++.el ends here
