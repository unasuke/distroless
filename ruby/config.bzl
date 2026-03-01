RUBY_DISTROS = ["debian12", "debian13"]
RUBY_ARCHITECTURES = {
    "debian12": ["amd64", "arm64"],
    "debian13": ["amd64", "arm64"],
}

RUBY_PACKAGES = {
    "debian12": [
        "libruby3.1",
        "ruby3.1",
        "ruby-rubygems",
        "rubygems-integration",
        "libyaml-0-2",
        "libgmp10",
        "libffi8",
        "libgdbm6",
        "libgdbm-compat4",
        "libreadline8",
        "libedit2",
        "libtinfo6",
        "libncursesw6",
        "libcrypt1",
        "zlib1g",
    ],
    "debian13": [
        "libruby3.3",
        "ruby3.3",
        "ruby-rubygems",
        "rubygems-integration",
        "libyaml-0-2",
        "libgmp10",
        "libffi8",
        "libgdbm6t64",
        "libgdbm-compat4t64",
        "libreadline8t64",
        "libtinfo6",
        "libncursesw6",
        "zlib1g",
        "libc-bin",
    ],
}
