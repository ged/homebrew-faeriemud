class NewtonDynamics < Formula
	desc "A cross-platform life-like physics simulation library"
	homepage "http://newtondynamics.com/"
	url "https://github.com/MADEAPPS/newton-dynamics/archive/newton-3.14.tar.gz"
	sha256 ""

	# Configure uses cmake internally
	depends_on "cmake" => :build

	def install
		ENV.deparallelize

		system "cmake", ".", "-DNEWTON_DEMOS_SANDBOX=0", *std_cmake_args
		system "make", "install"
	end

end
