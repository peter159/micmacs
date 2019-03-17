;;; init-c-c++.el ---                                -*- lexical-binding: t; -*-

;; Copyright (C) 2019  

;; Author:  <peter.linyi@DESKTOP-PMTGUNT>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(mark-time-here)

(use-package ccls
  :ensure t
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
  :ensure t
  :defer t
  :hook ((c-mode-common . smart-semicolon-mode)))

(provide 'init-c-c++)
(message "init-c-c++ loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-c-c++.el ends here
