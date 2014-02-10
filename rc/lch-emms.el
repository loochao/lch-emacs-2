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
(require 'emms-mark)

(emms-default-players)
;; NEWEST FEATURE. Use this if you like living on the edge.
(emms-devel)
;; (emms-standard)

(defvar emms-dir (concat emacs-var-dir "/emms"))
(make-directory emms-dir t)
(setq emms-history-file (concat emms-dir "/emms-history"))
(setq emms-cache-file (concat emms-dir "/cache"))
(setq emms-stream-bookmarks-file (concat emms-dir "/streams"))
(setq emms-score-file (concat emms-dir "/scores"))

(setq emms-playlist-buffer-name "*Music*")
(if lch-mac-p (setq emms-source-file-default-directory "/Volumes/DATA/Music/INBOX/Xiami/Current"))
(if lch-win32-p (setq emms-source-file-default-directory "~/Dropbox/Music/CHECKIN"))

(setq emms-player-list
      '(emms-player-mplayer
	emms-player-timidity
        emms-player-mpg321
        emms-player-ogg123))

;; (define-emms-simple-player mplayer '(file url)
;;       (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
;;                     ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "mms://"
;;                     ".rm" ".rmvb" ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
;;       "mplayer" "-slave" "-quiet" "-really-quiet")

;; (setq emms-player-mplayer-parameters (list "-slave" "-quiet" "-really-quiet"))

(setq emms-repeat-playlist t)

;; Prompt in minibuffer which track is playing when switch.
(add-hook 'emms-player-started-hook 'emms-show)
(setq emms-show-format "Now Playing: %s")

;;; Modeline
;; (defun lch-emms-mode-line-playlist-current ()
;;   (interactive)
;;   (format "[%s]" 
;; 	  (file-name-nondirectory (emms-track-name (emms-playlist-current-selected-track)))))
;; (setq emms-mode-line-mode-line-function
;;       'lch-emms-mode-line-playlist-current)

;; Don't show current track name on modeline.
(emms-mode-line-disable)
;; (require 'emms-mode-line-icon)

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

(defun lch-search-song-xiami ()
  (interactive)
  (let*
      (
       (full-path (emms-track-get (emms-playlist-current-selected-track) 'name))
       (file-name (file-name-nondirectory full-path))
       (name-list (split-string file-name "_"))
       (clean-name (loop for element in name-list
                         until (equal element "虾小米打碟中")
                         collect element))
       (final-name-no-extension (mapconcat 'identity clean-name " "))
       (final-name (concat final-name-no-extension ".mp3"))
       (url-xiami (concat "http://www.xiami.com/search?key=" final-name-no-extension))
       )
    ;; (message "%s" final-name2)
    (browse-url url-xiami)
    ;; (switch-to-buffer (get-buffer-create "*test*"))
    ;; (with-current-buffer
    ;; (url-retrieve-synchronously url-xiami)
    ;; (goto-char 1)
    ;; (when (re-search-forward "http://www.xiami.com/[0-9]+" nil t)
    ;;   (let ((test (match-string 0)))
    ;;     (message "%s" test)
    ;;     )
    ;;   ))
    ))
(define-key global-map (kbd "<f12> l") 'lch-search-song-xiami)

;; (require 'emms-lyrics-download)
;; (ad-activate 'emms-lyrics-find-lyric)
;;; Util
;; FIXME: emms-mark got some problem (the first char in emms buffer)
(defun emms-mark-track-and-move-next ()
  "Mark the current track, and move next track."
  (interactive)
  (call-interactively 'emms-mark-track)
  (call-interactively 'next-line))

(defun emms-mark-unmark-track-and-move-next ()
  "Unmark the current track, and move next track."
  (interactive)
  (call-interactively 'emms-mark-unmark-track)
  (call-interactively 'next-line))

(defun emms-next-mark-track ()
  "Jump to next mark track."
  (interactive)
  (let ((original-point (point))
        (original-column (current-column)))
    (if (bolp)
        (forward-char +1))
    (if (search-forward-regexp (format "^%c" emms-mark-char) nil t)
        (move-to-column original-column t)
      (goto-char original-point)
      (message "No next mark track."))))

(defun emms-prev-mark-track ()
  "Jump to previous mark track."
  (interactive)
  (let ((original-point (point))
        (original-column (current-column)))
    (if (not (bolp))
        (beginning-of-line))
    (if (search-backward-regexp (format "^%c" emms-mark-char) nil t)
        (move-to-column original-column t)
      (goto-char original-point)
      (message "No previous mark track."))))


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
(defvar lch-emms-radio-playlist (concat emms-dir "/playlists/radio.pls"))
(defun lch-emms-music-dir-switch (&optional option)
  (interactive "sWhich dir to play? (1) default (2) check-in (3) radio: ")
  (emms-stop)
  (with-current-emms-playlist (emms-playlist-clear))
  (cond
   ((string= option "1") (emms-add-directory-tree emms-source-file-default-directory))
   ((string= option "2") (emms-add-directory-tree lch-music-check-in-dir))
   ((string= option "3") (emms-add-playlist lch-emms-radio-playlist))
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
          (emms-playlist-mode-center-current)
          (emms-playlist-mode-kill-entire-track)
          (setq kill-ring (cdr kill-ring))
          (emms-playlist-mode-play-smart)
          )
        (dired-delete-file music-file)
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
        (emms-playlist-mode-center-current)
        (emms-playlist-mode-kill-entire-track)
        (setq kill-ring (cdr kill-ring))
        (emms-playlist-mode-play-smart)
        )
      (dired-delete-file music-file)
      (message (format "%s has deleted~" music-file))
      (sit-for 2)
      (emms-show))))

;;; Keymap
;; q -- only bury the emms playlist buffer, emms is still there.
;; Q -- really quit. But globally, "<f12> q" is really quit.
(lch-set-key
 '(
   ("<left>" . (lambda () (interactive) (emms-seek -10)))
   ("<right>" . (lambda () (interactive) (emms-seek 10)))
   ("<down>" . (lambda () (interactive) (emms-seek -60)))
   ("<up>" . (lambda () (interactive) (emms-seek 60)))

   ("," . (lambda () (interactive) (emms-seek -10)))
   ("." . (lambda () (interactive) (emms-seek 10)))

   ("'" . emms-jump-to-file)
   ("C-6" . emms-jump-to-file)

   ("SPC" . lch-emms-toggle-playing)
   ("c" . lch-emms-check-in)
   ("d" . lch-emms-dump)

   ("h" . (lambda () (interactive) (emms-seek -60)))
   ("l" . (lambda () (interactive) (emms-seek 60)))

   ("j" . next-line)
   ("k" . previous-line)
   ("C-k" . emms-playlist-mode-kill-entire-track)

   ("Q" . lch-emms-quit)
   ("x" . emms-stop)
   ("r" . emms-toggle-repeat-track)
   ("R" . emms-toggle-repeat-playlist)
   
   ("s" . emms-shuffle)
   )
 emms-playlist-mode-map
 )

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


