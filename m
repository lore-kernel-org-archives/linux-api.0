From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] tools/testing: add a test to check nsfs ioctl-s
Date: Fri, 26 Aug 2016 16:08:11 -0700
Message-ID: <1472252891-4963-5-git-send-email-avagin@openvz.org>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1472252891-4963-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

There are two new ioctl-s:
One ioctl for the user namespace that owns a file descriptor.
One ioctl for the parent namespace of a namespace file descriptor.

The test checks that these ioctl-s works and that they handle a case
when a target namespace is outside of the current process namespace.

Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/Makefile      |  1 +
 tools/testing/selftests/nsfs/Makefile | 12 +++++
 tools/testing/selftests/nsfs/owner.c  | 91 +++++++++++++++++++++++++++++++++++
 tools/testing/selftests/nsfs/pidns.c  | 78 ++++++++++++++++++++++++++++++
 4 files changed, 182 insertions(+)
 create mode 100644 tools/testing/selftests/nsfs/Makefile
 create mode 100644 tools/testing/selftests/nsfs/owner.c
 create mode 100644 tools/testing/selftests/nsfs/pidns.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index ff9e5f2..f770dba 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += memory-hotplug
 TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
+TARGETS += nsfs
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
diff --git a/tools/testing/selftests/nsfs/Makefile b/tools/testing/selftests/nsfs/Makefile
new file mode 100644
index 0000000..2306054
--- /dev/null
+++ b/tools/testing/selftests/nsfs/Makefile
@@ -0,0 +1,12 @@
+TEST_PROGS := owner pidns
+
+CFLAGS := -Wall -Werror
+
+all: owner pidns
+owner: owner.c
+pidns: pidns.c
+
+clean:
+	$(RM) owner pidns
+
+include ../lib.mk
diff --git a/tools/testing/selftests/nsfs/owner.c b/tools/testing/selftests/nsfs/owner.c
new file mode 100644
index 0000000..437205f
--- /dev/null
+++ b/tools/testing/selftests/nsfs/owner.c
@@ -0,0 +1,91 @@
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#define NSIO    0xb7
+#define NS_GET_USERNS   _IO(NSIO, 0x1)
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+int main(int argc, char *argvp[])
+{
+	int pfd[2], ns, uns, init_uns;
+	struct stat st1, st2;
+	char path[128];
+	pid_t pid;
+	char c;
+
+	if (pipe(pfd))
+		return 1;
+
+	pid = fork();
+	if (pid < 0)
+		return pr_err("fork");
+	if (pid == 0) {
+		prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (unshare(CLONE_NEWUTS | CLONE_NEWUSER))
+			return pr_err("unshare");
+		close(pfd[0]);
+		close(pfd[1]);
+		while (1)
+			sleep(1);
+		return 0;
+	}
+	close(pfd[1]);
+	if (read(pfd[0], &c, 1) != 0)
+		return pr_err("Unable to read from pipe");
+	close(pfd[0]);
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/uts", pid);
+	ns = open(path, O_RDONLY);
+	if (ns < 0)
+		return pr_err("Unable to open %s", path);
+
+	uns = ioctl(ns, NS_GET_USERNS);
+	if (uns < 0)
+		return pr_err("Unable to get an owning user namespace");
+
+	if (fstat(uns, &st1))
+		return pr_err("fstat");
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", pid);
+	if (stat(path, &st2))
+		return pr_err("stat");
+
+	if (st1.st_ino != st2.st_ino)
+		return pr_err("NS_GET_USERNS returned a wrong namespace");
+
+	init_uns = ioctl(uns, NS_GET_USERNS);
+	if (uns < 0)
+		return pr_err("Unable to get an owning user namespace");
+
+	if (ioctl(init_uns, NS_GET_USERNS) >= 0 || errno != EPERM)
+		return pr_err("Don't get EPERM");
+
+	if (unshare(CLONE_NEWUSER))
+		return pr_err("unshare");
+
+	if (ioctl(ns, NS_GET_USERNS) >= 0 || errno != EPERM)
+		return pr_err("Don't get EPERM");
+	if (ioctl(init_uns, NS_GET_USERNS) >= 0 || errno != EPERM)
+		return pr_err("Don't get EPERM");
+
+	kill(pid, SIGKILL);
+	wait(NULL);
+	return 0;
+}
diff --git a/tools/testing/selftests/nsfs/pidns.c b/tools/testing/selftests/nsfs/pidns.c
new file mode 100644
index 0000000..ae3a0d6
--- /dev/null
+++ b/tools/testing/selftests/nsfs/pidns.c
@@ -0,0 +1,78 @@
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+#define NSIO	0xb7
+#define NS_GET_USERNS   _IO(NSIO, 0x1)
+#define NS_GET_PARENT   _IO(NSIO, 0x2)
+
+#define __stack_aligned__	__attribute__((aligned(16)))
+struct cr_clone_arg {
+	char stack[128] __stack_aligned__;
+	char stack_ptr[0];
+};
+
+static int child(void *args)
+{
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	while (1)
+		sleep(1);
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	char *ns_strs[] = {"pid", "user"};
+	char path[] = "/proc/0123456789/ns/pid";
+	struct cr_clone_arg ca;
+	struct stat st1, st2;
+	int ns, pns, i;
+	pid_t pid;
+
+	pid = clone(child, ca.stack_ptr, CLONE_NEWUSER | CLONE_NEWPID | SIGCHLD, NULL);
+	if (pid < 0)
+		return pr_err("clone");
+
+	for (i = 0; i < 2; i++) {
+		snprintf(path, sizeof(path), "/proc/%d/ns/%s", pid, ns_strs[i]);
+		ns = open(path, O_RDONLY);
+		if (ns < 0)
+			return pr_err("Unable to open %s", path);
+
+		pns = ioctl(ns, NS_GET_PARENT);
+		if (pns < 0)
+			return pr_err("Unable to get a parent pidns");
+
+		snprintf(path, sizeof(path), "/proc/self/ns/%s", ns_strs[i]);
+		if (stat(path, &st2))
+			return pr_err("Unable to stat %s", path);
+		if (fstat(pns, &st1))
+			return pr_err("Unable to stat the parent pidns");
+		if (st1.st_ino != st2.st_ino)
+			return pr_err("NS_GET_PARENT returned a wrong namespace");
+
+		if (ioctl(pns, NS_GET_PARENT) >= 0 || errno != EPERM)
+			return pr_err("Don't get EPERM");;
+	}
+
+	kill(pid, SIGKILL);
+	wait(NULL);
+	return 0;
+}
-- 
2.5.5
