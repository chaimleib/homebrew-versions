class Sphinx208 < Formula
  desc "Full-text search engine server"
  homepage "http://www.sphinxsearch.com"
  url "http://sphinxsearch.com/files/sphinx-2.0.8-release.tar.gz"
  sha256 "bd699bf34635558e4d9d4d8bdcf5fcdd9c2e8f6c614824bec793b0010fa6cda3"

  option "with-mysql", "Force compiling against MySQL"
  option "with-postgresql", "Force compiling against PostgreSQL"

  depends_on :mysql => :optional
  depends_on :postgresql => :optional

  conflicts_with "sphinx", :because => "differing version of same formula"

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --localstatedir=#{var}]

    args << "--#{build.with?("mysql") ? "with" : "without"}-mysql"
    args << "--#{build.with?("postgresql") ? "with" : "without"}-pgsql"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Sphinx depends on either MySQL or PostreSQL as a datasource.

    You can install these with Homebrew with:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install postgresql
        For PostgreSQL server.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/searchd -h")
  end
end
