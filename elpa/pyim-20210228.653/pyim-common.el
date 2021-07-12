;;; pyim-common.el --- common utilities for pyim    -*- lexical-binding: t; -*-

;; * Header
;; Copyright (C) 2015-2021 Free Software Foundation, Inc.

;; Author: Feng Shu <tumashu@163.com>
;; Maintainer: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/pyim
;; Keywords: convenience, Chinese, pinyin, input-method

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; * 说明文档                                                              :doc:
;; This file has common utilities used by pyim

;;; Code:
;; * 代码                                                                 :code:

(defvar pyim-debug nil)

(defvar pyim-prefer-emacs-thread nil
  "是否优先使用 emacs thread 功能来生成 dcache.

如果这个变量设置为 t, 那么当 emacs thread 功能可以使用时，
pyim 优先使用 emacs thread 功能来生成 dcache, 如果设置为 nil,
pyim 总是使用 emacs-async 包来生成 dcache.

不过这个选项开启之后，会显著的减慢词库加载速度，特别是
五笔等形码输入法。")

(defcustom pyim-dcache-directory (locate-user-emacs-file "pyim/dcache/")
  "一个目录，用于保存 pyim 词库对应的 cache 文件."
  :type 'directory
  :group 'pyim)

(defun pyim-dcache-get-value-from-file (file)
  "读取保存到 FILE 里面的 value."
  (when (file-exists-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (let ((output
             (condition-case nil
                 (read (current-buffer))
               (error nil))))
        (unless output
          ;; 有时候词库缓存会发生错误，这时候，就将词库缓存转存到一个
          ;; 带时间戳的文件中，方便用户手动修复。
          (write-file (concat file "-dump-" (format-time-string "%Y%m%d%H%M%S"))))
        output))))

(defun pyim-dcache-get-variable (variable)
  "从 `pyim-dcache-directory' 中读取与 VARIABLE 对应的文件中保存的值."
  (let ((file (expand-file-name (symbol-name variable)
                                pyim-dcache-directory)))
    (pyim-dcache-get-value-from-file file)))

(defun pyim-dcache-set-variable (variable &optional force-restore fallback-value)
  "设置变量.

如果 VARIABLE 的值为 nil, 则使用 ‘pyim-dcache-directory’ 中对应文件的内容来设置
VARIABLE 变量，FORCE-RESTORE 设置为 t 时，强制恢复，变量原来的值将丢失。
如果获取的变量值为 nil 时，将 VARIABLE 的值设置为 FALLBACK-VALUE ."
  (when (or force-restore (not (symbol-value variable)))
    (let ((file (expand-file-name (symbol-name variable)
                                  pyim-dcache-directory)))
      (set variable (or (pyim-dcache-get-value-from-file file)
                        fallback-value
                        (make-hash-table :test #'equal))))))

(defun pyim-dcache-save-value-to-file (value file)
  "将 VALUE 保存到 FILE 文件中."
  (when value
    (with-temp-buffer
      ;; FIXME: We could/should set the major mode to `lisp-data-mode'.
      (insert ";; Auto generated by `pyim-dhashcache-save-variable-to-file', don't edit it by hand!\n")
      (insert (format ";; Build time: %s\n\n" (current-time-string)))
      (insert (prin1-to-string value))
      (insert "\n\n")
      (insert ";; Local\sVariables:\n") ;Use \s to avoid a false positive!
      (insert ";; coding: utf-8-unix\n")
      (insert ";; End:")
      (make-directory (file-name-directory file) t)
      (let ((save-silently t))
        (pyim-dcache-write-file file)))))


(defun pyim-dcache-save-variable (variable)
  "将 VARIABLE 变量的取值保存到 `pyim-dcache-directory' 中对应文件中."
  (let ((file (expand-file-name (symbol-name variable)
                                pyim-dcache-directory))
        (value (symbol-value variable)))
    (pyim-dcache-save-value-to-file value file)))

;; ** 处理词库文件
(defun pyim-use-emacs-thread-p ()
  "判断是否使用 emacs thread 功能来生成 thread."
  (and pyim-prefer-emacs-thread
       (>= emacs-major-version 26)))

(defun pyim-dcache-write-file (filename &optional confirm)
  "A helper function to write dcache files."
  (let ((coding-system-for-write 'utf-8-unix))
    (when (and confirm
               (file-exists-p filename)
               ;; NS does its own confirm dialog.
               (not (and (eq (framep-on-display) 'ns)
                         (listp last-nonmenu-event)
                         use-dialog-box))
               (or (y-or-n-p (format-message
                              "File `%s' exists; overwrite? " filename))
                   (user-error "Canceled"))))
    (write-region (point-min) (point-max) filename nil :silent)
    (message "Saving file %s..." filename)))

(defun pyim-string-match-p (regexp string &optional start)
  "与 `string-match-p' 类似，如果 REGEXP 和 STRING 是非字符串时，
不会报错。"
  (and (stringp regexp)
       (stringp string)
       (string-match-p regexp string start)))

(defun pyim-dline-parse (&optional seperaters)
  "解析词库文件当前行的信息，SEPERATERS 为词库使用的分隔符。"
  (let* ((begin (line-beginning-position))
         (end (line-end-position))
         (items (split-string
                 (buffer-substring-no-properties begin end)
                 seperaters)))
    items))

;; * Footer
(provide 'pyim-common)

;;; pyim-common.el ends here

