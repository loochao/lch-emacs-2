;;; lch-viper.el --- Charles Lu Viper configuration -*- emacs-lisp -*-

;; Author: Charles Lu <loochao@gmail.com>>
;; Keywords:

;; This file is NOT part of GNU Emacs.

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Emacs; see the file COPYING, or type `C-h C-c'. If not,
;; write to the Free Software Foundation at this address:

;;   Free Software Foundation
;;   51 Franklin Street, Fifth Floor
;;   Boston, MA 02110-1301
;;   USA

;;; Code:
(setq viper-inhibit-startup-message   t
      viper-expert-level              5        ; to do many customizations self
      viper-ex-style-editing          nil      ; ex-style don't allow you move cross lines.
      viper-ex-style-motion           nil
      viper-electric-mode             t
      viper-always                    t
      viper-want-ctl-h-help           t
      viper-want-emacs-keys-in-insert t
      viper-vi-style-in-minibuffer    nil
      viper-want-emacs-keys-in-vi     t)

(when (boundp 'viper-insert-global-user-map)
  (define-key viper-insert-global-user-map (kbd "C-d") 'delete-char)
  (define-key viper-insert-global-user-map (kbd "C-v") 'scroll-up)
  (define-key viper-insert-global-user-map (kbd "C-\\") 'toggle-input-method)
  (define-key viper-insert-global-user-map (kbd "C-t") 'transpose-chars)
  (define-key viper-insert-global-user-map (kbd "C-w") 'kill-region))

(when (boundp 'viper-vi-global-user-map)
  (define-key viper-vi-global-user-map (kbd "C-u") 'universal-argument)

  ;; These are shockingly cool.
  (define-key viper-vi-global-user-map (kbd "q") 'fill-paragraph)
  (define-key viper-vi-global-user-map (kbd "t") 'transpose-chars)

  (define-key viper-vi-global-user-map (kbd "E") 'viper-change-state-to-emacs)
  
  (define-key viper-vi-global-user-map (kbd "C-v") 'scroll-up)
  (define-key viper-vi-global-user-map (kbd "SPC") 'scroll-up)
  (define-key viper-vi-global-user-map (kbd "S-SPC") 'scroll-down)
  (define-key viper-vi-global-user-map (kbd "C-b") 'backward-char)
  (define-key viper-vi-global-user-map (kbd "C-f") 'forward-char)
  (define-key viper-vi-global-user-map (kbd "C-p") 'previous-line)
  (define-key viper-vi-global-user-map (kbd "C-n") 'next-line)

  ;; Being able to pull up help is a good thing.
  (define-key viper-vi-global-user-map (kbd "C-h") 'help-command)

  ;; I don't know what C-e or C-t do in vi by default and I don't care.
  (define-key viper-vi-global-user-map (kbd "C-e") 'viper-goto-eol)
  (define-key viper-vi-global-user-map (kbd "C-t") 'transpose-chars)

  ;; I don't need an alternate Meta key, thank you very much.
  (define-key viper-vi-global-user-map (kbd "C-\\") 'toggle-input-method)

  (define-key viper-vi-global-user-map (kbd "C-y") 'yank))

;; Enable Viper
;; (setq viper-mode t)
;; (add-hook 'emacs-startup-hook 'viper-mode)

(eval-after-load "viper-init"
  '(progn
     (mapc (lambda (hook)
             (remove-hook hook 'viper-restore-cursor-type))
           '(viper-vi-state-hook viper-replace-state-hook
             viper-emacs-state-hook))
     (remove-hook 'viper-insert-state-hook
                  'viper-set-insert-cursor-type)))
;;; lch-viper.el ends here



