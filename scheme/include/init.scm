(define (init-aliases)
;;Add aliases to ~/.scmbag
  (system "echo \"#SCMBAG aliases
alias gs='scmbag -s'
alias ga='scmbag -a'
alias gd='scmbag -d'
alias gps='git push'
alias gdc='git diff --cached'
alias gc='git commit'
alias gcm='scmbag -c'
alias gcma='scmbag -m'
alias gl='git log --graph'
alias gg='git log --graph --decorate --oneline'
alias grs='scmbag -r'
alias gb='scmbag -b'
alias gco='scmbag -o'
alias rm='scmbag -x'\" > ~/.scmbag")

;; Append aliases to bash profile.
  (system "if grep -Fxq '#SCMBAG' ~/.bash_profile
then
echo \"Aliases already sourced into ~/.bash_profile\n\"
else
printf \"\nAppended scmbag aliases,\033[31m source ~/.scmbag\033[0m to .bash_profile\n\n\"
echo \"
#SCMBAG
source ~/.scmbag\" >> ~/.bash_profile
fi")


;;Prints required action.
(print "Reload Bash (execute the following):\n$ source ~/.bash_profile"))
