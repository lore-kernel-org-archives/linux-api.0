From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [RFC v1 14/17] selftest/seccomp: Make tracer_poke() more generic
Date: Thu, 24 Mar 2016 03:53:59 +0100
Message-ID: <1458788042-26173-6-git-send-email-mic@digikod.net>
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

Use a different flag test (0x2001) than the RET_TRACE value (0x1001) to
not be ambiguous.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 24 ++++++++++++++++++-=
-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
index 7c48d4cf476a..f3a6ef4fce62 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1113,14 +1113,16 @@ void teardown_trace_fixture(struct __test_metad=
ata *_metadata,
=20
 /* "poke" tracer arguments and function. */
 struct tracer_args_poke_t {
-	unsigned long poke_addr;
+	unsigned long *poke_addr;
+	unsigned long *poke_data;
+	unsigned long poke_len;
 };
=20
 void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int =
status,
 		 void *args)
 {
 	int ret;
-	unsigned long msg;
+	unsigned long msg, i;
 	struct tracer_args_poke_t *info =3D (struct tracer_args_poke_t *)args=
;
=20
 	ret =3D ptrace(PTRACE_GETEVENTMSG, tracee, NULL, &msg);
@@ -1134,8 +1136,14 @@ void tracer_poke(struct __test_metadata *_metada=
ta, pid_t tracee, int status,
 	 * Registers are not touched to try to keep this relatively arch
 	 * agnostic.
 	 */
-	ret =3D ptrace(PTRACE_POKEDATA, tracee, info->poke_addr, 0x1001);
-	EXPECT_EQ(0, ret);
+	for (i =3D 0; i < info->poke_len; i++) {
+		unsigned long addr =3D (unsigned long)info->poke_addr +
+			i * sizeof(long);
+
+		ret =3D ptrace(PTRACE_POKEDATA, tracee,
+				addr, *(info->poke_data + i));
+		EXPECT_EQ(0, ret);
+	}
 }
=20
 FIXTURE_DATA(TRACE_poke_sys_read) {
@@ -1143,6 +1151,7 @@ FIXTURE_DATA(TRACE_poke_sys_read) {
 	pid_t tracer;
 	long poked;
 	struct tracer_args_poke_t tracer_args;
+	unsigned long flag;
 };
=20
 FIXTURE_SETUP(TRACE_poke_sys_read)
@@ -1163,7 +1172,10 @@ FIXTURE_SETUP(TRACE_poke_sys_read)
 	self->prog.len =3D (unsigned short)ARRAY_SIZE(filter);
=20
 	/* Set up tracer args. */
-	self->tracer_args.poke_addr =3D (unsigned long)&self->poked;
+	self->tracer_args.poke_addr =3D &self->poked;
+	self->flag =3D 0x2001;
+	self->tracer_args.poke_data =3D &self->flag;
+	self->tracer_args.poke_len =3D 1;
=20
 	/* Launch tracer. */
 	self->tracer =3D setup_trace_fixture(_metadata, tracer_poke,
@@ -1190,7 +1202,7 @@ TEST_F(TRACE_poke_sys_read, read_has_side_effects=
)
 	EXPECT_EQ(0, self->poked);
 	ret =3D read(-1, NULL, 0);
 	EXPECT_EQ(-1, ret);
-	EXPECT_EQ(0x1001, self->poked);
+	EXPECT_EQ(0x2001, self->poked);
 }
=20
 TEST_F(TRACE_poke_sys_read, getpid_runs_normally)
--=20
2.8.0.rc3
