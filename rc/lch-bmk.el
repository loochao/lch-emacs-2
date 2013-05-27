;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; BOOKMARK
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
(message "=> lch-bmk: loading...")

;;; Bookmark
;; Part of GNU Emacs.
(require 'bookmark)
(setq bookmark-save-flag 1)
(setq bookmark-default-file (concat emacs-var-dir "/emacs-bmk"))

(defun switch-to-bookmark (bname)
  "Interactively switch to bookmark as `iswitchb' does."
  (interactive (list (cl-flet ((ido-make-buffer-list
                                (default)
                                (bookmark-all-names)))
                       (ido-read-buffer "Jump to bookmark: " nil t))))
  (bookmark-jump bname))
(define-key global-map (kbd "C-c C-b") 'list-bookmarks)

(define-key global-map (kbd "<f5> a") 'bookmark-set)            ;; a: add
(define-key global-map (kbd "<f5> b") 'list-bookmarks)
(define-key global-map (kbd "<f5> j") 'switch-to-bookmark)      ;; j: jump

;;; Breadcrumb
(require 'breadcrumb)

(lch-set-key
 '(
   ("<f5> n" . bc-local-next)
   ("<f5> p" . bc-local-previous)
   ("<f5> ." . bc-next)
   ("<f5> ," . bc-previous)
   ("<f5> g" . bc-goto-current)
   ("<f5> l" . bc-list)
   ("<f5> /" . bc-list)
   ("<f5> '" . bc-set)
   ("<f5> <f5>" . bc-set)
   ))
;;; PROVIDE
(provide 'lch-bmk)
(message "~~ lch-bmk: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
