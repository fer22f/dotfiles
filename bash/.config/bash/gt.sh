#!/usr/bin/env bash

gt () {
  case "$1" in
    "get")
      case "$2" in
        "b" | "branch" | "branches") git branch -v;;
      esac;;
    "go")
      shift 1
      git checkout ${@} || git checkout -b ${@};;
    "new")
      case "$2" in
        "b" | "branch" | "branches")
          shift 2

          echo "git checkout -b ${@}"
          # git checkout -b $@;;
      esac;;
    "stage")
      shift 1
      git add -- ${@:-.};;
    "patch")
      shift 1
      git add --patch -- ${@};;
    "commit")
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
    "amend")
      git commit -a --amend;;
    "diff")
      shift 1
      git diff HEAD -- ${@};;
    "")
      git status;;
    *)
      git $@;;
  esac
}
