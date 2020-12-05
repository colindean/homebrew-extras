require 'formula'

class Coursier < Formula
  desc "Coursier launcher."
  homepage "https://get-coursier.io"
  version "2.0.7"
  url "https://github.com/coursier/coursier/releases/download/v2.0.7/coursier"
  sha256 "c4abcf6b5366dc5bc7453c8c68cb3c64a0864765442a8f7542974d5bd712f8f9"
  bottle :unneeded

  option "without-zsh-completions", "Disable zsh completion installation"

  depends_on "openjdk@8"

  def install
    unless build.without? "zsh-completion"
      FileUtils.mkdir_p "completions/zsh"
      system "bash", "-c", "bash ./coursier --completions zsh > completions/zsh/_coursier"
      zsh_completion.install "completions/zsh/_coursier"
    end

    bin.install 'coursier'
  end

  test do
    ENV["COURSIER_CACHE"] = "#{testpath}/cache"
    output = shell_output("#{bin}/coursier launch io.get-coursier:echo:1.0.4 -- foo")
    assert_equal ["foo\n"], output.lines
  end
end
