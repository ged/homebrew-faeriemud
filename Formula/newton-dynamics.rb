class NewtonDynamics < Formula
	desc "A cross-platform life-like physics simulation library"
	homepage "http://newtondynamics.com/"
	url "https://github.com/MADEAPPS/newton-dynamics/archive/newton-3.14.tar.gz"
	sha256 "ccbd13512fdb4ac6adf2a12cb035dd866a2ec93f6fc35feba58531ad883dbdeb"

	depends_on "cmake" => :build
	depends_on "tinyxml"

	def install
		ENV.deparallelize

		system "cmake", ".", "-DNEWTON_DEMOS_SANDBOX=0", *std_cmake_args
		system "make", "install"
	end

end
