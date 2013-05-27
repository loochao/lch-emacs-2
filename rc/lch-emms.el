;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; EMMS
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
;; Settings for emms

;;; CODE
(message "=> lch-emms: loading...")

;; Like require lch-conf, emms-setup will load lots of el files.
(require 'emms-setup)

(emms-default-players)
;; NEWEST FEATURE. Use this if you like living on the edge.
;; (emms-standard)
(emms-devel)

(defvar emms-dir (concat emacs-var-dir "/emms"))
(make-directory emms-dir t)
(setq emms-history-file (concat emms-dir "/emms-history"))
(setq emms-cache-file (concat emms-dir "/cache"))
(setq emms-stream-bookmarks-file (concat emms-dir "/streams"))
(setq emms-score-file (concat emms-dir "/scores"))


(setq emms-playlist-buffer-name "*Music*")
(setq emms-source-file-default-directory "/Volumes/DATA/Music/INBOX/Xiami/Current")

(setq emms-player-list
      '(emms-player-mplayer
	emms-player-timidity
        emms-player-mpg321
        emms-player-ogg123))
(setq emms-player-mplayer-parameters (list "-slave" "-quiet" "-really-quiet"))

(setq emms-repeat-playlist t)

;; Prompt in minibuffer which track is playing when switch.
(add-hook 'emms-player-started-hook 'emms-show)
(setq emms-show-format "Now Playing: %s")

;;; Modeline
;; Don't show current track name on modeline.
;; (emms-mode-line-disable)

(setq emms-mode-line-mode-line-function
      'lch-emms-mode-line-playlist-current)

(defun lch-emms-mode-line-playlist-current ()
  (interactive)
  (format "[%s]" 
	  (file-name-nondirectory (emms-track-name (emms-playlist-current-selected-track)))))

;; Display playing time
;; (setq emms-playing-time-style 'bar)
;; (setq emms-playing-time-style 'time)
(emms-playing-time-disable-display)

;; icon
(require 'emms-mode-line-icon)

;;; Tag
;; emms-print-metadata ships with emms.
;; It generates utf8 coding.
;; (require 'emms-info-libtag)
;; (setq emms-info-functions '(emms-info-libtag))
(setq emms-info-functions nil)

;;; Lyrics
;; (when (fboundp 'emms-lyrics)
;;   (emms-lyrics 1))
;; (setq emms-lyrics-coding-system 'gbk
;;       emms-lyrics-display-on-minibuffer t)
;; (setq emms-lyrics-dir (concat emms-dir "/lyric"))

;; (require 'emms-lyrics-download)
;; (ad-activate 'emms-lyrics-find-lyric)
;;; Util
(defun lch-emms-toggle-playing ()
  (interactive)
  (if emms-player-playing-p (emms-pause) (emms-start)))

(defvar lch-music-check-in-dir "~/Dropbox/Music/CHECKIN" "")

(defun lch-emms-init ()
  (interactive)
  (if (and (boundp 'emms-playlist-buffer) (buffer-live-p emms-playlist-buffer))
      (progn
	(emms-playlist-mode-go)
	(emms-show)
	(sit-for 3)
	(message ""))
      (progn
      (require 'lch-emms)
      (emms-add-directory-tree lch-music-check-in-dir)
      (emms-playlist-mode-go)
      ;; (setnu-mode)
      ;; (emms-shuffle)
      (lch-emms-toggle-playing)
      (message (format "Now playing: \"%s\"." lch-music-check-in-dir)))))

(defun lch-emms-quit ()
  (interactive)
  (if (and (boundp 'emms-playlist-buffer) (buffer-live-p emms-playlist-buffer))
      (progn
	  (emms-stop)
	  (with-current-emms-playlist
	    (emms-playlist-clear)
	    (kill-buffer))
	  (message "Emms quited."))
    (progn (message "No emms running now."))))

;; Have to use (call-interactively ...)
;; for emms-add-directory-tree requires an arg.
(defun lch-emms-add-dir ()
  (interactive)
  (emms-playlist-mode-go)
  (call-interactively 'emms-add-directory-tree))

(defun lch-emms-shuffle ()
  (interactive)
  (emms-shuffle)
  (message "Will shuffle current playlist."))

;; FIXME: how to skip the enter needed at the end of the input.
(defun lch-emms-music-dir-switch (&optional dir)
  (interactive "sWhich dir to play? (1) default (2) check-in: ")
  (emms-stop)
  (with-current-emms-playlist (emms-playlist-clear))
  (cond
   ((string= dir "1") (emms-add-directory-tree emms-source-file-default-directory))
   ((string= dir "2") (emms-add-directory-tree lch-music-check-in-dir))
   (t (emms-add-directory-tree lch-music-check-in-dir)))
  (emms-shuffle)
  (emms-playlist-mode-go)
  (lch-emms-toggle-playing))

(defun emms-jump-to-file ()
  "Jump to postion of current playing music."
  (interactive)
  (let* ((music-file (emms-track-name (emms-playlist-current-selected-track)))
         (music-folder (file-name-directory music-file)))
    (dired-x-find-file music-folder)
    (dired-goto-file music-file)
    ))

(defun lch-emms-check-in ()
  (interactive)
  (let* ((music-track (emms-playlist-current-selected-track))
	 (music-file (emms-track-name music-track))
         (music-folder (file-name-directory music-file)))
    (when (y-or-n-p (format "Check in %s? " music-file))
        (copy-file (concat (format "%s" music-file)) (format "%s" lch-music-check-in-dir))
	(with-current-emms-playlist
	  (save-excursion
	    (emms-playlist-mode-center-current)
	    (emms-playlist-mode-kill-entire-track)))
        (dired-delete-file music-file)
        (emms-next)
        (message (format "%s has been checked in~" music-file))
        (sit-for 1.5)
        (emms-show)
        )))

(defun lch-emms-dump ()
  "Jump to postion of current playing music."
  (interactive)
  (let* ((music-file (emms-track-name (emms-playlist-current-selected-track))) ;get playing music file name
         (music-folder (file-name-directory music-file))) ;get playing music directory
    (when (y-or-n-p (format "DUMP %s? " music-file))
      (with-current-emms-playlist
	(save-excursion
	  (emms-playlist-mode-center-current)
	  (emms-playlist-mode-kill-entire-track)))
      (dired-delete-file music-file)
      (emms-next)
      (message (format "%s has deleted~" music-file))
      (sit-for 2)
      (emms-show)
      )))

(defun emms-delete-file-from-disk ()
  "Delete this file from disk."
  (interactive)
  (let* ((current-track (emms-track-name (emms-playlist-track-at))))
    (when (yes-or-no-p (format "Are you really want to delete \' %s \' from disk? " current-track))
      (if (string-equal current-track (emms-playlist-play-filename))
          (emms-stop))
      (emms-playlist-mode-kill-entire-track)
      (dired-delete-file current-track)
      (message (format "Have delete \' %s \' from disk." current-track)))))
;;; Keymap
;; q -- only bury the emms playlist buffer, emms is still there.
;; Q -- really quit. But globally, "<f12> q" is really quit.
(define-key emms-playlist-mode-map (kbd "<left>")  (lambda () (interactive) (emms-seek -10)))
(define-key emms-playlist-mode-map (kbd "<right>") (lambda () (interactive) (emms-seek +10)))
(define-key emms-playlist-mode-map (kbd "<down>")  (lambda () (interactive) (emms-seek -60)))
(define-key emms-playlist-mode-map (kbd "<up>")    (lambda () (interactive) (emms-seek +60)))
(define-key emms-playlist-mode-map (kbd "'") 'emms-jump-to-file)
(define-key emms-playlist-mode-map (kbd "SPC") 'lch-emms-toggle-playing)
(define-key emms-playlist-mode-map (kbd "c") 'lch-emms-check-in)
(define-key emms-playlist-mode-map (kbd "d") 'lch-emms-dump)
(define-key emms-playlist-mode-map (kbd "C-6") 'emms-jump-to-file)
(define-key emms-playlist-mode-map (kbd "j") 'next-line)
(define-key emms-playlist-mode-map (kbd "k") 'previous-line)
(define-key emms-playlist-mode-map (kbd "C-k") 'emms-playlist-mode-kill-entire-track)
(define-key emms-playlist-mode-map (kbd "Q") 'lch-emms-quit)
(define-key emms-playlist-mode-map (kbd "x") 'emms-stop)
(define-key emms-playlist-mode-map (kbd "r") 'emms-toggle-repeat-track)
(define-key emms-playlist-mode-map (kbd "R") 'emms-toggle-repeat-playlist)
(define-key emms-playlist-mode-map (kbd "s") 'emms-shuffle)

(define-key global-map (kbd "s-<left>")  (lambda () (interactive) (emms-seek -10)))
(define-key global-map (kbd "s-<right>") (lambda () (interactive) (emms-seek +10)))
(define-key global-map (kbd "s-<down>")  (lambda () (interactive) (emms-seek -60)))
(define-key global-map (kbd "s-<up>")    (lambda () (interactive) (emms-seek +60)))
;;; PROVIDE
(provide 'lch-emms)
(message "~~ lch-emms: done.")


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:


