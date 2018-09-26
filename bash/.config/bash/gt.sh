gt () {
  case "$1" in
    "get")
      case "$2" in
        "b" | "branch" | "branches") git branch -v;;
      esac;;
    "go")
      git checkout $3 2>/dev/null || git checkout -b $3;;
    "new")
      case "$2" in
        "b" | "branch" | "branches") git checkout -b $3;;
      esac;;
    "stage")
      git add ${2:-.};;
    "patch")
      git add --patch $2;;
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
    "ammend")
      git commit -a --ammend;;
    "diff")
      git diff HEAD;;
    "")
      git status -sb;;
    *)
      git $@;;
  esac
}
