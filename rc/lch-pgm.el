;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; PRROGRAMMING
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author:  Chao LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Control file of which one to load

;;; CODE
(message "=> lch-pgm: loading...")

;;; Highlight-fixme-todo
(defvar lch-keyword-highlight-modes "")
(defvar lch-highlight-special-keywords "")
(setq lch-keyword-highlight-modes
      '(php-mode java-mode c-mode c++-mode emacs-lisp-mode scheme-mode
                 text-mode outline-mode org-mode))

(make-face 'font-lock-fixme-face)
(make-face 'font-lock-todo-face)

(modify-face 'font-lock-fixme-face "Black" "Yellow" nil t nil t nil nil)
(modify-face 'font-lock-todo-face  "Black" "Pink" nil t nil nil nil nil)

(defun lch-highlight-special-keywords ()
  (mapc (lambda (mode)
	  (font-lock-add-keywords
	   mode
	   '(("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
	     ("\\<\\(TODO\\)"  1 'font-lock-todo-face  t))))
	lch-keyword-highlight-modes))

(lch-highlight-special-keywords)

;;; PROVIDE

(provide 'lch-pgm)
(message "~~ lch-pgm: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
