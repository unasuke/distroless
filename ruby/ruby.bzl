"ruby image definitions"

load("@container_structure_test//:defs.bzl", "container_structure_test")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_image_index", "oci_load")
load("//common:variables.bzl", "DEBUG_MODE", "USERS")
load("//private/util:deb.bzl", "deb")

DISTRO_VERSION = {
    "debian12": "3.1",
    "debian13": "3.3",
}

def ruby_image_index(distro, architectures):
    """ruby image index for a distro

    Args:
        distro: name of distribution
        architectures: all architectures included in index
    """
    for mode in DEBUG_MODE:
        for user in USERS:
            oci_image_index(
                name = "ruby" + mode + "_" + user + "_" + distro,
                images = [
                    "ruby" + mode + "_" + user + "_" + arch + "_" + distro
                    for arch in architectures
                ],
            )

def ruby_image(distro, arch, packages):
    """ruby and debug image with tests.

    Args:
        distro: name of distribution
        arch: the target architecture
        packages: list of debian packages to include
    """
    for mode in DEBUG_MODE:
        for user in USERS:
            oci_image(
                name = "ruby" + mode + "_" + user + "_" + arch + "_" + distro,
                # Based on //cc so that C extensions work properly.
                base = "//cc:cc" + mode + "_" + user + "_" + arch + "_" + distro,
                entrypoint = [
                    "/usr/bin/ruby" + DISTRO_VERSION[distro],
                ],
                # Use UTF-8 encoding for file system: match modern Linux
                env = {"LANG": "C.UTF-8"},
                tars = [
                    deb.package(arch, distro, pkg, "ruby")
                    for pkg in packages
                ] + ([":ldconfig_cache_" + arch] if distro == "debian13" else []),
            )

    for mode in DEBUG_MODE:
        for user in USERS:
            # root images without debug mode for debian13 are already loaded by ldconfig.bzl
            if mode == "" and user == "root" and distro == "debian13":
                continue
            oci_load(
                name = "load_ruby" + mode + "_" + user + "_" + arch + "_" + distro,
                image = ":ruby" + mode + "_" + user + "_" + arch + "_" + distro,
                repo_tags = ["bazel/ruby:ruby" + mode + "_" + user + "_" + arch + "_" + distro],
            )

    for user in USERS:
        container_structure_test(
            name = "ruby_" + user + "_" + arch + "_" + distro + "_test",
            size = "medium",
            configs = ["testdata/ruby.yaml"],
            image = ":ruby_" + user + "_" + arch + "_" + distro,
            tags = [
                "manual",
                arch,
            ],
        )

    # tests for version-specific things
    for user in USERS:
        container_structure_test(
            name = "version_specific_" + user + "_" + arch + "_" + distro + "_test",
            size = "medium",
            configs = ["testdata/" + distro + ".yaml"],
            image = ":ruby_" + user + "_" + arch + "_" + distro,
            tags = [
                "manual",
                arch,
            ],
        )
