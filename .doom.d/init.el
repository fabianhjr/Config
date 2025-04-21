;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom!
 :editor
 (evil +everywhere); come to the dark side, we have cookies
 fold              ; (nigh) universal code folding
 (format +onsave)  ; automated prettiness
 multiple-cursors  ; editing in many places at once
 word-wrap         ; soft wrapping with language-aware indent

 :config
 (default +bindings +smartparens)

 :checkers
 (syntax +icons)   ; tasing you for every semicolon you forget
 (spell +flyspell) ; tasing you for misspelling mispelling
 grammar           ; tasing grammar mistake every you make

 :completion
 vertico           ; the search engine of the future

 :ui
 doom              ; what makes DOOM look the way it does
 doom-dashboard    ; a nifty splash screen for Emacs
 (emoji +unicode)  ; 🙂
 hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
 indent-guides     ; highlighted indent columns
 ligatures         ; ligatures and symbols to make your code pretty again
 minimap           ; show a map of the code on the side
 modeline          ; snazzy, Atom-inspired modeline, plus API
 ophints           ; highlight the region an operation acts on
 (popup +defaults)   ; tame sudden yet inevitable temporary windows
 treemacs          ; a project drawer, like neotree but cooler
 unicode           ; extended unicode support for various languages
 (vc-gutter +pretty) ; vcs diff in the fringe
 vi-tilde-fringe   ; fringe tildes to mark beyond EOB
 workspaces        ; tab emulation, persistence & separate workspaces

 :emacs
 (dired +icons)    ; making dired pretty [functional]
 undo              ; persistent, smarter undo for your inevitable mistakes
 vc                ; version-control and Emacs, sitting in a tree

 :term
 vterm             ; the best terminal emulation in Emacs

 :tools
 biblio            ; Writes a PhD for you (citation needed)
 direnv
 editorconfig      ; let someone else argue about tabs vs spaces
 (eval +overlay)   ; run code, run (also, repls)
 lookup            ; navigate your code and its documentation
 lsp               ; M-x vscode
 magit             ; a git porcelain for Emacs

 :os
 tty               ; improve the terminal Emacs experience

 :lang
 data              ; config/data formats
 dhall
 emacs-lisp        ; drown in parentheses
 json              ; At least it ain't XML
 markdown          ; writing docs for people to ignore
 nix               ; I hereby declare "nix geht mehr!"
 (org +roam2)      ; organize your plain life in plain text
 python            ; beautiful is better than ugly
 sh                ; she sells {ba,z,fi}sh shells on the C xor
 yaml              ; JSON, but readable
 )
