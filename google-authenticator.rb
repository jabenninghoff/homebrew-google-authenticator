class GoogleAuthenticator < Formula
  desc "PAM module for two-factor authentication"
  homepage "https://github.com/google/google-authenticator"
  head "https://github.com/google/google-authenticator.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "qrencode" => :recommended

  fails_with :clang do
    build 700
    cause <<-EOS.undent
      clang version 7 fails to compile pam_google_authenticator.c as reported in:
      https://github.com/google/google-authenticator/issues/520
      https://github.com/google/google-authenticator/issues/527
      with: "clang: error: unable to execute command: Segmentation fault: 11"
      EOS
  end

  def install
    cd "libpam" do
      # fix error in filename submitted in pull request:
      # https://github.com/google/google-authenticator/pull/513
      inreplace "google-authenticator.c", "libqrencode.dylib.3", "libqrencode.3.dylib"

      system "./bootstrap.sh"

      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"

      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    Add 2-factor authentication for ssh:
      echo "auth required /usr/local/lib/security/pam_google_authenticator.so" \\
      | sudo tee -a /etc/pam.d/sshd

    Add 2-factor authentication for ssh allowing users to log in without OTP:
      echo "auth required /usr/local/lib/security/pam_google_authenticator.so" \\
      "nullok" | sudo tee -a /etc/pam.d/sshd

    (Or just manually edit /etc/pam.d/sshd)

    Users can set up Google Authenticator interactively using:
      google-authenticator

    Users can set up Google Authenticator with default settings using:
      google-authenticator --force --time-based --disallow-reuse --rate-limit=3 \\
      --rate-time=30 --window-size=3
    EOS
  end

  test do
    system "google-authenticator", "--help"
  end
end
