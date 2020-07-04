;;; init-custom-vars.el ---                          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  linyi

;; Author: linyi <linyi@ubu-born-0>
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

(defvar petmacs-evil-major-leader-insert-default-key "M-m"
  "Evil leader key in evil insert mode.")

(defvar petmacs-lsp-active-modes '(
				   c-mode
				   c++-mode
				   python-mode
				   java-mode
				   scala-mode
				   go-mode
				   sh-mode
				   )
  "Primary major modes of the lsp activated layer.")

(provide 'init-custom-vars)
(message "init-custom-vars loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-custom-vars.el ends here
