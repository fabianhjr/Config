;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Fabián Heredia Montiel"
      user-mail-address "fabianhjr@protonmail.com")

(setq doom-theme 'badwolf
      doom-font (font-spec :family "SourceCodePro" :size 18))

(setq display-line-numbers-type t)
(setq-default indent-tabs-mode t)

(setq exec-path (append exec-path '("~/.local/bin")))

(setq org-directory "~/Documents/Knowledge/")

(setq org-agenda-files
      (append
       (directory-files-recursively "~/Documents/Knowledge/" "\\.org$")
       ))

(setq org-log-done 'time)

(setq org-roam-complete-everywhere t
      org-roam-directory org-directory
      org-roam-dailies-directory "Journal/"
      )
