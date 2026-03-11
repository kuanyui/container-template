;;; Directory Local Variables         -*- no-byte-compile: t; mode: emacs-lisp -*-
;;; For more information see (info "(emacs) Directory Variables")

(
 (nil . ((eval . (let* ((path (buffer-file-name))
			(expected-mode (when (and path (not (file-directory-p path)))
					 (cond
					  ((string-match-p "/_common/bash/" path) 'sh-mode)
					  ((string-match-p "/_common/zsh/" path) 'sh-mode)
					  ((string-match-p "/_common/docker/" path) (cond ((locate-library "dockerfile-mode") 'dockerfile-mode)
											  (t 'sh-mode)))))))
		   (if (and expected-mode (not (derived-mode-p expected-mode)))
		       (funcall expected-mode))))
	 (eval . (let (
		       (par '(:foreground "#ee88ff" :weight bold))   ; #ff99cc #9966cc
		       (kw '(:foreground "#aa66cc" :weight bold))    ; #ff66aa #ee88ff
		       (bold '(:weight bold))
		       )
		   (setq-local --faces-jinja-sharp
			       `(
				 ("\\(#{%\\) *\\([a-zA-Z0-9]+\\) *?\\(.*?\\)? *?\\(%}#\\)" (1 ',par t) (2 ',kw t) (3 ',bold t) (4 ',par t))  ; #{% if cond %}#
				 ("\\(#{{\\)\\(.*?\\)\\(}}#\\)" (1 ',par t) (2 ',bold t) (3 ',par t))  ; #{{ var }}#
				 ("\\(#{#\\)\\(.*?\\)\\(#}#\\)" (1 ',par t) (2 ',bold t) (3 ',par t))  ; #{# comment #}#
				 )))))
      )
 (dockerfile-mode . ((eval . (font-lock-add-keywords nil --faces-jinja-sharp))))
 (sh-mode . ((eval . (font-lock-add-keywords nil --faces-jinja-sharp))))
 )
