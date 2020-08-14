#!/bin/sh -l

echo "Starts"
SRC_DIR="$1"
DEST_GITHUB_USERNAME="$2"
DEST_GITHUB_REPO="$3"
USER_EMAIL="$4"
DEST_BRANCH="$5"

CLONE_DIR=$(mktemp -d)

# Setup git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$GITHUB_USERNAME"
git clone "https://$API_TOKEN_GITHUB@github.com/$DEST_GITHUB_USERNAME/$DEST_GITHUB_REPO.git" "$CLONE_DIR"

echo 'Copying from '"$SRC_DIR"'/*' "to $CLONE_DIR/$REPOSITORY_NAME"
mkdir -p "$CLONE_DIR/$REPOSITORY_NAME"
cp -R "$SRC_DIR"/* "$CLONE_DIR/$REPOSITORY_NAME" || (rm -Rf "$CLONE_DIR" && exit 1)

cd "$CLONE_DIR"
git add .
git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
git checkout -b $DEST_BRANCH
git push origin $DEST_BRANCH
