load(":config.bzl", "RUBY_ARCHITECTURES", "RUBY_DISTROS", "RUBY_PACKAGES")
load(":ldconfig.bzl", "ruby_ldconfig")
load(":ruby.bzl", "ruby_image", "ruby_image_index")
load("//private/util:tar.bzl", "tar")

package(default_visibility = ["//visibility:public"])

[
    tar(
        name = "ldconfig_cache_{}".format(arch),
        srcs = ["ldconfig/ld.so.cache.{}".format(arch)],
        args = [
            "--format",
            "gnutar",
        ],
        extension = "tar.gz",
        mtree = ["etc/ld.so.cache uid=0 gid=0 uname=root gname=root mode=0644 time=0 type=file content=$(location ldconfig/ld.so.cache.{})".format(arch)],
    )
    for arch in RUBY_ARCHITECTURES["debian13"]
]

[
    ruby_image(
        arch = arch,
        distro = distro,
        packages = RUBY_PACKAGES[distro],
    )
    for distro in RUBY_DISTROS
    for arch in RUBY_ARCHITECTURES[distro]
]

[
    ruby_image_index(
        architectures = RUBY_ARCHITECTURES[distro],
        distro = distro,
    )
    for distro in RUBY_DISTROS
]

# ldconfig.so.cache generation
ruby_ldconfig(
    architectures = RUBY_ARCHITECTURES["debian13"],
    distro = "debian13",
)
