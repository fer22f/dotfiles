#!/usr/bin/env bash

gt () {
  case "$1" in
    "list"|"ls")
      case "$2" in
        "b" | "branch" | "branches") git branch -v;;
        "r" | "remote" | "remotes") git remote -v;;
      esac;;
    "stage")
      if [[ -z $2 ]]; then
        git stage .
        git status -- .
      else
        git stage $2
        git status -- .
      fi
      ;;
    "patch")
      shift 1
      git add --patch -- ${@};;
    "rcommit")
      if [[ -z $(git diff --staged) ]]; then
        git add . && git commit -v
      else
        git commit -v
      fi

      if [[ $? -eq 1 ]]; then
        ROOT_DIR=$(git rev-parse --show-toplevel)

        echo Which files do you want to edit?
        select FILENAME in $(git diff --staged --name-only); do
          $EDITOR $ROOT_DIR/$FILENAME
          break
        done

        echo Commit?
        select RECOMMIT in "Commit" "No"; do
          if [[ $RECOMMIT == "Commit" ]]; then
            git add $ROOT_DIR/$FILENAME
            gt commit
          fi
          break
        done
      fi
      ;;
    "diff")
      shift 1
      git diff HEAD -- .
      ;;
    "")
      git status -- .;;
    "checkout")
      echo no;;
    *)
      git $@;;
  esac
}
