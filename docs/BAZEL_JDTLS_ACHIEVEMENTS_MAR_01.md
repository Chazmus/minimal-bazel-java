# Bazel JDTLS Integration Report - March 1, 2026

## Executive Summary
Today's efforts successfully bridged the gap between the headless Salesforce JDT.LS product and the Neovim client. We transitioned from a state where the server failed to recognize Bazel commands to a state where **synchronization is fully functional**, the project structure is correctly imported, and the server-side aspects are properly deployed.

---

## 1. Technical Breakthroughs

### A. LSP Command Registration & Execution
- **Problem**: Neovim reported `Unknown command: java.bazel.syncProjects` even when the server logs showed command registration.
- **Solution**: 
    - Modified `~/.config/nvim/lua/plugins/java.lua` to use `client.request("workspace/executeCommand", ...)` instead of the generic `vim.lsp.buf.execute_command`.
    - Forced the client to recognize the Salesforce extension by explicitly adding the bundle JAR/directory to `opts.bundles`, ensuring the client-side LSP capability for these commands is advertised.
- **Result**: The "Bazel sync successful" notification now triggers reliably upon LSP attachment.

### B. Aspect Deployment Repair
- **Problem**: JDTLS logs revealed a `NoSuchFileException` for `intellij-aspects/1e99c4/default/manifest`. Investigation showed the built product contained empty `aspects-*.zip` files (0 bytes).
- **Solution**:
    - Identified a working set of aspects in the `.eclipse/.intellij-aspects/3f0edc-9.0.0` directory.
    - Manually deployed these to the specific versioned location expected by the JDTLS state directory: `~/.cache/nvim/jdtls/bazel-workspace/.metadata/.plugins/com.salesforce.bazel.eclipse.core/intellij-aspects/1e99c4/`.
    - Provided the required `default/manifest` file to satisfy the SDK's initialization logic.
- **Result**: The server now successfully prepares the command line with the necessary `--aspects` flags for Bazel builds.

### C. Workspace Integrity & Query Resolution
- **Problem**: Bazel synchronization was failing with `exit code 3` (Query Failure).
- **Discovery**: A manual `bazel query "//..."` failed with `exit code 7` because a sub-directory named `intellij/` contained `.bzl` files without corresponding `BUILD` files.
- **Fix**: Moved the problematic `intellij/` directory to a temporary backup location.
- **Result**: Global queries now pass, allowing the Salesforce importer to correctly "materialize" targets into Eclipse-compatible projects.

---

## 2. Updated Architecture

### Custom Launcher: `jdtls-bazel-launcher.sh`
This remains the core of the integration, providing:
- Execution of the specialized Salesforce JDT.LS product.
- Headless mode via `-Declipse.application=org.eclipse.jdt.ls.core.id1`.
- Isolated workspace data path in `~/.cache/nvim/jdtls/bazel-workspace`.

### Neovim Config: `lua/plugins/java.lua`
- **Root Detection**: Now explicitly searches for `.bazelproject`, `WORKSPACE`, or `MODULE.bazel` to ensure the correct project context is established in headless mode.
- **Deferred Sync**: Automatically triggers the Bazel sync 2 seconds after attachment to ensure the server is ready to handle the request.

### Project View: `.bazelproject`
- Added an explicit `targets:` section:
  ```
  targets:
    //src/main/java/com/example:app
    //src/test/java/com/example:app_test
  ```
- This provides a deterministic scope for the JDTLS importer, reducing the "noise" of searching the entire tree.

---

## 3. Current Status & Next Steps

### State: **[FUNCTIONAL SYNC / PENDING CLASSPATH]**
The server now correctly identifies your project, creates the virtual Eclipse projects in `.eclipse/projects/`, and successfully runs Bazel builds with aspects.

### Immediate Next Steps:
1. **Maven Dependency Resolution**: While the sync is "successful," Jackson (`com.fasterxml`) is still not appearing on the JDTLS classpath. This suggests the server is parsing the aspect output but not correctly translating the `@maven//` labels into classpath entries.
2. **SDK Investigation**: Reviewing `JavaAspectsInfo.java` in the `bazel-eclipse` source to see how it handles external repository labels in Bazel 9.0.

---

**Launcher**: `/home/cbailey/workspace/bazel-jdtls/jdtls-bazel-launcher.sh`  
**JDTLS Log**: `~/.cache/nvim/jdtls/bazel-workspace/.metadata/.log`
