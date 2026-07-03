class CzmqDrafts < Formula
  desc "High-level C binding for ZeroMQ (with drafts option)"
  homepage "http://czmq.zeromq.org/"
  url "https://github.com/zeromq/czmq/releases/download/v4.2.1/czmq-4.2.1.tar.gz"
  sha256 "5d720a204c2a58645d6f7643af15d563a712dad98c9d32c1ed913377daa6ac39"

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-drafts", "Disable draft classes and methods"
  option "with-lz4", "Build with lz4 compression support"
  option "with-curl", "Build with libcurl (ZHTTP client) support"
  option "with-libmicrohttpd", "Build with libmicrohttpd (ZHTTP server) support"

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  depends_on "zeromq-drafts"
  depends_on "curl" => :optional
  depends_on "libmicrohttpd" => :optional
  depends_on "lz4" => :optional

  conflicts_with "czmq", because: "it's the same library, but this version has more options"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    args << "--enable-drafts" if build.with? "drafts"
    args << "--enable-liblz4" if build.with? "lz4"
    args << "--enable-libcurl" if build.with? "curl"
    args << "--enable-libmicrohttpd" if build.with? "libmicrohttpd"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    # system "make", "ZSYS_INTERFACE=lo0", "check-verbose"
    system "make", "install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <czmq.h>

      int main(void)
      {
        zsock_t *push = zsock_new_push("inproc://hello-world");
        zsock_t *pull = zsock_new_pull("inproc://hello-world");

        zstr_send(push, "Hello, World!");
        char *string = zstr_recv(pull);
        puts(string);
        zstr_free(&string);

        zsock_destroy(&pull);
        zsock_destroy(&push);

        return 0;
      }
    EOS

    flags = ENV.cflags.to_s.split + %W[
      -I#{include}
      -L#{lib}
      -lczmq
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    assert_equal "Hello, World!\n", shell_output("./test")
  end
end
