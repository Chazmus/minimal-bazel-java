# Bazel Integration for JDTLS (Neovim/LazyVim) - Status Report

## Current Status: [IN PROGRESS]
**Last Updated**: March 1, 2026
**Goal**: Full Bazel dependency resolution in Neovim using the Salesforce `bazel-eclipse` JDT.LS product.

---

## 1. Accomplishments (March 1, 2026)

### A. Functional Bazel Sync Command
- **Issue**: Neovim reported `Unknown command: java.bazel.syncProjects`.
- **Fix**: 
    - Updated `~/.config/nvim/lua/plugins/java.lua` to use `client.request("workspace/executeCommand", ...)` to target the `jdtls` client specifically.
    - Forced the client to recognize the Salesforce JDTLS extension by adding its directory to `opts.bundles`.
- **Result**: `java.bazel.syncProjects` now executes successfully and triggers the server-side sync.

### B. Repaired Aspect Deployment
- **Issue**: JDTLS failed to build with aspects due to `NoSuchFileException` in the state directory. The built product contained empty ZIPs.
- **Fix**: Manually deployed working aspects (from version `3f0edc`) into the versioned state folder `1e99c4` expected by the current SDK. Created the required `manifest` file.
- **Result**: Server now successfully generates `--aspects` flags and runs Bazel builds to collect metadata.

### C. Workspace & Project View Optimization
- **Bazel Query Fix**: Moved a conflicting `intellij/` directory (containing `.bzl` files but missing `BUILD` files) that was causing `bazel query //...` to fail with exit code 7.
- **Project View**: Updated `.bazelproject` with explicit `targets:` to provide a clear scope for the importer.
- **Result**: The synchronization process now completes without fatal errors.

---

## 2. Current Challenges
- **Classpath Resolution**: Even with a "successful" Bazel sync, Jackson imports (`com.fasterxml.jackson`) remain unresolved in Neovim.
- **Maven Integration**: The JDTLS classpath container is not yet correctly translating the `@maven//` dependencies discovered by the aspects into JDT classpath entries.

---

## 3. Next Steps
1. **Debug Classpath Container**: Investigate `BazelClasspathManager.java` and `JavaAspectsInfo.java` in the `bazel-eclipse` source to see why external dependencies are being skipped.
2. **Bazel 9 Compatibility**: Verify if the way Bazel 9 reports output paths or external repositories has changed in a way that breaks the Salesforce extension's parser.
3. **Trace BEP Output**: Capture and inspect the Build Event Protocol (BEP) output produced during a sync to verify it contains the expected library information.

---

## 4. Key Files
- **Launcher**: `/home/cbailey/workspace/bazel-jdtls/jdtls-bazel-launcher.sh`
- **Neovim Config**: `/home/cbailey/.config/nvim/lua/plugins/java.lua`
- **Project View**: `/home/cbailey/workspace/bazel-jdtls/.bazelproject`
- **Working Aspects Source**: `.eclipse/.intellij-aspects/3f0edc-9.0.0`
- **JDTLS State Location**: `~/.cache/nvim/jdtls/bazel-workspace/.metadata/.plugins/com.salesforce.bazel.eclipse.core/intellij-aspects/1e99c4/`

---

### Previous History (Feb 28, 2026)
- Deleted redundant `bin/` directory causing build failures.
- Created `jdtls-bazel-launcher.sh`.
- Initial LazyVim configuration for custom product.
