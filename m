Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225899;
	b=onc9ZPPRYK2CMMoN7EQaTw47w4URXIPqKQWgZUfKdvTwHOGEtzsNC4398BEUR2wpeanC
	 b+PtU0wz1cu0To9zBjPA1+HCZDUYbTvKm17l0WnR549wYSDxEjOQA6NDQOTfCNxZPzqnN
	 xUTEGWdY8KCigjgELseFOk5br2IwkoFyJ0wPlZkpwgP1oI97hmRHSUyGSap8FQGo78lzu
	 GCiKZkt1gTA/7hSIhSstS0KsbViIdo27pDbuJVqO2acTTG/wP5FjsPHhhnZQpZpbwBqn2
	 uAxg6jhv3HxG1RzoiH238bxGSiUiVlNbjOwPFrkF5gGrC25IPreMi5H/M+11TyFVchQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=rXOZnWDvJmiB79ZuH6HXR6byjnesMoeHBtfopQgX5R4=;
	b=UoAkpxpXvimozGBTTRRkzgpcX3B7pKuAP1hQgiugGKLYcxKaylgM58syz9V3xjG9DE3d
	 P/DA1CobQ80fSInppW+SgNEcTDsheyirHSYLPiSBzgKK/4sbWtH91gC+QPx8PBuNWyQ1N
	 VYMoXouXhNR5W2SkfvPeffmYQ22Q7s3T5NH0ndxXKyZdNArFQwJALOOztzkTOAd62d+zB
	 /9RRRruBAFHciSxHCr8bCPJvpuOi+CYyK7FvHvKtHt+KQZRBUr40mU0XMBeWP+flo2M7+
	 lZr/K6SDlP/V0qS/wWb+9jIu4T9AlEh/g/7BIHJs5JXh+34W0RBPR3jM5Zn5dYpB6NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HApD03Ii;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194660A3809
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B194660A3809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HApD03Ii
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c42f98f354fso139963266b.0
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225897; x=1793830697; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rXOZnWDvJmiB79ZuH6HXR6byjnesMoeHBtfopQgX5R4=;
        b=HApD03IioDyB/5xObYimRMBXncSrv0kSSdX2CR4WLFeIls9pL1v/pxHjby5HEDU6XY
         DhYhE0Atf4LeGLxzR4c9XbKLH2Jg2yLY1UN+BL7kW/Pv42jgs19tqA4glesZbbzyZHs/
         2TuH5smtOOqfXh5bOhu2Kfggifu8IMewub5YgBsxil909wHKiYCC71SeKrhv8LoiFTcA
         qg2RCrwHNNr7uFBfnfJJtbULdwgB+1bpieVpXUjPMDzx97URLNiT/pMFxrFe1HdjFmuZ
         0rNB57Fkbg7KgNe/2mwnwp3g6ZUQhyRsAINMiWNLvhxAQGMtGrilqdMZZMDLx0KYIwc/
         7xKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225897; x=1793830697;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rXOZnWDvJmiB79ZuH6HXR6byjnesMoeHBtfopQgX5R4=;
        b=siLmerJLFGAI6oWVQnQwcUJ4xfyMlCJdkKmf2ZtVDREumOQWyB0lykZjsr3exAnsg4
         +0HrZCJzo1dzPqbpOHKm0nZJLIE1tcwnArlkEWPTBLP7eXOpzRPR7zxfHHlcjjOoEQDn
         8Fv3tDWnXldGGWKJmlDi+ksKGczmN0o4XwNaK/LnYgbxsngqvgrUPJitB8ST/6mv9FKe
         BNBrDo8/+meUoB3PIAT0SHyTpP6XbZKNxvpBcmTg0pmCMuuGiqBu8nt8KOgHeuL5gkYD
         XTchpkzPees5+aMWgZjNz6UeXLgf3k3vzZIvDKV+8q3RVX5yXhu8WZ4yYLRq11TooAtv
         Q67w==
X-Forwarded-Encrypted: i=1; AKwUvBxILEesmlZg7lkjzkg8pYkHin0X9nvz+KzKh1FdtENE8Yc6t6uFk/dfR5RcIXglJWRhQYogHDB3QSE=@vger.kernel.org
X-Gm-Message-State: AFq9FYIAJ4pf6q23sp61nhQdxzNfr74VTzAZTilsffh6OigbswzLCVdC
	ckV9oCf9u8P5KTNzrWMivA44uELLJ5fLUwC6d6XGRCzhzwtVZymUQYj5kH7u3STmw7+2e6I3gg=
	=
X-Received: from ejbgx8.prod.google.com ([2002:a17:906:f1c8:b0:c49:b559:be86])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:d649:b0:c40:d762:feaf
 with SMTP id a640c23a62f3a-c49bdf380c3mr325253666b.21.1793225896643; Wed, 28
 Oct 2026 15:18:16 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:17:03 +0000
In-Reply-To: <20261028221705.3915340-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028221705.3915340-7-halg@google.com>
Subject: [PATCH 6/8] selftests/capabilities: tests for user namespace
 capability bounding set
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

Add tests in tools/testing/selftests/capabilities for the user
namespace capability bounding set feature:

- Verify default full capabilities and sysctl capability restriction for
  unprivileged user namespaces.
- Verify that unprivileged creators retain their existing effective
  capabilities despite the sysctl ceiling.
- Verify that privileged creators bypass the sysctl ceiling.
- Verify monotonic capability restriction across nested namespaces.
- Verify parent-ownership capability bounding.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 .../testing/selftests/capabilities/.gitignore |   1 +
 tools/testing/selftests/capabilities/Makefile |   2 +-
 .../capabilities/userns_bounding_set_test.c   | 420 ++++++++++++++++++
 3 files changed, 422 insertions(+), 1 deletion(-)
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
index 000000000000..798758e0705d
--- /dev/null
+++ b/tools/testing/selftests/capabilities/userns_bounding_set_test.c
@@ -0,0 +1,420 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/capability.h>
+#include <linux/sched.h>
+
+#include "../clone3/clone3_selftests.h"
+#include "../kselftest_harness.h"
+
+#define SYSCTL_PATH "/proc/sys/kernel/unprivileged_userns_caps_allowed"
+
+static const uint64_t cap_full_set = ~0ULL;
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
+	if (cap < 0 || cap >= 64)
+		return -EINVAL;
+
+	if (syscall(SYS_capget, &hdr, data) != 0)
+		return -errno;
+
+	idx = (cap >= 32) ? 1 : 0;
+	mask = 1U << (cap % 32);
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
+static int set_effective_cap(int cap)
+{
+	struct __user_cap_header_struct hdr = {
+		.version = _LINUX_CAPABILITY_VERSION_3,
+	};
+	struct __user_cap_data_struct data[2] = {};
+
+	if (cap >= 0) {
+		int idx = (cap >= 32) ? 1 : 0;
+		uint32_t mask = 1U << (cap % 32);
+
+		data[idx].effective = mask;
+		data[idx].permitted = mask;
+	}
+
+	return syscall(SYS_capset, &hdr, data);
+}
+
+static int drop_privileges(void)
+{
+	return set_effective_cap(-1);
+}
+
+static int write_file(const char *path, const char *str)
+{
+	ssize_t len = strlen(str);
+	ssize_t ret;
+	int fd;
+
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = write(fd, str, len);
+	close(fd);
+
+	return (ret == len) ? 0 : -1;
+}
+
+static int read_sysctl_caps(uint64_t *caps_out)
+{
+	char buf[64] = {};
+	ssize_t ret;
+	int fd;
+
+	fd = open(SYSCTL_PATH, O_RDONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (ret <= 0)
+		return -1;
+
+	*caps_out = strtoull(buf, NULL, 16);
+	return 0;
+}
+
+static int write_sysctl_caps(uint64_t val)
+{
+	char buf[64];
+
+	snprintf(buf, sizeof(buf), "%016llx\n", (unsigned long long)val);
+	return write_file(SYSCTL_PATH, buf);
+}
+
+/*
+ * Attempts setns(CLONE_NEWUSER) into an unprivileged child user namespace
+ * from the owning parent process (which has no effective capabilities in
+ * its own namespace and relies on the parent-owner rule in
+ * cap_capable_helper()).
+ */
+static int run_parent_owner_setns(uint64_t sysctl_mask)
+{
+	pid_t owner_pid;
+	int status;
+
+	if (write_sysctl_caps(sysctl_mask) != 0)
+		return -1;
+
+	owner_pid = fork();
+	if (owner_pid < 0)
+		return -1;
+
+	if (owner_pid == 0) {
+		struct __clone_args args = {
+			.flags = CLONE_FILES | CLONE_NEWUSER,
+			.exit_signal = SIGCHLD,
+		};
+		pid_t child_pid;
+		int userns_fd;
+		int err;
+
+		if (drop_privileges() != 0)
+			_exit(255);
+
+		child_pid = sys_clone3(&args, sizeof(args));
+		if (child_pid < 0)
+			_exit(255);
+
+		if (child_pid == 0) {
+			int fd = open("/proc/self/ns/user", O_RDONLY);
+
+			if (fd < 0)
+				_exit(255);
+			_exit(fd);
+		}
+
+		if (waitpid(child_pid, &status, 0) != child_pid ||
+		    !WIFEXITED(status) || WEXITSTATUS(status) == 255)
+			_exit(255);
+
+		userns_fd = WEXITSTATUS(status);
+		err = (setns(userns_fd, CLONE_NEWUSER) == 0) ? 0 : errno;
+		close(userns_fd);
+		_exit(err);
+	}
+
+	if (waitpid(owner_pid, &status, 0) != owner_pid || !WIFEXITED(status))
+		return -1;
+
+	return WEXITSTATUS(status);
+}
+
+FIXTURE(userns_bset) {
+	uint64_t orig_caps;
+	bool have_orig_caps;
+};
+
+FIXTURE_SETUP(userns_bset)
+{
+	self->orig_caps = 0;
+	self->have_orig_caps = false;
+
+	if (geteuid() != 0)
+		SKIP(return, "Requires root privileges");
+	if (access(SYSCTL_PATH, F_OK) != 0)
+		SKIP(return, "Sysctl %s not present", SYSCTL_PATH);
+
+	ASSERT_EQ(0, read_sysctl_caps(&self->orig_caps));
+	self->have_orig_caps = true;
+}
+
+FIXTURE_TEARDOWN(userns_bset)
+{
+	if (self->have_orig_caps)
+		write_sysctl_caps(self->orig_caps);
+}
+
+/*
+ * An unprivileged userns creator with the full mask should receive
+ * CAP_NET_ADMIN and CAP_SYS_ADMIN.
+ */
+TEST_F(userns_bset, default_full_capabilities)
+{
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(cap_full_set));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (drop_privileges() != 0)
+			_exit(1);
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(2);
+		if (!cap_raised(CAP_SYS_ADMIN))
+			_exit(3);
+		if (!cap_raised(CAP_NET_ADMIN))
+			_exit(4);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Dropping CAP_NET_ADMIN from the sysctl prevents unprivileged userns
+ * from obtaining CAP_NET_ADMIN while retaining other capabilities.
+ */
+TEST_F(userns_bset, unprivileged_restriction)
+{
+	uint64_t restricted_mask = cap_full_set & ~(1ULL << CAP_NET_ADMIN);
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(restricted_mask));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (drop_privileges() != 0)
+			_exit(1);
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(2);
+		if (!cap_raised(CAP_SYS_ADMIN))
+			_exit(3);
+		if (!cap_dropped(CAP_NET_ADMIN))
+			_exit(4);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Unprivileged userns should retain effective capabilities from the creator
+ * (CAP_NET_ADMIN) while still having unheld capabilities (CAP_NET_RAW) trimmed.
+ */
+TEST_F(userns_bset, creator_retains_effective_cap)
+{
+	uint64_t restricted_mask = cap_full_set &
+		~((1ULL << CAP_NET_ADMIN) | (1ULL << CAP_NET_RAW));
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(restricted_mask));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (set_effective_cap(CAP_NET_ADMIN) != 0)
+			_exit(1);
+
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(2);
+
+		if (!cap_raised(CAP_NET_ADMIN))
+			_exit(3);
+		if (!cap_dropped(CAP_NET_RAW))
+			_exit(4);
+		if (!cap_raised(CAP_SYS_ADMIN))
+			_exit(5);
+
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Privileged processes (with CAP_SYS_ADMIN in parent ns) retain full
+ * capabilities regardless of the unprivileged sysctl mask.
+ */
+TEST_F(userns_bset, privileged_bypass)
+{
+	uint64_t restricted_mask = cap_full_set & ~(1ULL << CAP_NET_ADMIN);
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(restricted_mask));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(1);
+		if (!cap_raised(CAP_NET_ADMIN))
+			_exit(2);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify that once a capability is dropped in a user namespace
+ * a privileged creator (holding CAP_SYS_ADMIN) in that namespace
+ * cannot regain the dropped capability by creating a nested child
+ * namespace.
+ */
+TEST_F(userns_bset, nested_monotonic_restriction)
+{
+	uint64_t restricted_mask = cap_full_set & ~(1ULL << CAP_NET_ADMIN);
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(restricted_mask));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (set_effective_cap(CAP_SETFCAP) != 0)
+			_exit(1);
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(2);
+		if (!cap_dropped(CAP_NET_ADMIN))
+			_exit(3);
+
+		/* Map our UID/GID so creating a nested userns is permitted */
+		if (write_file("/proc/self/setgroups", "deny\n") != 0 ||
+		    write_file("/proc/self/uid_map", "0 0 1\n") != 0 ||
+		    write_file("/proc/self/gid_map", "0 0 1\n") != 0)
+			_exit(4);
+
+		if (unshare(CLONE_NEWUSER) != 0)
+			_exit(5);
+		if (!cap_dropped(CAP_NET_ADMIN))
+			_exit(6);
+		if (!cap_raised(CAP_SYS_ADMIN))
+			_exit(7);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify that an unprivileged parent owning a child namespace retains
+ * implicit capabilities over it when permitted by the child's cap_bset.
+ */
+TEST_F(userns_bset, parent_owner_cap_permitted)
+{
+	EXPECT_EQ(0, run_parent_owner_setns(cap_full_set));
+}
+
+/*
+ * Verify that an unprivileged parent's implicit capabilities over its
+ * owned child namespace are restricted by the child's cap_bset.
+ */
+TEST_F(userns_bset, parent_owner_cap_restricted)
+{
+	uint64_t restricted_mask = cap_full_set & ~(1ULL << CAP_SYS_ADMIN);
+
+	EXPECT_EQ(EPERM, run_parent_owner_setns(restricted_mask));
+}
+
+TEST_HARNESS_MAIN
-- 
2.56.0.313.g2479322e68-goog

