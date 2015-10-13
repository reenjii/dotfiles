# user@host path
# (time) >
# right prompt is the result of previous command
PROMPT="%{$fg_no_bold[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%~
%{$reset_color%}(%{$fg[yellow]%}%D{%H:%M}%{$reset_color%}) %{$fg[blue]%}> %{$reset_color%}"
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
PS2=" %{$fg_no_bold[blue]%}>%{$reset_color%} "
