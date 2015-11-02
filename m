From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH v2 selftests 3/6] selftests: kprobe: Choose an always-defined
 function to probe
Date: Mon, 2 Nov 2015 12:22:07 +0000
Message-ID: <20151102122207.GD17015@decadent.org.uk>
References: <20151102122048.GA17015@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151102122048.GA17015-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

do_fork() is no longer defined on x86, so probe _do_fork() instead.

Fixes: 3033f14ab78c ("clone: support passing tls argument via C ...")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
 .../selftests/ftrace/test.d/kprobe/add_and_remove.tc       |  2 +-
 tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc |  2 +-
 .../testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc  |  2 +-
 .../selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc        | 14 +++++++---=
----
 .../selftests/ftrace/test.d/kprobe/kretprobe_args.tc       |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc=
 b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index a5a4262..c3843ed 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 grep myevent kprobe_events
 test -d events/kprobes/myevent
 echo > kprobe_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/t=
ools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index d8c7bb6..74507db 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
 test -d events/kprobes/myevent
 echo 1 > events/kprobes/myevent/enable
 echo > kprobe_events && exit 1 # this must fail
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/=
tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index c45ee27..64949d4 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
+echo 'p:testprobe _do_fork $stack $stack0 +0($stack)' > kprobe_events
 grep testprobe kprobe_events
 test -d events/kprobes/testprobe
 echo 1 > events/kprobes/testprobe/enable
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc =
b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
index ab41d2b..d6f2f49 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -6,31 +6,31 @@ grep function available_tracers || exit_unsupported # thi=
s is configurable
=20
 # prepare
 echo nop > current_tracer
-echo do_fork > set_ftrace_filter
+echo _do_fork > set_ftrace_filter
 echo 0 > events/enable
 echo > kprobe_events
-echo 'p:testprobe do_fork' > kprobe_events
+echo 'p:testprobe _do_fork' > kprobe_events
=20
 # kprobe on / ftrace off
 echo 1 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=20
 # kprobe on / ftrace on
 echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe off / ftrace on
 echo 0 > events/kprobes/testprobe/enable
 echo > trace
 ( echo "forked")
 ! grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe on / ftrace on
 echo 1 > events/kprobes/testprobe/enable
@@ -38,14 +38,14 @@ echo function > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=20
 # kprobe on / ftrace off
 echo nop > current_tracer
 echo > trace
 ( echo "forked")
 grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=20
 # cleanup
 echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc=
 b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 3171798..0d09546 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -5,7 +5,7 @@
=20
 echo 0 > events/enable
 echo > kprobe_events
-echo 'r:testprobe2 do_fork $retval' > kprobe_events
+echo 'r:testprobe2 _do_fork $retval' > kprobe_events
 grep testprobe2 kprobe_events
 test -d events/kprobes/testprobe2
 echo 1 > events/kprobes/testprobe2/enable


--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVjdVb+e/yOyVhhEJAQpPQhAAogTtWEuut5sleGwC4OnJ5WxpKJ1IhSrk
UZFUc9VBkkCw+wLTd8QYP7RBYMAG37YGYl1FkWQR5Y1n/uW1qZOIdabk9shMQ8Tj
Q2iDo+NMjjuRidFJV0I7JNVgnWfjN3mM1ouhJ4g2TgALP50YpR0CgYOdLluiygLg
zZR6IFAz61i2iMSDs8lkPCrM4kYOkqvaEUsbJbFy6Tf6+v9Jzjz8frst1ReNWRdD
3qNdLNUY+kmS2SIci7sH/24Acf47qs5lXkUJ1cR9j5iHeZWdlzUq7S6csq0yJUIU
FiJYJ+W6/j/MdbFsdKAot5xzg8XWgmVg3e8ax636SAZHmj61kReuFOUW8RtqyrWn
Eu9BoKrl49HMmbufN2vXtgDJmmojGu69BK4LJZYqYHfV3Gqy91b7fhXcDKAxZtaR
yuFmxRORleqb3iAkGQlr250t5tTi3kzg5oXJJfyZ3Uv5NEsK87OmNmMP54OYUkCT
p+OSnMLDwbomFCV3G5r+OwWU8lCBxb7PobVwB2pZKtdiW6DXGKvl3kiT8VZjrZ6F
ltCemfZU+j5GkHSBMohavwNygXJt/C0QXT1O7xc9BrWuBDvVD0SQp7yxVzNZWEV/
m708SrpZD+j5lSm3MNLS7EoZGD0WErVWrM7HdFER5zBQw5rLgYBUcVEoKw3lhq7d
YO3zg8cYAec=
=pXpO
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
