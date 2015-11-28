#!/bin/bash

# ----------------------
# KUDU Deployment Script
# Version: 1.0.2
# ----------------------

# Helpers
# -------

exitWithMessageOnError () {
  if [ ! $? -eq 0 ]; then
    echo "An error has occurred during web site deployment."
    echo $1
    exit 1
  fi
}

# Prerequisites
# -------------

# Verify node.js installed
hash node 2>/dev/null
exitWithMessageOnError "Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment."

# Setup
# -----

SCRIPT_DIR="${BASH_SOURCE[0]%\\*}"
SCRIPT_DIR="${SCRIPT_DIR%/*}"
ARTIFACTS=$SCRIPT_DIR/../artifacts
KUDU_SYNC_CMD=${KUDU_SYNC_CMD//\"}

if [[ ! -n "$DEPLOYMENT_SOURCE" ]]; then
  DEPLOYMENT_SOURCE=$SCRIPT_DIR
fi

if [[ ! -n "$NEXT_MANIFEST_PATH" ]]; then
  NEXT_MANIFEST_PATH=$ARTIFACTS/manifest

  if [[ ! -n "$PREVIOUS_MANIFEST_PATH" ]]; then
    PREVIOUS_MANIFEST_PATH=$NEXT_MANIFEST_PATH
  fi
fi

if [[ ! -n "$DEPLOYMENT_TARGET" ]]; then
  DEPLOYMENT_TARGET=$ARTIFACTS/wwwroot
else
  KUDU_SERVICE=true
fi

if [[ ! -n "$KUDU_SYNC_CMD" ]]; then
  # Install kudu sync
  echo Installing Kudu Sync
  npm install kudusync -g --silent
  exitWithMessageOnError "npm failed"

  if [[ ! -n "$KUDU_SERVICE" ]]; then
    # In case we are running locally this is the correct location of kuduSync
    KUDU_SYNC_CMD=kuduSync
  else
    # In case we are running on kudu service this is the correct location of kuduSync
    KUDU_SYNC_CMD=$APPDATA/npm/node_modules/kuduSync/bin/kuduSync
  fi
fi

# Node Helpers
# ------------

selectNodeVersion () {
  if [[ -n "$KUDU_SELECT_NODE_VERSION_CMD" ]]; then
    SELECT_NODE_VERSION="$KUDU_SELECT_NODE_VERSION_CMD \"$DEPLOYMENT_SOURCE\" \"$DEPLOYMENT_TARGET\" \"$DEPLOYMENT_TEMP\""
    eval $SELECT_NODE_VERSION
    exitWithMessageOnError "select node version failed"

    if [[ -e "$DEPLOYMENT_TEMP/__nodeVersion.tmp" ]]; then
      NODE_EXE=`cat "$DEPLOYMENT_TEMP/__nodeVersion.tmp"`
      exitWithMessageOnError "getting node version failed"
    fi
    
    if [[ -e "$DEPLOYMENT_TEMP/.tmp" ]]; then
      NPM_JS_PATH=`cat "$DEPLOYMENT_TEMP/__npmVersion.tmp"`
      exitWithMessageOnError "getting npm version failed"
    fi

    if [[ ! -n "$NODE_EXE" ]]; then
      NODE_EXE=node
    fi

    NPM_CMD="\"$NODE_EXE\" \"$NPM_JS_PATH\""
  else
    NPM_CMD=npm
    NODE_EXE=node
  fi
}

##################################################################################################################################
# Deployment
# ----------

echo Handling node.js deployment.

# 1. KuduSync
if [[ "$IN_PLACE_DEPLOYMENT" -ne "1" ]]; then
  "$KUDU_SYNC_CMD" -v 50 -f "$DEPLOYMENT_SOURCE" -t "$DEPLOYMENT_TARGET" -n "$NEXT_MANIFEST_PATH" -p "$PREVIOUS_MANIFEST_PATH" -i ".git;.hg;.deployment;deploy.sh"
  exitWithMessageOnError "Kudu Sync failed"
fi

# 2. Select node version
selectNodeVersion

# 3. Install npm packages
if [ -e "$DEPLOYMENT_TARGET/package.json" ]; then
  cd "$DEPLOYMENT_TARGET"
  eval $NPM_CMD install --production
  exitWithMessageOnError "npm failed"

  echo "Calling jspm register config github"
  eval "node_modules/.bin/jspm" config registries.github.auth $JSPM_GITHUB_AUTH_TOKEN
  exitWithMessageOnError "jspm registry config github failed"  

  echo "Installing jspm"
  eval "node_modules/.bin/jspm" install
  exitWithMessageOnError "jspm failed"  
  echo "Finished installing jspm"

  echo "Installing gulp"
  eval $NPM_CMD install gulp
  exitWithMessageOnError "gulp install failed"
  echo "Finished installing gulp"

  echo "Installing require-dir"
  eval $NPM_CMD install require-dir
  exitWithMessageOnError "require-dir install failed"
  echo "Finished installing require-dir"

  echo "Installing run-sequence"
  eval $NPM_CMD install run-sequence
  exitWithMessageOnError "run-sequence install failed"
  echo "Finished installing run-sequence"

  echo "Installing gulp-changed"
  eval $NPM_CMD install gulp-changed
  exitWithMessageOnError "gulp-changed install failed"
  echo "Finished installing gulp-changed"

  echo "Installing gulp-plumber"
  eval $NPM_CMD install gulp-plumber
  exitWithMessageOnError "gulp-plumber install failed"
  echo "Finished installing gulp-plumber"

  echo "Installing gulp-babel"
  eval $NPM_CMD install gulp-babel
  exitWithMessageOnError "gulp-babel install failed"
  echo "Finished installing gulp-babel"

  echo "Installing gulp-sourcemaps"
  eval $NPM_CMD install gulp-sourcemaps
  exitWithMessageOnError "gulp-sourcemaps install failed"
  echo "Finished installing gulp-sourcemaps"

  echo "Installing gulp-notify"
  eval $NPM_CMD install gulp-notify
  exitWithMessageOnError "gulp-notify install failed"
  echo "Finished installing gulp-notify"

  echo "Installing aurelia-bundler"
  eval $NPM_CMD install aurelia-bundler
  exitWithMessageOnError "aurelia-bundler install failed"
  echo "Finished installing aurelia-bundler"

  echo "Installing del"
  eval $NPM_CMD install del
  exitWithMessageOnError "del install failed"
  echo "Finished installing del"

  echo "Installing vinyl-paths"
  eval $NPM_CMD install vinyl-paths
  exitWithMessageOnError "vinyl-paths install failed"
  echo "Finished installing vinyl-paths"

  echo "Installing aurelia-tools"
  eval $NPM_CMD install aurelia-tools
  exitWithMessageOnError "aurelia-tools install failed"
  echo "Finished installing aurelia-tools"

  echo "Installing gulp-yuidoc"
  eval $NPM_CMD install gulp-yuidoc
  exitWithMessageOnError "gulp-yuidoc install failed"
  echo "Finished installing gulp-yuidoc"

  echo "Installing gulp-protractor"
  eval $NPM_CMD install gulp-protractor
  exitWithMessageOnError "gulp-protractor install failed"
  echo "Finished installing gulp-protractor"

  echo "Installing gulp-eslint"
  eval $NPM_CMD install gulp-eslint
  exitWithMessageOnError "gulp-eslint install failed"
  echo "Finished installing gulp-eslint"

  echo "Installing conventional-changelog"
  eval $NPM_CMD install conventional-changelog
  exitWithMessageOnError "conventional-changelog install failed"
  echo "Finished installing conventional-changelog"

  echo "Installing gulp-bump"
  eval $NPM_CMD install gulp-bump
  exitWithMessageOnError "gulp-bump install failed"
  echo "Finished installing gulp-bump"

  echo "Installing browser-sync"
  eval $NPM_CMD install browser-sync
  exitWithMessageOnError "browser-sync install failed"
  echo "Finished installing browser-sync"

  echo "Installing karma"
  eval $NPM_CMD install karma
  exitWithMessageOnError "karma install failed"
  echo "Finished installing karma"

  echo "Calling gulp build"
  eval "node_modules/.bin/gulp" build
  exitWithMessageOnError "gulp build failed"  
  echo "Finished gulp build"

  cd - > /dev/null
fi

##################################################################################################################################

# Post deployment stub
if [[ -n "$POST_DEPLOYMENT_ACTION" ]]; then
  POST_DEPLOYMENT_ACTION=${POST_DEPLOYMENT_ACTION//\"}
  cd "${POST_DEPLOYMENT_ACTION_DIR%\\*}"
  "$POST_DEPLOYMENT_ACTION"
  exitWithMessageOnError "post deployment action failed"
fi

echo "Finished successfully."
