;;; init-lsp.el ---                                  -*- lexical-binding: t; -*-

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

;; https://github.com/andreyorst/dotfiles/tree/master/.config/emacs
(use-package lsp-mode
  :hook ((rust-mode c-mode c++-mode) . lsp)
  :custom
  (lsp-enable-links nil)
  (lsp-keymap-prefix "C-c l")
  (lsp-rust-clippy-preference "on")
  (lsp-prefer-capf t)
  (lsp-enable-symbol-highlighting nil)
  (lsp-rust-server 'rust-analyzer)
  (lsp-session-file (expand-file-name "lsp-session" user-emacs-directory)))(use-package lsp-mode
  :hook ((rust-mode c-mode c++-mode) . lsp)
  :custom
  (lsp-enable-links nil)
  (lsp-keymap-prefix "C-c l")
  (lsp-rust-clippy-preference "on")
  (lsp-prefer-capf t)
  (lsp-enable-symbol-highlighting nil)
  (lsp-rust-server 'rust-analyzer)
  (lsp-session-file (expand-file-name "lsp-session" user-emacs-directory)))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :bind (:map lsp-ui-mode-map
	      ("M-." . lsp-ui-peek-find-definitions)
	      ("M-/" . lsp-ui-peek-find-references))
  :custom
  (lsp-ui-doc-border (face-attribute 'mode-line-inactive :background))
  (lsp-ui-sideline-enable nil)
  (lsp-ui-imenu-enable nil)
  (lsp-ui-doc-delay 1 "higher than eldoc delay")
  :config
  (when (fboundp 'aorst/escape)
    (define-advice lsp-ui-doc--make-request (:around (foo))
      (unless (eq this-command 'aorst/escape)
        (funcall foo))))
  (lsp-ui-mode))

(provide 'init-lsp)
(message "init-lsp loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-lsp.el ends here
