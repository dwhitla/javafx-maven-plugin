#!/usr/bin/env bash

export REPO_NAME=javafx-maven-archetypes
export REPO_SLUG=openjfx/javafx-maven-archetypes
export XML_LOCATION=src/main/resources/META-INF/maven/archetype-metadata.xml

cd $TRAVIS_BUILD_DIR
git clone https://github.com/$REPO_SLUG
cd $REPO_NAME

# Traverse through all sub-directories starting with "javafx-archetype-"
for f in ./javafx-archetype-* ; do
  # f is directory and not a symlink
  if [[  -d "$f" && ! -L "$f" ]]; then\
    # Update <defaultValue> for parent node <requiredProperty> with key='javafx-maven-plugin-version'
    xmlstarlet ed -P -L -u "//_:requiredProperty[@key='javafx-maven-plugin-version']/_:defaultValue" -v "$1" "$f"/$XML_LOCATION
  fi
done

git commit */$XML_LOCATION -m "Upgrade javafx-maven-plugin version to $1"
git push https://gluon-bot:$GITHUB_PASSWORD@github.com/$REPO_SLUG HEAD:master