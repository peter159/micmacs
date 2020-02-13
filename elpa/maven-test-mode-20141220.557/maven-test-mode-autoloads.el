;;; maven-test-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "maven-test-mode" "maven-test-mode.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from maven-test-mode.el

(defvar maven-test-mode-map (let ((map (make-sparse-keymap))) (define-key map (kbd "C-c , a") 'maven-test-all) (define-key map (kbd "C-c , v") 'maven-test-file) (define-key map (kbd "C-c , s") 'maven-test-method) (define-key map (kbd "C-c , i") 'maven-test-install) (define-key map (kbd "C-c , C") 'maven-test-clean-test-all) (define-key map (kbd "C-c , r") 'recompile) (define-key map (kbd "C-c , t") 'maven-test-toggle-between-test-and-class) (define-key map (kbd "C-c , y") 'maven-test-toggle-between-test-and-class-other-window) map))

(autoload 'maven-test-mode "maven-test-mode" "\
This minor mode provides utilities to run maven test tasks

If called interactively, enable Maven-Test mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "maven-test-mode" '("maven-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; maven-test-mode-autoloads.el ends here
