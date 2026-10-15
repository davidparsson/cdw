# cd to a worktree of the current repository, selected with fzf
cdw() {
    local selected_worktree
    selected_worktree=$(_cdw_list_worktrees | fzf --ansi --no-sort --delimiter=$'\t' --with-nth=2 \
        --query="$*" ${*:+--select-1} --exit-0 | cut -f1)
    [[ -n $selected_worktree ]] && builtin cd "$selected_worktree"
}

# Worktrees as "<path>\t<display line>", most recently committed first
_cdw_list_worktrees() {
    local reset=$'\e[0m' green=$'\e[32m' yellow=$'\e[33m' grey=$'\e[2;37m'
    local current_worktree repository_root line worktree_path branch head name marker relative_path commit_info
    local -A entries_by_head
    current_worktree=$(git rev-parse --show-toplevel) || return
    git worktree list --porcelain | while IFS= read -r line; do
        case $line in
            worktree\ *) worktree_path=${line#worktree }; branch=
                repository_root=${repository_root:-$worktree_path} ;;
            HEAD\ *) head=${line#HEAD } ;;
            branch\ *) branch=${line#branch refs/heads/} ;;
            '') name=${branch:-"${yellow}(detached ${head:0:10})${reset}"} marker='  '
                [[ $worktree_path == "$current_worktree" ]] && name=$green$name$reset marker='* '
                relative_path=${(D)${${worktree_path:/$repository_root/.}#$repository_root/}}
                entries_by_head[$head]+="$worktree_path"$'\t'"$marker$name  $grey$relative_path$reset "$'\n' ;;
        esac
    done
    git log --no-walk --color=always --format='%H%x09%C(dim white)(%C(dim green)%cr%C(dim white))%C(reset)' \
        ${(k)entries_by_head} | while IFS=$'\t' read -r head commit_info; do
        for line in ${(f)entries_by_head[$head]}; do
            print -r -- "$line$commit_info"
        done
    done
}
