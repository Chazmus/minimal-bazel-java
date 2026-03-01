workspace(name = "bazel_java_test")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_java",
    urls = [
        "https://github.com/bazelbuild/rules_java/releases/download/7.10.0/rules_java-7.10.0.tar.gz",
    ],
    sha256 = "66f39e334336214170327f3f3824578ef2b801a6b093358055a407851253a6eb",
)

load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")
rules_java_dependencies()
rules_java_toolchains()

RULES_JVM_EXTERNAL_TAG = "5.3"
RULES_JVM_EXTERNAL_SHA = "d359e830e2389d020cf01103c8b4172a6b2210777e481079bc97e163b2164c8d"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/releases/download/%s/rules_jvm_external-%s.tar.gz" % (RULES_JVM_EXTERNAL_TAG, RULES_JVM_EXTERNAL_TAG),
)

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "com.fasterxml.jackson.core:jackson-databind:2.15.2",
        "junit:junit:4.13.2",
    ],
    repositories = [
        "https://maven.google.com/content/repositories/releases",
        "https://repo1.maven.org/maven2",
    ],
)
