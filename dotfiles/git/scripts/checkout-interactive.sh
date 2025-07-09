#! /bin/sh

git branch | gum filter | sed 's/..//' | xargs git checkout
