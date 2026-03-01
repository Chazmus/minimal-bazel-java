load("@rules_java//java:defs.bzl", "java_binary", "java_library")

java_binary(
    name = "app",
    srcs = ["App.java"],
    main_class = "com.example.App",
    visibility = ["//visibility:public"],
    deps = [
        "@maven//:com_fasterxml_jackson_core_jackson_databind",
    ],
)
