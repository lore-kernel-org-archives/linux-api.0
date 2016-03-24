From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 17/17] selftest/seccomp: Add argeval_toctou_filesystem test
Date: Thu, 24 Mar 2016 03:54:02 +0100
Message-ID: <1458788042-26173-9-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2847-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Detect a TOCTOU race condition attack on the filesystem by renaming a
file after the seccomp filter evaluation but before the effective
syscall.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 180 +++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 64b4d758b007..1558e0079fe9 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -10,6 +10,7 @@
 #define __have_sigval_t 1
 #define __have_sigevent_t 1
 
+#define _GNU_SOURCE
 #include <errno.h>
 #include <linux/filter.h>
 #include <sys/prctl.h>
@@ -32,8 +33,6 @@
 #include <sys/fcntl.h>
 #include <sys/mman.h>
 #include <sys/times.h>
-
-#define _GNU_SOURCE
 #include <unistd.h>
 #include <sys/syscall.h>
 
@@ -2520,6 +2519,183 @@ TEST_F(TRACE_poke_arg_path, argeval_toctou_argument)
 	EXPECT_EQ(E2BIG, errno);
 	close(fd);
 }
+
+char *new_file(struct __test_metadata *_metadata, const char *name, char buf)
+{
+	int ret, fd, path_len;
+	char *path;
+	const char tmpl[] = "/tmp/seccomp-test_%s.XXXXXX";
+
+	path_len = sizeof(tmpl) - 2 + strlen(name);
+	path = malloc(path_len);
+	ASSERT_NE(path, NULL);
+	ret = snprintf(path, path_len, tmpl, name);
+	ASSERT_EQ(ret, path_len - 1);
+	fd = mkostemp(path, O_CLOEXEC);
+	ASSERT_NE(fd, -1);
+	ret = write(fd, &buf, sizeof(buf));
+	ASSERT_EQ(ret, sizeof(buf));
+	close(fd);
+	return path;
+}
+
+struct tracer_args_files {
+	char *path_orig, *path_hijack, *path_swap;
+};
+
+/* Move a file after the filter evaluation but before the effective syscall. */
+void tracer_swap_file(struct __test_metadata *_metadata, pid_t tracee,
+		int status, void *args)
+{
+	int ret;
+	unsigned long msg;
+	struct tracer_args_files *info = (struct tracer_args_files *)args;
+
+	ret = ptrace(PTRACE_GETEVENTMSG, tracee, NULL, &msg);
+	EXPECT_EQ(0, ret);
+	/* If this fails, don't try to recover. */
+	ASSERT_EQ(0x1002, msg) {
+		kill(tracee, SIGKILL);
+	}
+	/* Let's start the bonneteau! */
+	ret = rename(info->path_orig, info->path_swap);
+	EXPECT_EQ(0, ret);
+	ret = rename(info->path_hijack, info->path_orig);
+	EXPECT_EQ(0, ret);
+	ret = rename(info->path_swap, info->path_hijack);
+	EXPECT_EQ(0, ret);
+}
+
+FIXTURE_DATA(TRACE_swap_file) {
+	struct sock_fprog prog;
+	pid_t tracer;
+	struct tracer_args_files tracer_args;
+	char *path_orig, *path_hijack, *path_swap;
+};
+
+FIXTURE_SETUP(TRACE_swap_file)
+{
+	int fd;
+	unsigned long orig_delta, orig_size, hijack_delta, hijack_size;
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_open, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1002),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter = malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
+
+	/* Create all the files */
+	self->path_orig = new_file(_metadata, "orig", 'O');
+	self->tracer_args.path_orig = self->path_orig;
+	self->path_hijack = new_file(_metadata, "hijack", 'H');
+	self->tracer_args.path_hijack = self->path_hijack;
+	self->path_swap = new_file(_metadata, "swap", 'S');
+	self->tracer_args.path_swap = self->path_swap;
+
+	/* Remove the temporary swap file */
+	unlink(self->path_swap);
+
+	/* Launch tracer */
+	self->tracer = setup_trace_fixture(_metadata, tracer_swap_file,
+					   &self->tracer_args);
+}
+
+FIXTURE_TEARDOWN(TRACE_swap_file)
+{
+	teardown_trace_fixture(_metadata, self->tracer);
+	if (self->prog.filter)
+		free(self->prog.filter);
+	if (self->path_orig) {
+		unlink(self->path_orig);
+		free(self->path_orig);
+	}
+	if (self->path_hijack) {
+		unlink(self->path_hijack);
+		free(self->path_hijack);
+	}
+	if (self->path_swap) {
+		unlink(self->path_swap);
+		free(self->path_swap);
+	}
+}
+
+TEST_F(TRACE_swap_file, argeval_toctou_filesystem)
+{
+	int fd;
+	char buf;
+	ssize_t len;
+
+	/* Validate the first test file */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_orig);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_orig);
+	}
+	EXPECT_EQ('O', buf) {
+		TH_LOG("Got unexpected value from %s", self->path_orig);
+	}
+	close(fd);
+
+	/* Validate the second test file */
+	fd = open(self->path_hijack, O_RDONLY);
+	EXPECT_NE(-1, fd) {
+		TH_LOG("Failed to open %s", self->path_hijack);
+	}
+	len = read(fd, &buf, sizeof(buf));
+	EXPECT_EQ(1, len) {
+		TH_LOG("Failed to read from %s", self->path_hijack);
+	}
+	EXPECT_EQ('H', buf) {
+		TH_LOG("Got unexpected value from %s", self->path_hijack);
+	}
+	close(fd);
+
+	apply_sandbox0(_metadata, self->path_orig);
+
+	/* Setup the hijack for every open */
+	EXPECT_EQ(0, seccomp(SECCOMP_SET_MODE_FILTER,
+				SECCOMP_FILTER_FLAG_TSYNC, &self->prog)) {
+		TH_LOG("Failed to install filter!");
+	}
+
+	/* Hijacked file */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_hijack);
+	}
+	EXPECT_EQ(EPERM, errno);
+	close(fd);
+
+	/* Denied file */
+	fd = open(self->path_orig, O_RDONLY);
+	EXPECT_EQ(-1, fd) {
+		TH_LOG("Could open %s", self->path_hijack);
+	}
+	EXPECT_EQ(E2BIG, errno);
+	close(fd);
+}
+
+/*
+ * TODO: tests to add
+ * - symlink following
+ * - dentry/inode/device/mount checkers
+ * - PATH_BENEATH
+ * - object creation with nonexistent file
+ * - validate that ptrace's SETREGS is still working on a process using seccomp-objects
+ * - TOCTOU with a hard link (should pass)
+ * - limits
+ */
+
 #endif /* SECCOMP_DATA_ARGEVAL_PRESENT */
 
 /*
-- 
2.8.0.rc3
