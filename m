Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59350430CC4;
	Thu, 16 Jul 2026 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213211; cv=pass; b=ZyQ5QZrLs30p7fMaxj/umrtw/SAnGohIuiSzlv79GlDigxYVTjGX3KXqJ1ZOpPiM0mTberW8krEbpIQypsp3GsqHSZjcLJVaX8MxM8e6vREDgadJ3eGwK0DRut6gqTcz34BM0qB2SRpkooDFS1Np4AYc+obm78AQnKn34jEnqgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213211; c=relaxed/simple;
	bh=UI1Qy/JA2kK14QjeKU9oyjJidZdErKypnL+v+IEyOjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoJ14vM2i5VkRG+TsLLzDItBlCRub27LZbIZ/sGBxiZJLsAL1BD86hdIdXXgBgCCICk21x38noKB5EIAuGRu17Ytdu61FqltTrO/L9hIEnBoCRxakIMZCSwK1VHJqvtsqHXKxR24qX3TgZ17L17qZl6JcEnVgbUvUnZVF+/Yrz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=GCqFz/k1; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="GCqFz/k1"
ARC-Seal: i=1; a=rsa-sha256; t=1784212562; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=m9YG5eJCcvhJgFWyYb8KfmJyOwnc7KaV4Gs0Vvqr+SsLMxT6yO1I4uJ86fMf50PdwodxcAIU14cQb8cHmHTiDzK+blO0XbW2aMpYUKhAQ5f8o6X228CKaRmXOx9E95VCWrcLHtWY9Kn5NwaAnBadXC3CB24EnmJauO3tIgndb6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212562; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zSJeaT+7wBp24aXgLwHlqrduB54OJcztxyAGclnCqd4=; 
	b=QZO7y5nwl/0uJB5VoXlxUHlT4Y+MINBhsOFK9DtFDd734UujVjYw+x/Wt/RGg1KMx9dWNNW/Srfv7gckEFQ9BNfsQB+dcQLbBj46SPdLz6/9gBGg1n0KzdhSUdcUodVDk5IbxKqhg68d687moBPfnjbHYrYuzDg49KXzzj9qlKc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212562;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=zSJeaT+7wBp24aXgLwHlqrduB54OJcztxyAGclnCqd4=;
	b=GCqFz/k1LtrBr6gkdsjiLtb+xHGRlkAz0Q74u2FfmkeSKFrmJedf4/y2RcVmApaW
	dvkrXc0CiqQwvMyqRtoYizrYu9GDb1d1A/Ezd7QGWC6GGKAM7xknl8BUfliJ9thFljl
	pYYzUp/a+Srx8E24IDTuq60CQSqU6HliD4xaZUr0=
Received: by mx.zohomail.com with SMTPS id 1784212559199923.6921112541716;
	Thu, 16 Jul 2026 07:35:59 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 23/24] selftests/pidfd: cover pidfd spawn builders
Date: Thu, 16 Jul 2026 22:31:49 +0800
Message-ID: <22b5717a38c7e96d2667d3c2453defcaf4692456.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Add comprehensive coverage for the pidfd spawn builder lifecycle and ABI.
Exercise taskless configuration, direct and staged executable paths,
one-shot execution, precise terminal errors, source-state inheritance,
and pidfs identity before and after task publication.

Cover ordered DUP2, CLOSE_RANGE, and FCHDIR actions, including validation,
same-fd FD_CLOEXEC semantics, child-only state, ordered effects, and
failures after publication. Verify run argument input-only behavior,
normal exec failure, status-127 children, and auto-reap metadata.

Use deterministic userfaultfd stalls and bounded monotonic waits to
exercise publication races, competing run claims, cancellation before
and after task creation, coredump suppression, and pre-uaccess claiming.

Verify ptrace, pidfd_getfd, procfs, source credential and PID namespace,
SCM_RIGHTS, RLIMIT_NPROC, and pids cgroup boundaries. Cover Landlock and
seccomp policy behavior, dedicated audit transactions, and compat pointer
containers.

The suite also checks pidfs reopen, bind-mount, xattr, and epoll behavior.
Keep feature-dependent cases skippable and request the required kselftest
configuration.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 tools/testing/selftests/landlock/audit.h      |    6 +-
 tools/testing/selftests/pidfd/.gitignore      |    9 +
 tools/testing/selftests/pidfd/Makefile        |   25 +-
 tools/testing/selftests/pidfd/config          |    6 +
 .../pidfd/pidfd_spawn_accounting_test.c       |  428 ++++++
 .../pidfd/pidfd_spawn_actions_test.c          |  474 +++++++
 .../selftests/pidfd/pidfd_spawn_audit_test.c  |  521 +++++++
 .../selftests/pidfd/pidfd_spawn_common.c      |  512 +++++++
 .../selftests/pidfd/pidfd_spawn_common.h      |   59 +
 .../selftests/pidfd/pidfd_spawn_compat.c      |  221 +++
 .../selftests/pidfd/pidfd_spawn_exec_test.c   |  301 ++++
 .../selftests/pidfd/pidfd_spawn_policy_test.c |  294 ++++
 .../selftests/pidfd/pidfd_spawn_race_test.c   |  923 ++++++++++++
 .../pidfd/pidfd_spawn_security_test.c         | 1242 +++++++++++++++++
 .../selftests/pidfd/pidfd_spawn_test.c        |  550 ++++++++
 15 files changed, 5568 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.h
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_compat.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
 create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_test.c

diff --git a/tools/testing/selftests/landlock/audit.h b/tools/testing/selftests/landlock/audit.h
index f45fdef35681a..9530b8aca6c9f 100644
--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -550,7 +550,8 @@ static int audit_init_filter_exe(struct audit_filter *filter, const char *path)
 	return 0;
 }
 
-static int audit_cleanup(int audit_fd, struct audit_filter *filter)
+static int __maybe_unused
+audit_cleanup(int audit_fd, struct audit_filter *filter)
 {
 	struct audit_filter new_filter;
 	int err = 0;
@@ -581,7 +582,8 @@ static int audit_cleanup(int audit_fd, struct audit_filter *filter)
 	return err;
 }
 
-static int audit_init_with_exe_filter(struct audit_filter *filter)
+static int __maybe_unused
+audit_init_with_exe_filter(struct audit_filter *filter)
 {
 	int fd, err;
 
diff --git a/tools/testing/selftests/pidfd/.gitignore b/tools/testing/selftests/pidfd/.gitignore
index 4cd8ec7fd349a..72acb3371fadc 100644
--- a/tools/testing/selftests/pidfd/.gitignore
+++ b/tools/testing/selftests/pidfd/.gitignore
@@ -13,3 +13,12 @@ pidfd_exec_helper
 pidfd_xattr_test
 pidfd_setattr_test
 pidfd_autoreap_test
+pidfd_spawn_test
+pidfd_spawn_actions_test
+pidfd_spawn_exec_test
+pidfd_spawn_race_test
+pidfd_spawn_security_test
+pidfd_spawn_accounting_test
+pidfd_spawn_policy_test
+pidfd_spawn_audit_test
+pidfd_spawn_compat
diff --git a/tools/testing/selftests/pidfd/Makefile b/tools/testing/selftests/pidfd/Makefile
index 4211f91e9af85..1d58f76261200 100644
--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,12 +1,35 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES) -pthread -Wall
 
+CAN_BUILD_I386 := $(shell ../x86/check_cc.sh "$(CC)" \
+	../x86/trivial_32bit_program.c -m32 -static)
+
+PIDFD_SPAWN_TESTS := pidfd_spawn_test pidfd_spawn_exec_test \
+	pidfd_spawn_actions_test pidfd_spawn_race_test \
+	pidfd_spawn_security_test pidfd_spawn_accounting_test \
+	pidfd_spawn_policy_test pidfd_spawn_audit_test
+
 TEST_GEN_PROGS := pidfd_test pidfd_fdinfo_test pidfd_open_test \
 	pidfd_poll_test pidfd_wait pidfd_getfd_test pidfd_setns_test \
 	pidfd_file_handle_test pidfd_bind_mount pidfd_info_test \
-	pidfd_xattr_test pidfd_setattr_test pidfd_autoreap_test
+	pidfd_xattr_test pidfd_setattr_test pidfd_autoreap_test \
+	$(PIDFD_SPAWN_TESTS)
+
+ifeq ($(CAN_BUILD_I386),1)
+TEST_GEN_PROGS += pidfd_spawn_compat
+endif
 
 TEST_GEN_PROGS_EXTENDED := pidfd_exec_helper
+LOCAL_HDRS += pidfd_spawn_common.h ../landlock/audit.h
 
 include ../lib.mk
 
+$(addprefix $(OUTPUT)/,$(PIDFD_SPAWN_TESTS)): \
+	pidfd_spawn_common.c pidfd_spawn_common.h
+
+ifeq ($(CAN_BUILD_I386),1)
+pidfd_spawn_compat: CFLAGS += -m32
+pidfd_spawn_compat: LDLIBS += -static
+$(OUTPUT)/pidfd_spawn_compat: CFLAGS += -m32
+$(OUTPUT)/pidfd_spawn_compat: LDLIBS += -static
+endif
diff --git a/tools/testing/selftests/pidfd/config b/tools/testing/selftests/pidfd/config
index cf7cc0ce02484..699d43aaa4093 100644
--- a/tools/testing/selftests/pidfd/config
+++ b/tools/testing/selftests/pidfd/config
@@ -5,4 +5,10 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_TIME_NS=y
 CONFIG_CGROUPS=y
+CONFIG_CGROUP_PIDS=y
 CONFIG_CHECKPOINT_RESTORE=y
+CONFIG_USERFAULTFD=y
+CONFIG_SECURITY_LANDLOCK=y
+CONFIG_SECCOMP=y
+CONFIG_SECCOMP_FILTER=y
+CONFIG_AUDIT=y
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
new file mode 100644
index 0000000000000..25fe493a34d44
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
@@ -0,0 +1,428 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+static int write_string_file(const char *path, const char *value)
+{
+	size_t len = strlen(value);
+	ssize_t ret;
+	int saved_errno;
+	int fd;
+
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = write(fd, value, len);
+	saved_errno = errno;
+	close(fd);
+	if (ret != (ssize_t)len) {
+		errno = ret < 0 ? saved_errno : EIO;
+		return -1;
+	}
+	return 0;
+}
+
+static int path_join(char **out, const char *dir, const char *name)
+{
+	if (asprintf(out, "%s/%s", dir, name) < 0) {
+		errno = ENOMEM;
+		return -1;
+	}
+	return 0;
+}
+
+static bool controller_list_has(const char *controllers, const char *name)
+{
+	size_t name_len = strlen(name);
+	const char *next = controllers;
+
+	while (next) {
+		const char *end = strchr(next, ',');
+		size_t len = end ? end - next : strlen(next);
+
+		if (len == name_len && !strncmp(next, name, len))
+			return true;
+		next = end ? end + 1 : NULL;
+	}
+	return false;
+}
+
+static int read_current_cgroup(char *buf, size_t size, bool *unified)
+{
+	char line[PATH_MAX];
+	FILE *file;
+
+	file = fopen("/proc/self/cgroup", "re");
+	if (!file)
+		return -1;
+	while (fgets(line, sizeof(line), file)) {
+		char *controllers;
+		char *path;
+		char *separator;
+
+		separator = strchr(line, ':');
+		if (!separator)
+			continue;
+		controllers = separator + 1;
+		separator = strchr(controllers, ':');
+		if (!separator)
+			continue;
+		*separator = '\0';
+		if (*controllers &&
+		    !controller_list_has(controllers, "pids"))
+			continue;
+		path = separator + 1;
+		path[strcspn(path, "\n")] = '\0';
+		if (strlen(path) >= size) {
+			fclose(file);
+			errno = ENAMETOOLONG;
+			return -1;
+		}
+		strcpy(buf, path);
+		*unified = !*controllers;
+		fclose(file);
+		return 0;
+	}
+	fclose(file);
+	errno = ENOENT;
+	return -1;
+}
+
+static int current_cgroup_path(char **pathp)
+{
+	char current[PATH_MAX];
+	const char *root;
+	bool unified;
+	int ret;
+
+	ret = read_current_cgroup(current, sizeof(current), &unified);
+	if (ret)
+		return ret;
+	root = unified ? "/sys/fs/cgroup" : "/sys/fs/cgroup/pids";
+	if (!strcmp(current, "/"))
+		ret = asprintf(pathp, "%s", root);
+	else
+		ret = asprintf(pathp, "%s%s", root, current);
+	if (ret < 0) {
+		errno = ENOMEM;
+		return -1;
+	}
+	return 0;
+}
+
+static int enable_pids_controller(const char *cgroup)
+{
+	char *controllers = NULL;
+	char *control = NULL;
+	int ret;
+
+	ret = path_join(&controllers, cgroup, "cgroup.controllers");
+	if (ret)
+		return ret;
+	ret = access(controllers, F_OK);
+	free(controllers);
+	if (ret && errno == ENOENT)
+		return 0;
+	if (ret)
+		return ret;
+	ret = path_join(&control, cgroup, "cgroup.subtree_control");
+	if (ret)
+		return ret;
+	ret = write_string_file(control, "+pids");
+	free(control);
+	return ret;
+}
+
+static int set_cgroup_pids_max(const char *cgroup, const char *value)
+{
+	char *max = NULL;
+	int ret;
+
+	ret = path_join(&max, cgroup, "pids.max");
+	if (ret)
+		return ret;
+	ret = write_string_file(max, value);
+	free(max);
+	return ret;
+}
+
+static int enter_cgroup(const char *cgroup)
+{
+	char pid[32];
+	char *procs = NULL;
+	int ret;
+
+	ret = snprintf(pid, sizeof(pid), "%d", getpid());
+	if (ret < 0 || ret >= (int)sizeof(pid)) {
+		errno = EINVAL;
+		return -1;
+	}
+	ret = path_join(&procs, cgroup, "cgroup.procs");
+	if (ret)
+		return ret;
+	ret = write_string_file(procs, pid);
+	free(procs);
+	return ret;
+}
+
+static int make_limited_pids_cgroup_at(const char *base, char **parentp,
+				       char **leafp)
+{
+	char name[64];
+	char *parent = NULL;
+	char *leaf = NULL;
+	char *max = NULL;
+	bool parent_created = false;
+	bool leaf_created = false;
+	int ret;
+
+	/* The controller may already be enabled for children. */
+	enable_pids_controller(base);
+	snprintf(name, sizeof(name), "pidfd-spawn-pids-%d", getpid());
+	ret = path_join(&parent, base, name);
+	if (ret)
+		goto out;
+	if (mkdir(parent, 0755)) {
+		ret = -1;
+		goto out;
+	}
+	parent_created = true;
+	ret = path_join(&max, parent, "pids.max");
+	if (ret)
+		goto out;
+	ret = access(max, W_OK);
+	free(max);
+	max = NULL;
+	if (ret)
+		goto out;
+	ret = enable_pids_controller(parent);
+	if (ret)
+		goto out;
+	ret = path_join(&leaf, parent, "leaf");
+	if (ret)
+		goto out;
+	if (mkdir(leaf, 0755)) {
+		ret = -1;
+		goto out;
+	}
+	leaf_created = true;
+	ret = set_cgroup_pids_max(leaf, "1");
+	if (ret)
+		goto out;
+
+	*parentp = parent;
+	*leafp = leaf;
+	parent_created = false;
+	leaf_created = false;
+	parent = NULL;
+	leaf = NULL;
+out:
+	if (leaf_created)
+		rmdir(leaf);
+	if (parent_created)
+		rmdir(parent);
+	free(max);
+	free(leaf);
+	free(parent);
+	return ret;
+}
+
+static int make_limited_pids_cgroup(char **parentp, char **leafp)
+{
+	char *base = NULL;
+	int saved_errno;
+	int ret;
+
+	ret = current_cgroup_path(&base);
+	if (ret)
+		return ret;
+	ret = make_limited_pids_cgroup_at(base, parentp, leafp);
+	saved_errno = errno;
+	free(base);
+	if (!ret)
+		return 0;
+	ret = make_limited_pids_cgroup_at("/sys/fs/cgroup", parentp, leafp);
+	if (!ret)
+		return 0;
+	errno = saved_errno;
+	return -1;
+}
+
+static int pidfd_spawn_pids_worker(const char *cgroup, const char *path)
+{
+	char * const argv[] = { "pidfd_spawn_accounting_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	int failed_builder;
+	int builder;
+
+	if (enter_cgroup(cgroup))
+		return 1;
+	failed_builder = sys_pidfd_empty_open();
+	if (failed_builder < 0)
+		return 2;
+	errno = 0;
+	if (spawn_run_path(failed_builder, path, argv, NULL, 0) != -1 ||
+	    errno != EAGAIN)
+		return 3;
+	errno = 0;
+	if (spawn_run_path(failed_builder, path, argv, NULL, 0) != -1 ||
+	    errno != EBUSY)
+		return 4;
+	if (set_cgroup_pids_max(cgroup, "2"))
+		return 5;
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		return 6;
+	if (spawn_run_path(builder, path, argv, NULL, 0))
+		return 7;
+	if (wait_pidfd_exit(builder, 0))
+		return 8;
+	if (close(builder) || close(failed_builder))
+		return 9;
+	return 0;
+}
+
+#define PIDFD_SPAWN_UID_FIRST 60000
+#define PIDFD_SPAWN_UID_LAST 65000
+#define PIDFD_SPAWN_UID_BUSY 78
+
+static int pidfd_spawn_rlimit_worker(const char *path, uid_t uid)
+{
+	char * const argv[] = { "pidfd_spawn_accounting_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct rlimit limit = {
+		.rlim_cur = 1,
+		.rlim_max = 2,
+	};
+	int failed_builder;
+	int builder;
+
+	if (setrlimit(RLIMIT_NPROC, &limit))
+		return 1;
+	if (setgid(uid) || setuid(uid))
+		return 77;
+
+	failed_builder = sys_pidfd_empty_open();
+	if (failed_builder < 0)
+		return 2;
+	errno = 0;
+	if (spawn_run_path(failed_builder, path, argv, NULL, 0) != -1 ||
+	    errno != EAGAIN)
+		return 3;
+	errno = 0;
+	if (spawn_run_path(failed_builder, path, argv, NULL, 0) != -1 ||
+	    errno != EBUSY)
+		return 4;
+
+	limit.rlim_cur = 2;
+	if (setrlimit(RLIMIT_NPROC, &limit))
+		return 5;
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		return 6;
+	if (spawn_run_path(builder, path, argv, NULL, 0))
+		return errno == EAGAIN ? PIDFD_SPAWN_UID_BUSY : 7;
+	if (wait_pidfd_exit(builder, 0))
+		return 8;
+	if (close(builder) || close(failed_builder))
+		return 9;
+	return 0;
+}
+
+TEST(pidfd_spawn_charges_rlimit_nproc_at_run)
+{
+	const char *path = self_exe_path();
+	pid_t worker;
+	pid_t waited;
+	uid_t uid;
+	int status;
+
+	if (getuid())
+		SKIP(return, "test requires root to select an unused uid");
+	ASSERT_NE(path, NULL);
+	for (uid = PIDFD_SPAWN_UID_FIRST; uid < PIDFD_SPAWN_UID_LAST; uid++) {
+		worker = fork();
+		ASSERT_GE(worker, 0);
+		if (!worker)
+			_exit(pidfd_spawn_rlimit_worker(path, uid));
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		ASSERT_EQ(waited, worker);
+		ASSERT_TRUE(WIFEXITED(status));
+		if (WEXITSTATUS(status) == 77)
+			SKIP(return, "changing uid is unavailable");
+		if (WEXITSTATUS(status) == PIDFD_SPAWN_UID_BUSY)
+			continue;
+		ASSERT_EQ(WEXITSTATUS(status), 0);
+		return;
+	}
+	SKIP(return, "no unused uid available for RLIMIT_NPROC");
+}
+
+TEST(pidfd_spawn_charges_pids_cgroup_at_run)
+{
+	const char *path = self_exe_path();
+	char *parent = NULL;
+	char *leaf = NULL;
+	int cleanup_leaf;
+	int cleanup_parent;
+	int saved_errno;
+	pid_t worker;
+	pid_t waited;
+	int status;
+
+	ASSERT_NE(path, NULL);
+	if (make_limited_pids_cgroup(&parent, &leaf)) {
+		saved_errno = errno;
+		SKIP(return, "writable pids cgroup is unavailable: %s",
+		     strerror(saved_errno));
+	}
+
+	worker = fork();
+	if (worker < 0) {
+		cleanup_leaf = rmdir(leaf);
+		cleanup_parent = rmdir(parent);
+		free(leaf);
+		free(parent);
+		ASSERT_GE(worker, 0);
+		ASSERT_EQ(cleanup_leaf, 0);
+		ASSERT_EQ(cleanup_parent, 0);
+	}
+	if (!worker)
+		_exit(pidfd_spawn_pids_worker(leaf, path));
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	cleanup_leaf = rmdir(leaf);
+	cleanup_parent = rmdir(parent);
+	free(leaf);
+	free(parent);
+
+	ASSERT_EQ(cleanup_leaf, 0);
+	ASSERT_EQ(cleanup_parent, 0);
+	ASSERT_EQ(waited, worker);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
new file mode 100644
index 0000000000000..d44873280b6d2
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
@@ -0,0 +1,474 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/close_range.h>
+#include <linux/pidfd_spawn.h>
+#include <poll.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+static ssize_t read_exact_timeout(int fd, void *buf, size_t size)
+{
+	struct pollfd pfd = {
+		.fd = fd,
+		.events = POLLIN,
+	};
+	size_t offset = 0;
+
+	while (offset < size) {
+		ssize_t len;
+		int ret;
+
+		ret = poll(&pfd, 1, PIDFD_SPAWN_TIMEOUT_MS);
+		if (ret <= 0) {
+			if (!ret)
+				errno = ETIMEDOUT;
+			return -1;
+		}
+		if (pfd.revents & (POLLERR | POLLNVAL)) {
+			errno = EIO;
+			return -1;
+		}
+		len = read(fd, (char *)buf + offset, size - offset);
+		if (len < 0) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		}
+		if (!len) {
+			errno = EPIPE;
+			return -1;
+		}
+		offset += len;
+	}
+	return offset;
+}
+
+static int run_args_fail_taskless(struct pidfd_spawn_run_args *args,
+				  size_t size, int expected_errno)
+{
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	const char *path = self_exe_path();
+	int saved_errno;
+	int ret;
+	int fd;
+
+	if (!path)
+		return -1;
+	fd = sys_pidfd_empty_open();
+	if (fd < 0)
+		return -1;
+	errno = 0;
+	ret = sys_pidfd_spawn_run(fd, args, size);
+	saved_errno = errno;
+	if (ret != -1 || saved_errno != expected_errno)
+		goto fail;
+	errno = 0;
+	if (ioctl(fd, PIDFD_GET_INFO, &info) != -1 || errno != ESRCH)
+		goto fail;
+	errno = 0;
+	if (config_path(fd, path) != -1 || errno != EBUSY)
+		goto fail;
+	return close(fd);
+
+fail:
+	saved_errno = errno;
+	close(fd);
+	errno = saved_errno;
+	return -1;
+}
+
+TEST(pidfd_spawn_run_rejects_bad_actions)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+		.flags = 1,
+	};
+	struct pidfd_spawn_run_args args = {
+		.path = ptr_to_u64(path),
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+		.actions = ptr_to_u64(&action),
+		.nr_actions = 1,
+		.action_size = sizeof(action),
+	};
+
+	ASSERT_NE(path, NULL);
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+	action.flags = 0;
+	action.reserved[0] = 1;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+	action.reserved[0] = 0;
+	action.reserved[1] = 1;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+	action.reserved[1] = 0;
+	action.type = UINT32_MAX;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EOPNOTSUPP), 0);
+
+	action.type = PIDFD_SPAWN_ACTION_CLOSE_RANGE;
+	action.fd = 10;
+	action.newfd = 9;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+
+	action.type = PIDFD_SPAWN_ACTION_DUP2;
+	action.fd = STDOUT_FILENO;
+	action.newfd = STDOUT_FILENO;
+	args.action_size = PIDFD_SPAWN_ACTION_SIZE_VER0 - sizeof(__u64);
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+	args.action_size = PIDFD_SPAWN_ACTION_SIZE_VER0 + sizeof(__u32);
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+	args.action_size = PIDFD_SPAWN_ACTION_SIZE_VER0;
+	args.nr_actions = 65536 / PIDFD_SPAWN_ACTION_SIZE_VER0 + 1;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), E2BIG), 0);
+
+	args.actions = 0;
+	args.nr_actions = 0;
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), EINVAL), 0);
+}
+
+TEST(pidfd_spawn_run_accepts_versioned_action_elements)
+{
+	struct {
+		struct pidfd_spawn_action action;
+		__u64 tail;
+	} extended_action = {
+		.action = {
+			.type = PIDFD_SPAWN_ACTION_DUP2,
+			.fd = STDOUT_FILENO,
+			.newfd = STDOUT_FILENO,
+		},
+		.tail = 1,
+	};
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_args args = {
+		.path = ptr_to_u64(path),
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+		.actions = ptr_to_u64(&extended_action),
+		.nr_actions = 1,
+		.action_size = sizeof(extended_action),
+	};
+	int child_pid;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	ASSERT_EQ(run_args_fail_taskless(&args, sizeof(args), E2BIG), 0);
+
+	extended_action.tail = 0;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	child_pid = sys_pidfd_spawn_run(fd, &args, sizeof(args));
+	ASSERT_GT(child_pid, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_action_failure_publishes_waitable_child)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+		.fd = UINT_MAX,
+		.newfd = STDOUT_FILENO,
+	};
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), -1);
+	ASSERT_EQ(errno, EBADF);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), 0);
+	ASSERT_GT(info.pid, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 127), 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), -1);
+	ASSERT_EQ(errno, EBUSY);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_fchdir_rejects_regular_file)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_FCHDIR,
+	};
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int regular_fd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	regular_fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(regular_fd, 0);
+	action.fd = regular_fd;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), -1);
+	ASSERT_EQ(errno, ENOTDIR);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), 0);
+	ASSERT_GT(info.pid, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 127), 0);
+	ASSERT_GE(fcntl(regular_fd, F_GETFD), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(close(regular_fd), 0);
+}
+
+TEST(pidfd_spawn_dup2_captures_stdout)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+		.newfd = STDOUT_FILENO,
+	};
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "print", NULL };
+	char buf[13] = {};
+	int pipefd[2];
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	ASSERT_EQ(pipe2(pipefd, O_CLOEXEC), 0);
+	action.fd = pipefd[1];
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), 0);
+	ASSERT_EQ(close(pipefd[1]), 0);
+	ASSERT_EQ(read_exact_timeout(pipefd[0], buf, sizeof(buf) - 1),
+		  sizeof(buf) - 1);
+	ASSERT_STREQ(buf, "pidfd-spawn\n");
+	ASSERT_EQ(close(pipefd[0]), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_close_range_closes_only_child_fd)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_CLOSE_RANGE,
+	};
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "fd-closed", fdarg,
+				NULL };
+	int devnull;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	devnull = open("/dev/null", O_RDONLY);
+	ASSERT_GE(devnull, 0);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", devnull), 0);
+	action.fd = devnull;
+	action.newfd = devnull;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_GE(fcntl(devnull, F_GETFD), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(close(devnull), 0);
+}
+
+TEST(pidfd_spawn_dup2_same_fd_clears_child_cloexec)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+	};
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "fd-open", fdarg,
+				NULL };
+	int devnull;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	devnull = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(devnull, 0);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", devnull), 0);
+	action.fd = devnull;
+	action.newfd = devnull;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_NE(fcntl(devnull, F_GETFD) & FD_CLOEXEC, 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(close(devnull), 0);
+}
+
+TEST(pidfd_spawn_close_range_cloexec_is_child_local)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_CLOSE_RANGE,
+		.flags = CLOSE_RANGE_CLOEXEC,
+	};
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "fd-closed", fdarg,
+				NULL };
+	int devnull;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	devnull = open("/dev/null", O_RDONLY);
+	ASSERT_GE(devnull, 0);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", devnull), 0);
+	action.fd = devnull;
+	action.newfd = devnull;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, &action, 1), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(fcntl(devnull, F_GETFD) & FD_CLOEXEC, 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(close(devnull), 0);
+}
+
+TEST(pidfd_spawn_fchdir_changes_only_child_cwd)
+{
+	struct pidfd_spawn_action actions[2] = {
+		{
+			.type = PIDFD_SPAWN_ACTION_FCHDIR,
+		},
+		{
+			.type = PIDFD_SPAWN_ACTION_DUP2,
+			.newfd = STDOUT_FILENO,
+		},
+	};
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_actions_test",
+				"--pidfd-spawn-helper", "cwd-file", NULL };
+	char parent_cwd[PATH_MAX];
+	char current_cwd[PATH_MAX];
+	char template[] = "/tmp/pidfd-spawn-cwd.XXXXXX";
+	char payload[PATH_MAX];
+	char buf[9] = {};
+	int pipefd[2];
+	int dirfd;
+	int filefd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	ASSERT_NE(getcwd(parent_cwd, sizeof(parent_cwd)), NULL);
+	ASSERT_NE(mkdtemp(template), NULL);
+	ASSERT_LT(snprintf(payload, sizeof(payload), "%s/payload.txt", template),
+		  sizeof(payload));
+	filefd = open(payload, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
+	ASSERT_GE(filefd, 0);
+	ASSERT_EQ(write(filefd, "run-cwd\n", 8), 8);
+	ASSERT_EQ(close(filefd), 0);
+	dirfd = open(template, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(dirfd, 0);
+	ASSERT_EQ(pipe2(pipefd, O_CLOEXEC), 0);
+	actions[0].fd = dirfd;
+	actions[1].fd = pipefd[1];
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, actions,
+				 ARRAY_SIZE(actions)), 0);
+	ASSERT_EQ(close(pipefd[1]), 0);
+	ASSERT_EQ(read_exact_timeout(pipefd[0], buf, sizeof(buf) - 1),
+		  sizeof(buf) - 1);
+	ASSERT_STREQ(buf, "run-cwd\n");
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_NE(getcwd(current_cwd, sizeof(current_cwd)), NULL);
+	ASSERT_STREQ(current_cwd, parent_cwd);
+	ASSERT_GE(fcntl(dirfd, F_GETFD), 0);
+	ASSERT_EQ(close(pipefd[0]), 0);
+	ASSERT_EQ(close(dirfd), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(unlink(payload), 0);
+	ASSERT_EQ(rmdir(template), 0);
+}
+
+TEST(pidfd_spawn_file_actions_run_in_array_order)
+{
+	struct pidfd_spawn_action actions[2] = {
+		{
+			.type = PIDFD_SPAWN_ACTION_CLOSE_RANGE,
+		},
+		{
+			.type = PIDFD_SPAWN_ACTION_DUP2,
+		},
+	};
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const open_argv[] = { "pidfd_spawn_actions_test",
+				     "--pidfd-spawn-helper", "fd-open", fdarg,
+				     NULL };
+	char * const closed_argv[] = { "pidfd_spawn_actions_test",
+				       "--pidfd-spawn-helper", "fd-closed",
+				       fdarg, NULL };
+	int target;
+	int devnull;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	devnull = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(devnull, 0);
+	target = fcntl(devnull, F_DUPFD_CLOEXEC, 100);
+	ASSERT_GE(target, 100);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", target), 0);
+	actions[0].fd = target;
+	actions[0].newfd = target;
+	actions[1].fd = devnull;
+	actions[1].newfd = target;
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, open_argv, actions,
+				 ARRAY_SIZE(actions)), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+
+	actions[0].type = PIDFD_SPAWN_ACTION_DUP2;
+	actions[0].fd = devnull;
+	actions[0].newfd = target;
+	actions[1].type = PIDFD_SPAWN_ACTION_CLOSE_RANGE;
+	actions[1].fd = target;
+	actions[1].newfd = target;
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, closed_argv, actions,
+				 ARRAY_SIZE(actions)), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_NE(fcntl(target, F_GETFD) & FD_CLOEXEC, 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(close(target), 0);
+	ASSERT_EQ(close(devnull), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
new file mode 100644
index 0000000000000..759af7d6a68f8
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
@@ -0,0 +1,521 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <asm/unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/audit.h>
+#include <linux/netlink.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+#include "../landlock/audit.h"
+
+struct pidfd_spawn_audit_event {
+	unsigned long long serial;
+	pid_t pid;
+	bool syscall;
+	bool pidfd_spawn;
+	bool execve;
+	bool cwd;
+	bool cwd_matches;
+	bool path;
+};
+
+struct pidfd_spawn_audit_observation {
+	bool parent_syscall;
+	bool child_syscall;
+	bool child_pidfd_spawn;
+	bool child_execve;
+	bool child_cwd;
+	bool child_cwd_matches;
+	bool child_path;
+};
+
+static int pidfd_spawn_audit_filter_syscall(int audit_fd, __u16 type)
+{
+	struct audit_message msg = {
+		.header = {
+			.nlmsg_len = NLMSG_SPACE(sizeof(msg.rule)),
+			.nlmsg_type = type,
+			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
+		},
+		.rule = {
+			.flags = AUDIT_FILTER_EXIT,
+			.action = AUDIT_ALWAYS,
+		},
+	};
+
+	if (AUDIT_WORD(__NR_pidfd_spawn_run) >= AUDIT_BITMASK_SIZE)
+		return -E2BIG;
+	msg.rule.mask[AUDIT_WORD(__NR_pidfd_spawn_run)] =
+		AUDIT_BIT(__NR_pidfd_spawn_run);
+	return audit_request(audit_fd, &msg, NULL);
+}
+
+static int pidfd_spawn_audit_get_status(struct audit_status *status)
+{
+	const struct audit_message request = {
+		.header = {
+			.nlmsg_len = NLMSG_SPACE(0),
+			.nlmsg_type = AUDIT_GET,
+			.nlmsg_flags = NLM_F_REQUEST,
+		},
+	};
+	struct audit_message reply;
+	int audit_fd;
+	int ret;
+
+	audit_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_AUDIT);
+	if (audit_fd < 0)
+		return -errno;
+	ret = audit_send(audit_fd, &request);
+	while (!ret) {
+		memset(&reply, 0, sizeof(reply));
+		ret = audit_recv(audit_fd, &reply);
+		if (ret)
+			continue;
+		if (reply.header.nlmsg_type == NLMSG_ERROR) {
+			ret = reply.err.error ? reply.err.error : -EIO;
+			break;
+		}
+		if (reply.header.nlmsg_type != AUDIT_GET)
+			continue;
+		*status = reply.status;
+		break;
+	}
+	close(audit_fd);
+	return ret;
+}
+
+static int pidfd_spawn_audit_init(int *audit_fd, bool *owner_set)
+{
+	int fd;
+	int ret;
+
+	fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_AUDIT);
+	if (fd < 0)
+		return -errno;
+	*audit_fd = fd;
+	ret = audit_set_status(fd, AUDIT_STATUS_PID, getpid());
+	if (ret)
+		return ret;
+	*owner_set = true;
+	ret = audit_set_status(fd, AUDIT_STATUS_ENABLED, 1);
+	if (ret)
+		return ret;
+	ret = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &audit_tv_fast,
+			 sizeof(audit_tv_fast));
+	if (ret)
+		return -errno;
+	while (audit_recv(fd, NULL) == 0)
+		;
+	ret = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &audit_tv_default,
+			 sizeof(audit_tv_default));
+	return ret ? -errno : 0;
+}
+
+static void pidfd_spawn_audit_record_cleanup(int *first_error, int error)
+{
+	if (!*first_error && error)
+		*first_error = error;
+}
+
+static int pidfd_spawn_audit_release(int audit_fd, __u32 enabled)
+{
+	const struct audit_message msg = {
+		.header = {
+			.nlmsg_len = NLMSG_SPACE(sizeof(msg.status)),
+			.nlmsg_type = AUDIT_SET,
+			.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
+		},
+		.status = {
+			.mask = AUDIT_STATUS_ENABLED | AUDIT_STATUS_PID,
+			.enabled = enabled,
+			.pid = 0,
+		},
+	};
+	int ret;
+
+	ret = audit_request(audit_fd, &msg, NULL);
+	return ret > 0 ? 0 : ret;
+}
+
+static unsigned long long pidfd_spawn_audit_serial(const char *record)
+{
+	const char *audit;
+	const char *separator;
+	char *end;
+	unsigned long long serial;
+
+	audit = strstr(record, "audit(");
+	if (!audit)
+		return 0;
+	separator = strchr(audit, ':');
+	if (!separator)
+		return 0;
+	errno = 0;
+	serial = strtoull(separator + 1, &end, 10);
+	if (errno || end == separator + 1 || *end != ')')
+		return 0;
+	return serial;
+}
+
+static int pidfd_spawn_audit_field(const char *record, const char *field,
+				   long *value)
+{
+	char pattern[32];
+	const char *start;
+	char *end;
+	int len;
+
+	len = snprintf(pattern, sizeof(pattern), " %s=", field);
+	if (len < 0 || len >= sizeof(pattern))
+		return -E2BIG;
+	start = strstr(record, pattern);
+	if (!start)
+		return -ENOENT;
+	errno = 0;
+	*value = strtol(start + len, &end, 10);
+	if (errno || end == start + len)
+		return -EINVAL;
+	return 0;
+}
+
+static bool pidfd_spawn_audit_cwd_matches(const char *record, const char *cwd)
+{
+	char field[PATH_MAX + sizeof("cwd=\"\"")];
+	int len;
+
+	len = snprintf(field, sizeof(field), "cwd=\"%s\"", cwd);
+	return len > 0 && len < (int)sizeof(field) && strstr(record, field);
+}
+
+static struct pidfd_spawn_audit_event *
+pidfd_spawn_audit_event(struct pidfd_spawn_audit_event *events,
+			unsigned int *nr_events, unsigned long long serial)
+{
+	unsigned int i;
+
+	for (i = 0; i < *nr_events; i++)
+		if (events[i].serial == serial)
+			return &events[i];
+	if (*nr_events == 16)
+		return NULL;
+	events[*nr_events].serial = serial;
+	return &events[(*nr_events)++];
+}
+
+static int
+pidfd_spawn_collect_audit(int audit_fd, pid_t parent, pid_t child,
+			  const char *expected_cwd,
+			  struct pidfd_spawn_audit_observation *obs)
+{
+	struct pidfd_spawn_audit_event events[16] = {};
+	unsigned int nr_events = 0;
+	struct audit_message msg;
+	unsigned int i;
+	int ret;
+
+	for (;;) {
+		struct pidfd_spawn_audit_event *event;
+		unsigned long long serial;
+
+		memset(&msg, 0, sizeof(msg));
+		ret = audit_recv(audit_fd, &msg);
+		if (ret == -EAGAIN)
+			break;
+		if (ret)
+			return ret;
+		serial = pidfd_spawn_audit_serial(msg.data);
+		if (!serial)
+			continue;
+		event = pidfd_spawn_audit_event(events, &nr_events, serial);
+		if (!event)
+			return -E2BIG;
+		switch (msg.header.nlmsg_type) {
+		case AUDIT_SYSCALL:
+		case AUDIT_PIDFD_SPAWN: {
+			long pid;
+			long syscall;
+
+			if (pidfd_spawn_audit_field(msg.data, "syscall", &syscall) ||
+			    syscall != __NR_pidfd_spawn_run ||
+			    pidfd_spawn_audit_field(msg.data, "pid", &pid))
+				break;
+			event->pid = pid;
+			if (msg.header.nlmsg_type == AUDIT_SYSCALL)
+				event->syscall = true;
+			else
+				event->pidfd_spawn = true;
+			break;
+		}
+		case AUDIT_EXECVE:
+			event->execve = true;
+			break;
+		case AUDIT_CWD:
+			event->cwd = true;
+			if (expected_cwd &&
+			    pidfd_spawn_audit_cwd_matches(msg.data, expected_cwd))
+				event->cwd_matches = true;
+			break;
+		case AUDIT_PATH:
+			event->path = true;
+			break;
+		}
+	}
+
+	for (i = 0; i < nr_events; i++) {
+		if (events[i].pid == parent)
+			obs->parent_syscall |= events[i].syscall;
+		if (events[i].pid != child)
+			continue;
+		obs->child_syscall |= events[i].syscall;
+		obs->child_pidfd_spawn |= events[i].pidfd_spawn;
+		obs->child_execve |= events[i].execve;
+		obs->child_cwd |= events[i].cwd;
+		obs->child_cwd_matches |= events[i].cwd_matches;
+		obs->child_path |= events[i].path;
+	}
+	return 0;
+}
+
+static int pidfd_spawn_audit_worker(int pipe_fd, const char *path, int cwd_fd)
+{
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_FCHDIR,
+		.fd = cwd_fd,
+	};
+	char * const argv[] = { "pidfd_spawn_audit_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	pid_t child;
+	int builder;
+
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		return 1;
+	child = spawn_run_path_pid(builder, path, argv,
+				   cwd_fd < 0 ? NULL : &action, cwd_fd < 0 ? 0 : 1);
+	if (child < 0) {
+		close(builder);
+		return 2;
+	}
+	if (write(pipe_fd, &child, sizeof(child)) != sizeof(child)) {
+		close(builder);
+		return 3;
+	}
+	if (wait_pidfd_exit(builder, 0)) {
+		close(builder);
+		return 4;
+	}
+	return close(builder) ? 5 : 0;
+}
+
+static int
+pidfd_spawn_observe_audit(struct pidfd_spawn_audit_observation *obs,
+			  bool fail_after_filter, const char *path, int cwd_fd,
+			  const char *expected_cwd)
+{
+	struct audit_records records;
+	struct audit_filter filter;
+	struct audit_status original = {};
+	bool audit_owner_set = false;
+	bool filter_added = false;
+	bool rule_added = false;
+	int pipe_fds[2] = { -1, -1 };
+	int audit_fd = -1;
+	int cleanup_error = 0;
+	int cleanup;
+	int status;
+	int ret;
+	pid_t child = 0;
+	pid_t source;
+	pid_t waited;
+	ssize_t len;
+
+	if (!path)
+		path = self_exe_path();
+	if (!path)
+		return -ENOENT;
+	ret = pidfd_spawn_audit_get_status(&original);
+	if (ret)
+		return ret;
+	if (original.pid)
+		return -EEXIST;
+	if (original.enabled == 2)
+		return -EPERM;
+	ret = pidfd_spawn_audit_init(&audit_fd, &audit_owner_set);
+	if (ret)
+		goto out;
+	ret = audit_init_filter_exe(&filter, NULL);
+	if (ret)
+		goto out;
+	ret = audit_filter_exe(audit_fd, &filter, AUDIT_ADD_RULE);
+	if (ret)
+		goto out;
+	filter_added = true;
+	if (fail_after_filter) {
+		ret = -ECANCELED;
+		goto out;
+	}
+	ret = pidfd_spawn_audit_filter_syscall(audit_fd, AUDIT_ADD_RULE);
+	if (ret)
+		goto out;
+	rule_added = true;
+	if (pipe2(pipe_fds, O_CLOEXEC)) {
+		ret = -errno;
+		goto out;
+	}
+	source = fork();
+	if (source < 0) {
+		ret = -errno;
+		goto out;
+	}
+	if (!source) {
+		close(pipe_fds[0]);
+		_exit(pidfd_spawn_audit_worker(pipe_fds[1], path, cwd_fd));
+	}
+	close(pipe_fds[1]);
+	pipe_fds[1] = -1;
+	do {
+		len = read(pipe_fds[0], &child, sizeof(child));
+	} while (len < 0 && errno == EINTR);
+	close(pipe_fds[0]);
+	pipe_fds[0] = -1;
+	waited = waitpid_timeout(source, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (waited != source || !WIFEXITED(status) || WEXITSTATUS(status)) {
+		ret = -ECHILD;
+		goto out;
+	}
+	if (len != sizeof(child)) {
+		ret = len < 0 ? -errno : -EIO;
+		goto out;
+	}
+	ret = pidfd_spawn_collect_audit(audit_fd, source, child, expected_cwd,
+					obs);
+	if (!ret)
+		ret = audit_count_records(audit_fd, &records);
+out:
+	if (pipe_fds[0] >= 0)
+		close(pipe_fds[0]);
+	if (pipe_fds[1] >= 0)
+		close(pipe_fds[1]);
+	if (audit_fd < 0)
+		return ret;
+	if (!audit_owner_set) {
+		close(audit_fd);
+		return ret;
+	}
+	if (rule_added) {
+		cleanup = pidfd_spawn_audit_filter_syscall(audit_fd,
+							   AUDIT_DEL_RULE);
+		pidfd_spawn_audit_record_cleanup(&cleanup_error, cleanup);
+	}
+	if (filter_added) {
+		cleanup = audit_filter_exe(audit_fd, &filter, AUDIT_DEL_RULE);
+		pidfd_spawn_audit_record_cleanup(&cleanup_error, cleanup);
+	}
+	cleanup = pidfd_spawn_audit_release(audit_fd, original.enabled);
+	pidfd_spawn_audit_record_cleanup(&cleanup_error, cleanup);
+	close(audit_fd);
+	return cleanup_error ? cleanup_error : ret;
+}
+
+TEST(pidfd_spawn_audit_records_child_exec)
+{
+	struct pidfd_spawn_audit_observation observation = {};
+	int ret;
+
+	ret = pidfd_spawn_observe_audit(&observation, false, NULL, -1, NULL);
+	if (ret == -EPERM || ret == -EACCES || ret == -EEXIST ||
+	    ret == -EAFNOSUPPORT || ret == -EPROTONOSUPPORT)
+		SKIP(return, "Audit control is unavailable: %s", strerror(-ret));
+	ASSERT_EQ(ret, 0);
+	ASSERT_TRUE(observation.parent_syscall);
+	ASSERT_FALSE(observation.child_syscall);
+	ASSERT_TRUE(observation.child_pidfd_spawn);
+	ASSERT_TRUE(observation.child_execve);
+	ASSERT_TRUE(observation.child_cwd);
+	ASSERT_TRUE(observation.child_path);
+}
+
+TEST(pidfd_spawn_audit_records_post_fchdir_cwd)
+{
+	struct pidfd_spawn_audit_observation observation = {};
+	const char *path = self_exe_path();
+	static const char relative_path[] = "pidfd-spawn-audit-helper";
+	char template[] = "/tmp/pidfd-spawn-audit.XXXXXX";
+	char link_path[PATH_MAX];
+	int dirfd;
+	int len;
+	int ret;
+
+	ASSERT_NE(path, NULL);
+	ASSERT_NE(mkdtemp(template), NULL);
+	len = snprintf(link_path, sizeof(link_path), "%s/%s", template,
+		       relative_path);
+	ASSERT_GT(len, 0);
+	ASSERT_LT(len, (int)sizeof(link_path));
+	ASSERT_EQ(symlink(path, link_path), 0);
+	dirfd = open(template, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(dirfd, 0);
+
+	ret = pidfd_spawn_observe_audit(&observation, false, relative_path,
+					dirfd, template);
+	ASSERT_EQ(close(dirfd), 0);
+	ASSERT_EQ(unlink(link_path), 0);
+	ASSERT_EQ(rmdir(template), 0);
+	if (ret == -EPERM || ret == -EACCES || ret == -EEXIST ||
+	    ret == -EAFNOSUPPORT || ret == -EPROTONOSUPPORT)
+		SKIP(return, "Audit control is unavailable: %s", strerror(-ret));
+	ASSERT_EQ(ret, 0);
+	ASSERT_TRUE(observation.parent_syscall);
+	ASSERT_TRUE(observation.child_pidfd_spawn);
+	ASSERT_TRUE(observation.child_execve);
+	ASSERT_TRUE(observation.child_cwd);
+	ASSERT_TRUE(observation.child_cwd_matches);
+	ASSERT_TRUE(observation.child_path);
+}
+
+TEST(pidfd_spawn_audit_setup_failure_restores_status)
+{
+	struct pidfd_spawn_audit_observation observation = {};
+	struct audit_status original = {};
+	struct audit_status restored = {};
+	int ret;
+
+	ret = pidfd_spawn_audit_get_status(&original);
+	if (ret == -EPERM || ret == -EACCES ||
+	    ret == -EAFNOSUPPORT || ret == -EPROTONOSUPPORT)
+		SKIP(return, "Audit control is unavailable: %s", strerror(-ret));
+	ASSERT_EQ(ret, 0);
+	if (original.pid)
+		SKIP(return, "Audit is owned by pid %u", original.pid);
+	if (original.enabled == 2)
+		SKIP(return, "Audit configuration is immutable");
+	ret = pidfd_spawn_observe_audit(&observation, true, NULL, -1, NULL);
+	if (ret == -EPERM || ret == -EACCES || ret == -EEXIST ||
+	    ret == -EAFNOSUPPORT || ret == -EPROTONOSUPPORT)
+		SKIP(return, "Audit control is unavailable: %s", strerror(-ret));
+	ASSERT_EQ(ret, -ECANCELED);
+	ASSERT_EQ(pidfd_spawn_audit_get_status(&restored), 0);
+	ASSERT_EQ(restored.enabled, original.enabled);
+	ASSERT_EQ(restored.pid, original.pid);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_common.c b/tools/testing/selftests/pidfd/pidfd_spawn_common.c
new file mode 100644
index 0000000000000..aab7211f5e2c7
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_common.c
@@ -0,0 +1,512 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <asm/unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "pidfd.h"
+#include "pidfd_spawn_common.h"
+
+char * const empty_envp[] = { NULL };
+
+int helper_main(int argc, char **argv)
+{
+	if (argc < 3 || strcmp(argv[1], "--pidfd-spawn-helper")) {
+		int fd = sys_pidfd_empty_open();
+
+		if (fd >= 0) {
+			close(fd);
+			return -1;
+		}
+		if (errno != EINVAL && errno != ENOSYS)
+			return -1;
+		ksft_print_msg("pidfd spawn is unavailable: %s\n",
+			       strerror(errno));
+		return KSFT_SKIP;
+	}
+
+	if (!strcmp(argv[2], "exit0"))
+		return 0;
+	if (!strcmp(argv[2], "empty-env"))
+		return environ[0] ? 1 : 0;
+	if (!strcmp(argv[2], "print")) {
+		if (write(STDOUT_FILENO, "pidfd-spawn\n", 12) != 12)
+			return 1;
+		return 0;
+	}
+	if (!strcmp(argv[2], "cwd-file")) {
+		char buf[32];
+		int fd;
+		ssize_t len;
+
+		fd = open("payload.txt", O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			return 1;
+		len = read(fd, buf, sizeof(buf));
+		close(fd);
+		if (len < 0)
+			return 1;
+		if (write(STDOUT_FILENO, buf, len) != len)
+			return 1;
+		return 0;
+	}
+	if (!strcmp(argv[2], "fd-closed")) {
+		int fd;
+
+		if (argc != 4)
+			return 127;
+		fd = atoi(argv[3]);
+		if (fcntl(fd, F_GETFD) == -1 && errno == EBADF)
+			return 0;
+		return 1;
+	}
+	if (!strcmp(argv[2], "fd-open")) {
+		int fd;
+
+		if (argc != 4)
+			return 127;
+		fd = atoi(argv[3]);
+		return fcntl(fd, F_GETFD) >= 0 ? 0 : 1;
+	}
+	if (!strcmp(argv[2], "wait-fd")) {
+		char byte;
+		ssize_t len;
+		int fd;
+
+		if (argc != 4)
+			return 127;
+		fd = atoi(argv[3]);
+		do {
+			len = read(fd, &byte, sizeof(byte));
+		} while (len < 0 && errno == EINTR);
+		return len == sizeof(byte) ? 0 : 1;
+	}
+	if (!strcmp(argv[2], "ready-wait-fd")) {
+		char byte = 1;
+		ssize_t len;
+		int ready_fd;
+		int wait_fd;
+
+		if (argc != 5)
+			return 127;
+		ready_fd = atoi(argv[3]);
+		wait_fd = atoi(argv[4]);
+		if (write(ready_fd, &byte, sizeof(byte)) != sizeof(byte))
+			return 1;
+		do {
+			len = read(wait_fd, &byte, sizeof(byte));
+		} while (len < 0 && errno == EINTR);
+		return len == sizeof(byte) ? 0 : 1;
+	}
+	if (!strcmp(argv[2], "seccomp-actions")) {
+		char * const blocked_argv[] = { "blocked", NULL };
+		char cwd[PATH_MAX];
+		int closed_fd;
+		int cwd_fd;
+		int target;
+
+		if (argc != 7)
+			return 127;
+		target = atoi(argv[3]);
+		closed_fd = atoi(argv[4]);
+		cwd_fd = atoi(argv[5]);
+		if (fcntl(target, F_GETFD) < 0)
+			return 1;
+		if (fcntl(closed_fd, F_GETFD) != -1 || errno != EBADF)
+			return 2;
+		if (!getcwd(cwd, sizeof(cwd)) || strcmp(cwd, argv[6]))
+			return 3;
+#ifdef __NR_dup2
+		errno = 0;
+		if (dup2(target, target) != -1 || errno != EPERM)
+			return 4;
+#endif
+		errno = 0;
+		if (syscall(__NR_close_range, target, target, 0) != -1 ||
+		    errno != EPERM)
+			return 5;
+		errno = 0;
+		if (fchdir(cwd_fd) != -1 || errno != EPERM)
+			return 6;
+		errno = 0;
+		if (execve("/no/such/pidfd-spawn-seccomp", blocked_argv,
+			   empty_envp) != -1 || errno != EPERM)
+			return 7;
+		errno = 0;
+		if (syscall(__NR_execveat, AT_FDCWD,
+			    "/no/such/pidfd-spawn-seccomp", blocked_argv,
+			    empty_envp, 0) != -1 || errno != EPERM)
+			return 8;
+		return 0;
+	}
+	return 127;
+}
+
+const char *self_exe_path(void)
+{
+	static char path[PATH_MAX];
+	ssize_t len;
+
+	if (path[0])
+		return path;
+
+	len = readlink("/proc/self/exe", path, sizeof(path) - 1);
+	if (len < 0)
+		return NULL;
+	path[len] = '\0';
+	return path;
+}
+
+int enter_self_exe_directory(char **storage, const char **relative)
+{
+	const char *path = self_exe_path();
+	char *slash;
+	int cwd_fd;
+
+	if (!path) {
+		errno = ENOENT;
+		return -1;
+	}
+	*storage = strdup(path);
+	if (!*storage)
+		return -1;
+	slash = strrchr(*storage, '/');
+	if (!slash || !slash[1]) {
+		free(*storage);
+		*storage = NULL;
+		errno = EINVAL;
+		return -1;
+	}
+	*slash = '\0';
+	*relative = slash + 1;
+	cwd_fd = open(".", O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	if (cwd_fd < 0 || chdir(**storage ? *storage : "/")) {
+		int saved_errno = errno;
+
+		if (cwd_fd >= 0)
+			close(cwd_fd);
+		free(*storage);
+		*storage = NULL;
+		errno = saved_errno;
+		return -1;
+	}
+	return cwd_fd;
+}
+
+int leave_self_exe_directory(int cwd_fd, char *storage)
+{
+	int ret = fchdir(cwd_fd);
+	int saved_errno = errno;
+
+	if (close(cwd_fd) && !ret) {
+		ret = -1;
+		saved_errno = errno;
+	}
+	free(storage);
+	errno = saved_errno;
+	return ret;
+}
+
+int config_path(int fd, const char *path)
+{
+	return sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+				PIDFD_CONFIG_KEY_PATH, path, 0);
+}
+
+int spawn_run_path_pid(int fd, const char *path, char * const argv[],
+		       struct pidfd_spawn_action *actions,
+		       unsigned int nr_actions)
+{
+	struct pidfd_spawn_run_args args = {
+		.path = ptr_to_u64(path),
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+		.actions = ptr_to_u64(actions),
+		.nr_actions = nr_actions,
+		.action_size = nr_actions ? sizeof(*actions) : 0,
+	};
+
+	return sys_pidfd_spawn_run(fd, &args, sizeof(args));
+}
+
+int spawn_run_path(int fd, const char *path, char * const argv[],
+		   struct pidfd_spawn_action *actions,
+		   unsigned int nr_actions)
+{
+	return spawn_run_path_pid(fd, path, argv, actions, nr_actions) < 0 ?
+		-1 : 0;
+}
+
+int spawn_run_staged(int fd, char * const argv[],
+		     struct pidfd_spawn_action *actions,
+		     unsigned int nr_actions)
+{
+	return spawn_run_path(fd, NULL, argv, actions, nr_actions);
+}
+
+static int deadline_after_ms(struct timespec *deadline, unsigned int timeout_ms)
+{
+	if (clock_gettime(CLOCK_MONOTONIC, deadline))
+		return -1;
+	deadline->tv_sec += timeout_ms / 1000;
+	deadline->tv_nsec += (timeout_ms % 1000) * 1000000L;
+	if (deadline->tv_nsec >= 1000000000L) {
+		deadline->tv_sec++;
+		deadline->tv_nsec -= 1000000000L;
+	}
+	return 0;
+}
+
+static int deadline_remaining_ms(const struct timespec *deadline)
+{
+	struct timespec now;
+	int64_t remaining_ns;
+
+	if (clock_gettime(CLOCK_MONOTONIC, &now))
+		return -1;
+	remaining_ns = (deadline->tv_sec - now.tv_sec) * 1000000000LL +
+			       deadline->tv_nsec - now.tv_nsec;
+	if (remaining_ns <= 0)
+		return 0;
+	if (remaining_ns > (int64_t)INT_MAX * 1000000)
+		return INT_MAX;
+	return (remaining_ns + 999999) / 1000000;
+}
+
+static int poll_until(int fd, short events, const struct timespec *deadline)
+{
+	struct pollfd pfd = {
+		.fd = fd,
+		.events = events,
+	};
+	int timeout;
+	int ret;
+
+	for (;;) {
+		timeout = deadline_remaining_ms(deadline);
+		if (timeout <= 0) {
+			if (!timeout)
+				errno = ETIMEDOUT;
+			return -1;
+		}
+		ret = poll(&pfd, 1, timeout);
+		if (ret > 0) {
+			if (pfd.revents & POLLNVAL) {
+				errno = EBADF;
+				return -1;
+			}
+			if (pfd.revents & (events | POLLERR | POLLHUP))
+				return 0;
+			continue;
+		}
+		if (!ret) {
+			errno = ETIMEDOUT;
+			return -1;
+		}
+		if (errno != EINTR)
+			return -1;
+	}
+}
+
+int wait_pidfd_exit_info(int pidfd, struct pidfd_info *info)
+{
+	struct timespec deadline;
+
+	if (deadline_after_ms(&deadline, PIDFD_SPAWN_TIMEOUT_MS))
+		return -1;
+	for (;;) {
+		memset(info, 0, sizeof(*info));
+		info->mask = PIDFD_INFO_EXIT;
+		if (!ioctl(pidfd, PIDFD_GET_INFO, info)) {
+			if (info->mask & PIDFD_INFO_EXIT)
+				return 0;
+		} else if (errno != ESRCH && errno != EINTR) {
+			return -1;
+		}
+		if (poll_until(pidfd, POLLIN, &deadline))
+			return -1;
+	}
+}
+
+static int wait_pidfd_info(int pidfd, siginfo_t *info)
+{
+	struct timespec deadline;
+
+	if (deadline_after_ms(&deadline, PIDFD_SPAWN_TIMEOUT_MS))
+		return -1;
+	for (;;) {
+		memset(info, 0, sizeof(*info));
+		if (!sys_waitid(P_PIDFD, pidfd, info, WEXITED | WNOHANG)) {
+			if (info->si_pid)
+				return 0;
+		} else if (errno != EINTR) {
+			return -1;
+		}
+		if (poll_until(pidfd, POLLIN, &deadline))
+			return -1;
+	}
+}
+
+int wait_pidfd_exit(int pidfd, int status)
+{
+	siginfo_t info = {};
+
+	if (wait_pidfd_info(pidfd, &info))
+		return -1;
+	if (info.si_code != CLD_EXITED || info.si_status != status) {
+		errno = ECHILD;
+		return -1;
+	}
+	return 0;
+}
+
+int wait_pidfd_signal(int pidfd, int signal)
+{
+	siginfo_t info = {};
+
+	if (wait_pidfd_info(pidfd, &info))
+		return -1;
+	if (info.si_code != CLD_KILLED || info.si_status != signal) {
+		errno = ECHILD;
+		return -1;
+	}
+	return 0;
+}
+
+#define PIDFD_SPAWN_MAX_SENT_FDS 2
+
+int send_fds_status(int socket, int status, const int *fds, size_t nr_fds)
+{
+	union {
+		char buf[CMSG_SPACE(sizeof(int) * PIDFD_SPAWN_MAX_SENT_FDS)];
+		struct cmsghdr align;
+	} control = {};
+	struct iovec iov = {
+		.iov_base = &status,
+		.iov_len = sizeof(status),
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+	};
+	struct cmsghdr *cmsg;
+
+	if (nr_fds > PIDFD_SPAWN_MAX_SENT_FDS) {
+		errno = E2BIG;
+		return -1;
+	}
+	if (nr_fds) {
+		msg.msg_control = control.buf;
+		msg.msg_controllen = CMSG_SPACE(sizeof(*fds) * nr_fds);
+		cmsg = CMSG_FIRSTHDR(&msg);
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SCM_RIGHTS;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(*fds) * nr_fds);
+		memcpy(CMSG_DATA(cmsg), fds, sizeof(*fds) * nr_fds);
+	}
+
+	return sendmsg(socket, &msg, 0) == sizeof(status) ? 0 : -1;
+}
+
+int recv_fds_status(int socket, int *status, int *fds, size_t nr_fds)
+{
+	union {
+		char buf[CMSG_SPACE(sizeof(int) * PIDFD_SPAWN_MAX_SENT_FDS)];
+		struct cmsghdr align;
+	} control = {};
+	struct iovec iov = {
+		.iov_base = status,
+		.iov_len = sizeof(*status),
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = control.buf,
+		.msg_controllen = sizeof(control.buf),
+	};
+	struct cmsghdr *cmsg;
+
+	if (!nr_fds || nr_fds > PIDFD_SPAWN_MAX_SENT_FDS) {
+		errno = EINVAL;
+		return -1;
+	}
+	if (recvmsg(socket, &msg, MSG_CMSG_CLOEXEC) != sizeof(*status))
+		return -1;
+	if (*status)
+		return -1;
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	if (!cmsg || cmsg->cmsg_level != SOL_SOCKET ||
+	    cmsg->cmsg_type != SCM_RIGHTS ||
+	    cmsg->cmsg_len != CMSG_LEN(sizeof(*fds) * nr_fds) ||
+	    (msg.msg_flags & (MSG_CTRUNC | MSG_TRUNC))) {
+		errno = EBADMSG;
+		return -1;
+	}
+
+	memcpy(fds, CMSG_DATA(cmsg), sizeof(*fds) * nr_fds);
+	return 0;
+}
+
+pid_t waitpid_timeout(pid_t pid, int *status, unsigned int timeout_ms)
+{
+	struct timespec deadline;
+	pid_t ret;
+	int timeout;
+
+	if (deadline_after_ms(&deadline, timeout_ms))
+		return -1;
+	for (;;) {
+		ret = waitpid(pid, status, WNOHANG);
+		if (ret > 0)
+			return ret;
+		if (ret < 0 && errno != EINTR)
+			return -1;
+		timeout = deadline_remaining_ms(&deadline);
+		if (timeout <= 0)
+			break;
+		if (timeout > 10)
+			timeout = 10;
+		if (poll(NULL, 0, timeout) < 0 && errno != EINTR)
+			return -1;
+	}
+
+	errno = ETIMEDOUT;
+	return 0;
+}
+
+int pthread_join_timeout(pthread_t thread, void **retval,
+			 unsigned int timeout_ms)
+{
+	struct timespec deadline;
+	int timeout;
+	int ret;
+
+	if (deadline_after_ms(&deadline, timeout_ms))
+		return errno;
+	for (;;) {
+		ret = pthread_tryjoin_np(thread, retval);
+		if (ret != EBUSY)
+			return ret;
+		timeout = deadline_remaining_ms(&deadline);
+		if (timeout <= 0)
+			return timeout ? errno : ETIMEDOUT;
+		if (timeout > 10)
+			timeout = 10;
+		if (poll(NULL, 0, timeout) < 0 && errno != EINTR)
+			return errno;
+	}
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_common.h b/tools/testing/selftests/pidfd/pidfd_spawn_common.h
new file mode 100644
index 0000000000000..33f9b72655d67
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_common.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PIDFD_SPAWN_COMMON_H
+#define __PIDFD_SPAWN_COMMON_H
+
+#include <linux/pidfd_spawn.h>
+#include <pthread.h>
+#include <stddef.h>
+
+#include "pidfd.h"
+
+#ifndef PIDFD_EMPTY
+#define PIDFD_EMPTY 0x08000000U
+#endif
+
+#define PIDFD_SPAWN_TIMEOUT_MS 5000
+
+extern char * const empty_envp[];
+
+int helper_main(int argc, char **argv);
+static inline int sys_pidfd_empty_open(void)
+{
+	return sys_pidfd_open(0, PIDFD_EMPTY);
+}
+
+static inline int sys_pidfd_config(int fd, unsigned int cmd,
+				   const char *key, const void *value, int aux)
+{
+	return syscall(__NR_pidfd_config, fd, cmd, key, value, aux);
+}
+
+static inline int sys_pidfd_spawn_run(int fd,
+				      struct pidfd_spawn_run_args *args,
+				      size_t size)
+{
+	return syscall(__NR_pidfd_spawn_run, fd, args, size);
+}
+
+const char *self_exe_path(void);
+int enter_self_exe_directory(char **storage, const char **relative);
+int leave_self_exe_directory(int cwd_fd, char *storage);
+int config_path(int fd, const char *path);
+int spawn_run_path_pid(int fd, const char *path, char * const argv[],
+		       struct pidfd_spawn_action *actions,
+		       unsigned int nr_actions);
+int spawn_run_path(int fd, const char *path, char * const argv[],
+		   struct pidfd_spawn_action *actions, unsigned int nr_actions);
+int spawn_run_staged(int fd, char * const argv[],
+		     struct pidfd_spawn_action *actions,
+		     unsigned int nr_actions);
+int wait_pidfd_exit_info(int pidfd, struct pidfd_info *info);
+int wait_pidfd_exit(int pidfd, int status);
+int wait_pidfd_signal(int pidfd, int signal);
+int send_fds_status(int socket, int status, const int *fds, size_t nr_fds);
+int recv_fds_status(int socket, int *status, int *fds, size_t nr_fds);
+pid_t waitpid_timeout(pid_t pid, int *status, unsigned int timeout_ms);
+int pthread_join_timeout(pthread_t thread, void **retval,
+			 unsigned int timeout_ms);
+
+#endif /* __PIDFD_SPAWN_COMMON_H */
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_compat.c b/tools/testing/selftests/pidfd/pidfd_spawn_compat.c
new file mode 100644
index 0000000000000..a4e31d271a5d5
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_compat.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <limits.h>
+#include <linux/fs.h>
+#include <linux/pidfd.h>
+#include <linux/pidfd_spawn.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+
+#ifndef __NR_pidfd_config
+#define __NR_pidfd_config 472
+#endif
+#ifndef __NR_pidfd_spawn_run
+#define __NR_pidfd_spawn_run 473
+#endif
+
+static __u64 compat_ptr64(const void *ptr)
+{
+	return (__u64)(uintptr_t)ptr;
+}
+
+static __u64 invalid_full_width_ptr(const void *ptr)
+{
+	return compat_ptr64(ptr) | (1ULL << 32);
+}
+
+static int read_self_exe(char *path, size_t size)
+{
+	ssize_t len;
+
+	len = readlink("/proc/self/exe", path, size - 1);
+	if (len < 0 || (size_t)len >= size - 1)
+		return -1;
+	path[len] = '\0';
+	return 0;
+}
+
+static int run_child(bool staged)
+{
+	char * const argv[] = { "pidfd_spawn_compat", "--exit0", NULL };
+	char * const envp[] = { NULL };
+	char path[PATH_MAX] = {};
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+		.fd = STDOUT_FILENO,
+		.newfd = STDOUT_FILENO,
+	};
+	struct pidfd_spawn_run_args args = {
+		.path = staged ? 0 : compat_ptr64(path),
+		.argv = compat_ptr64(argv),
+		.envp = compat_ptr64(envp),
+		.actions = compat_ptr64(&action),
+		.nr_actions = 1,
+		.action_size = sizeof(action),
+	};
+	siginfo_t info = {};
+	__u32 published_generation;
+	__u32 future_generation;
+	int fd;
+
+	if (read_self_exe(path, sizeof(path)))
+		return 1;
+	fd = syscall(__NR_pidfd_open, 0, PIDFD_EMPTY);
+	if (fd < 0)
+		return 2;
+	if (ioctl(fd, FS_IOC_GETVERSION, &future_generation))
+		return 3;
+	if (staged && syscall(__NR_pidfd_config, fd, PIDFD_CONFIG_SET_STRING,
+			      PIDFD_CONFIG_KEY_PATH, path, 0))
+		return 4;
+	if (syscall(__NR_pidfd_spawn_run, fd, &args, sizeof(args)) < 0)
+		return 5;
+	if (ioctl(fd, FS_IOC_GETVERSION, &published_generation))
+		return 6;
+	if (published_generation != future_generation)
+		return 7;
+	if (waitid(P_PIDFD, fd, &info, WEXITED))
+		return 8;
+	if (info.si_code != CLD_EXITED || info.si_status)
+		return 9;
+	return close(fd) ? 10 : 0;
+}
+
+static int run_empty_env(void)
+{
+	char * const argv[] = { "pidfd_spawn_compat", "--check-empty-env",
+				NULL };
+	char path[PATH_MAX];
+	struct pidfd_spawn_run_args args = {
+		.argv = compat_ptr64(argv),
+	};
+	siginfo_t info = {};
+	int fd;
+
+	if (read_self_exe(path, sizeof(path)))
+		return 1;
+	args.path = compat_ptr64(path);
+	fd = syscall(__NR_pidfd_open, 0, PIDFD_EMPTY);
+	if (fd < 0)
+		return 2;
+	if (syscall(__NR_pidfd_spawn_run, fd, &args, sizeof(args)) < 0)
+		return 3;
+	if (waitid(P_PIDFD, fd, &info, WEXITED))
+		return 4;
+	if (info.si_code != CLD_EXITED || info.si_status)
+		return 5;
+	return close(fd) ? 6 : 0;
+}
+
+enum bad_pointer {
+	BAD_PATH,
+	BAD_ARGV,
+	BAD_ENVP,
+	BAD_ACTIONS,
+};
+
+static int reject_bad_pointer(enum bad_pointer bad)
+{
+	char * const argv[] = { "true", NULL };
+	char * const envp[] = { NULL };
+	const char *path = "/bin/true";
+	struct pidfd_spawn_action action = {
+		.type = PIDFD_SPAWN_ACTION_DUP2,
+		.fd = STDOUT_FILENO,
+		.newfd = STDOUT_FILENO,
+	};
+	struct pidfd_spawn_run_args args = {
+		.path = compat_ptr64(path),
+		.argv = compat_ptr64(argv),
+		.envp = compat_ptr64(envp),
+		.actions = compat_ptr64(&action),
+		.nr_actions = 1,
+		.action_size = sizeof(action),
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int fd;
+
+	switch (bad) {
+	case BAD_PATH:
+		args.path = invalid_full_width_ptr(path);
+		break;
+	case BAD_ARGV:
+		args.argv = invalid_full_width_ptr(argv);
+		break;
+	case BAD_ENVP:
+		args.envp = invalid_full_width_ptr(envp);
+		break;
+	case BAD_ACTIONS:
+		args.actions = invalid_full_width_ptr(&action);
+		break;
+	}
+	fd = syscall(__NR_pidfd_open, 0, PIDFD_EMPTY);
+	if (fd < 0)
+		return 1;
+	errno = 0;
+	if (syscall(__NR_pidfd_spawn_run, fd, &args, sizeof(args)) != -1 ||
+	    errno != EFAULT)
+		return 2;
+	errno = 0;
+	if (ioctl(fd, PIDFD_GET_INFO, &info) != -1 || errno != ESRCH)
+		return 3;
+	errno = 0;
+	if (syscall(__NR_pidfd_spawn_run, fd, &args, sizeof(args)) != -1 ||
+	    errno != EBUSY)
+		return 4;
+	return close(fd) ? 5 : 0;
+}
+
+int main(int argc, char **argv)
+{
+	const char *stage = "direct path";
+	enum bad_pointer bad;
+	int fd;
+	int ret;
+
+	if (argc == 2 && !strcmp(argv[1], "--exit0"))
+		return 0;
+	if (argc == 2 && !strcmp(argv[1], "--check-empty-env"))
+		return environ[0] ? 1 : 0;
+	fd = syscall(__NR_pidfd_open, 0, PIDFD_EMPTY);
+	if (fd < 0 && (errno == EINVAL || errno == ENOSYS)) {
+		ksft_print_msg("pidfd spawn is unavailable: %s\n",
+			       strerror(errno));
+		return KSFT_SKIP;
+	}
+	if (fd < 0 || close(fd)) {
+		fprintf(stderr, "compat pidfd spawn feature probe failed: %s\n",
+			strerror(errno));
+		return 1;
+	}
+	ret = run_child(false);
+	if (!ret) {
+		stage = "staged path";
+		ret = run_child(true);
+	}
+	if (!ret) {
+		stage = "empty env";
+		ret = run_empty_env();
+	}
+	for (bad = BAD_PATH; bad <= BAD_ACTIONS && !ret; bad++) {
+		stage = "bad pointer";
+		ret = reject_bad_pointer(bad);
+	}
+	if (ret)
+		fprintf(stderr, "compat pidfd spawn %s failed at step %d: %s\n",
+			stage, ret, strerror(errno));
+	return ret ? KSFT_FAIL : KSFT_PASS;
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
new file mode 100644
index 0000000000000..c03f8d2ee69c8
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/pidfd_spawn.h>
+#include <poll.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/epoll.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+TEST(pidfd_spawn_run_execs_path_without_config)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_execs_proc_self_exe)
+{
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	int fd;
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, "/proc/self/exe", argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_uses_current_source_cwd)
+{
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	const char *relative;
+	char *storage;
+	int cwd_fd;
+	int fd;
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	cwd_fd = enter_self_exe_directory(&storage, &relative);
+	ASSERT_GE(cwd_fd, 0);
+	ASSERT_EQ(spawn_run_path(fd, relative, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(leave_self_exe_directory(cwd_fd, storage), 0);
+}
+
+TEST(pidfd_spawn_run_inherits_new_non_cloexec_fd)
+{
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "fd-open", fdarg,
+				NULL };
+	int inherited_fd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	inherited_fd = open("/dev/null", O_RDONLY);
+	ASSERT_GE(inherited_fd, 0);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", inherited_fd), 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(inherited_fd), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_honors_new_cloexec_fd)
+{
+	const char *path = self_exe_path();
+	char fdarg[32];
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "fd-closed", fdarg,
+				NULL };
+	int inherited_fd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	inherited_fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(inherited_fd, 0);
+	ASSERT_GT(snprintf(fdarg, sizeof(fdarg), "%d", inherited_fd), 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(inherited_fd), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_accepts_null_envp)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "empty-env", NULL };
+	struct pidfd_spawn_run_args args = {
+		.path = ptr_to_u64(path),
+		.argv = ptr_to_u64(argv),
+	};
+	int child_pid;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	child_pid = sys_pidfd_spawn_run(fd, &args, sizeof(args));
+	ASSERT_GT(child_pid, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_exec_failure_publishes_waitable_child)
+{
+	const char *path = self_exe_path();
+	char * const bad_argv[] = { "missing-pidfd-spawn-helper", NULL };
+	char * const good_argv[] = { "pidfd_spawn_exec_test",
+				     "--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int ret;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	errno = 0;
+	ret = spawn_run_path(fd, "/no/such/pidfd-spawn-helper", bad_argv,
+			     NULL, 0);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOENT);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), 0);
+	ASSERT_GT(info.pid, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 127), 0);
+	ASSERT_EQ(spawn_run_path(fd, path, good_argv, NULL, 0), -1);
+	ASSERT_EQ(errno, EBUSY);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_pre_task_failure_is_terminal)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_args args = {
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct epoll_event interest = {
+		.events = EPOLLIN,
+	};
+	struct epoll_event event = {};
+	struct pollfd pfd = {
+		.events = POLLIN,
+	};
+	int epoll_fd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	ASSERT_GE(epoll_fd, 0);
+	interest.data.fd = fd;
+	ASSERT_EQ(epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &interest), 0);
+	ASSERT_EQ(sys_pidfd_spawn_run(fd, &args, sizeof(args)), -1);
+	ASSERT_EQ(errno, EINVAL);
+	pfd.fd = fd;
+	ASSERT_EQ(poll(&pfd, 1, 0), 1);
+	ASSERT_EQ(pfd.revents & (POLLERR | POLLHUP), POLLERR | POLLHUP);
+	ASSERT_EQ(epoll_wait(epoll_fd, &event, 1, 0), 1);
+	ASSERT_EQ(event.data.fd, fd);
+	ASSERT_EQ(event.events & (EPOLLERR | EPOLLHUP),
+		  EPOLLERR | EPOLLHUP);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), -1);
+	ASSERT_EQ(errno, EBUSY);
+	ASSERT_EQ(close(epoll_fd), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_staged_path_conflict_precedes_path_uaccess)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_args args = {
+		.path = ptr_to_u64(MAP_FAILED),
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(config_path(fd, path), 0);
+	ASSERT_EQ(sys_pidfd_spawn_run(fd, &args, sizeof(args)), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_exec_failure_survives_auto_reap)
+{
+	char * const argv[] = { "missing-pidfd-spawn-helper", NULL };
+	struct sigaction ignored = {
+		.sa_handler = SIG_IGN,
+	};
+	struct pidfd_info info;
+	struct sigaction old;
+	siginfo_t wait_info = {};
+	int saved_errno;
+	int ret;
+	int fd;
+
+	sigemptyset(&ignored.sa_mask);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(sigaction(SIGCHLD, &ignored, &old), 0);
+	ret = spawn_run_path(fd, "/no/such/pidfd-spawn-helper", argv, NULL, 0);
+	saved_errno = errno;
+	ASSERT_EQ(wait_pidfd_exit_info(fd, &info), 0);
+	ASSERT_EQ(sigaction(SIGCHLD, &old, NULL), 0);
+	errno = saved_errno;
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, ENOENT);
+	ASSERT_NE(info.mask & PIDFD_INFO_EXIT, 0);
+	ASSERT_EQ(info.exit_code, 127 << 8);
+	ASSERT_EQ(sys_waitid(P_PIDFD, fd, &wait_info, WEXITED | WNOHANG), -1);
+	ASSERT_EQ(errno, ECHILD);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_args_are_input_only)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_exec_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	long page_size = sysconf(_SC_PAGESIZE);
+	struct pidfd_spawn_run_args *args;
+	void *page;
+	int fd;
+
+	ASSERT_GT(page_size, 0);
+	ASSERT_NE(path, NULL);
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(page, MAP_FAILED);
+	args = page;
+	*args = (struct pidfd_spawn_run_args) {
+		.path = ptr_to_u64(path),
+		.argv = ptr_to_u64(argv),
+		.envp = ptr_to_u64(empty_envp),
+	};
+	ASSERT_EQ(mprotect(page, page_size, PROT_READ), 0);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(sys_pidfd_spawn_run(fd, args, sizeof(*args)), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(munmap(page, page_size), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
new file mode 100644
index 0000000000000..87c03007f793b
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <asm/unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/pidfd_spawn.h>
+#include <linux/seccomp.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+static int
+pidfd_spawn_landlock_create_ruleset(const struct landlock_ruleset_attr *attr)
+{
+	return syscall(__NR_landlock_create_ruleset, attr, sizeof(*attr), 0);
+}
+
+static int pidfd_spawn_landlock_restrict_self(int ruleset_fd)
+{
+	return syscall(__NR_landlock_restrict_self, ruleset_fd, 0);
+}
+
+static int pidfd_spawn_landlock_worker(const char *path)
+{
+	char * const argv[] = { "pidfd_spawn_policy_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_fs = LANDLOCK_ACCESS_FS_EXECUTE,
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int ruleset_fd;
+	int builder;
+	int ret;
+
+	ruleset_fd = pidfd_spawn_landlock_create_ruleset(&ruleset_attr);
+	if (ruleset_fd < 0)
+		return errno == ENOMSG || errno == EOPNOTSUPP ? 77 : 1;
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) ||
+	    pidfd_spawn_landlock_restrict_self(ruleset_fd)) {
+		close(ruleset_fd);
+		return 2;
+	}
+	close(ruleset_fd);
+
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		return 3;
+	errno = 0;
+	ret = spawn_run_path(builder, path, argv, NULL, 0);
+	if (ret != -1 || errno != EACCES) {
+		if (!ret)
+			wait_pidfd_exit(builder, 0);
+		close(builder);
+		return 4;
+	}
+	if (ioctl(builder, PIDFD_GET_INFO, &info) || !info.pid) {
+		close(builder);
+		return 5;
+	}
+	if (wait_pidfd_exit(builder, 127)) {
+		close(builder);
+		return 6;
+	}
+	return close(builder) ? 7 : 0;
+}
+
+static int pidfd_spawn_install_seccomp(struct sock_filter *filter,
+				       size_t nr_filter)
+{
+	struct sock_fprog program = {
+		.len = nr_filter,
+		.filter = filter,
+	};
+
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0))
+		return -errno;
+	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &program))
+		return -errno;
+	return 0;
+}
+
+static int pidfd_spawn_seccomp_setup_worker(const char *path)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+#ifdef __NR_dup2
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_dup2, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EPERM),
+#endif
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_close_range, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EPERM),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_fchdir, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EPERM),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_execve, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EPERM),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_execveat, 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EPERM),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct pidfd_spawn_action actions[] = {
+		{
+			.type = PIDFD_SPAWN_ACTION_DUP2,
+		},
+		{
+			.type = PIDFD_SPAWN_ACTION_CLOSE_RANGE,
+		},
+		{
+			.type = PIDFD_SPAWN_ACTION_FCHDIR,
+		},
+	};
+	char template[] = "/tmp/pidfd-spawn-seccomp.XXXXXX";
+	char target_arg[32];
+	char closed_arg[32];
+	char cwd_arg[32];
+	char * const argv[] = { "pidfd_spawn_policy_test",
+				"--pidfd-spawn-helper", "seccomp-actions",
+				target_arg, closed_arg, cwd_arg, template, NULL };
+	int target = 200;
+	int devnull = -1;
+	int builder = -1;
+	int cwd = -1;
+	int result = 0;
+	int ret;
+
+	if (!mkdtemp(template))
+		return 1;
+	cwd = open(template, O_PATH | O_DIRECTORY);
+	if (cwd < 0) {
+		result = 2;
+		goto out;
+	}
+	devnull = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	if (devnull < 0) {
+		result = 3;
+		goto out;
+	}
+	builder = sys_pidfd_empty_open();
+	if (builder < 0) {
+		result = 4;
+		goto out;
+	}
+	actions[0].fd = devnull;
+	actions[0].newfd = target;
+	actions[1].fd = devnull;
+	actions[1].newfd = devnull;
+	actions[2].fd = cwd;
+	snprintf(target_arg, sizeof(target_arg), "%d", target);
+	snprintf(closed_arg, sizeof(closed_arg), "%d", devnull);
+	snprintf(cwd_arg, sizeof(cwd_arg), "%d", cwd);
+
+	ret = pidfd_spawn_install_seccomp(filter, ARRAY_SIZE(filter));
+	if (ret) {
+		result = ret == -EINVAL || ret == -ENOSYS ? 77 : 5;
+		goto out;
+	}
+	ret = spawn_run_path(builder, path, argv, actions,
+			     ARRAY_SIZE(actions));
+	if (ret) {
+		result = 6;
+		goto out;
+	}
+	if (wait_pidfd_exit(builder, 0))
+		result = 7;
+out:
+	if (builder >= 0 && close(builder) && !result)
+		result = 8;
+	if (devnull >= 0 && close(devnull) && !result)
+		result = 9;
+	if (cwd >= 0 && close(cwd) && !result)
+		result = 10;
+	if (rmdir(template) && !result)
+		result = 11;
+	return result;
+}
+
+static int pidfd_spawn_seccomp_run_worker(const char *path)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_pidfd_spawn_run,
+			 0, 1),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | EACCES),
+		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
+	};
+	char * const argv[] = { "pidfd_spawn_policy_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	int builder;
+	int ret;
+
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		return 1;
+	ret = pidfd_spawn_install_seccomp(filter, ARRAY_SIZE(filter));
+	if (ret)
+		return ret == -EINVAL || ret == -ENOSYS ? 77 : 2;
+	errno = 0;
+	if (spawn_run_path(builder, path, argv, NULL, 0) != -1 ||
+	    errno != EACCES)
+		return 3;
+	errno = 0;
+	if (ioctl(builder, PIDFD_GET_INFO, &info) != -1 || errno != ESRCH)
+		return 4;
+	if (config_path(builder, path))
+		return 5;
+	return close(builder) ? 6 : 0;
+}
+
+TEST(pidfd_spawn_landlock_exec_denial_is_reported)
+{
+	const char *path = self_exe_path();
+	pid_t worker;
+	pid_t waited;
+	int status;
+
+	ASSERT_NE(path, NULL);
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker)
+		_exit(pidfd_spawn_landlock_worker(path));
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	ASSERT_EQ(waited, worker);
+	ASSERT_TRUE(WIFEXITED(status));
+	if (WEXITSTATUS(status) == 77)
+		SKIP(return, "Landlock is unavailable");
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST(pidfd_spawn_seccomp_uses_spawn_syscall_boundary)
+{
+	const char *path = self_exe_path();
+	pid_t worker;
+	pid_t waited;
+	int status;
+
+	ASSERT_NE(path, NULL);
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker)
+		_exit(pidfd_spawn_seccomp_setup_worker(path));
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	ASSERT_EQ(waited, worker);
+	ASSERT_TRUE(WIFEXITED(status));
+	if (WEXITSTATUS(status) == 77)
+		SKIP(return, "seccomp filters are unavailable");
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST(pidfd_spawn_seccomp_run_filter_keeps_builder_taskless)
+{
+	const char *path = self_exe_path();
+	pid_t worker;
+	pid_t waited;
+	int status;
+
+	ASSERT_NE(path, NULL);
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker)
+		_exit(pidfd_spawn_seccomp_run_worker(path));
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	ASSERT_EQ(waited, worker);
+	ASSERT_TRUE(WIFEXITED(status));
+	if (WEXITSTATUS(status) == 77)
+		SKIP(return, "seccomp filters are unavailable");
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_race_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
new file mode 100644
index 0000000000000..19a82c77e5bc9
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
@@ -0,0 +1,923 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/pidfd_spawn.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+struct pidfd_spawn_run_result {
+	int ret;
+	int error;
+	int wait_error;
+};
+
+struct pidfd_spawn_concurrent_run {
+	pthread_barrier_t *barrier;
+	char * const *argv;
+	const char *path;
+	int fd;
+	int ret;
+	int error;
+	int barrier_error;
+};
+
+static void *pidfd_spawn_concurrent_run(void *data)
+{
+	struct pidfd_spawn_concurrent_run *run = data;
+	int ret;
+
+	ret = pthread_barrier_wait(run->barrier);
+	if (ret && ret != PTHREAD_BARRIER_SERIAL_THREAD) {
+		run->barrier_error = ret;
+		return NULL;
+	}
+
+	errno = 0;
+	run->ret = spawn_run_path_pid(run->fd, run->path, run->argv,
+				      NULL, 0);
+	run->error = errno;
+	return NULL;
+}
+
+static int wait_readable(int fd, int timeout_ms)
+{
+	struct pollfd pfd = {
+		.fd = fd,
+		.events = POLLIN,
+	};
+	int ret;
+
+	do {
+		ret = poll(&pfd, 1, timeout_ms);
+	} while (ret < 0 && errno == EINTR);
+	if (ret <= 0) {
+		if (!ret)
+			errno = ETIMEDOUT;
+		return -1;
+	}
+	if (!(pfd.revents & (POLLIN | POLLHUP))) {
+		errno = EIO;
+		return -1;
+	}
+	return 0;
+}
+
+static int read_result(int socket, struct pidfd_spawn_run_result *result)
+{
+	ssize_t len;
+
+	if (wait_readable(socket, PIDFD_SPAWN_TIMEOUT_MS))
+		return -1;
+	do {
+		len = read(socket, result, sizeof(*result));
+	} while (len < 0 && errno == EINTR);
+	if (len != sizeof(*result)) {
+		errno = len < 0 ? errno : EIO;
+		return -1;
+	}
+	return 0;
+}
+
+static bool race_check(bool condition, int *failure_errno,
+		       int *failure_line, int line)
+{
+	if (condition)
+		return true;
+
+	*failure_errno = errno;
+	*failure_line = line;
+	return false;
+}
+
+static int open_missing_userfaultfd(void *fault_page, long page_size)
+{
+	struct uffdio_register registration = {
+		.range = {
+			.start = (uintptr_t)fault_page,
+			.len = page_size,
+		},
+		.mode = UFFDIO_REGISTER_MODE_MISSING,
+	};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	int saved_errno;
+	int uffd;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		return -1;
+	if (!ioctl(uffd, UFFDIO_API, &api) &&
+	    !ioctl(uffd, UFFDIO_REGISTER, &registration))
+		return uffd;
+
+	saved_errno = errno;
+	close(uffd);
+	errno = saved_errno;
+	return -1;
+}
+
+static void pidfd_spawn_blocked_exec_worker(int socket, void *fault_page,
+					    long page_size, pid_t parent,
+					    const char *path,
+					    int expected_signal)
+{
+	char * const argv[] = { fault_page, "--pidfd-spawn-helper", "exit0",
+				NULL };
+	struct pidfd_spawn_run_result result = {};
+	sigset_t unblocked;
+	int bootstrap[2];
+	int builder;
+	int uffd;
+
+	if (expected_signal) {
+		sigemptyset(&unblocked);
+		sigaddset(&unblocked, expected_signal);
+		if (signal(expected_signal, SIG_DFL) == SIG_ERR ||
+		    sigprocmask(SIG_UNBLOCK, &unblocked, NULL))
+			_exit(99);
+	}
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(100);
+	uffd = open_missing_userfaultfd(fault_page, page_size);
+	if (uffd < 0)
+		_exit(101);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(102);
+	bootstrap[0] = builder;
+	bootstrap[1] = uffd;
+	if (send_fds_status(socket, 0, bootstrap, ARRAY_SIZE(bootstrap)))
+		_exit(103);
+	close(uffd);
+
+	errno = 0;
+	result.ret = spawn_run_path_pid(builder, path, argv, NULL, 0);
+	result.error = errno;
+	if (result.ret > 0 && expected_signal)
+		result.wait_error = wait_pidfd_signal(builder, expected_signal);
+	else if (result.ret > 0)
+		result.wait_error = wait_pidfd_exit(builder, 0);
+	else
+		result.wait_error = -1;
+	if (write(socket, &result, sizeof(result)) != sizeof(result))
+		_exit(104);
+	close(builder);
+	close(socket);
+	_exit(0);
+}
+
+static void pidfd_spawn_cancel_worker(int socket, void *fault_page,
+				      long page_size, pid_t parent,
+				      const char *path)
+{
+	char * const argv[] = { fault_page, "--pidfd-spawn-helper", "exit0",
+				NULL };
+	int bootstrap[2];
+	int builder;
+	int uffd;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(110);
+	uffd = open_missing_userfaultfd(fault_page, page_size);
+	if (uffd < 0)
+		_exit(111);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(112);
+	bootstrap[0] = builder;
+	bootstrap[1] = uffd;
+	if (send_fds_status(socket, 0, bootstrap, ARRAY_SIZE(bootstrap)))
+		_exit(113);
+	close(uffd);
+
+	spawn_run_path_pid(builder, path, argv, NULL, 0);
+	_exit(114);
+}
+
+static void pidfd_spawn_claim_worker(int socket, void *fault_page,
+				     long page_size, pid_t parent)
+{
+	struct pidfd_spawn_run_result result = {
+		.wait_error = -1,
+	};
+	int bootstrap[2];
+	int builder;
+	int uffd;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(120);
+	uffd = open_missing_userfaultfd(fault_page, page_size);
+	if (uffd < 0)
+		_exit(121);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(122);
+	bootstrap[0] = builder;
+	bootstrap[1] = uffd;
+	if (send_fds_status(socket, 0, bootstrap, ARRAY_SIZE(bootstrap)))
+		_exit(123);
+	close(uffd);
+
+	errno = 0;
+	result.ret = sys_pidfd_spawn_run(builder, fault_page,
+					 sizeof(struct pidfd_spawn_run_args));
+	result.error = errno;
+	if (write(socket, &result, sizeof(result)) != sizeof(result))
+		_exit(124);
+	close(builder);
+	close(socket);
+	_exit(0);
+}
+
+#define PIDFD_SPAWN_RUN_RACE_ITERATIONS 16
+
+TEST(pidfd_spawn_concurrent_runs_have_one_winner)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_race_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	unsigned int iteration;
+
+	ASSERT_NE(path, NULL);
+	for (iteration = 0; iteration < PIDFD_SPAWN_RUN_RACE_ITERATIONS;
+	     iteration++) {
+		struct pidfd_spawn_concurrent_run runs[2] = {};
+		pthread_barrier_t barrier;
+		pthread_t threads[2];
+		void *thread_ret;
+		unsigned int busy = 0;
+		unsigned int success = 0;
+		unsigned int i;
+		int ret;
+		int fd;
+
+		fd = sys_pidfd_empty_open();
+		ASSERT_GE(fd, 0);
+		ASSERT_EQ(pthread_barrier_init(&barrier, NULL, 3), 0);
+		for (i = 0; i < ARRAY_SIZE(runs); i++) {
+			runs[i].barrier = &barrier;
+			runs[i].argv = argv;
+			runs[i].path = path;
+			runs[i].fd = fd;
+			ret = pthread_create(&threads[i], NULL,
+					     pidfd_spawn_concurrent_run, &runs[i]);
+			ASSERT_EQ(ret, 0);
+		}
+		ret = pthread_barrier_wait(&barrier);
+		ASSERT_TRUE(!ret || ret == PTHREAD_BARRIER_SERIAL_THREAD);
+		for (i = 0; i < ARRAY_SIZE(runs); i++) {
+			ret = pthread_join_timeout(threads[i], &thread_ret,
+						   PIDFD_SPAWN_TIMEOUT_MS);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(thread_ret, NULL);
+			ASSERT_EQ(runs[i].barrier_error, 0);
+			if (runs[i].ret > 0) {
+				success++;
+				continue;
+			}
+			ASSERT_EQ(runs[i].ret, -1);
+			ASSERT_EQ(runs[i].error, EBUSY);
+			busy++;
+		}
+		ASSERT_EQ(success, 1);
+		ASSERT_EQ(busy, 1);
+		ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+		ASSERT_EQ(pthread_barrier_destroy(&barrier), 0);
+		ASSERT_EQ(close(fd), 0);
+	}
+}
+
+TEST(pidfd_spawn_fatal_signal_cancels_child)
+{
+	struct uffdio_zeropage zeropage = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct uffd_msg message;
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_race_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	bool worker_reaped = false;
+	long page_size;
+	void *fault_page;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+
+#define RACE_CHECK(condition) \
+	race_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	fault_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(fault_page, MAP_FAILED);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_cancel_worker(sockets[1], fault_page, page_size,
+					  parent, path);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+
+	if (!RACE_CHECK(!wait_readable(uffd, PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!RACE_CHECK(read(uffd, &message, sizeof(message)) ==
+							 sizeof(message)))
+		goto cleanup;
+	if (!RACE_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!RACE_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!RACE_CHECK(info.pid > 0))
+		goto cleanup;
+	if (!RACE_CHECK(!kill(worker, SIGKILL)))
+		goto cleanup;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!RACE_CHECK(WIFSIGNALED(status)))
+		goto cleanup;
+	if (!RACE_CHECK(WTERMSIG(status) == SIGKILL))
+		goto cleanup;
+	if (!RACE_CHECK(!wait_pidfd_exit_info(builder, &info)))
+		goto cleanup;
+	if (!RACE_CHECK(WIFSIGNALED(info.exit_code)))
+		goto cleanup;
+	if (!RACE_CHECK(WTERMSIG(info.exit_code) == SIGKILL))
+		goto cleanup;
+	if (!RACE_CHECK(spawn_run_path_pid(builder, path, argv, NULL, 0) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == EBUSY))
+		goto cleanup;
+
+cleanup:
+	if (uffd >= 0) {
+		zeropage.range.start = (uintptr_t)fault_page;
+		zeropage.range.len = page_size;
+		ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage);
+	}
+	if (!worker_reaped && worker > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	munmap(fault_page, page_size);
+	if (failure_line)
+		TH_LOG("cancellation test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef RACE_CHECK
+}
+
+TEST(pidfd_spawn_default_fatal_signal_wins_during_setup)
+{
+	struct uffdio_copy copy = {};
+	struct uffdio_zeropage zeropage = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct uffd_msg message;
+	const char *path = self_exe_path();
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	bool page_resolved = false;
+	bool worker_reaped = false;
+	long page_size;
+	void *fault_page;
+	void *source_page;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int child_pid = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+
+#define RACE_CHECK(condition) \
+	race_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	fault_page = mmap(NULL, page_size * 2, PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(fault_page, MAP_FAILED);
+	ASSERT_EQ(mprotect(fault_page + page_size, page_size, PROT_NONE), 0);
+	source_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(source_page, MAP_FAILED);
+	memset(source_page, 'x', page_size);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_blocked_exec_worker(sockets[1], fault_page,
+						page_size, parent, path,
+						SIGSEGV);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+
+	if (!RACE_CHECK(!wait_readable(uffd, PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!RACE_CHECK(read(uffd, &message, sizeof(message)) ==
+							 sizeof(message)))
+		goto cleanup;
+	if (!RACE_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!RACE_CHECK((message.arg.pagefault.address & ~(page_size - 1)) ==
+			(uintptr_t)fault_page))
+		goto cleanup;
+	if (!RACE_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!RACE_CHECK(info.pid > 0))
+		goto cleanup;
+	child_pid = info.pid;
+	if (!RACE_CHECK(!sys_pidfd_send_signal(builder, SIGSEGV, NULL, 0)))
+		goto cleanup;
+	copy.src = (uintptr_t)source_page;
+	copy.dst = (uintptr_t)fault_page;
+	copy.len = page_size;
+	if (!RACE_CHECK(!ioctl(uffd, UFFDIO_COPY, &copy)))
+		goto cleanup;
+	page_resolved = true;
+	if (!RACE_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!RACE_CHECK(result.ret == child_pid))
+		goto cleanup;
+	if (!RACE_CHECK(!result.error))
+		goto cleanup;
+	if (!RACE_CHECK(!result.wait_error))
+		goto cleanup;
+	if (!RACE_CHECK(!wait_pidfd_exit_info(builder, &info)))
+		goto cleanup;
+	if (!RACE_CHECK(WIFSIGNALED(info.exit_code)))
+		goto cleanup;
+	if (!RACE_CHECK(WTERMSIG(info.exit_code) == SIGSEGV))
+		goto cleanup;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!RACE_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!RACE_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (!page_resolved && uffd >= 0) {
+		zeropage.range.start = (uintptr_t)fault_page;
+		zeropage.range.len = page_size;
+		ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage);
+	}
+	if (!worker_reaped && worker > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	munmap(source_page, page_size);
+	munmap(fault_page, page_size * 2);
+	if (failure_line)
+		TH_LOG("default-fatal test failed at line %d: %s",
+		       failure_line, strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef RACE_CHECK
+}
+
+TEST(pidfd_spawn_claim_precedes_run_uaccess)
+{
+	struct uffdio_zeropage zeropage = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct pollfd pidfd_poll = {
+		.events = POLLIN,
+	};
+	struct uffd_msg message;
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_race_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	bool worker_reaped = false;
+	bool page_resolved = false;
+	long page_size;
+	void *fault_page;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+
+#define RACE_CHECK(condition) \
+	race_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	fault_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(fault_page, MAP_FAILED);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_claim_worker(sockets[1], fault_page, page_size,
+					 parent);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+	pidfd_poll.fd = builder;
+
+	if (!RACE_CHECK(!wait_readable(uffd, PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!RACE_CHECK(read(uffd, &message, sizeof(message)) ==
+							 sizeof(message)))
+		goto cleanup;
+	if (!RACE_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!RACE_CHECK(config_path(builder, path) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == EBUSY))
+		goto cleanup;
+	if (!RACE_CHECK(spawn_run_path_pid(builder, path, argv, NULL, 0) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == EBUSY))
+		goto cleanup;
+	if (!RACE_CHECK(ioctl(builder, PIDFD_GET_INFO, &info) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == ESRCH))
+		goto cleanup;
+	if (!RACE_CHECK(sys_pidfd_send_signal(builder, 0, NULL, 0) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == ESRCH))
+		goto cleanup;
+	if (!RACE_CHECK(poll(&pidfd_poll, 1, 0) == 0))
+		goto cleanup;
+
+	zeropage.range.start = (uintptr_t)fault_page;
+	zeropage.range.len = page_size;
+	if (!RACE_CHECK(!ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage)))
+		goto cleanup;
+	page_resolved = true;
+	if (!RACE_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!RACE_CHECK(result.ret == -1))
+		goto cleanup;
+	if (!RACE_CHECK(result.error == EINVAL))
+		goto cleanup;
+	if (!RACE_CHECK(result.wait_error == -1))
+		goto cleanup;
+	if (!RACE_CHECK(spawn_run_path_pid(builder, path, argv, NULL, 0) == -1))
+		goto cleanup;
+	if (!RACE_CHECK(errno == EBUSY))
+		goto cleanup;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!RACE_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!RACE_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (!page_resolved && uffd >= 0) {
+		zeropage.range.start = (uintptr_t)fault_page;
+		zeropage.range.len = page_size;
+		ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage);
+	}
+	if (!worker_reaped && worker > 0) {
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	munmap(fault_page, page_size);
+	if (failure_line)
+		TH_LOG("claim test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef RACE_CHECK
+}
+
+TEST(pidfd_spawn_publication_precedes_exec_completion)
+{
+	struct uffdio_zeropage zeropage = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID | PIDFD_INFO_COREDUMP,
+	};
+	struct pollfd result_poll = {
+		.events = POLLIN,
+	};
+	struct uffd_msg message;
+	const char *path = self_exe_path();
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	struct stat builder_stat;
+	struct stat opened_stat;
+	bool worker_reaped = false;
+	bool page_resolved = false;
+	long page_size;
+	void *fault_page;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int opened = -1;
+	int builder = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+
+#define RACE_CHECK(condition) \
+	race_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	fault_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(fault_page, MAP_FAILED);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_blocked_exec_worker(sockets[1], fault_page,
+						page_size, parent, path, 0);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!RACE_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+
+	if (!RACE_CHECK(!wait_readable(uffd, PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!RACE_CHECK(read(uffd, &message, sizeof(message)) ==
+							 sizeof(message)))
+		goto cleanup;
+	if (!RACE_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!RACE_CHECK((message.arg.pagefault.address & ~(page_size - 1)) ==
+			(uintptr_t)fault_page))
+		goto cleanup;
+	if (!RACE_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!RACE_CHECK(info.pid > 0))
+		goto cleanup;
+	if (!RACE_CHECK(info.mask & PIDFD_INFO_COREDUMP))
+		goto cleanup;
+	if (!RACE_CHECK(info.coredump_mask == PIDFD_COREDUMP_SKIP))
+		goto cleanup;
+	if (!RACE_CHECK(!(info.mask & (PIDFD_INFO_COREDUMP_SIGNAL |
+				       PIDFD_INFO_COREDUMP_CODE))))
+		goto cleanup;
+	if (!RACE_CHECK(!info.coredump_signal && !info.coredump_code))
+		goto cleanup;
+	opened = sys_pidfd_open(info.pid, 0);
+	if (!RACE_CHECK(opened >= 0))
+		goto cleanup;
+	if (!RACE_CHECK(!fstat(builder, &builder_stat)))
+		goto cleanup;
+	if (!RACE_CHECK(!fstat(opened, &opened_stat)))
+		goto cleanup;
+	if (!RACE_CHECK(builder_stat.st_dev == opened_stat.st_dev))
+		goto cleanup;
+	if (!RACE_CHECK(builder_stat.st_ino == opened_stat.st_ino))
+		goto cleanup;
+	result_poll.fd = sockets[0];
+	if (!RACE_CHECK(poll(&result_poll, 1, 0) == 0))
+		goto cleanup;
+
+	zeropage.range.start = (uintptr_t)fault_page;
+	zeropage.range.len = page_size;
+	if (!RACE_CHECK(!ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage)))
+		goto cleanup;
+	page_resolved = true;
+	if (!RACE_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!RACE_CHECK(result.ret == info.pid))
+		goto cleanup;
+	if (!RACE_CHECK(!result.error))
+		goto cleanup;
+	if (!RACE_CHECK(!result.wait_error))
+		goto cleanup;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!RACE_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!RACE_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!RACE_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (!page_resolved && uffd >= 0) {
+		zeropage.range.start = (uintptr_t)fault_page;
+		zeropage.range.len = page_size;
+		ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage);
+	}
+	if (!worker_reaped && worker > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (opened >= 0)
+		close(opened);
+	if (builder >= 0)
+		close(builder);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	munmap(fault_page, page_size);
+	if (failure_line)
+		TH_LOG("publication test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef RACE_CHECK
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_security_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
new file mode 100644
index 0000000000000..4da23384e8b79
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
@@ -0,0 +1,1242 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/pidfd_spawn.h>
+#include <linux/userfaultfd.h>
+#include <poll.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/fsuid.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/ptrace.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "pidfd_spawn_common.h"
+
+struct pidfd_spawn_run_result {
+	int ret;
+	int error;
+	int wait_error;
+};
+
+struct pidfd_spawn_cred_test {
+	const char *path;
+	int builder;
+	int setup_error;
+	int restore_error;
+	int config_ret;
+	int config_error;
+	int run_ret;
+	int run_error;
+};
+
+struct pidfd_spawn_pidns_test {
+	const char *path;
+	int builder;
+	int setup_error;
+	int config_ret;
+	int config_error;
+	int run_ret;
+	int run_error;
+};
+
+#define PIDFD_SPAWN_UNPRIVILEGED_ID 65534
+#define PIDFD_SPAWN_SLEEP_PATH "/bin/sleep"
+
+static void *pidfd_spawn_changed_cred_thread(void *data)
+{
+	struct pidfd_spawn_cred_test *test = data;
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	uid_t original;
+	uid_t target;
+
+	original = setfsuid((uid_t)-1);
+	target = original ? 0 : 1;
+	setfsuid(target);
+	if (setfsuid((uid_t)-1) != target) {
+		test->setup_error = EPERM;
+		return NULL;
+	}
+
+	errno = 0;
+	test->config_ret = config_path(test->builder, test->path);
+	test->config_error = errno;
+	errno = 0;
+	test->run_ret = spawn_run_path_pid(test->builder, test->path, argv,
+					   NULL, 0);
+	test->run_error = errno;
+
+	setfsuid(original);
+	if (setfsuid((uid_t)-1) != original)
+		test->restore_error = EPERM;
+	return NULL;
+}
+
+static void *pidfd_spawn_changed_pidns_thread(void *data)
+{
+	struct pidfd_spawn_pidns_test *test = data;
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+
+	if (unshare(CLONE_NEWPID)) {
+		test->setup_error = errno;
+		return NULL;
+	}
+
+	errno = 0;
+	test->config_ret = config_path(test->builder, test->path);
+	test->config_error = errno;
+	errno = 0;
+	test->run_ret = spawn_run_path_pid(test->builder, test->path, argv,
+					   NULL, 0);
+	test->run_error = errno;
+	return NULL;
+}
+
+static int wait_readable(int fd, int timeout_ms)
+{
+	struct pollfd pfd = {
+		.fd = fd,
+		.events = POLLIN,
+	};
+	int ret;
+
+	do {
+		ret = poll(&pfd, 1, timeout_ms);
+	} while (ret < 0 && errno == EINTR);
+	if (ret <= 0) {
+		if (!ret)
+			errno = ETIMEDOUT;
+		return -1;
+	}
+	if (!(pfd.revents & (POLLIN | POLLHUP))) {
+		errno = EIO;
+		return -1;
+	}
+	return 0;
+}
+
+static int read_result(int socket, struct pidfd_spawn_run_result *result)
+{
+	ssize_t len;
+
+	if (wait_readable(socket, PIDFD_SPAWN_TIMEOUT_MS))
+		return -1;
+	do {
+		len = read(socket, result, sizeof(*result));
+	} while (len < 0 && errno == EINTR);
+	if (len != sizeof(*result)) {
+		errno = len < 0 ? errno : EIO;
+		return -1;
+	}
+	return 0;
+}
+
+static bool security_check(bool condition, int *failure_errno,
+			   int *failure_line, int line)
+{
+	if (condition)
+		return true;
+
+	*failure_errno = errno;
+	*failure_line = line;
+	return false;
+}
+
+static int open_missing_userfaultfd(void *fault_page, long page_size)
+{
+	struct uffdio_register registration = {
+		.range = {
+			.start = (uintptr_t)fault_page,
+			.len = page_size,
+		},
+		.mode = UFFDIO_REGISTER_MODE_MISSING,
+	};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	int saved_errno;
+	int uffd;
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (uffd < 0)
+		return -1;
+	if (!ioctl(uffd, UFFDIO_API, &api) &&
+	    !ioctl(uffd, UFFDIO_REGISTER, &registration))
+		return uffd;
+
+	saved_errno = errno;
+	close(uffd);
+	errno = saved_errno;
+	return -1;
+}
+
+static int pidfd_spawn_ptrace_preflight(const char *path)
+{
+	int ready_pipe[2] = { -1, -1 };
+	int release_pipe[2] = { -1, -1 };
+	bool attached = false;
+	char ready_arg[32];
+	char release_arg[32];
+	char byte = 1;
+	pid_t child = -1;
+	pid_t waited;
+	int saved_errno = 0;
+	int status = -1;
+	int ret = -1;
+
+	if (pipe(ready_pipe) || pipe(release_pipe))
+		goto out;
+	child = fork();
+	if (child < 0)
+		goto out;
+	if (!child) {
+		close(ready_pipe[0]);
+		close(release_pipe[1]);
+		if (snprintf(ready_arg, sizeof(ready_arg), "%d", ready_pipe[1]) < 0 ||
+		    snprintf(release_arg, sizeof(release_arg), "%d",
+			     release_pipe[0]) < 0)
+			_exit(120);
+		execl(path, path, "--pidfd-spawn-helper", "ready-wait-fd",
+		      ready_arg, release_arg, NULL);
+		_exit(121);
+	}
+	close(ready_pipe[1]);
+	ready_pipe[1] = -1;
+	close(release_pipe[0]);
+	release_pipe[0] = -1;
+	if (wait_readable(ready_pipe[0], PIDFD_SPAWN_TIMEOUT_MS))
+		goto out;
+	if (read(ready_pipe[0], &byte, sizeof(byte)) != sizeof(byte))
+		goto out;
+	if (ptrace(PTRACE_SEIZE, child, NULL, NULL))
+		goto out;
+	attached = true;
+	if (ptrace(PTRACE_INTERRUPT, child, NULL, NULL))
+		goto out;
+	waited = waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (waited != child || !WIFSTOPPED(status)) {
+		errno = EIO;
+		goto out;
+	}
+	if (ptrace(PTRACE_DETACH, child, NULL, NULL))
+		goto out;
+	attached = false;
+	if (write(release_pipe[1], &byte, sizeof(byte)) != sizeof(byte))
+		goto out;
+	waited = waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (waited != child || !WIFEXITED(status) || WEXITSTATUS(status)) {
+		errno = EIO;
+		goto out;
+	}
+	child = -1;
+	ret = 0;
+out:
+	saved_errno = errno;
+	if (attached && child > 0) {
+		ptrace(PTRACE_INTERRUPT, child, NULL, NULL);
+		waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+		ptrace(PTRACE_DETACH, child, NULL, NULL);
+	}
+	if (child > 0) {
+		kill(child, SIGKILL);
+		waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	}
+	if (ready_pipe[0] >= 0)
+		close(ready_pipe[0]);
+	if (ready_pipe[1] >= 0)
+		close(ready_pipe[1]);
+	if (release_pipe[0] >= 0)
+		close(release_pipe[0]);
+	if (release_pipe[1] >= 0)
+		close(release_pipe[1]);
+	errno = saved_errno;
+	return ret;
+}
+
+static void pidfd_spawn_ptrace_worker(int socket, void *fault_page,
+				      long page_size, pid_t parent,
+				      const char *path, int wait_fd,
+				      int release_fd)
+{
+	char fdarg[32];
+	char * const argv[] = { fault_page, "--pidfd-spawn-helper", "wait-fd",
+				fdarg, NULL };
+	struct pidfd_spawn_run_result result = {};
+	int bootstrap[2];
+	int builder;
+	int uffd;
+	int len;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(100);
+	close(release_fd);
+	len = snprintf(fdarg, sizeof(fdarg), "%d", wait_fd);
+	if (len < 0 || len >= sizeof(fdarg))
+		_exit(101);
+	uffd = open_missing_userfaultfd(fault_page, page_size);
+	if (uffd < 0)
+		_exit(102);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(103);
+	bootstrap[0] = builder;
+	bootstrap[1] = uffd;
+	if (send_fds_status(socket, 0, bootstrap, ARRAY_SIZE(bootstrap)))
+		_exit(104);
+	close(uffd);
+
+	errno = 0;
+	result.ret = spawn_run_path_pid(builder, path, argv, NULL, 0);
+	result.error = errno;
+	if (write(socket, &result, sizeof(result)) != sizeof(result))
+		_exit(105);
+	if (result.ret < 0)
+		_exit(106);
+	if (wait_pidfd_exit(builder, 0))
+		_exit(107);
+	close(wait_fd);
+	close(builder);
+	close(socket);
+	_exit(0);
+}
+
+static int pidfd_spawn_unprivileged_preflight(void)
+{
+	pid_t child;
+	pid_t waited;
+	int status;
+
+	child = fork();
+	if (child < 0)
+		return -1;
+	if (!child) {
+		if (setresgid(PIDFD_SPAWN_UNPRIVILEGED_ID,
+			      PIDFD_SPAWN_UNPRIVILEGED_ID,
+			      PIDFD_SPAWN_UNPRIVILEGED_ID) ||
+		    setresuid(PIDFD_SPAWN_UNPRIVILEGED_ID,
+			      PIDFD_SPAWN_UNPRIVILEGED_ID,
+			      PIDFD_SPAWN_UNPRIVILEGED_ID))
+			_exit(77);
+		if (access(PIDFD_SPAWN_SLEEP_PATH, X_OK))
+			_exit(78);
+		if (prctl(PR_SET_DUMPABLE, 1))
+			_exit(79);
+		_exit(0);
+	}
+
+	waited = waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (waited != child) {
+		kill(child, SIGKILL);
+		waitpid_timeout(child, &status, PIDFD_SPAWN_TIMEOUT_MS);
+		errno = ETIMEDOUT;
+		return -1;
+	}
+	if (!WIFEXITED(status)) {
+		errno = EIO;
+		return -1;
+	}
+	switch (WEXITSTATUS(status)) {
+	case 0:
+		return 0;
+	case 77:
+		errno = EPERM;
+		break;
+	case 78:
+		errno = EACCES;
+		break;
+	default:
+		errno = EINVAL;
+		break;
+	}
+	return -1;
+}
+
+static void pidfd_spawn_proc_worker(int socket, void *fault_page,
+				    long page_size, pid_t parent)
+{
+	char * const argv[] = { "sleep", fault_page, NULL };
+	struct pidfd_spawn_run_result result = {
+		.wait_error = -1,
+	};
+	char exec_path[64];
+	int bootstrap[2];
+	int builder;
+	int exec_fd;
+	int ret;
+	int uffd;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(130);
+	uffd = open_missing_userfaultfd(fault_page, page_size);
+	if (uffd < 0)
+		_exit(131);
+	if (setresgid(PIDFD_SPAWN_UNPRIVILEGED_ID,
+		      PIDFD_SPAWN_UNPRIVILEGED_ID,
+		      PIDFD_SPAWN_UNPRIVILEGED_ID) ||
+	    setresuid(PIDFD_SPAWN_UNPRIVILEGED_ID,
+		      PIDFD_SPAWN_UNPRIVILEGED_ID,
+		      PIDFD_SPAWN_UNPRIVILEGED_ID) ||
+	    prctl(PR_SET_DUMPABLE, 1) ||
+	    prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(132);
+	/*
+	 * Force the child to instantiate its numeric proc dentry before argv
+	 * copying reaches the userfaultfd stall. Keep the fd non-CLOEXEC so the
+	 * proc fd path remains usable throughout executable lookup.
+	 */
+	exec_fd = open(PIDFD_SPAWN_SLEEP_PATH, O_PATH);
+	if (exec_fd < 0)
+		_exit(138);
+	ret = snprintf(exec_path, sizeof(exec_path), "/proc/self/fd/%d", exec_fd);
+	if (ret < 0 || ret >= (int)sizeof(exec_path))
+		_exit(139);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(133);
+	bootstrap[0] = builder;
+	bootstrap[1] = uffd;
+	if (send_fds_status(socket, 0, bootstrap, ARRAY_SIZE(bootstrap)))
+		_exit(134);
+	close(uffd);
+
+	errno = 0;
+	result.ret = spawn_run_path_pid(builder, exec_path, argv, NULL, 0);
+	result.error = errno;
+	close(exec_fd);
+	if (write(socket, &result, sizeof(result)) != sizeof(result))
+		_exit(135);
+	close(socket);
+	if (result.ret < 0)
+		_exit(136);
+	if (wait_pidfd_signal(builder, SIGKILL))
+		_exit(137);
+	close(builder);
+	_exit(0);
+}
+
+static void pidfd_spawn_traced_source_worker(int socket, pid_t parent,
+					     const char *path)
+{
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_result result;
+	char command;
+	ssize_t len;
+	int builder;
+	int i;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(120);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(121);
+	if (send_fds_status(socket, 0, &builder, 1))
+		_exit(122);
+
+	for (i = 0; i < 2; i++) {
+		do {
+			len = read(socket, &command, sizeof(command));
+		} while (len < 0 && errno == EINTR);
+		if (len != sizeof(command))
+			_exit(123);
+
+		result = (struct pidfd_spawn_run_result) {};
+		errno = 0;
+		result.ret = spawn_run_path_pid(builder, path, argv, NULL, 0);
+		result.error = errno;
+		if (result.ret > 0)
+			result.wait_error = wait_pidfd_exit(builder, 0);
+		else
+			result.wait_error = -1;
+		if (write(socket, &result, sizeof(result)) != sizeof(result))
+			_exit(124);
+	}
+
+	close(builder);
+	close(socket);
+	_exit(0);
+}
+
+static void pidfd_spawn_authority_worker(int socket, pid_t parent,
+					 const char *path)
+{
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_result result = {};
+	char command;
+	ssize_t len;
+	int builder;
+
+	if (prctl(PR_SET_PDEATHSIG, SIGKILL) || getppid() != parent)
+		_exit(130);
+	builder = sys_pidfd_empty_open();
+	if (builder < 0)
+		_exit(131);
+	if (send_fds_status(socket, 0, &builder, 1))
+		_exit(132);
+	do {
+		len = read(socket, &command, sizeof(command));
+	} while (len < 0 && errno == EINTR);
+	if (len != sizeof(command))
+		_exit(133);
+
+	errno = 0;
+	result.ret = spawn_run_path_pid(builder, path, argv, NULL, 0);
+	result.error = errno;
+	if (result.ret > 0)
+		result.wait_error = wait_pidfd_exit(builder, 0);
+	else
+		result.wait_error = -1;
+	if (write(socket, &result, sizeof(result)) != sizeof(result))
+		_exit(134);
+	close(builder);
+	close(socket);
+	_exit(0);
+}
+
+TEST(pidfd_spawn_embryonic_task_denies_ptrace)
+{
+	struct uffdio_zeropage zeropage = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct uffd_msg message;
+	const char *path = self_exe_path();
+	int release_pipe[2] = { -1, -1 };
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	bool worker_reaped = false;
+	bool page_resolved = false;
+	bool child_released = false;
+	bool attached = false;
+	long page_size;
+	void *fault_page;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int child_pid = -1;
+	int child_wait_fd = -1;
+	int received_fd = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+	char byte = 1;
+
+#define SECURITY_CHECK(condition) \
+	security_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	ret = pidfd_spawn_ptrace_preflight(path);
+	if (ret && errno == EPERM)
+		SKIP(return, "ambient ptrace policy denies normal attach");
+	ASSERT_EQ(ret, 0);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	fault_page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(fault_page, MAP_FAILED);
+	ASSERT_EQ(pipe(release_pipe), 0);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_ptrace_worker(sockets[1], fault_page, page_size,
+					  parent, path, release_pipe[0],
+					  release_pipe[1]);
+	}
+	child_wait_fd = release_pipe[0];
+	close(sockets[1]);
+	sockets[1] = -1;
+	close(release_pipe[0]);
+	release_pipe[0] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+
+	if (!SECURITY_CHECK(!wait_readable(uffd,
+					   PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!SECURITY_CHECK(read(uffd, &message, sizeof(message)) ==
+							     sizeof(message)))
+		goto cleanup;
+	if (!SECURITY_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!SECURITY_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!SECURITY_CHECK(info.pid > 0))
+		goto cleanup;
+	child_pid = info.pid;
+
+	errno = 0;
+	ret = ptrace(PTRACE_SEIZE, child_pid, NULL, NULL);
+	if (!ret)
+		attached = true;
+	if (!SECURITY_CHECK(ret == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == EPERM))
+		goto cleanup;
+	errno = 0;
+	received_fd = sys_pidfd_getfd(builder, child_wait_fd, 0);
+	if (!SECURITY_CHECK(received_fd == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == EPERM))
+		goto cleanup;
+
+	zeropage.range.start = (uintptr_t)fault_page;
+	zeropage.range.len = page_size;
+	if (!SECURITY_CHECK(!ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage)))
+		goto cleanup;
+	page_resolved = true;
+	if (!SECURITY_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.ret == child_pid))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.error))
+		goto cleanup;
+	received_fd = sys_pidfd_getfd(builder, child_wait_fd, 0);
+	if (!SECURITY_CHECK(received_fd >= 0))
+		goto cleanup;
+	if (!SECURITY_CHECK(!close(received_fd)))
+		goto cleanup;
+	received_fd = -1;
+
+	if (!SECURITY_CHECK(!ptrace(PTRACE_SEIZE, child_pid, NULL, NULL)))
+		goto cleanup;
+	attached = true;
+	if (!SECURITY_CHECK(!ptrace(PTRACE_INTERRUPT, child_pid, NULL, NULL)))
+		goto cleanup;
+	waited = waitpid_timeout(child_pid, &status,
+				 PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == child_pid))
+		goto cleanup;
+	if (!SECURITY_CHECK(WIFSTOPPED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!ptrace(PTRACE_DETACH, child_pid, NULL, NULL)))
+		goto cleanup;
+	attached = false;
+	if (!SECURITY_CHECK(write(release_pipe[1], &byte, sizeof(byte)) ==
+							     sizeof(byte)))
+		goto cleanup;
+	child_released = true;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!SECURITY_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (attached && child_pid > 0) {
+		ptrace(PTRACE_INTERRUPT, child_pid, NULL, NULL);
+		waitpid_timeout(child_pid, &status, PIDFD_SPAWN_TIMEOUT_MS);
+		ptrace(PTRACE_DETACH, child_pid, NULL, NULL);
+	}
+	if (!page_resolved && uffd >= 0) {
+		zeropage.range.start = (uintptr_t)fault_page;
+		zeropage.range.len = page_size;
+		ioctl(uffd, UFFDIO_ZEROPAGE, &zeropage);
+	}
+	if (!child_released && release_pipe[1] >= 0)
+		write(release_pipe[1], &byte, sizeof(byte));
+	if (!worker_reaped && worker > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (received_fd >= 0)
+		close(received_fd);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	if (release_pipe[0] >= 0)
+		close(release_pipe[0]);
+	if (release_pipe[1] >= 0)
+		close(release_pipe[1]);
+	munmap(fault_page, page_size);
+	if (failure_line)
+		TH_LOG("ptrace test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef SECURITY_CHECK
+}
+
+TEST(pidfd_spawn_embryonic_task_is_hidden_from_proc)
+{
+	struct uffdio_copy uffd_copy = {};
+	struct uffdio_api api = {
+		.api = UFFD_API,
+	};
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	struct uffd_msg message;
+	struct stat proc_dir_stat;
+	struct stat proc_mem_stat;
+	int sockets[2] = { -1, -1 };
+	int bootstrap[2] = { -1, -1 };
+	bool child_killed = false;
+	bool worker_reaped = false;
+	bool page_resolved = false;
+	char proc_dir[64];
+	char proc_cmdline[64];
+	char proc_mem[64];
+	char cmdline[32];
+	char *fill_page;
+	long page_size;
+	void *fault_page;
+	void *mapping;
+	pid_t parent;
+	pid_t worker = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int cmdline_fd = -1;
+	int status = -1;
+	int probe;
+	int ret;
+	int uffd = -1;
+
+#define SECURITY_CHECK(condition) \
+	security_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	if (geteuid())
+		SKIP(return, "test requires root to create a distinct task uid");
+	ret = pidfd_spawn_unprivileged_preflight();
+	if (ret && (errno == EPERM || errno == EACCES || errno == EINVAL))
+		SKIP(return, "unprivileged proc ownership setup is unavailable");
+	ASSERT_EQ(ret, 0);
+	page_size = sysconf(_SC_PAGESIZE);
+	ASSERT_GT(page_size, 0);
+	probe = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
+	if (probe < 0 && (errno == ENOSYS || errno == EPERM))
+		SKIP(return, "userfaultfd is unavailable: %s", strerror(errno));
+	ASSERT_GE(probe, 0);
+	ASSERT_EQ(ioctl(probe, UFFDIO_API, &api), 0);
+	ASSERT_EQ(close(probe), 0);
+
+	mapping = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	fault_page = mapping;
+	fill_page = (char *)mapping + page_size;
+	memcpy(fill_page, "30", 3);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	parent = getpid();
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (!worker) {
+		close(sockets[0]);
+		pidfd_spawn_proc_worker(sockets[1], fault_page, page_size,
+					parent);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, bootstrap,
+			      ARRAY_SIZE(bootstrap));
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	builder = bootstrap[0];
+	uffd = bootstrap[1];
+
+	if (!SECURITY_CHECK(!wait_readable(uffd,
+					   PIDFD_SPAWN_TIMEOUT_MS)))
+		goto cleanup;
+	if (!SECURITY_CHECK(read(uffd, &message, sizeof(message)) ==
+							     sizeof(message)))
+		goto cleanup;
+	if (!SECURITY_CHECK(message.event == UFFD_EVENT_PAGEFAULT))
+		goto cleanup;
+	if (!SECURITY_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!SECURITY_CHECK(info.pid > 0))
+		goto cleanup;
+	ret = snprintf(proc_dir, sizeof(proc_dir), "/proc/%u", info.pid);
+	if (!SECURITY_CHECK(ret > 0 && ret < sizeof(proc_dir)))
+		goto cleanup;
+	ret = snprintf(proc_cmdline, sizeof(proc_cmdline), "/proc/%u/cmdline",
+		       info.pid);
+	if (!SECURITY_CHECK(ret > 0 && ret < sizeof(proc_cmdline)))
+		goto cleanup;
+	ret = snprintf(proc_mem, sizeof(proc_mem), "/proc/%u/mem", info.pid);
+	if (!SECURITY_CHECK(ret > 0 && ret < sizeof(proc_mem)))
+		goto cleanup;
+	errno = 0;
+	if (!SECURITY_CHECK(stat(proc_dir, &proc_dir_stat) == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == ENOENT))
+		goto cleanup;
+	errno = 0;
+	cmdline_fd = open(proc_cmdline, O_RDONLY | O_CLOEXEC);
+	if (!SECURITY_CHECK(cmdline_fd == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == ENOENT))
+		goto cleanup;
+
+	uffd_copy.dst = (uintptr_t)fault_page;
+	uffd_copy.src = (uintptr_t)fill_page;
+	uffd_copy.len = page_size;
+	if (!SECURITY_CHECK(!ioctl(uffd, UFFDIO_COPY, &uffd_copy)))
+		goto cleanup;
+	page_resolved = true;
+	if (!SECURITY_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.ret == info.pid))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.error))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.wait_error == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(!stat(proc_dir, &proc_dir_stat)))
+		goto cleanup;
+	if (!SECURITY_CHECK(proc_dir_stat.st_uid ==
+				   PIDFD_SPAWN_UNPRIVILEGED_ID))
+		goto cleanup;
+	if (!SECURITY_CHECK(proc_dir_stat.st_gid ==
+				   PIDFD_SPAWN_UNPRIVILEGED_ID))
+		goto cleanup;
+	if (!SECURITY_CHECK(!stat(proc_mem, &proc_mem_stat)))
+		goto cleanup;
+	if (!SECURITY_CHECK(proc_mem_stat.st_uid ==
+				   PIDFD_SPAWN_UNPRIVILEGED_ID))
+		goto cleanup;
+	if (!SECURITY_CHECK(proc_mem_stat.st_gid ==
+				   PIDFD_SPAWN_UNPRIVILEGED_ID))
+		goto cleanup;
+	cmdline_fd = open(proc_cmdline, O_RDONLY | O_CLOEXEC);
+	if (!SECURITY_CHECK(cmdline_fd >= 0))
+		goto cleanup;
+	ret = read(cmdline_fd, cmdline, sizeof(cmdline));
+	if (!SECURITY_CHECK(ret >= (int)sizeof("sleep")))
+		goto cleanup;
+	if (!SECURITY_CHECK(!memcmp(cmdline, "sleep", sizeof("sleep"))))
+		goto cleanup;
+	if (!SECURITY_CHECK(!close(cmdline_fd)))
+		goto cleanup;
+	cmdline_fd = -1;
+	if (!SECURITY_CHECK(!sys_pidfd_send_signal(builder, SIGKILL, NULL, 0)))
+		goto cleanup;
+	child_killed = true;
+	waited = waitpid_timeout(worker, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == worker))
+		goto cleanup;
+	worker_reaped = true;
+	if (!SECURITY_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (!page_resolved && uffd >= 0) {
+		uffd_copy.dst = (uintptr_t)fault_page;
+		uffd_copy.src = (uintptr_t)fill_page;
+		uffd_copy.len = page_size;
+		ioctl(uffd, UFFDIO_COPY, &uffd_copy);
+	}
+	if (!child_killed && builder >= 0)
+		sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+	if (!worker_reaped && worker > 0) {
+		kill(worker, SIGKILL);
+		waited = waitpid_timeout(worker, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		worker_reaped = waited == worker;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (cmdline_fd >= 0)
+		close(cmdline_fd);
+	if (uffd >= 0)
+		close(uffd);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	munmap(mapping, 2 * page_size);
+	if (failure_line)
+		TH_LOG("proc visibility test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(worker_reaped);
+
+#undef SECURITY_CHECK
+}
+
+TEST(pidfd_spawn_traced_source_does_not_consume_builder)
+{
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	const char *path = self_exe_path();
+	int sockets[2] = { -1, -1 };
+	bool source_reaped = false;
+	bool attached = false;
+	pid_t source = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int status = -1;
+	char command = 1;
+	int ret;
+
+#define SECURITY_CHECK(condition) \
+	security_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	ret = pidfd_spawn_ptrace_preflight(path);
+	if (ret && errno == EPERM)
+		SKIP(return, "ambient ptrace policy denies normal attach");
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	source = fork();
+	ASSERT_GE(source, 0);
+	if (!source) {
+		close(sockets[0]);
+		pidfd_spawn_traced_source_worker(sockets[1], getppid(), path);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, &builder, 1);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+
+	if (!SECURITY_CHECK(!ptrace(PTRACE_SEIZE, source, NULL, NULL)))
+		goto cleanup;
+	attached = true;
+	if (!SECURITY_CHECK(write(sockets[0], &command, sizeof(command)) ==
+							 sizeof(command)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.ret == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.error == EPERM))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.wait_error == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(ioctl(builder, PIDFD_GET_INFO, &info) == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == ESRCH))
+		goto cleanup;
+
+	if (!SECURITY_CHECK(!ptrace(PTRACE_INTERRUPT, source, NULL, NULL)))
+		goto cleanup;
+	waited = waitpid_timeout(source, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == source))
+		goto cleanup;
+	if (!SECURITY_CHECK(WIFSTOPPED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!ptrace(PTRACE_DETACH, source, NULL, NULL)))
+		goto cleanup;
+	attached = false;
+	if (!SECURITY_CHECK(write(sockets[0], &command, sizeof(command)) ==
+							 sizeof(command)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.ret > 0))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.error))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.wait_error))
+		goto cleanup;
+	info = (struct pidfd_info) {
+		.mask = PIDFD_INFO_EXIT,
+	};
+	if (!SECURITY_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!SECURITY_CHECK(info.mask & PIDFD_INFO_EXIT))
+		goto cleanup;
+	if (!SECURITY_CHECK(WIFEXITED(info.exit_code)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(info.exit_code)))
+		goto cleanup;
+	waited = waitpid_timeout(source, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == source))
+		goto cleanup;
+	source_reaped = true;
+	if (!SECURITY_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (attached && source > 0) {
+		ptrace(PTRACE_INTERRUPT, source, NULL, NULL);
+		waitpid_timeout(source, &status, PIDFD_SPAWN_TIMEOUT_MS);
+		ptrace(PTRACE_DETACH, source, NULL, NULL);
+	}
+	if (!source_reaped && source > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(source, SIGKILL);
+		waited = waitpid_timeout(source, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		source_reaped = waited == source;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	if (failure_line)
+		TH_LOG("traced-source test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(source_reaped);
+
+#undef SECURITY_CHECK
+}
+
+TEST(pidfd_spawn_passed_builder_does_not_delegate_authority)
+{
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_run_result result = {};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	const char *path = self_exe_path();
+	int sockets[2] = { -1, -1 };
+	bool source_reaped = false;
+	pid_t parent = getpid();
+	pid_t source = -1;
+	pid_t waited;
+	int failure_errno = 0;
+	int failure_line = 0;
+	int builder = -1;
+	int status = -1;
+	char command = 1;
+	int ret;
+
+#define SECURITY_CHECK(condition) \
+	security_check((condition), &failure_errno, &failure_line, __LINE__)
+
+	ASSERT_NE(path, NULL);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_CLOEXEC, 0,
+			     sockets), 0);
+	source = fork();
+	ASSERT_GE(source, 0);
+	if (!source) {
+		close(sockets[0]);
+		pidfd_spawn_authority_worker(sockets[1], parent, path);
+	}
+	close(sockets[1]);
+	sockets[1] = -1;
+	ret = wait_readable(sockets[0], PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+	ret = recv_fds_status(sockets[0], &status, &builder, 1);
+	if (!SECURITY_CHECK(!ret))
+		goto cleanup;
+
+	if (!SECURITY_CHECK(config_path(builder, path) == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == EPERM))
+		goto cleanup;
+	if (!SECURITY_CHECK(spawn_run_path_pid(builder, path, argv,
+					       NULL, 0) == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == EPERM))
+		goto cleanup;
+	if (!SECURITY_CHECK(ioctl(builder, PIDFD_GET_INFO, &info) == -1))
+		goto cleanup;
+	if (!SECURITY_CHECK(errno == ESRCH))
+		goto cleanup;
+
+	if (!SECURITY_CHECK(write(sockets[0], &command, sizeof(command)) ==
+							 sizeof(command)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!read_result(sockets[0], &result)))
+		goto cleanup;
+	if (!SECURITY_CHECK(result.ret > 0))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.error))
+		goto cleanup;
+	if (!SECURITY_CHECK(!result.wait_error))
+		goto cleanup;
+	info = (struct pidfd_info) {
+		.mask = PIDFD_INFO_EXIT,
+	};
+	if (!SECURITY_CHECK(!ioctl(builder, PIDFD_GET_INFO, &info)))
+		goto cleanup;
+	if (!SECURITY_CHECK(info.mask & PIDFD_INFO_EXIT))
+		goto cleanup;
+	if (!SECURITY_CHECK(WIFEXITED(info.exit_code)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(info.exit_code)))
+		goto cleanup;
+	waited = waitpid_timeout(source, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!SECURITY_CHECK(waited == source))
+		goto cleanup;
+	source_reaped = true;
+	if (!SECURITY_CHECK(WIFEXITED(status)))
+		goto cleanup;
+	if (!SECURITY_CHECK(!WEXITSTATUS(status)))
+		goto cleanup;
+
+cleanup:
+	if (!source_reaped && source > 0) {
+		if (builder >= 0)
+			sys_pidfd_send_signal(builder, SIGKILL, NULL, 0);
+		kill(source, SIGKILL);
+		waited = waitpid_timeout(source, &status,
+					 PIDFD_SPAWN_TIMEOUT_MS);
+		source_reaped = waited == source;
+	}
+	if (builder >= 0)
+		close(builder);
+	if (sockets[0] >= 0)
+		close(sockets[0]);
+	if (sockets[1] >= 0)
+		close(sockets[1]);
+	if (failure_line)
+		TH_LOG("authority test failed at line %d: %s", failure_line,
+		       strerror(failure_errno));
+	ASSERT_EQ(failure_line, 0);
+	ASSERT_TRUE(source_reaped);
+
+#undef SECURITY_CHECK
+}
+
+TEST(pidfd_spawn_changed_cred_does_not_have_authority)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_cred_test test = {
+		.path = path,
+	};
+	pthread_t thread;
+	void *thread_ret;
+	int ret;
+
+	ASSERT_NE(path, NULL);
+	test.builder = sys_pidfd_empty_open();
+	ASSERT_GE(test.builder, 0);
+	ret = pthread_create(&thread, NULL, pidfd_spawn_changed_cred_thread,
+			     &test);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(pthread_join_timeout(thread, &thread_ret,
+				       PIDFD_SPAWN_TIMEOUT_MS), 0);
+	ASSERT_EQ(thread_ret, NULL);
+	if (test.setup_error) {
+		ASSERT_EQ(close(test.builder), 0);
+		SKIP(return, "changing fsuid is unavailable");
+	}
+	ASSERT_EQ(test.restore_error, 0);
+	ASSERT_EQ(test.config_ret, -1);
+	ASSERT_EQ(test.config_error, EPERM);
+	ASSERT_EQ(test.run_ret, -1);
+	ASSERT_EQ(test.run_error, EPERM);
+	ASSERT_GT(spawn_run_path_pid(test.builder, path, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(test.builder, 0), 0);
+	ASSERT_EQ(close(test.builder), 0);
+}
+
+TEST(pidfd_spawn_changed_pidns_does_not_have_authority)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_security_test",
+				"--pidfd-spawn-helper", "exit0", NULL };
+	struct pidfd_spawn_pidns_test test = {
+		.path = path,
+	};
+	pthread_t thread;
+	void *thread_ret;
+	int ret;
+
+	ASSERT_NE(path, NULL);
+	test.builder = sys_pidfd_empty_open();
+	ASSERT_GE(test.builder, 0);
+	ret = pthread_create(&thread, NULL, pidfd_spawn_changed_pidns_thread,
+			     &test);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(pthread_join_timeout(thread, &thread_ret,
+				       PIDFD_SPAWN_TIMEOUT_MS), 0);
+	ASSERT_EQ(thread_ret, NULL);
+	if (test.setup_error) {
+		ASSERT_EQ(close(test.builder), 0);
+		if (test.setup_error == EPERM || test.setup_error == EINVAL)
+			SKIP(return, "PID namespace creation is unavailable");
+		ASSERT_EQ(test.setup_error, 0);
+	}
+	ASSERT_EQ(test.config_ret, -1);
+	ASSERT_EQ(test.config_error, EPERM);
+	ASSERT_EQ(test.run_ret, -1);
+	ASSERT_EQ(test.run_error, EPERM);
+	ASSERT_GT(spawn_run_path_pid(test.builder, path, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(test.builder, 0), 0);
+	ASSERT_EQ(close(test.builder), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
diff --git a/tools/testing/selftests/pidfd/pidfd_spawn_test.c b/tools/testing/selftests/pidfd/pidfd_spawn_test.c
new file mode 100644
index 0000000000000..da28ad125a345
--- /dev/null
+++ b/tools/testing/selftests/pidfd/pidfd_spawn_test.c
@@ -0,0 +1,550 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <asm/unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/fs.h>
+#include <linux/pidfd_spawn.h>
+#include <poll.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/epoll.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/uio.h>
+#include <sys/wait.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+
+#include "pidfd.h"
+#include "kselftest_harness.h"
+#include "../filesystems/wrappers.h"
+
+#include "pidfd_spawn_common.h"
+
+struct pidfd_spawn_xattr_writer {
+	const char *value;
+	int fd;
+};
+
+static void *pidfd_spawn_xattr_writer(void *data)
+{
+	struct pidfd_spawn_xattr_writer *writer = data;
+	size_t len = strlen(writer->value);
+	int i;
+
+	for (i = 0; i < 1000; i++) {
+		if (fsetxattr(writer->fd, "trusted.pidfd_spawn", writer->value,
+			      len, 0))
+			return (void *)(intptr_t)errno;
+	}
+	return NULL;
+}
+
+static int read_fdinfo_pid(int fd)
+{
+	char path[64];
+	char line[128];
+	FILE *file;
+	int pid = INT_MIN;
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", fd);
+	file = fopen(path, "re");
+	if (!file)
+		return INT_MIN;
+	while (fgets(line, sizeof(line), file)) {
+		if (sscanf(line, "Pid:\t%d", &pid) == 1)
+			break;
+	}
+	fclose(file);
+	return pid;
+}
+
+TEST(pidfd_open_empty_rejects_bad_flags)
+{
+	ASSERT_EQ(sys_pidfd_open(0, 0), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_open(0, PIDFD_EMPTY | PIDFD_THREAD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_open(0, PIDFD_EMPTY | (1U << 26)), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_open(getpid(), PIDFD_EMPTY), -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
+TEST(pidfd_open_empty_close_discards_builder)
+{
+	int fd;
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_open_empty_accepts_nonblock)
+{
+	int fd;
+	int flags;
+
+	fd = sys_pidfd_open(0, PIDFD_EMPTY | PIDFD_NONBLOCK);
+	ASSERT_GE(fd, 0);
+
+	flags = fcntl(fd, F_GETFL);
+	ASSERT_GE(flags, 0);
+	ASSERT_NE(flags & O_NONBLOCK, 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_config_stages_absolute_path)
+{
+	const char *path = self_exe_path();
+	int fd;
+
+	ASSERT_NE(path, NULL);
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(config_path(fd, path), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_config_stages_relative_path)
+{
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	const char *relative;
+	char *storage;
+	int cwd_fd;
+	int fd;
+
+	cwd_fd = enter_self_exe_directory(&storage, &relative);
+	ASSERT_GE(cwd_fd, 0);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(config_path(fd, relative), 0);
+	ASSERT_EQ(spawn_run_staged(fd, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(leave_self_exe_directory(cwd_fd, storage), 0);
+}
+
+TEST(pidfd_config_rejects_bad_arguments)
+{
+	char unterminated_key[256];
+	int fd;
+
+	memset(unterminated_key, 'x', sizeof(unterminated_key));
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING, NULL,
+				   "/bin/true", 0),
+		  -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+				   PIDFD_CONFIG_KEY_PATH, NULL, 0),
+		  -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+				   PIDFD_CONFIG_KEY_PATH, "/bin/true", 1),
+		  -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(sys_pidfd_config(fd, UINT_MAX, PIDFD_CONFIG_KEY_PATH,
+				   "/bin/true", 0),
+		  -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING, "unknown",
+				   "/bin/true", 0),
+		  -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(sys_pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+				   unterminated_key, "/bin/true", 0),
+		  -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_open_empty_getversion_survives_publication)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	__u32 published_generation;
+	__u32 future_generation;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ioctl(fd, FS_IOC_GETVERSION, &future_generation), 0);
+	ASSERT_GT(spawn_run_path_pid(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(ioctl(fd, FS_IOC_GETVERSION, &published_generation), 0);
+	ASSERT_EQ(published_generation, future_generation);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_reopened_file_does_not_cancel_builder)
+{
+	char proc_path[64];
+	const char *path = self_exe_path();
+	int reopened;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(snprintf(proc_path, sizeof(proc_path), "/proc/self/fd/%d", fd),
+		  0);
+	reopened = open(proc_path, O_RDWR | O_CLOEXEC);
+	ASSERT_GE(reopened, 0);
+	ASSERT_EQ(close(reopened), 0);
+
+	ASSERT_EQ(config_path(fd, path), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+static int pidfd_spawn_bind_mount_child(const char *path)
+{
+	char template[] = P_tmpdir "/pidfd_spawn_mount_XXXXXX";
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	int mounted_fd = -1;
+	int mount_fd = -1;
+	int target_fd = -1;
+	bool mounted = false;
+	int ret = 1;
+	int fd = -1;
+
+	if (unshare(CLONE_NEWNS))
+		return errno == EPERM ? 77 : 1;
+	if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
+		return errno == EPERM ? 77 : 2;
+	target_fd = mkstemp(template);
+	if (target_fd < 0)
+		return 3;
+
+	fd = sys_pidfd_empty_open();
+	if (fd < 0) {
+		ret = 4;
+		goto out;
+	}
+	mount_fd = sys_open_tree(fd, "", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC |
+					    AT_EMPTY_PATH);
+	if (mount_fd < 0) {
+		ret = 5;
+		goto out;
+	}
+	if (move_mount(mount_fd, "", target_fd, "",
+		       MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_EMPTY_PATH)) {
+		ret = 6;
+		goto out;
+	}
+	mounted = true;
+	close(mount_fd);
+	mount_fd = -1;
+	close(fd);
+	fd = -1;
+
+	mounted_fd = open(template, O_RDWR | O_CLOEXEC);
+	if (mounted_fd < 0) {
+		ret = 7;
+		goto out;
+	}
+	if (spawn_run_path(mounted_fd, path, argv, NULL, 0)) {
+		ret = 8;
+		goto out;
+	}
+	if (wait_pidfd_exit(mounted_fd, 0)) {
+		ret = 9;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	if (mounted_fd >= 0)
+		close(mounted_fd);
+	if (mounted)
+		umount2(template, MNT_DETACH);
+	if (mount_fd >= 0)
+		close(mount_fd);
+	if (fd >= 0)
+		close(fd);
+	if (target_fd >= 0)
+		close(target_fd);
+	if (target_fd >= 0)
+		unlink(template);
+	return ret;
+}
+
+TEST(pidfd_spawn_bind_mount_keeps_builder_alive)
+{
+	const char *path = self_exe_path();
+	int status;
+	pid_t waited;
+	pid_t pid;
+
+	ASSERT_NE(path, NULL);
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (!pid)
+		_exit(pidfd_spawn_bind_mount_child(path));
+	waited = waitpid_timeout(pid, &status, PIDFD_SPAWN_TIMEOUT_MS);
+	if (!waited) {
+		kill(pid, SIGKILL);
+		waited = waitpid_timeout(pid, &status, 1000);
+	}
+	ASSERT_EQ(waited, pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	if (WEXITSTATUS(status) == 77)
+		SKIP(return, "mount namespaces are unavailable");
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST(pidfd_spawn_run_preserves_pidfd_identity)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	struct stat builder_stat;
+	struct stat future_stat;
+	struct stat opened_stat;
+	struct stat ordinary_stat;
+	int opened;
+	int ordinary;
+	int child_pid;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	ordinary = sys_pidfd_open(getpid(), 0);
+	ASSERT_GE(ordinary, 0);
+	ASSERT_EQ(fstat(ordinary, &ordinary_stat), 0);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fstat(fd, &future_stat), 0);
+	ASSERT_EQ(future_stat.st_mode, ordinary_stat.st_mode);
+	ASSERT_EQ(future_stat.st_uid, ordinary_stat.st_uid);
+	ASSERT_EQ(future_stat.st_gid, ordinary_stat.st_gid);
+	ASSERT_EQ(close(ordinary), 0);
+	child_pid = spawn_run_path_pid(fd, path, argv, NULL, 0);
+	ASSERT_GT(child_pid, 0);
+	opened = sys_pidfd_open(child_pid, 0);
+	ASSERT_GE(opened, 0);
+	ASSERT_EQ(fstat(fd, &builder_stat), 0);
+	ASSERT_EQ(fstat(opened, &opened_stat), 0);
+	ASSERT_EQ(future_stat.st_dev, builder_stat.st_dev);
+	ASSERT_EQ(future_stat.st_ino, builder_stat.st_ino);
+	ASSERT_EQ(future_stat.st_mode, builder_stat.st_mode);
+	ASSERT_EQ(future_stat.st_uid, builder_stat.st_uid);
+	ASSERT_EQ(future_stat.st_gid, builder_stat.st_gid);
+	ASSERT_EQ(builder_stat.st_dev, opened_stat.st_dev);
+	ASSERT_EQ(builder_stat.st_ino, opened_stat.st_ino);
+	ASSERT_EQ(builder_stat.st_mode, opened_stat.st_mode);
+	ASSERT_EQ(builder_stat.st_uid, opened_stat.st_uid);
+	ASSERT_EQ(builder_stat.st_gid, opened_stat.st_gid);
+
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(opened), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_preserves_pidfd_xattrs)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	struct pidfd_spawn_xattr_writer writers[2];
+	pthread_t threads[2];
+	void *thread_ret;
+	int child_pid;
+	int opened;
+	int fd;
+	int ret;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	child_pid = spawn_run_path_pid(fd, path, argv, NULL, 0);
+	ASSERT_GT(child_pid, 0);
+	opened = sys_pidfd_open(child_pid, 0);
+	ASSERT_GE(opened, 0);
+
+	errno = 0;
+	ret = fsetxattr(fd, "trusted.pidfd_spawn", "probe", 5, 0);
+	if (ret && (errno == EPERM || errno == EACCES)) {
+		ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+		ASSERT_EQ(close(opened), 0);
+		ASSERT_EQ(close(fd), 0);
+		SKIP(return, "trusted xattrs require CAP_SYS_ADMIN");
+	}
+	ASSERT_EQ(ret, 0);
+
+	writers[0].fd = fd;
+	writers[0].value = "builder";
+	writers[1].fd = opened;
+	writers[1].value = "opened";
+	ASSERT_EQ(pthread_create(&threads[0], NULL, pidfd_spawn_xattr_writer,
+				 &writers[0]), 0);
+	ASSERT_EQ(pthread_create(&threads[1], NULL, pidfd_spawn_xattr_writer,
+				 &writers[1]), 0);
+	ASSERT_EQ(pthread_join_timeout(threads[0], &thread_ret,
+				       PIDFD_SPAWN_TIMEOUT_MS), 0);
+	ASSERT_EQ((intptr_t)thread_ret, 0);
+	ASSERT_EQ(pthread_join_timeout(threads[1], &thread_ret,
+				       PIDFD_SPAWN_TIMEOUT_MS), 0);
+	ASSERT_EQ((intptr_t)thread_ret, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(opened), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_prerun_epoll_reports_child_exit)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	struct epoll_event event = {
+		.events = EPOLLIN,
+	};
+	struct epoll_event ready = {};
+	int epoll_fd;
+	int fd;
+
+	ASSERT_NE(path, NULL);
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	event.data.fd = fd;
+	epoll_fd = epoll_create1(EPOLL_CLOEXEC);
+	ASSERT_GE(epoll_fd, 0);
+	ASSERT_EQ(epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &event), 0);
+	ASSERT_GT(spawn_run_path_pid(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(epoll_wait(epoll_fd, &ready, 1,
+			     PIDFD_SPAWN_TIMEOUT_MS), 1);
+	ASSERT_EQ(ready.data.fd, fd);
+	ASSERT_NE(ready.events & EPOLLIN, 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(epoll_fd), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_is_one_shot)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	int fd;
+
+	ASSERT_NE(path, NULL);
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_GT(spawn_run_path_pid(fd, path, argv, NULL, 0), 0);
+	ASSERT_EQ(spawn_run_path_pid(fd, path, argv, NULL, 0), -1);
+	ASSERT_EQ(errno, EBUSY);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_execs_staged_path)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	int fd;
+
+	ASSERT_NE(path, NULL);
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(config_path(fd, path), 0);
+	ASSERT_EQ(spawn_run_staged(fd, argv, NULL, 0), 0);
+	ASSERT_EQ(wait_pidfd_exit(fd, 0), 0);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_run_rejects_conflicting_paths)
+{
+	const char *path = self_exe_path();
+	char * const argv[] = { "pidfd_spawn_test", "--pidfd-spawn-helper",
+				"exit0", NULL };
+	int fd;
+
+	ASSERT_NE(path, NULL);
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(config_path(fd, path), 0);
+	ASSERT_EQ(spawn_run_path(fd, path, argv, NULL, 0), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(pidfd_spawn_pending_pidfd_apis_return_esrch)
+{
+	char byte;
+	struct iovec iov = {
+		.iov_base = &byte,
+		.iov_len = sizeof(byte),
+	};
+	struct pidfd_info info = {
+		.mask = PIDFD_INFO_PID,
+	};
+	siginfo_t wait_info = {};
+	struct pollfd pfd = {};
+	int nsfd;
+	int fd;
+
+	fd = sys_pidfd_empty_open();
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(sys_pidfd_send_signal(fd, 0, NULL, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(sys_pidfd_getfd(fd, STDIN_FILENO, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(ioctl(fd, PIDFD_GET_INFO, &info), -1);
+	ASSERT_EQ(errno, ESRCH);
+	nsfd = ioctl(fd, PIDFD_GET_MNT_NAMESPACE, 0);
+	ASSERT_EQ(nsfd, -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(setns(fd, CLONE_NEWNS), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(read_fdinfo_pid(fd), -1);
+	ASSERT_EQ(sys_waitid(P_PIDFD, fd, &wait_info, WEXITED | WNOHANG), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(syscall(__NR_process_madvise, fd, &iov, 1,
+			  MADV_DONTNEED, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(syscall(__NR_process_mrelease, fd, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+	ASSERT_EQ(flistxattr(fd, NULL, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+	ASSERT_EQ(poll(&pfd, 1, 0), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+int main(int argc, char **argv)
+{
+	int ret = helper_main(argc, argv);
+
+	if (ret >= 0)
+		return ret;
+	return test_harness_run(argc, argv);
+}
-- 
2.52.0

