From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH selftests 3/6] selftests: kprobe: Choose an always-defined
 function to probe
Date: Sat, 31 Oct 2015 23:37:31 +0000
Message-ID: <1446334651.2595.16.camel@decadent.org.uk>
References: <1446334510.2595.13.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-COCj6Mp3uDebZ19RE73T"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446334510.2595.13.camel-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-COCj6Mp3uDebZ19RE73T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

do_fork() is no longer defined on x86, so probe _do_fork() instead.

Fixes: 3033f14ab78c ("clone: support passing tls argument via C ...")
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
=C2=A0.../selftests/ftrace/test.d/kprobe/add_and_remove.tc=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
=C2=A0tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc |=C2=A0=C2=
=A02 +-
=C2=A0.../testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc=C2=A0=C2=A0=
|=C2=A0=C2=A02 +-
=C2=A0.../selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 14 +++++++-------
=C2=A0.../selftests/ftrace/test.d/kprobe/kretprobe_args.tc=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
=C2=A05 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc=
 b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
index a5a4262..c3843ed 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/add_and_remove.tc
@@ -5,7 +5,7 @@
=C2=A0
=C2=A0echo 0 > events/enable
=C2=A0echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
=C2=A0grep myevent kprobe_events
=C2=A0test -d events/kprobes/myevent
=C2=A0echo > kprobe_events
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc b/t=
ools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
index d8c7bb6..74507db 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/busy_check.tc
@@ -5,7 +5,7 @@
=C2=A0
=C2=A0echo 0 > events/enable
=C2=A0echo > kprobe_events
-echo p:myevent do_fork > kprobe_events
+echo p:myevent _do_fork > kprobe_events
=C2=A0test -d events/kprobes/myevent
=C2=A0echo 1 > events/kprobes/myevent/enable
=C2=A0echo > kprobe_events && exit 1 # this must fail
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc b/=
tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
index c45ee27..64949d4 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args.tc
@@ -5,7 +5,7 @@
=C2=A0
=C2=A0echo 0 > events/enable
=C2=A0echo > kprobe_events
-echo 'p:testprobe do_fork $stack $stack0 +0($stack)' > kprobe_events
+echo 'p:testprobe _do_fork $stack $stack0 +0($stack)' > kprobe_events
=C2=A0grep testprobe kprobe_events
=C2=A0test -d events/kprobes/testprobe
=C2=A0echo 1 > events/kprobes/testprobe/enable
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc =
b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
index ab41d2b..d6f2f49 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_ftrace.tc
@@ -6,31 +6,31 @@ grep function available_tracers || exit_unsupported # thi=
s is configurable
=C2=A0
=C2=A0# prepare
=C2=A0echo nop > current_tracer
-echo do_fork > set_ftrace_filter
+echo _do_fork > set_ftrace_filter
=C2=A0echo 0 > events/enable
=C2=A0echo > kprobe_events
-echo 'p:testprobe do_fork' > kprobe_events
+echo 'p:testprobe _do_fork' > kprobe_events
=C2=A0
=C2=A0# kprobe on / ftrace off
=C2=A0echo 1 > events/kprobes/testprobe/enable
=C2=A0echo > trace
=C2=A0( echo "forked")
=C2=A0grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=C2=A0
=C2=A0# kprobe on / ftrace on
=C2=A0echo function > current_tracer
=C2=A0echo > trace
=C2=A0( echo "forked")
=C2=A0grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=C2=A0
=C2=A0# kprobe off / ftrace on
=C2=A0echo 0 > events/kprobes/testprobe/enable
=C2=A0echo > trace
=C2=A0( echo "forked")
=C2=A0! grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=C2=A0
=C2=A0# kprobe on / ftrace on
=C2=A0echo 1 > events/kprobes/testprobe/enable
@@ -38,14 +38,14 @@ echo function > current_tracer
=C2=A0echo > trace
=C2=A0( echo "forked")
=C2=A0grep testprobe trace
-grep 'do_fork <-' trace
+grep '_do_fork <-' trace
=C2=A0
=C2=A0# kprobe on / ftrace off
=C2=A0echo nop > current_tracer
=C2=A0echo > trace
=C2=A0( echo "forked")
=C2=A0grep testprobe trace
-! grep 'do_fork <-' trace
+! grep '_do_fork <-' trace
=C2=A0
=C2=A0# cleanup
=C2=A0echo nop > current_tracer
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc=
 b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
index 3171798..0d09546 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_args.tc
@@ -5,7 +5,7 @@
=C2=A0
=C2=A0echo 0 > events/enable
=C2=A0echo > kprobe_events
-echo 'r:testprobe2 do_fork $retval' > kprobe_events
+echo 'r:testprobe2 _do_fork $retval' > kprobe_events
=C2=A0grep testprobe2 kprobe_events
=C2=A0test -d events/kprobes/testprobe2
=C2=A0echo 1 > events/kprobes/testprobe2/enable

--=20
Ben Hutchings
All extremists should be taken out and shot.
--=-COCj6Mp3uDebZ19RE73T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVjVQu+e/yOyVhhEJAQoA4w//VlVUCy9V4fx1rZNFUuRAmYrnpXL1jTJp
SVqHcMxGrsiS8+xA4iM7xvrMfhiVuWXE3Yryj+z6mQ3bZ7mZnEBIcwhYNlFrUGbW
sSQQ/1aVyE+BBzSbPtzptmlFRuTWZ8O+N6f4aWmrW3/gdqLQpAG0MzfoAlRO+tQ9
mxX0jki46EjONU6UOvA6Mq86xlIABQXAFD4b3N3802tvtfxssJ9sirQ3bDiy/RR3
wDGZ7aq16KChKKLoXY/PmVY8W8zsgSYqutMvB8fZCvEG+nnbMzvoRUWDXGiavjY7
ZJRYiO1WMyiuga7V4hb+pYKiD2mAO7OsEwOnfeyfFfOesaEyyxFuP9b0oLEgvLTh
LMWYUS6CzcZgkop6a4yt2M9hSdX7xGI0xf2fFbeqO1Ycq2H+4KyeDnmHRbf5E9tn
lciulHHzjeEBfODLhZ9FVSYzmLeC1OLpMGx5AH+qcH/uASRMB+tLrnCSU8H5HqBl
bj6+zfulCk1C1lR8wQmDkYMSVircGRn+rAWqJK+fjx2rE1ndRJKUuMeIUE4ygVFF
Ljl0nHWYwG56K1CPNznjMiqndLUjZsbemSkVWoqtTFo5lRttiyrL60Mu72hyNfCM
qiOT3xCJB2FtyJA9OF2JYM+5uGHFpECFE6JtktvjRyHz5wgdyF0rNT6BUpKrBfRr
TTZ07dQR0vg=
=ElEW
-----END PGP SIGNATURE-----

--=-COCj6Mp3uDebZ19RE73T--
