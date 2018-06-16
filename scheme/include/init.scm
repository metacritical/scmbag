(define (init-aliases)
  ;;Add aliases to ~/.scmbag
  (system "echo \"#SCMBAG aliases
alias gs='scmbag -s'
alias ga='scmbag -a'
alias gd='scmbag -d'
alias gps='git push'\" > ~/.scmbag")
  ;; Append aliases to bash profile.
  (system "echo \"
#SCMBAG
source ~/.scmbag\" >> ~/.bash_profile")

  ;;Prints required action.
  (print "SCMBAG alias appended to ~/.bash_profile.

execute: 'source ~/.bash_profile'")
  )
