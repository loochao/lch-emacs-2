;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; LCH-KEY-UTIL
;;
;; Copyright (c) 2006-2013 Charles LU
;;
;; Author:  Charles LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Stealed from Lazycat.

;;; CODE
;; lch-set-key
;; For reducing types when defining key binding.
;; Copied for lazycat.
(defun lch-set-key (key-alist &optional keymap key-prefix)
  "This function is to reduce type when define key binding.
`KEYMAP' is a add keymap for some binding, default is `current-global-map'.
`KEY-ALIST' is a alist contain main-key and command.
`KEY-PREFIX' is a add prefix for some binding, default is nil."
  (let (key def)
    (or keymap (setq keymap (current-global-map)))
    (if key-prefix
        (setq key-prefix (concat key-prefix " "))
      (setq key-prefix ""))
    (dolist (element key-alist)
      (setq key (car element))
      (setq def (cdr element))
      (cond ((stringp key) (setq key (read-kbd-macro (concat key-prefix key))))
            ((vectorp key) nil)
            (t (signal 'wrong-type-argument (list 'array key))))
      (define-key keymap key def))))

(defun lch-unset-key (key-list &optional keymap)
  "This function is to reduce type when unset key binding.
`KEYMAP' is add keymap for some binding, default is `current-global-map'
`KEY-LIST' is list contain key."
  (let (key)
    (or keymap (setq keymap (current-global-map)))
    (dolist (key key-list)
      (cond ((stringp key) (setq key (read-kbd-macro (concat key))))
            ((vectorp key) nil)
            (t (signal 'wrong-type-argument (list 'array key))))
      (define-key keymap key nil))))

(defun lch-menu-to-key (one-key-menu-alist prefix)
  "This function is to generate an alist from corresponding one-key-menu-alist
for lch-set-key to use."
  (let ((keymap nil))
    (dolist (x one-key-menu-alist)
      (add-to-list 'keymap (cons (concat prefix " " (caar x)) (cdr x))))
    (lch-set-key keymap)))

;;; PROVIDE
(provide 'lch-key-util)


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
