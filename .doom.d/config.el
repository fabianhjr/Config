;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq-default indent-tabs-mode t)

(setq user-full-name "Fabián Heredia Montiel"
      user-mail-address "fabianhjr@protonmail.com")

(setq doom-theme 'badwolf)
(setq display-line-numbers-type t)

(setq exec-path (append exec-path '("/home/fabian/.local/bin")))

(setq org-directory "~/Documents/PersonalKnowledgeBase/")
(setq org-agenda-files "~/Documents/PersonalKnowledgeBase/Agenda.org")
(setq org-roam-directory org-directory)

(after! elfeed
  (setq elfeed-search-filter "@1-year-ago +unread"))

(use-package! idris-mode
  :mode ("\\.l?idr\\'" . idris-mode)
  :config

  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(idris-mode . "idris2"))

    (lsp-register-client
     (make-lsp-client
      :new-connection (lsp-stdio-connection "idris2-lsp")
      :major-modes '(idris-mode)
      :server-id 'idris2-lsp))
    )
  (setq lsp-semantic-tokens-enable t)

  (add-hook 'idris-mode-hook #'lsp!)
  )

(add-to-list 'auto-mode-alist '("\\.coconut\\'" . python-mode))
