Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084977;
	b=XkcMv2Ywi9zxRbbSORh1gxGoRS6q89IK8oL7Og80FkAcwd1yNZf8LMWTIAxQUoke9Fxj
	 e7s7VcAP0eVTMVIfyOwGfQvnCL4IGlMtBE3+MYebBe0CId/wxl/TJxR9LnJsoVYgjkisl
	 3xbDie/fYYWFYNZo/Zeg+Xac67x76RZQxyDW19Aiwvm+QxvbkRlrq3cBUktGZt2cMQqu8
	 lGVFE6WTwDjB3Y8hqJ19xsh61eji4yXuhuvM3jmXrxz1UmYS/y13k4AkKEAW4RFbuL9CR
	 FFk2ZVEsK7Riu8QglAXtRMaeC3QmkIkmi4ZlZZhOhn5xuI3p0KmXRm5lhh91aOC1oNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084977;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=UjAH+QE35y8GnT9n4LFzvY1A8XYm2bKH7Y8LCmn/mok=;
	b=lh/53M8ZojyOw8AhTzFroS4YEJV8mc2iKVnvdNlkvg3zdwO8SNcyaWUdp2DXBrCHcidh
	 IvD8E+kkiyjfyoDFaIDliDpbq+hhRkK6dhV/Q7ek3ynZkSIbCj3rIkmwGO+YPLDWm8KAU
	 tm8dsMhIN5SPPNfsxA5Fb3O+m05Slid5qIdTOqLbMJ6DmpbRHrkR3Y8sP3H5qvrCMmoIS
	 e35zuralKuvthNZbrq8MIujI/biqkEN34osn0+iI4aN2RPyqsncE+wUtA1yvnhLtP/pQI
	 FsIGFojheAHRWD9zMBAdD9pMLHnvUcpFfaZyvAGnO5EU6GrFEVIlWQKnp3DeI3lB9qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BByuNhs0;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D0260A260B
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 10:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23D0260A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BByuNhs0
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c49b95262a5so173452866b.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 02:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795084973; x=1795689773; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UjAH+QE35y8GnT9n4LFzvY1A8XYm2bKH7Y8LCmn/mok=;
        b=BByuNhs09rXRcaa/+nwkW28Ge+hkkZaVqN/V4WQW5AOuEjLAJ+G0uzwuu3jqzG1UrE
         pj+qLjE/TQlf4ivrIUXYaOpbLx5qM4yQVpsTO0NGpvYNizDWVcPFprNn//HpkOqRU2Eq
         mW8AOnmi8RzjuUV/PjKnv8y/oBAx1vYa1i1iprwbPFusQIcv5PngdE8fZoNy8Dxylwk2
         ucin4X1sz+tFcA9ir8mH18TZYRFUo0EVQQtuccB1wE+TSEGpZyUt4mtBOlJxc9Gz0fu3
         o0cqtl2iQXISm4z8rCuClpQJLttXm6Qc7EVsRyHb6RnFRnibUhhE1EEBpTZUS4rmvRzD
         jdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084973; x=1795689773;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UjAH+QE35y8GnT9n4LFzvY1A8XYm2bKH7Y8LCmn/mok=;
        b=iatvHniwebovyFYPVIs6ACqnQpxTYEZFdX5mONmpHcxjZ3OH5kgG9Y6xMoULkPRjuH
         2CKFWtm5MIhCKZfMgAAb4SOowFRu9XXTkCQpFttCA2Gii1atnfEmVHQMAdjICrWCcQry
         eRZAYmlG+g8OsKzhPk7W8e66pBm51fCCz8qLpwrd/hZ6ULhEqQNtds+ChvBpHLjI4Bkc
         bLzRXogaaNlJEk6IUNbw3zudpe42vdNrYcQRsT20wBKZWnHmmv+Nk1yoz2Tbj4Yj7ZMf
         kWPMjXmQ7HoZQ6ardAwWKMhXec78sUvB3h8Cu0Yp0thFww6z+dzpdj1ZH/66IzmRqyro
         54ww==
X-Forwarded-Encrypted: i=1; AL+hErG6eCASm5wzh7010y9/cIcQweu3bP4Z2sf0zzUj7vyNQLqqMApBU4dO9VKvTqL5cIvHt4GjAHR8lu4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9oUPJmtKAaXx/rrilrGtFVrsh0sy5oKKjaQPXfamXCQebIwCAo
	Z5ZQY1hmDHUvQ0n6S0Uv69afnJUnm6DgeYECwAlr4sKIwgnqmIrB9jyS0Rx+QhqWXfY/Ddl/oA=
	=
X-Received: from ejcbu14.prod.google.com ([2002:a17:907:930e:b0:c46:aa67:4b28])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:5c1:b0:c42:fc8b:6c7a
 with SMTP id a640c23a62f3a-c510e35be45mr483347066b.41.1795084973273; Thu, 19
 Nov 2026 02:42:53 -0800 (PST)
Date: Thu, 19 Nov 2026 10:42:08 +0000
In-Reply-To: <20261119104208.782900-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119104208.782900-1-halg@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119104208.782900-5-halg@google.com>
Subject: [PATCH v2 4/4] selftests/capabilities: add userns capability bounding
 set tests
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>, 
	Andy Lutomirski <luto@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, keyrings@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

Add selftests in tools/testing/selftests/capabilities covering:

- prctl(PR_CAP_USERNS) argument validation and authorization rules for
  lowering, clearing, and raising capabilities.
- Default full capability grants, cap_userns restrictions (including
  clearing all capabilities), and monotonic inheritance across nested
  user namespaces.
- Default retention of capabilities in cap_permitted, and strict
  enforcement and persistence of SECBIT_CAP_USERNS_STRICT and its lock
  across user namespace transitions.
- Credential and cap_userns clamping upon entering a user namespace via
  setns().
- Implicit parent-owner capability bounding by the owned namespace's
  cap_bset (including over descendants) and the caller's userns
  ceiling, while preserving explicit ancestor capabilities.
- Ptrace restrictions across PTRACE_ATTACH, PTRACE_TRACEME, and
  PTRACE_MODE_READ for same-userns peers and owned descendant
  namespaces, while preserving explicit CAP_SYS_PTRACE.
- Preservation of dumpable and pdeath_signal when narrowing the userns
  ceiling and resets when widening it.
- CapUns reporting in /proc/self/status.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 .../testing/selftests/capabilities/.gitignore |    1 +
 tools/testing/selftests/capabilities/Makefile |    2 +-
 .../capabilities/userns_bounding_set_test.c   | 1064 +++++++++++++++++
 3 files changed, 1066 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/capabilities/userns_bounding_set_test.c

diff --git a/tools/testing/selftests/capabilities/.gitignore b/tools/testing/selftests/capabilities/.gitignore
index 426d9adca67c..28767c08dea8 100644
--- a/tools/testing/selftests/capabilities/.gitignore
+++ b/tools/testing/selftests/capabilities/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_execve
+userns_bounding_set_test
 validate_cap
diff --git a/tools/testing/selftests/capabilities/Makefile b/tools/testing/selftests/capabilities/Makefile
index 411ac098308f..b29f7b117c11 100644
--- a/tools/testing/selftests/capabilities/Makefile
+++ b/tools/testing/selftests/capabilities/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 TEST_GEN_FILES := validate_cap
-TEST_GEN_PROGS := test_execve
+TEST_GEN_PROGS := test_execve userns_bounding_set_test
 
 CFLAGS += -O2 -g -std=gnu99 -Wall $(KHDR_INCLUDES)
 LDLIBS += -lcap-ng -lrt -ldl
diff --git a/tools/testing/selftests/capabilities/userns_bounding_set_test.c b/tools/testing/selftests/capabilities/userns_bounding_set_test.c
new file mode 100644
index 000000000000..9aa9e5b31130
--- /dev/null
+++ b/tools/testing/selftests/capabilities/userns_bounding_set_test.c
@@ -0,0 +1,1064 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/ptrace.h>
+#include <sys/socket.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/capability.h>
+#include <linux/prctl.h>
+#include <linux/sched.h>
+#include <linux/securebits.h>
+
+#include "../clone3/clone3_selftests.h"
+#include "../kselftest_harness.h"
+
+#define MAX_TRACEES 2
+
+struct cap_state {
+	bool bset;
+	bool permitted;
+	bool effective;
+};
+
+static int get_cap_state(int cap, struct cap_state *state)
+{
+	struct __user_cap_header_struct hdr = {
+		.version = _LINUX_CAPABILITY_VERSION_3,
+		.pid = 0,
+	};
+	struct __user_cap_data_struct data[2];
+	uint32_t mask;
+	int idx;
+
+	if (cap < 0 || cap > CAP_LAST_CAP)
+		return -EINVAL;
+
+	if (syscall(SYS_capget, &hdr, data) != 0)
+		return -errno;
+
+	idx = CAP_TO_INDEX(cap);
+	mask = CAP_TO_MASK(cap);
+
+	state->bset = (prctl(PR_CAPBSET_READ, cap, 0, 0, 0) == 1);
+	state->permitted = (data[idx].permitted & mask) != 0;
+	state->effective = (data[idx].effective & mask) != 0;
+
+	return 0;
+}
+
+static bool cap_raised(int cap)
+{
+	struct cap_state t;
+
+	if (get_cap_state(cap, &t) != 0)
+		return false;
+
+	return t.bset && t.permitted && t.effective;
+}
+
+static bool cap_dropped(int cap)
+{
+	struct cap_state t;
+
+	if (get_cap_state(cap, &t) != 0)
+		return false;
+
+	return !t.bset && !t.permitted && !t.effective;
+}
+
+static int set_caps(uint64_t permitted, uint64_t effective)
+{
+	struct __user_cap_header_struct hdr = {
+		.version = _LINUX_CAPABILITY_VERSION_3,
+	};
+	struct __user_cap_data_struct data[2] = {
+		{
+			.permitted = (uint32_t)permitted,
+			.effective = (uint32_t)effective,
+		},
+		{
+			.permitted = (uint32_t)(permitted >> 32),
+			.effective = (uint32_t)(effective >> 32),
+		},
+	};
+
+	return syscall(SYS_capset, &hdr, data);
+}
+
+static int drop_all_caps(void)
+{
+	return set_caps(0, 0);
+}
+
+static int drop_caps_except(int cap)
+{
+	uint64_t cap_mask = 1ULL << cap;
+
+	return set_caps(cap_mask, cap_mask);
+}
+
+static int write_file(const char *path, const char *str)
+{
+	ssize_t len = strlen(str);
+	ssize_t ret;
+	int fd, err;
+
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	ret = write(fd, str, len);
+	err = errno;
+	close(fd);
+
+	if (ret < 0)
+		return -err;
+	return (ret == len) ? 0 : -EIO;
+}
+
+static int map_current_ugid(uid_t uid, gid_t gid)
+{
+	char map_buf[64];
+	int ret;
+
+	/*
+	 * May return -EPERM in nested user namespaces when an ancestor
+	 * namespace already set setgroups to "deny".
+	 */
+	ret = write_file("/proc/self/setgroups", "deny\n");
+	if (ret != 0 && ret != -EPERM)
+		return ret;
+
+	snprintf(map_buf, sizeof(map_buf), "0 %u 1\n", uid);
+	ret = write_file("/proc/self/uid_map", map_buf);
+	if (ret != 0)
+		return ret;
+
+	snprintf(map_buf, sizeof(map_buf), "0 %u 1\n", gid);
+	return write_file("/proc/self/gid_map", map_buf);
+}
+
+static int read_proc_userns(uint64_t *val)
+{
+	static const char prefix[] = "CapUns:\t";
+	FILE *f = fopen("/proc/self/status", "r");
+	char line[256];
+	int ret = -1;
+
+	if (!f)
+		return -1;
+
+	while (fgets(line, sizeof(line), f)) {
+		if (strncmp(line, prefix, strlen(prefix)) == 0) {
+			*val = strtoull(line + strlen(prefix), NULL, 16);
+			ret = 0;
+			break;
+		}
+	}
+
+	fclose(f);
+	return ret;
+}
+
+/*
+ * Spawns a child userns owned by the caller's euid without mutating the
+ * caller's credentials. Uses CLONE_FILES so the child can open its own
+ * /proc/self/ns/user directly into the parent's fd table and exit cleanly.
+ */
+static int open_child_userns_without(int lower_cap)
+{
+	struct __clone_args args = {
+		.flags = CLONE_FILES,
+		.exit_signal = SIGCHLD,
+	};
+	int ns_fd, status;
+	pid_t child;
+
+	ns_fd = open("/dev/null", O_RDONLY | O_CLOEXEC);
+	if (ns_fd < 0)
+		return -1;
+
+	child = sys_clone3(&args, sizeof(args));
+	if (child < 0) {
+		close(ns_fd);
+		return -1;
+	}
+
+	if (child == 0) {
+		int fd;
+
+		if (lower_cap >= 0) {
+			if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+				  lower_cap, 0, 0) != 0)
+				_exit(1);
+			if (prctl(PR_SET_SECUREBITS, SECBIT_CAP_USERNS_STRICT,
+				  0, 0, 0) != 0)
+				_exit(1);
+		}
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(1);
+
+		fd = open("/proc/self/ns/user", O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			_exit(1);
+		if (dup3(fd, ns_fd, O_CLOEXEC) < 0)
+			_exit(1);
+		close(fd);
+		_exit(0);
+	}
+
+	if (waitpid(child, &status, 0) != child ||
+	    !WIFEXITED(status) || WEXITSTATUS(status) != 0) {
+		close(ns_fd);
+		return -1;
+	}
+
+	return ns_fd;
+}
+
+static int open_child_userns(void)
+{
+	return open_child_userns_without(-1);
+}
+
+FIXTURE(userns_bset) {
+};
+
+FIXTURE_SETUP(userns_bset)
+{
+	uid_t uid = geteuid();
+	gid_t gid = getegid();
+
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET, 0, 0, 0) < 0 &&
+	    errno == EINVAL)
+		SKIP(return, "PR_CAP_USERNS not supported");
+
+	if (unshare(CLONE_NEWUSER) != 0)
+		SKIP(return, "unshare(CLONE_NEWUSER) failed");
+
+	ASSERT_EQ(0, map_current_ugid(uid, gid));
+}
+
+FIXTURE_TEARDOWN(userns_bset)
+{
+}
+
+/*
+ * An unprivileged userns creator with the default full cap_userns mask
+ * receives all capabilities (0..CAP_LAST_CAP) in a new user namespace.
+ */
+TEST_F(userns_bset, default_full_capabilities)
+{
+	int cap;
+
+	for (cap = 0; cap <= CAP_LAST_CAP; cap++)
+		EXPECT_EQ(1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+				   cap, 0, 0));
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	for (cap = 0; cap <= CAP_LAST_CAP; cap++)
+		EXPECT_TRUE(cap_raised(cap));
+}
+
+/*
+ * Verify prctl(PR_CAP_USERNS) rejects unknown sub-options, out-of-range
+ * capabilities, and non-zero reserved arguments.
+ */
+TEST_F(userns_bset, prctl_invalid_args)
+{
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, 999, 0, 0, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			    CAP_LAST_CAP + 1, 0, 0));
+	EXPECT_EQ(EINVAL, errno);
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_RAISE,
+			    CAP_LAST_CAP + 1, 0, 0));
+	EXPECT_EQ(EINVAL, errno);
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			    CAP_LAST_CAP + 1, 0, 0));
+	EXPECT_EQ(EINVAL, errno);
+
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			    CAP_NET_ADMIN, 1, 0));
+	EXPECT_EQ(EINVAL, errno);
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			    CAP_NET_ADMIN, 0, 1));
+	EXPECT_EQ(EINVAL, errno);
+
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 1, 0, 0));
+	EXPECT_EQ(EINVAL, errno);
+}
+
+/*
+ * Verify PR_CAP_USERNS_LOWER and PR_CAP_USERNS_CLEAR_ALL require either
+ * CAP_SETPCAP or no_new_privs.
+ */
+TEST_F(userns_bset, prctl_lower_authorization)
+{
+	/* CAP_SETPCAP alone (without no_new_privs) authorizes LOWER */
+	ASSERT_EQ(0, drop_caps_except(CAP_SETPCAP));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_RAW, 0, 0));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_RAW, 0, 0));
+
+	/* Without CAP_SETPCAP or no_new_privs, LOWER and CLEAR_ALL must fail */
+	ASSERT_EQ(0, drop_all_caps());
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			    CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(EPERM, errno);
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 0, 0, 0));
+	EXPECT_EQ(EPERM, errno);
+
+	/* Setting no_new_privs unlocks LOWER and CLEAR_ALL */
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+
+	EXPECT_EQ(1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_SYS_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 0, 0, 0));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_SYS_ADMIN, 0, 0));
+}
+
+/*
+ * Verify PR_CAP_USERNS_RAISE requires the capability in cap_permitted.
+ */
+TEST_F(userns_bset, prctl_raise_requires_permitted)
+{
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_RAISE,
+			   CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, drop_caps_except(CAP_SETPCAP));
+
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_RAISE,
+			    CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(EPERM, errno);
+}
+
+/*
+ * Verify /proc/self/status CapUns reflects PR_CAP_USERNS mutations.
+ */
+TEST_F(userns_bset, proc_status_cap_uns)
+{
+	uint64_t cap_uns = 0;
+
+	ASSERT_EQ(0, read_proc_userns(&cap_uns));
+	EXPECT_NE(0ULL, cap_uns & (1ULL << CAP_NET_ADMIN));
+	EXPECT_NE(0ULL, cap_uns & (1ULL << CAP_SYS_ADMIN));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, read_proc_userns(&cap_uns));
+	EXPECT_EQ(0ULL, cap_uns & (1ULL << CAP_NET_ADMIN));
+	EXPECT_NE(0ULL, cap_uns & (1ULL << CAP_SYS_ADMIN));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_RAISE,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, read_proc_userns(&cap_uns));
+	EXPECT_NE(0ULL, cap_uns & (1ULL << CAP_NET_ADMIN));
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 0, 0, 0));
+	ASSERT_EQ(0, read_proc_userns(&cap_uns));
+	EXPECT_EQ(0ULL, cap_uns);
+}
+
+/*
+ * Lowering CAP_NET_ADMIN in cap_userns prevents an unprivileged creator from
+ * acquiring it in a child userns while keeping other capabilities intact.
+ */
+TEST_F(userns_bset, unprivileged_restriction)
+{
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+}
+
+/*
+ * Clearing all capabilities in cap_userns produces a userns with an empty
+ * bounding, permitted, and effective set for an unprivileged creator.
+ */
+TEST_F(userns_bset, clear_all_caps)
+{
+	int cap;
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 0, 0, 0));
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	for (cap = 0; cap <= CAP_LAST_CAP; cap++)
+		EXPECT_TRUE(cap_dropped(cap));
+}
+
+/*
+ * A userns creator retains capabilities held in cred->cap_permitted even when
+ * lowered in cred->cap_userns.
+ */
+TEST_F(userns_bset, creator_retains_permitted_caps)
+{
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_RAW, 0, 0));
+	ASSERT_EQ(0, drop_caps_except(CAP_NET_ADMIN));
+
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	EXPECT_TRUE(cap_raised(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_dropped(CAP_NET_RAW));
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_RAW, 0, 0));
+}
+
+/*
+ * Verify SECURE_CAP_USERNS_STRICT:
+ *  - Prevents PR_CAP_USERNS_RAISE even when cap is in cap_permitted.
+ *  - Prevents retaining lowered caps via cap_permitted on userns creation.
+ *  - Persists (with its lock bit) across userns transition.
+ */
+TEST_F(userns_bset, securebit_cap_userns_strict)
+{
+	int secbits;
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_SET_SECUREBITS,
+			   SECBIT_CAP_USERNS_STRICT |
+			   SECBIT_CAP_USERNS_STRICT_LOCKED, 0, 0, 0));
+
+	/* Lock prevents clearing */
+	EXPECT_EQ(-1, prctl(PR_SET_SECUREBITS, 0, 0, 0, 0));
+	EXPECT_EQ(EPERM, errno);
+
+	/* Cannot raise even though CAP_NET_ADMIN is in cap_permitted */
+	EXPECT_EQ(-1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_RAISE,
+			    CAP_NET_ADMIN, 0, 0));
+	EXPECT_EQ(EPERM, errno);
+
+	/* Child userns does not inherit CAP_NET_ADMIN from cap_permitted */
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+
+	/* Securebit and lock persist across userns transition */
+	secbits = prctl(PR_GET_SECUREBITS, 0, 0, 0, 0);
+	ASSERT_GE(secbits, 0);
+	EXPECT_NE(0, secbits & SECBIT_CAP_USERNS_STRICT);
+	EXPECT_NE(0, secbits & SECBIT_CAP_USERNS_STRICT_LOCKED);
+}
+
+/*
+ * Verify ns->cap_bset decreases monotonically across nested user namespaces.
+ */
+TEST_F(userns_bset, nested_monotonic_restriction)
+{
+	/* Child userns lacks CAP_NET_ADMIN (keep CAP_SETFCAP to map uid 0) */
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, drop_caps_except(CAP_SETFCAP));
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+	ASSERT_EQ(0, map_current_ugid(0, 0));
+
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_raised(CAP_NET_RAW));
+
+	/* Lower a second cap and unshare a grandchild userns */
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_RAW, 0, 0));
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	/* Grandchild lacks both parent's dropped cap and newly lowered cap */
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_dropped(CAP_NET_RAW));
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+}
+
+/*
+ * Verify setns() clamps both active capabilities and cap_userns to the target
+ * namespace's cap_bset, even when held in cap_permitted and cap_userns.
+ */
+TEST_F(userns_bset, setns_clamps_to_userns_bset)
+{
+	int trimmed_ns_fd;
+
+	trimmed_ns_fd = open_child_userns_without(CAP_NET_ADMIN);
+	ASSERT_GE(trimmed_ns_fd, 0);
+
+	ASSERT_EQ(0, drop_caps_except(CAP_NET_ADMIN));
+	ASSERT_EQ(1, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, setns(trimmed_ns_fd, CLONE_NEWUSER));
+	close(trimmed_ns_fd);
+
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+	EXPECT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET,
+			   CAP_NET_ADMIN, 0, 0));
+}
+
+/*
+ * Verify setns() clamps capabilities to the caller's userns capability ceiling
+ * when entering a less-restricted child userns.
+ */
+TEST_F(userns_bset, setns_clamps_to_task_cap_userns)
+{
+	int full_ns_fd;
+
+	full_ns_fd = open_child_userns();
+	ASSERT_GE(full_ns_fd, 0);
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_SET_SECUREBITS, SECBIT_CAP_USERNS_STRICT,
+			   0, 0, 0));
+	ASSERT_TRUE(cap_raised(CAP_NET_ADMIN));
+
+	ASSERT_EQ(0, setns(full_ns_fd, CLONE_NEWUSER));
+	close(full_ns_fd);
+
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+	EXPECT_TRUE(cap_raised(CAP_SYS_ADMIN));
+}
+
+/*
+ * Verify a child's ns->cap_bset does not restrict an ancestor holding the
+ * capability from acting on the child userns, while still clamping credentials
+ * upon entry.
+ */
+TEST_F(userns_bset, ancestor_capable_over_trimmed_child)
+{
+	int no_sys_admin_ns_fd;
+
+	no_sys_admin_ns_fd = open_child_userns_without(CAP_SYS_ADMIN);
+	ASSERT_GE(no_sys_admin_ns_fd, 0);
+
+	ASSERT_EQ(0, setns(no_sys_admin_ns_fd, CLONE_NEWUSER));
+	close(no_sys_admin_ns_fd);
+
+	EXPECT_TRUE(cap_dropped(CAP_SYS_ADMIN));
+	EXPECT_TRUE(cap_raised(CAP_NET_ADMIN));
+}
+
+/*
+ * Verify an unprivileged parent owner only holds implicit capabilities that
+ * are present in the owned namespace's cap_bset, even when the caller's own
+ * cap_userns is unrestricted.
+ */
+TEST_F(userns_bset, parent_owner_bounded_by_owned_bset)
+{
+	int full_ns_fd, no_sys_admin_ns_fd;
+
+	full_ns_fd = open_child_userns();
+	ASSERT_GE(full_ns_fd, 0);
+	no_sys_admin_ns_fd = open_child_userns_without(CAP_SYS_ADMIN);
+	ASSERT_GE(no_sys_admin_ns_fd, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+
+	/* Denied when the owned namespace's cap_bset lacks CAP_SYS_ADMIN */
+	EXPECT_EQ(-1, setns(no_sys_admin_ns_fd, CLONE_NEWUSER));
+	EXPECT_EQ(EPERM, errno);
+
+	/* Allowed when the owned namespace's cap_bset contains CAP_SYS_ADMIN */
+	EXPECT_EQ(0, setns(full_ns_fd, CLONE_NEWUSER));
+
+	close(no_sys_admin_ns_fd);
+	close(full_ns_fd);
+}
+
+/*
+ * Verify an unprivileged parent owner only holds implicit capabilities over a
+ * child userns when the child's cap_bset is a subset of the caller's userns
+ * capability ceiling.
+ */
+TEST_F(userns_bset, parent_owner_requires_bset_subset)
+{
+	int full_ns_fd, trimmed_ns_fd;
+
+	full_ns_fd = open_child_userns();
+	ASSERT_GE(full_ns_fd, 0);
+	trimmed_ns_fd = open_child_userns_without(CAP_NET_ADMIN);
+	ASSERT_GE(trimmed_ns_fd, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	/* Denied: full_ns has CAP_NET_ADMIN outside caller's ceiling */
+	EXPECT_EQ(-1, setns(full_ns_fd, CLONE_NEWUSER));
+	EXPECT_EQ(EPERM, errno);
+
+	/* Allowed: trimmed_ns->cap_bset is a subset of caller's ceiling */
+	EXPECT_EQ(0, setns(trimmed_ns_fd, CLONE_NEWUSER));
+
+	close(trimmed_ns_fd);
+	close(full_ns_fd);
+}
+
+struct tracee {
+	pid_t pid;
+	int fd;
+};
+
+FIXTURE(userns_ptrace) {
+	struct tracee tracees[MAX_TRACEES];
+};
+
+FIXTURE_SETUP(userns_ptrace)
+{
+	uid_t uid = geteuid();
+	gid_t gid = getegid();
+	int i;
+
+	for (i = 0; i < MAX_TRACEES; i++) {
+		self->tracees[i].pid = -1;
+		self->tracees[i].fd = -1;
+	}
+
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_IS_SET, 0, 0, 0) < 0 &&
+	    errno == EINVAL)
+		SKIP(return, "PR_CAP_USERNS not supported");
+
+	if (unshare(CLONE_NEWUSER) != 0)
+		SKIP(return, "unshare(CLONE_NEWUSER) failed");
+
+	ASSERT_EQ(0, map_current_ugid(uid, gid));
+}
+
+FIXTURE_TEARDOWN(userns_ptrace)
+{
+	int i;
+
+	for (i = 0; i < MAX_TRACEES; i++) {
+		if (self->tracees[i].fd >= 0)
+			close(self->tracees[i].fd);
+		if (self->tracees[i].pid > 0) {
+			kill(self->tracees[i].pid, SIGKILL);
+			waitpid(self->tracees[i].pid, NULL, 0);
+		}
+	}
+}
+
+/*
+ * Spawn a child initialized with @setup() that blocks until FIXTURE_TEARDOWN.
+ */
+static pid_t start_tracee(struct tracee *tracees, int (*setup)(void))
+{
+	int slot = -1, sv[2];
+	char ch = 0;
+	pid_t pid;
+	int i;
+
+	for (i = 0; i < MAX_TRACEES; i++) {
+		if (tracees[i].pid < 0) {
+			slot = i;
+			break;
+		}
+	}
+	if (slot < 0)
+		return -1;
+
+	if (socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, sv) != 0)
+		return -1;
+
+	pid = fork();
+	if (pid < 0) {
+		close(sv[0]);
+		close(sv[1]);
+		return -1;
+	}
+
+	if (pid == 0) {
+		close(sv[0]);
+		if (setup && setup() != 0)
+			_exit(1);
+		if (write(sv[1], &ch, 1) != 1)
+			_exit(1);
+		while (read(sv[1], &ch, 1) < 0 && errno == EINTR)
+			;
+		close(sv[1]);
+		_exit(0);
+	}
+
+	close(sv[1]);
+	if (read(sv[0], &ch, 1) != 1) {
+		close(sv[0]);
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+		return -1;
+	}
+
+	tracees[slot].pid = pid;
+	tracees[slot].fd = sv[0];
+	return pid;
+}
+
+static int try_ptrace_attach(pid_t pid)
+{
+	int err, status;
+	pid_t ret;
+
+	if (ptrace(PTRACE_ATTACH, pid, NULL, NULL) != 0)
+		return -errno;
+	do {
+		ret = waitpid(pid, &status, 0);
+	} while (ret < 0 && errno == EINTR);
+	if (ret != pid) {
+		err = -errno;
+		ptrace(PTRACE_DETACH, pid, NULL, NULL);
+		return err;
+	}
+	if (ptrace(PTRACE_DETACH, pid, NULL, NULL) != 0)
+		return -errno;
+	return 0;
+}
+
+/* Unprivileged task in caller's userns with a full userns ceiling. */
+static int tracee_same_ns_full(void)
+{
+	return drop_all_caps();
+}
+
+/* Unprivileged task in caller's userns with CAP_NET_ADMIN lowered. */
+static int tracee_same_ns_no_net_admin(void)
+{
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER, CAP_NET_ADMIN, 0, 0) != 0)
+		return -1;
+	return drop_all_caps();
+}
+
+/* Task with full capabilities inside an untrimmed child userns. */
+static int tracee_child_ns_full(void)
+{
+	return unshare(CLONE_NEWUSER);
+}
+
+/* Task inside a trimmed child userns lacking CAP_NET_ADMIN. */
+static int tracee_child_ns_no_net_admin(void)
+{
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER, CAP_NET_ADMIN, 0, 0) != 0)
+		return -1;
+	if (drop_all_caps() != 0)
+		return -1;
+	return unshare(CLONE_NEWUSER);
+}
+
+/*
+ * Unprivileged task in an untrimmed child userns with CAP_NET_ADMIN dropped
+ * from task caps.
+ */
+static int tracee_child_ns_dropped_caps(void)
+{
+	if (unshare(CLONE_NEWUSER) != 0)
+		return -1;
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER, CAP_NET_ADMIN, 0, 0) != 0)
+		return -1;
+	if (prctl(PR_CAPBSET_DROP, CAP_NET_ADMIN, 0, 0, 0) != 0)
+		return -1;
+	return drop_all_caps();
+}
+
+/*
+ * Unprivileged task in an empty grandchild userns under an untrimmed child
+ * userns.
+ */
+static int tracee_grandchild_ns_empty(void)
+{
+	if (unshare(CLONE_NEWUSER) != 0)
+		return -1;
+	if (map_current_ugid(0, 0) != 0)
+		return -1;
+	if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_CLEAR_ALL, 0, 0, 0) != 0)
+		return -1;
+	if (drop_all_caps() != 0)
+		return -1;
+	return unshare(CLONE_NEWUSER);
+}
+
+/*
+ * Unprivileged tracer in the same userns cannot PTRACE_ATTACH a peer with a
+ * wider userns capability ceiling, while attaching to an equally restricted
+ * peer succeeds.
+ */
+TEST_F(userns_ptrace, same_ns_ceiling)
+{
+	pid_t full, trimmed;
+
+	full = start_tracee(self->tracees, tracee_same_ns_full);
+	ASSERT_GT(full, 0);
+	trimmed = start_tracee(self->tracees, tracee_same_ns_no_net_admin);
+	ASSERT_GT(trimmed, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	EXPECT_EQ(-EPERM, try_ptrace_attach(full));
+	EXPECT_EQ(0, try_ptrace_attach(trimmed));
+}
+
+/*
+ * Implicit CAP_SYS_PTRACE from owning a child userns does not allow a
+ * restricted parent task to attach to a less restricted child userns.
+ */
+TEST_F(userns_ptrace, owned_child_ns_ceiling)
+{
+	pid_t full, trimmed;
+
+	full = start_tracee(self->tracees, tracee_child_ns_full);
+	ASSERT_GT(full, 0);
+	trimmed = start_tracee(self->tracees, tracee_child_ns_no_net_admin);
+	ASSERT_GT(trimmed, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	EXPECT_EQ(-EPERM, try_ptrace_attach(full));
+	EXPECT_EQ(0, try_ptrace_attach(trimmed));
+}
+
+/*
+ * A tracer holding CAP_SYS_PTRACE in its own credentials can still attach to
+ * less restricted tasks in both its own userns and descendant user namespaces.
+ */
+TEST_F(userns_ptrace, explicit_cap_sys_ptrace)
+{
+	pid_t same, child;
+
+	same = start_tracee(self->tracees, tracee_same_ns_full);
+	ASSERT_GT(same, 0);
+	child = start_tracee(self->tracees, tracee_child_ns_full);
+	ASSERT_GT(child, 0);
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_SET_SECUREBITS, SECBIT_CAP_USERNS_STRICT,
+			   0, 0, 0));
+	ASSERT_EQ(0, drop_caps_except(CAP_SYS_PTRACE));
+
+	EXPECT_EQ(0, try_ptrace_attach(same));
+	EXPECT_EQ(0, try_ptrace_attach(child));
+}
+
+/*
+ * PTRACE_MODE_READ_FSCREDS (gating /proc/<pid>/ns/user and /proc/<pid>/fd/)
+ * is likewise bounded by the caller's userns capability ceiling, preventing
+ * a restricted task from stealing open fds or setns()-joining a populated
+ * untrimmed child userns to gain intra-namespace CAP_SYS_PTRACE over tasks
+ * inside it.
+ */
+TEST_F(userns_ptrace, read_mode_ceiling)
+{
+	pid_t full, trimmed;
+	char path[64];
+	int fd;
+
+	full = start_tracee(self->tracees, tracee_child_ns_full);
+	ASSERT_GT(full, 0);
+	trimmed = start_tracee(self->tracees, tracee_child_ns_no_net_admin);
+	ASSERT_GT(trimmed, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", full);
+	EXPECT_EQ(-1, open(path, O_RDONLY | O_CLOEXEC));
+	EXPECT_EQ(EACCES, errno);
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", trimmed);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	EXPECT_GE(fd, 0);
+	if (fd >= 0)
+		close(fd);
+}
+
+/*
+ * Verify PTRACE_TRACEME fails when the parent tracer has a narrower userns
+ * capability ceiling than the child, and succeeds once the child matches it.
+ */
+TEST_F(userns_ptrace, traceme_ceiling)
+{
+	int sync_pipe[2];
+	int status;
+	char ch = 0;
+	pid_t child;
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, pipe(sync_pipe));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0) {
+		close(sync_pipe[1]);
+		if (read(sync_pipe[0], &ch, 1) != 1)
+			_exit(1);
+		close(sync_pipe[0]);
+
+		/* Parent lowered CAP_NET_ADMIN; child still has full mask */
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != -1 ||
+		    errno != EPERM)
+			_exit(2);
+
+		/* Matching parent's ceiling allows PTRACE_TRACEME */
+		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0)
+			_exit(3);
+		if (prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			  CAP_NET_ADMIN, 0, 0) != 0)
+			_exit(4);
+
+		if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0)
+			_exit(5);
+
+		_exit(0);
+	}
+
+	close(sync_pipe[0]);
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	ASSERT_EQ(1, write(sync_pipe[1], &ch, 1));
+	close(sync_pipe[1]);
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify a restricted parent owner cannot attach to a task in an untrimmed
+ * child userns even after that task drops the restricted capability from all
+ * of its own capability sets, since the child namespace itself remains less
+ * restricted than the tracer.
+ */
+TEST_F(userns_ptrace, owned_child_ns_dropped_task_caps)
+{
+	pid_t child;
+
+	child = start_tracee(self->tracees, tracee_child_ns_dropped_caps);
+	ASSERT_GT(child, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+
+	EXPECT_EQ(-EPERM, try_ptrace_attach(child));
+}
+
+/*
+ * Verify narrowing the userns capability ceiling preserves dumpability and the
+ * parent-death signal, while widening it resets both.
+ */
+TEST_F(userns_ptrace, ceiling_widening_resets_dumpable)
+{
+	int suid_dumpable = 0;
+	int pdeath_sig = 0;
+	FILE *f;
+
+	f = fopen("/proc/sys/fs/suid_dumpable", "r");
+	if (f) {
+		if (fscanf(f, "%d", &suid_dumpable) != 1)
+			suid_dumpable = 0;
+		fclose(f);
+	}
+
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_ADMIN, 0, 0));
+	ASSERT_EQ(0, prctl(PR_SET_SECUREBITS, SECBIT_CAP_USERNS_STRICT,
+			   0, 0, 0));
+
+	ASSERT_EQ(0, prctl(PR_SET_DUMPABLE, 1, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_SET_PDEATHSIG, SIGUSR1, 0, 0, 0));
+
+	/* Narrowing the ceiling preserves dumpable and parent-death signal */
+	ASSERT_EQ(0, prctl(PR_CAP_USERNS, PR_CAP_USERNS_LOWER,
+			   CAP_NET_RAW, 0, 0));
+	EXPECT_EQ(1, prctl(PR_GET_DUMPABLE, 0, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_GET_PDEATHSIG, &pdeath_sig, 0, 0, 0));
+	EXPECT_EQ(SIGUSR1, pdeath_sig);
+
+	/*
+	 * Clearing SECBIT_CAP_USERNS_STRICT widens the effective ceiling via
+	 * cap_permitted, resetting both.
+	 */
+	ASSERT_EQ(0, prctl(PR_SET_SECUREBITS, 0, 0, 0, 0));
+	EXPECT_EQ(suid_dumpable, prctl(PR_GET_DUMPABLE, 0, 0, 0, 0));
+	ASSERT_EQ(0, prctl(PR_GET_PDEATHSIG, &pdeath_sig, 0, 0, 0));
+	EXPECT_EQ(0, pdeath_sig);
+}
+
+/*
+ * Verify an unprivileged owner of an untrimmed child userns retains implicit
+ * capabilities (ptrace and setns) over a grandchild userns with an empty
+ * cap_bset, while setns() still clamps capabilities to the grandchild's
+ * cap_bset upon entry.
+ */
+TEST_F(userns_ptrace, owned_child_ns_trimmed_grandchild)
+{
+	char path[64];
+	pid_t child;
+	int ns_fd;
+
+	child = start_tracee(self->tracees, tracee_grandchild_ns_empty);
+	ASSERT_GT(child, 0);
+
+	ASSERT_EQ(0, drop_all_caps());
+	EXPECT_EQ(0, try_ptrace_attach(child));
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", child);
+	ns_fd = open(path, O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(ns_fd, 0);
+
+	ASSERT_EQ(0, setns(ns_fd, CLONE_NEWUSER));
+	close(ns_fd);
+
+	EXPECT_TRUE(cap_dropped(CAP_SYS_ADMIN));
+	EXPECT_TRUE(cap_dropped(CAP_NET_ADMIN));
+}
+
+TEST_HARNESS_MAIN
-- 
2.56.1.708.g77570a6a1d-goog

