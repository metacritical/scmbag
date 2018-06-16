(use shell)

(define (init-aliases)
  (system "echo \"#SCMBAG aliases
alias gs='scmbag -s'
alias ga='scmbag -a'
alias gd='git diff'\" > ~/.scmbag")
  (system "echo \"
#SCMBAG
source ~/.scmbag\" >> ~/.bash_profile")
  (print "SCMBAG alias appended to ~/.bash_profile.

execute: 'source ~/.bash_profile'")
  )
