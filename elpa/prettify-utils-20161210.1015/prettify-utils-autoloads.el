;;; prettify-utils-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "prettify-utils" "prettify-utils.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from prettify-utils.el

(autoload 'prettify-utils--list "prettify-utils" "\
Takes two lists and interleaves the (optional) second between each element of 
the first.  Used to create multi-character sequences for use with the minor mode
'prettify-symbols'.  If not supplied, GLUE defaults to '(Br . Bl).  For more 
information about GLUE, refer to the documentation for the 'compose-region
function and the 'reference-point-alist variable.

This function is used by prettify-utils-string to create the lists given to 
prettify-symbols-alist.  Calling prettify-utils--list directly is probably not 
what you want, check the documentation for prettify-utils-string and 
prettify-utils-generate instead.

Example use:
\(prettify-utils--list (string-to-list \"hello\") '(Br . Bl))

\(fn L &optional GLUE)" nil nil)

(autoload 'prettify-utils-string "prettify-utils" "\
Takes a string and an optional list, and returns a list of the string's 
characters with GLUE interleaved between each character, for use with 
prettify-symbols mode.  If no GLUE is supplied, uses the 
prettify-utils--list default.  For more information about GLUE, refer to the 
documentation for the 'compose-region function and the 'reference-point-alist 
variable.

This function can be used to simplify multiple-character replacements when 
manually constructing a prettify-symbols-alist.  For something more high-level, 
consider using prettify-utils-generate to create the entire alist instead.

Example:

\(prettify-utils-string \"example\" '(Br . Bl))

\(fn S &optional GLUE)" nil nil)

(autoload 'prettify-utils-generate "prettify-utils" "\
Generates an alist for use when setting prettify-symbols-alist.  Takes one or 
more lists, each consisting of two strings and an optional GLUE list to be 
interleaved between characters in the replacement list.  If the optional GLUE
list is not supplied, uses the prettify-list default of '(Br . Bl).  For more 
information about GLUE, refer to the documentation for the 'compose-region
function and the 'reference-point-alist variable.

Example #1:

\(setq prettify-symbols-alist 
	  (prettify-utils-generate (\"foo\" \"bar\")
							   (\">=\" \"≥\" (Br . Bl))
							   (\"->\"     \"→ \")))

Example #2:

\(setq prettify-symbols-alist
	  (prettify-generate 
	   (\"lambda\"  \"λ\")
	   (\"|>\"      \"▷\")
	   (\"<|\"      \"◁\")
	   (\"->>\"     \"↠  \")
	   (\"->\"      \"→ \")
	   (\"<-\"      \"← \")
	   (\"=>\"      \"⇒\")
	   (\"<=\"      \"≤\")
	   (\">=\"      \"≥\")))

\(fn &rest PAIRS)" nil t)

(autoload 'prettify-utils-generate-f "prettify-utils" "\
Generates an alist for use when setting prettify-symbols-alist.  Takes one or 
more lists, each consisting of two strings and an optional GLUE list to be 
interleaved between characters in the replacement list.  If the optional GLUE
list is not supplied, uses the prettify-list default of '(Br . Bl).  For more 
information about GLUE, refer to the documentation for the 'compose-region
function and the 'reference-point-alist variable.

This is a function equivalent of the prettify-utils-generate macro.  Unless
you specifically need a function, such as for use with a higher-order function,
you should use the 'prettify-utils-generate macro instead.

Example:

\(prettify-utils-generate-f '(\"foo\" \"bar\")
				           '(\">=\" \"≥\" (Br . Bl))
						   '(\"->\"     \"→ \"))

\(fn &rest PAIRS)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "prettify-utils" '("prettify-utils-create-pair")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; prettify-utils-autoloads.el ends here
