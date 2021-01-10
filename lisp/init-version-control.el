;;; init-version-control.el ---                      -*- lexical-binding: t; -*-

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

;; ;; set socks proxy
;; (setq url-proxy-services `(("http" . ,"10.137.133.20:1080")
;; 			   ("https" . ,"10.137.133.20:1080")
;; 			   ("no_proxy" . "^\\(localhost\\|192.168.*\\|10.*\\)")))

;; set socks proxy
(setq url-proxy-services `(("http" . ,"127.0.0.1:12333")
			   ("https" . ,"127.0.0.1:12333")
			   ("no_proxy" . "^\\(localhost\\|192.168.*\\|10.*\\)")))

(use-package magit
  :ensure t
  )

(provide 'init-version-control)
(message "init-version-control loaded in '%.2f' seconds ..." (get-time-diff time-marked))
;;; init-version-control.el ends here
