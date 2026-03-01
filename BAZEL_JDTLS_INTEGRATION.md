# Bazel Integration for JDTLS (Neovim/LazyVim) - Status Report

## Current Status: [IN PROGRESS]
**Last Updated**: Feb 28, 2026
**Goal**: Full Bazel dependency resolution in Neovim using the Salesforce `bazel-eclipse` JDT.LS product.

---

## 1. Accomplishments Today

### A. Repaired Bazel Workspace
- **Issue**: `bazel build //...` was failing due to a redundant `bin/` directory containing duplicate `BUILD` files but missing source `.java` files.
- **Fix**: Deleted the `bin/` directory.
- **Result**: `bazel build //...` and `bazel test //...` now pass successfully. External dependencies (Jackson) are correctly resolved by Bazel.

### B. Custom JDTLS Launcher
- **Created**: `jdtls-bazel-launcher.sh` in the project root.
- **Function**: This script runs the built Salesforce JDT.LS product (`releng/products/jdt-bazel-ls`) in headless mode (`-application org.eclipse.jdt.ls.core.id1`).
- **Advantage**: It bypasses the need to manually load OSGi bundles into a generic JDTLS install, as they are already baked into this product.

### C. LazyVim Configuration (`~/.config/nvim/lua/plugins/java.lua`)
- **Updated `opts.cmd`**: Points to the new `jdtls-bazel-launcher.sh`.
- **Filtered Bundles**: Cleared `opts.bundles` to prevent Mason-related JAR conflicts.
- **Auto-Sync**: Added an `LspAttach` autocmd to automatically trigger `java.bazel.syncProjects` 2 seconds after the server attaches.

---

## 2. Current Challenges
- **Command Support**: We recently saw `No delegateCommandHandler for java.bazel.syncProjects`. This suggests that even though we are running the built product, the Bazel-specific commands aren't being registered in the headless instance yet.
- **Dependency Resolution**: Jackson imports in `App.java` are still intermittently red in Neovim, despite being valid in the Bazel build.

---

## 3. Tomorrow's Strategy
1. **Verify OSGi Bundle Activation**: Check the `jdtls.log` from the new launcher to see if `com.salesforce.bazel.eclipse.jdtls` is actually starting.
2. **Force Plugin Loading**: Experiment with adding the specific Salesforce JDTLS JAR back into the `bundles` list *even while using the custom launcher* to force registration.
3. **Headless Mode Validation**: Confirm that the `-application org.eclipse.jdt.ls.core.id1` flag is correctly enabling the Bazel extensions or if a different application ID is required.
4. **Cache Reset**: Perform a "deep clean" of `~/.cache/nvim/jdtls/bazel-workspace` to ensure no stale Eclipse metadata is interfering.

---

## 4. Key Files for Resume
- **Launcher**: `/home/cbailey/workspace/bazel-jdtls/jdtls-bazel-launcher.sh`
- **Neovim Config**: `/home/cbailey/.config/nvim/lua/plugins/java.lua`
- **Project View**: `/home/cbailey/workspace/bazel-jdtls/.bazelproject` (Symlinked to `.eclipse/.bazelproject`)
