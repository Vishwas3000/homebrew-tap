class JpegAiApple < Formula
  desc "Experimental native Apple JPEG AI encoder and decoder"
  homepage "https://github.com/Vishwas3000/ai_compression"
  url "https://github.com/Vishwas3000/ai_compression/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "3019c94f126d6089b51a7031475f5c07c71193378eb130bc770dbb1afd42018d"
  license all_of: ["MIT", "BSD-3-Clause"]

  depends_on macos: :ventura

  resource "models" do
    url "https://github.com/Vishwas3000/ai_compression/releases/download/v0.1.0/jpeg-ai-apple-models-0.1.0.tar.gz"
    sha256 "524b7927c8d3483b9945a8520b3b7d51400d1eed2c3a431728f6622cce5a054b"
  end

  def install
    system "swift", "build", "--package-path", "apple", "--disable-sandbox",
           "--configuration", "release", "--product", "jpegai-info"
    bin.install "apple/.build/release/jpegai-info" => "jpeg-ai"
    resource("models").stage do
      (share/"jpeg-ai").install "Tables", "Models", "LICENSE", "THIRD_PARTY_NOTICES.md"
    end
  end

  def caveats
    <<~EOS
      This is an experimental untiled 4:4:4 simple-profile implementation,
      not a claim of complete JPEG AI conformance.
    EOS
  end

  test do
    assert_match "jpeg-ai #{version}", shell_output("#{bin}/jpeg-ai --version")
    assert_match "jpeg-ai encode", shell_output("#{bin}/jpeg-ai --help")
  end
end
