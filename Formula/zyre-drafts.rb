class ZyreDrafts < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/releases/download/v2.0.1/zyre-2.0.1.tar.gz"
  sha256 "0ba43fcdf70fa1f35b068843a90fdf50b34d65a9be7f2c193924a87a4031a98c"
  license "MPL-2.0"

  head do
    url "https://github.com/zeromq/zyre.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-drafts", "Disable draft classes and methods"

  depends_on "pkg-config" => :build
  depends_on "czmq-drafts"
  depends_on "zeromq-drafts"

  conflicts_with "zyre", because: "it doesn't allow enabling of drafts"

  def install
    args = ["--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"]

    args << "--enable-drafts" if build.with? "drafts"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    # system "make", "check-verbose"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zyre.h>

      int main()
      {
        uint64_t version = zyre_version ();
        assert(version >= 2);

        zyre_test(true);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lzyre", "-o", "test"
    system "./test"
  end
end
