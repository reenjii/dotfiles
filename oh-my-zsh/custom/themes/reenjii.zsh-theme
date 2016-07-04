# user@host path
# (time) >
# right prompt is the result of previous command

PROMPT='%{$fg_no_bold[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%~
%{$reset_color%}(%{$fg[yellow]%}%D{%H:%M}%{$reset_color%}) $(git_prompt_info) %{$fg[blue]%}> %{$reset_color%}'
RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
PS2=" %{$fg_no_bold[blue]%}>%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
