From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [RFC v1 15/17] selftest/seccomp: Add argeval_toctou_argument test
Date: Thu, 24 Mar 2016 03:54:00 +0100
Message-ID: <1458788042-26173-7-git-send-email-mic@digikod.net>
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

Test if a time-of-check-time-of-use (TOCTOU) race condition attack is
effective to change a syscall argument after the seccomp filter
evaluation but before the effective syscall.

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 157 ++++++++++++++++++=
++++++++
 1 file changed, 157 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
index f3a6ef4fce62..64b4d758b007 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -2363,6 +2363,163 @@ TEST(argeval_open_whitelist)
 	EXPECT_EQ(E2BIG, errno);
 	close(fd);
 }
+
+FIXTURE_DATA(TRACE_poke_arg_path) {
+	struct sock_fprog prog;
+	pid_t tracer;
+	struct tracer_args_poke_t tracer_args;
+	char *path_orig;
+	char *path_hijack;
+};
+
+FIXTURE_SETUP(TRACE_poke_arg_path)
+{
+	unsigned long orig_delta, orig_size, hijack_delta, hijack_size;
+	struct sock_filter filter[] =3D {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_open, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1001),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter =3D malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len =3D (unsigned short)ARRAY_SIZE(filter);
+
+	/* @path_orig must be writable */
+	orig_delta =3D sizeof(PATH_DEV_ZERO) % sizeof(long);
+	orig_size =3D sizeof(PATH_DEV_ZERO) - orig_delta +
+		(orig_delta ? sizeof(long) : 0);
+	self->path_orig =3D malloc(orig_size);
+	ASSERT_NE(NULL, self->path_orig);
+	memset(self->path_orig, 0, orig_size);
+	memcpy(self->path_orig, PATH_DEV_ZERO, sizeof(PATH_DEV_ZERO));
+	self->tracer_args.poke_addr =3D (unsigned long *)self->path_orig;
+
+	hijack_delta =3D sizeof(PATH_DEV_NULL) % sizeof(long);
+	hijack_size =3D sizeof(PATH_DEV_NULL) - hijack_delta +
+		(hijack_delta ? sizeof(long) : 0);
+	/* @path_hijack must be able to override @path_orig */
+	ASSERT_GE(orig_size, hijack_size);
+	self->path_hijack =3D malloc(hijack_size);
+	ASSERT_NE(NULL, self->path_hijack);
+	memset(self->path_hijack, 0, hijack_size);
+	memcpy(self->path_hijack, PATH_DEV_NULL, sizeof(PATH_DEV_NULL));
+	self->tracer_args.poke_data =3D (unsigned long *)self->path_hijack;
+	self->tracer_args.poke_len =3D hijack_size;
+
+	/* Launch tracer */
+	self->tracer =3D setup_trace_fixture(_metadata, tracer_poke,
+					   &self->tracer_args);
+}
+
+FIXTURE_TEARDOWN(TRACE_poke_arg_path)
+{
+	teardown_trace_fixture(_metadata, self->tracer);
+	if (self->prog.filter)
+		free(self->prog.filter);
+	if (self->path_orig)
+		free(self->path_orig);
+}
+
+/* Any tracer process can bypass a seccomp filter, so we can't protect=
 against
+ * this threat and should deny any ptrace call from a seccomped proces=
s to be
+ * able to properly sandbox it.
+ *
+ * However, a seccomped process can fork and ask its child to change a=
 shared
+ * memory used to hold the syscall arguments. This can be used to trig=
ger
+ * TOCTOU race conditions between the filter evaluation and the effect=
ive
+ * syscall operations. For test purpose, it is simpler to ask a dedica=
ted
+ * tracer process to do the same action after the filter evaluation to=
 acheive
+ * the same result. The kernel must detect and block this race conditi=
on.
+ */
+TEST_F(TRACE_poke_arg_path, argeval_toctou_argument)
+{
+	int fd;
+	char buf;
+	ssize_t len;
+
+	/* Validate the first test file */
+	fd =3D open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len =3D read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Validate the second test file */
+	fd =3D open(self->path_hijack, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_hijack);
+	}
+	len =3D read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(0, len) {
+		TH_LOG("Able to read from %s", self->path_orig);
+	}
+	close(fd);
+
+	apply_sandbox0(_metadata, PATH_DEV_ZERO);
+
+	/* Allowed file: /dev/zero */
+	fd =3D open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len =3D read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Denied file: /dev/null */
+	fd =3D open(self->path_hijack, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_hijack);
+	}
+	close(fd);
+
+	/* Setup the hijack for every open: replace /dev/zero with /dev/null =
*/
+	EXPECT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER,
+				SECCOMP_FILTER_FLAG_TSYNC, &self->prog)) {
+		TH_LOG("Failed to install filter!");
+	}
+
+	/* Should read /dev/zero even if it is hijacked with /dev/null after
+	 * the filter
+	 */
+	fd =3D open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len =3D read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ(0, buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Now path_orig is definitely hijacked, so it must be denied */
+	fd =3D open(self->path_orig, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_orig);
+	}
+	EXPECT_EQ(E2BIG, errno);
+	close(fd);
+}
 #endif /* SECCOMP_DATA_ARGEVAL_PRESENT */
=20
 /*
--=20
2.8.0.rc3
