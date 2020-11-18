;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Fabián Heredia Montiel"
      user-mail-address "fabianhjr@protonmail.com")

(setq doom-theme 'badwolf)
(setq display-line-numbers-type t)

(setq org-directory "~/Documents/PersonalKnowledgeBase/")
(setq org-agenda-files "~/Documents/PersonalKnowledgeBase/Agenda.org")
(setq org-roam-directory org-directory)

(add-to-list 'auto-mode-alist '("\\.coconut\\'" . python-mode))
