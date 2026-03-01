#!/usr/bin/env bash

# 1. Base paths for your built product
PRODUCT_HOME="/home/cbailey/workspace/bazel-eclipse/releng/products/jdt-bazel-ls/target/products/jdt-bazel-ls/linux/gtk/x86_64"
JAVA_EXEC="$PRODUCT_HOME/plugins/org.eclipse.justj.openjdk.hotspot.jre.minimal.stripped.linux.x86_64_21.0.6.v20250130-0529/jre/bin/java"
CONFIG_DIR="$PRODUCT_HOME/configuration"
LAUNCHER_JAR=$(ls $PRODUCT_HOME/plugins/org.eclipse.equinox.launcher_*.jar | head -n 1)

# 2. Workspace and Logging
WORKSPACE_ROOT="/home/cbailey/.cache/nvim/jdtls/bazel-workspace"
mkdir -p "$WORKSPACE_ROOT"

# 3. Execute JDTLS in headless mode using the product's own config
exec "$JAVA_EXEC" \
  "-Declipse.application=org.eclipse.jdt.ls.core.id1" \
  "-Dosgi.bundles.defaultStartLevel=4" \
  "-Declipse.product=org.eclipse.jdt.ls.core.product" \
  "-Dcom.salesforce.bazel.log.dir=$WORKSPACE_ROOT/.metadata" \
  "-Dlog.level=ALL" \
  "-Xms1G" \
  "--add-modules=ALL-SYSTEM" \
  "--add-opens" "java.base/java.util=ALL-UNNAMED" \
  "--add-opens" "java.base/java.lang=ALL-UNNAMED" \
  "-jar" "$LAUNCHER_JAR" \
  "-configuration" "$CONFIG_DIR" \
  "-data" "$WORKSPACE_ROOT" \
  "$@"
