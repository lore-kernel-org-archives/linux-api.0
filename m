From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 0/6] Fix some broken tests
Date: Mon, 2 Nov 2015 12:20:48 +0000
Message-ID: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This series fixes some self-tests that are broken, unreliable or
produce compiler warnings in 4.3.

Ben.

Ben Hutchings (6):
  selftests: Add missing #include directives
  selftests: memfd: Stop unnecessary rebuilds
  selftests: kprobe: Choose an always-defined function to probe
  selftests: Make scripts executable
  selftests: vm: Try harder to allocate huge pages
  selftests: breakpoint: Actually build it

 tools/testing/selftests/breakpoints/Makefile              |  2 +-
 .../selftests/ftrace/test.d/kprobe/add_and_remove.tc      |  2 +-
 .../testing/selftests/ftrace/test.d/kprobe/busy_check.tc  |  2 +-
 .../testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc       | 14 +++++++-------
 .../selftests/ftrace/test.d/kprobe/kretprobe_args.tc      |  2 +-
 tools/testing/selftests/memfd/Makefile                    | 12 ++++++------
 tools/testing/selftests/memfd/memfd_test.c                |  1 +
 tools/testing/selftests/memfd/run_fuse_test.sh            |  0
 tools/testing/selftests/mqueue/mq_open_tests.c            |  1 +
 tools/testing/selftests/mqueue/mq_perf_tests.c            |  1 +
 tools/testing/selftests/static_keys/test_static_keys.sh   |  0
 tools/testing/selftests/timers/nanosleep.c                |  1 +
 tools/testing/selftests/vm/run_vmtests                    | 15 ++++++++++++++-
 14 files changed, 36 insertions(+), 19 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/memfd/run_fuse_test.sh
 mode change 100644 => 100755 tools/testing/selftests/static_keys/test_static_keys.sh


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVIOe/yOyVhhEJAQpCqQ/9F/ttBUnkhvQJJJv/fKtdi94hX63Z3hg7
hunPFuZCkIhhTvATl2N41NAUF111VWK76XnfCFuP1JocR7SHMNuwJfwm1r1PWYVg
X08UL9THcoTmZh0rDHIVrf/jQ0ACcHHfuMocdFPVbIZuo2ct0T7Z+rS+CyH7FDTC
uPzloI9e9mtxxV0zQWDgUuumoUZS/m0xCPCyemykGcrNUt8wWxfvgT7fvTaFcQPL
BdlCMJourkRTnrKhb+yctYNrPduJl6kdFfOo2fOJbAZkljwhJHdcnrKbaCUAXUId
FereonBDMvQ8QaHtQx0AAe2TmmT6M9IaLJfz/qGEU9xusVu3D5h1VVnIvoTNvFt3
LIUwdFcq53hf0Ird6B+IXbHrmcxD0UmmnD+DxW8Sv6wbQn8wiakwsSGon+0AXXzr
WZzsajy3aG4z2M0Dy/4sR9yL69lAsunegev4TjjNncvWFkd7p8Oyx2h5BZ9lw5C4
ciPYhJJaoKONsZRoWbCn2Axxq/Dz76i8Kb5JvBTtVCJ0MuCECE/MXsRVi8vNYb0P
OEji/YTI/Tx2rNALLQ3Yz2d88IvkartSps4v70S8CE1nvkjm4yQJ/IpkDwv8GGvF
2OI1aQpnTZ1EnENNoWOBJuB1iEWmiePv68o3CAO15J14GvKgpAvz8NYSLHdQ/xWj
/R9f62p/WnQ=
=8CSU
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
