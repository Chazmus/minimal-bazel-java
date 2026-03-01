load("@rules_java//java:defs.bzl", "java_test")

java_test(
    name = "app_test",
    srcs = ["AppTest.java"],
    test_class = "com.example.AppTest",
    deps = [
        "//src/main/java/com/example:app",
        "@maven//:junit_junit",
    ],
)
