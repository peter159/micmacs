;;; init-html.el ---                                 -*- lexical-binding: t; -*-

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
;; ref: https://ithelp.ithome.com.tw/articles/10202632

;;

;;; Code:

(mark-time-here)

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'")
  :hook
  (html-mode . web-mode)
  (web-mode . (lambda()
		(lsp-deferred))))

(use-package emmet-mode
  :ensure t
  :hook
  (html-mode . emmet-mode)
  (web-mode . emmet-mode))

;; (use-package web-mode
;;   :ensure t
;;   :mode ("\\.html\\'")
;;   :config
;;   (setq web-mode-markup-indent-offset 2)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-code-indent-offset 2)
;;   (setq web-mode-enable-current-element-highlight t)
;;   (setq web-mode-enable-css-colorization t)
;;   (use-package company-web
;;     :ensure t
;;     :config
;;     (add-hook 'web-mode-hook (lambda()
;;                                (cond ((equal web-mode-content-type "html")
;;                                       (my/web-html-setup)))))))

;; (defun my/web-html-setup()
;;   "Setup for web-mod html files."
;;   (message "web-mode use html related setup")
;;   (flycheck-add-mode 'html-tidy 'web-mode)
;;   (flycheck-select-checker 'html-tidy)
;;   (add-to-list (make-local-variable 'company-backends)
;;                `(company-web-html company-files company-css company-capf company-keywords))
;;   (add-hook 'before-save-hook 'sgml-pretty-print)
;;   )

;; (use-package css-mode
;;   :ensure t
;;   :mode "\\.css\\'"
;;   :config
;;   (add-hook 'css-mode-hook (lambda()
;;                              (add-to-list (make-local-variable 'company-backends)
;;                                           '(company-css company-files company-yasnippet company-capf))))
;;   (setq css-indent-offset 2)
;;   (setq flycheck-stylelintrc "~/.stylelintrc"))

;; (use-package scss-mode
;;   :ensure t
;;   :mode "\\.scss\\'")

;; (use-package emmet-mode
;;   :ensure t
;;   :hook (web-mode css-mode scss-mode sgml-mode)
;;   :config
;;   (add-hook 'emmet-mode-hook (lambda ()
;;                                (setq emmet-indent-after-insert t))))

(provide 'init-html)
(message "init-html loaded in '%.2f' seconds" (get-time-diff time-marked))
;;; init-html.el ends here
