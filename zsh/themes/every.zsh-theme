# Purple ASCII banner for oh-my-zsh (truecolor)
# Shows once per shell session. Call `banner` anytime to reprint.

banner() {
  local -a lines=(
    '    __                 __                     '
    '   / /__  ____        / /____  _________ ___  '
    '  / / _ \/ __ \______/ __/ _ \/ ___/ __  __ \ '
    ' / /  __/ /_/ /_____/ /_/  __/ /  / / / / / / '
    '/_/\___/\____/      \__/\___/_/  /_/ /_/ /_/  '
    '                                              '
  )

  # Light → deep purple gradient (6 rows)
  local -a colors=(
    '255;208;255'  # #FFD0FF
    '179;136;255'  # #B388FF
    '157;78;221'   # #9D4EDD
    '123;44;191'   # #7B2CBF
    '90;24;154'    # #5A189A
    '60;9;108'     # #3C096C
  )

  local i rgb r g b
  for i in {1..$#lines}; do
    rgb=("${(@s/;/)colors[i]}")
    r=${rgb[1]} g=${rgb[2]} b=${rgb[3]}
    printf "\e[38;2;%s;%s;%sm%s\e[0m\n" "$r" "$g" "$b" "${lines[i]}"
  done
}

# Auto-print once per session
autoload -Uz add-zsh-hook
_zsh_print_banner_once() {
  [[ -n ${_PURPLE_BANNER_SHOWN-} ]] && return
  _PURPLE_BANNER_SHOWN=1
  banner
}
add-zsh-hook precmd _zsh_print_banner_once


PROMPT="%{$FG[056]%}%n%{$FG[214]%}@%{$fg[blue]%}%m %{$fg[cyan]%}%~ %{$fg[green]%}% ➜ %{$reset_color%}% "
