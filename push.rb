#!/usr/bin/env ruby

DEBUG_MODE = ["", "_debug"]
USER = %w(root nonroot)
ARCH = %w(amd64 arm64)
DISTRO = %w(debian12 debian13)

build_date = Time.now.strftime("%F")

DEBUG_MODE.each do |mode|
  USER.each do |user|
    ARCH.each do |arch|
      DISTRO.each do |distro|
        variant = "ruby#{mode}_#{user}_#{arch}_#{distro}"
        load_target = "//ruby:load_#{variant}"
        docker_image = "bazel/ruby:#{variant}"

        tag_suffix = [
          mode.empty? ? nil : mode.delete_prefix("_"),
          user,
          arch,
          distro,
        ].compact.join("_")

        docker_tag_base = "ghcr.io/#{ENV["GITHUB_REPOSITORY_OWNER"]}/distroless/ruby:#{tag_suffix}"

        # Load the OCI image into docker
        system("bazel run #{load_target}", exception: true)

        # Tag and push with date
        system("docker tag #{docker_image} #{docker_tag_base}-#{build_date}", exception: true)
        system("docker push #{docker_tag_base}-#{build_date}", exception: true)

        # Tag and push as latest
        system("docker tag #{docker_image} #{docker_tag_base}-latest", exception: true)
        system("docker push #{docker_tag_base}-latest", exception: true)
      end
    end
  end
end
