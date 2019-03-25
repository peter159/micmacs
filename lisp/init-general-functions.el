;;; init-general-functions.el ---                    -*- lexical-binding: t; -*-

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

;; serve as time mark
(defun mark-time-here()
  "return current time in float, this used as a mark time star"
  (interactive)
  (setq time-marked (float-time)))

(mark-time-here)

;; serve to get time difference between `current' and `time-marked'
(defun get-time-diff(time-marked)
  "return seconds passed from current to `time-start'"
  (interactive)
  (setq diff (time-subtract (float-time) time-marked))
  (float-time diff))

;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
(setq comint-prompt-read-only t)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
;; ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

(provide 'init-general-functions)
(message "init-general-functions loaded in '%.2f seconds ...'" (get-time-diff time-marked))
;;; init-general-functions.el ends here
