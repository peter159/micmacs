;;; init-shell_bak.el ---                            -*- lexical-binding: t; -*-

;; Copyright (C) 2019  

;; Author:  <lipe6002@SHA-LPC-03254>
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


(load "init-shell/config")
(load "init-shell/funcs")
(load "init-shell/packages")

(defun my-shell-here()
  "open shell here and automatically close window when quiting the shell"
  (interactive)
  (let ((file-name-directory (buffer-file-name)))
    (call-interactively 'spacemacs/default-pop-shell)))

(setq shell-default-shell 'shell)

(make-shell-pop-command eshell)
(make-shell-pop-command term shell-pop-term-shell)
(make-shell-pop-command ansi-term shell-pop-term-shell)
(make-shell-pop-command inferior-shell)
(make-shell-pop-command multiterm)

(provide 'init-shell_bak)
;;; init-shell_bak.el ends here
