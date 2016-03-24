From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [RFC v1 13/17] selftest/seccomp: Rename TRACE_poke to TRACE_poke_sys_read
Date: Thu, 24 Mar 2016 03:53:58 +0100
Message-ID: <1458788042-26173-5-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458788042-26173-1-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Cosmetic rename for future name derivatives.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
index 49c5d39c30a4..7c48d4cf476a 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1138,14 +1138,14 @@ void tracer_poke(struct __test_metadata *_metad=
ata, pid_t tracee, int status,
 	EXPECT_EQ(0, ret);
 }
=20
-FIXTURE_DATA(TRACE_poke) {
+FIXTURE_DATA(TRACE_poke_sys_read) {
 	struct sock_fprog prog;
 	pid_t tracer;
 	long poked;
 	struct tracer_args_poke_t tracer_args;
 };
=20
-FIXTURE_SETUP(TRACE_poke)
+FIXTURE_SETUP(TRACE_poke_sys_read)
 {
 	struct sock_filter filter[] =3D {
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
@@ -1170,14 +1170,14 @@ FIXTURE_SETUP(TRACE_poke)
 					   &self->tracer_args);
 }
=20
-FIXTURE_TEARDOWN(TRACE_poke)
+FIXTURE_TEARDOWN(TRACE_poke_sys_read)
 {
 	teardown_trace_fixture(_metadata, self->tracer);
 	if (self->prog.filter)
 		free(self->prog.filter);
 }
=20
-TEST_F(TRACE_poke, read_has_side_effects)
+TEST_F(TRACE_poke_sys_read, read_has_side_effects)
 {
 	ssize_t ret;
=20
@@ -1193,7 +1193,7 @@ TEST_F(TRACE_poke, read_has_side_effects)
 	EXPECT_EQ(0x1001, self->poked);
 }
=20
-TEST_F(TRACE_poke, getpid_runs_normally)
+TEST_F(TRACE_poke_sys_read, getpid_runs_normally)
 {
 	long ret;
=20
--=20
2.8.0.rc3
