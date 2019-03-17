;;; init-sql.el ---                                  -*- lexical-binding: t; -*-

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

(use-package sql
  :ensure nil
  :hook (sql-mode . (lambda ()
		      (set (make-local-variable 'company-backends)
			   '((company-capf company-files)))))
  )

(use-package sql-indent
  :ensure nil
  :quelpa
  (sql-indent :fetcher github
  	      :repo "alex-hhh/emacs-sql-indent"
  	      :files ("sql-indent.el"))
  :hook (sql-mode . sqlind-minor-mode))

(use-package sqlup-mode
  :ensure t
  :hook ((sql-mode . sqlup-mode)
	 (sql-interactive-mode . sqlup-mode))
  :config
  (setq sqlup-blacklist (append sqlup-blacklist
                                sql-capitalize-keywords-blacklist)))

(provide 'init-sql)
(message "init-sql loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-sql.el ends here
