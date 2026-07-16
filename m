Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77604314B1;
	Thu, 16 Jul 2026 14:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212519; cv=pass; b=MOTbeggme34P186pntf/gOcYuFA7TW14RxGnCVpOmg/W0dNfmkZmS3XTxx/UwYwCEWYigtQlgOYhuCgtE237DuggHqUZgPXMarKQZ4THEIvgvG08Xile9V1mD62JUZwF3mJp7776jWMRR9gAwHQAZURiYidlsAs9MqBGlLfZtaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212519; c=relaxed/simple;
	bh=v7vKQyl937DD2cM4XIndrYqPAlDTl+JGdjo0sTaN38k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2YRvOn9TIGtnJyjMMj9Wo2aVxsw6ojC+RD1YPE6kGEOIBrJWCpfRHWl+6di24bHA7OkIACPjSChRKQZyQ5beSKQaWVOMM3U0hwBqqWEioXInctlkiLCPDKwUMeLh1cb67pdhKkjomRkdAxMSzQuz5ixelUEchyWN+2FohML8ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=jTrWaB7i; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="jTrWaB7i"
ARC-Seal: i=1; a=rsa-sha256; t=1784212376; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HFmpAz4C9R0TnPKzRNuFSkpgM2kb9oILNBvGPY4pvl8bZpivswWxSMo5p3WXzctQkpXbEz2IBULJPKpr74RHnouAwp7kc69E+7ESOVpj3hC3a3DnO2Rv9oxlBcD2Q0yzZfnCfn4EZ+umvY+qwI2aZahf/9mBNYkSQ60/iYQeRGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212376; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=T/VVSvRXHLa77eMtO3a7EFd0LYmFQlAnxLeIAWiP5T4=; 
	b=F0vSvygOymL1fsRODFtGCo4CDyW3yNxYi9LoDr+kP9S+epA1AfftM/EB+OmAg7qt/MIdTbg3kuHzE991VKNfxBhwVyQE7geLct4mfABV/7aYOiJ0O3ABfmExg5rafFpTcj2w2ipBpAX+Qn7QHm0WrFqutb8/FQHxOS5EN6UDHNU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212376;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=T/VVSvRXHLa77eMtO3a7EFd0LYmFQlAnxLeIAWiP5T4=;
	b=jTrWaB7ieafwCMDhLQgGicc0pwh/0tx5KeTntlFPWkSNDo1dtkgE7bpJLl+b9LcC
	BG8HuIOfT2TiXDMdQNA2vVqTK0ARcxk7uxmZlO18RYZkRBwexcTJcDplSj1z4wTOupM
	GuF9IocfDM+SjWxUSzd2RvEaX7CrgpguxKz6RgvU=
Received: by mx.zohomail.com with SMTPS id 1784212373133952.5048884005315;
	Thu, 16 Jul 2026 07:32:53 -0700 (PDT)
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
Subject: [RFC PATCH 04/24] pidfd: create taskless spawn builders
Date: Thu, 16 Jul 2026 22:31:30 +0800
Message-ID: <f9604865f72d4c74eabec71a1ff070f68697cf38.1784204592.git.me@linux.beauty>
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

Add a pidfs-backed constructor for taskless spawn-builder files. The inode
owns the builder state, so procfd reopens and bind mounts retain it without
creating per-file lifetime rules.

The constructor allocates no task, struct pid, numeric PID, or
process-count charge. Until a later run operation publishes a pid, ordinary
pidfd operations resolve the file as -ESRCH. Preserve that error through
setns() and pidfd_send_signal() instead of translating a valid future pidfd
into an unrelated descriptor error. Assert that PIDFD_EMPTY does not
overlap a valid open flag, so future collisions fail the build instead of
silently aliasing builder creation.

Keep the public pidfd_open() entry point disabled until the complete spawn
state machine is wired later in the series.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                 |  2 +
 fs/Makefile                 |  2 +-
 fs/pidfd_spawn.c            | 81 +++++++++++++++++++++++++++++++++++++
 fs/pidfs.c                  |  5 ++-
 include/linux/pidfd_spawn.h |  9 +++++
 kernel/nsproxy.c            | 11 +++--
 kernel/signal.c             |  2 +-
 7 files changed, 106 insertions(+), 6 deletions(-)
 create mode 100644 fs/pidfd_spawn.c
 create mode 100644 include/linux/pidfd_spawn.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b63bc1ee0171f..8d7f94f09f414 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21287,6 +21287,8 @@ M:	Christian Brauner <christian@brauner.io>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git
+F:	fs/pidfd_spawn.c
+F:	include/linux/pidfd_spawn.h
 F:	include/uapi/linux/pidfd_spawn.h
 F:	samples/pidfd/
 F:	tools/include/uapi/linux/pidfd_spawn.h
diff --git a/fs/Makefile b/fs/Makefile
index aa847be93bc6f..f24beb7c9b7dc 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -8,7 +8,7 @@
 
 
 obj-y :=	open.o read_write.o file_table.o super.o \
-		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
+		char_dev.o stat.o exec.o pidfd_spawn.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
diff --git a/fs/pidfd_spawn.c b/fs/pidfd_spawn.c
new file mode 100644
index 0000000000000..ff2b0cb6365a5
--- /dev/null
+++ b/fs/pidfd_spawn.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * pidfd-backed process spawn builders
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/pid.h>
+#include <linux/pidfd_spawn.h>
+#include <linux/pidfs.h>
+#include <linux/refcount.h>
+#include <linux/slab.h>
+#include <uapi/linux/pidfd.h>
+
+struct pidfd_spawn_state {
+	refcount_t count;
+	struct pid *pid;
+};
+
+static void pidfd_spawn_state_put(struct pidfd_spawn_state *state);
+
+static void pidfd_spawn_free_state(struct pidfd_spawn_state *state)
+{
+	put_pid(state->pid);
+	kfree(state);
+}
+
+static void pidfd_spawn_state_put(struct pidfd_spawn_state *state)
+{
+	if (refcount_dec_and_test(&state->count))
+		pidfd_spawn_free_state(state);
+}
+
+static void pidfd_spawn_state_release(void *data)
+{
+	pidfd_spawn_state_put(data);
+}
+
+static struct pid *pidfd_spawn_file_pid(void *data)
+{
+	struct pidfd_spawn_state *state = data;
+	struct pid *pid;
+
+	pid = READ_ONCE(state->pid);
+	return pid ? pid : ERR_PTR(-ESRCH);
+}
+
+static const struct pidfs_future_file_ops pidfd_spawn_future_ops = {
+	.get_pid = pidfd_spawn_file_pid,
+	.release = pidfd_spawn_state_release,
+};
+
+int pidfd_empty_open(unsigned int flags)
+{
+	struct pidfd_spawn_state *state;
+	struct file *pidfile;
+	int pidfd;
+
+	state = kzalloc_obj(*state, GFP_KERNEL_ACCOUNT);
+	if (!state)
+		return -ENOMEM;
+
+	refcount_set(&state->count, 1);
+
+	pidfile = pidfs_alloc_future_file("[pidfd_spawn]", state,
+					  &pidfd_spawn_future_ops,
+					  O_RDWR | flags);
+	if (IS_ERR(pidfile)) {
+		pidfd_spawn_state_put(state);
+		return PTR_ERR(pidfile);
+	}
+
+	pidfd = get_unused_fd_flags(O_CLOEXEC);
+	if (pidfd < 0) {
+		fput(pidfile);
+		return pidfd;
+	}
+
+	fd_install(pidfd, pidfile);
+	return pidfd;
+}
diff --git a/fs/pidfs.c b/fs/pidfs.c
index ebd8cc463811b..28464fe274c9e 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -2,6 +2,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/compat.h>
 #include <linux/exportfs.h>
+#include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/cgroup.h>
@@ -1261,7 +1262,9 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
 	 * other or with uapi pidfd flags.
 	 */
 	BUILD_BUG_ON(hweight32(PIDFD_THREAD | PIDFD_NONBLOCK |
-				PIDFD_STALE | PIDFD_AUTOKILL) != 4);
+				PIDFD_EMPTY | PIDFD_STALE |
+				PIDFD_AUTOKILL) != 5);
+	BUILD_BUG_ON(PIDFD_EMPTY & VALID_OPEN_FLAGS);
 
 	ret = path_from_stashed(&pid->stashed, pidfs_mnt, get_pid(pid), &path);
 	if (ret < 0)
diff --git a/include/linux/pidfd_spawn.h b/include/linux/pidfd_spawn.h
new file mode 100644
index 0000000000000..8df168cf0c2f9
--- /dev/null
+++ b/include/linux/pidfd_spawn.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PIDFD_SPAWN_H
+#define _LINUX_PIDFD_SPAWN_H
+
+#include <uapi/linux/pidfd_spawn.h>
+
+int pidfd_empty_open(unsigned int flags);
+
+#endif /* _LINUX_PIDFD_SPAWN_H */
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index d9d3d5973bf52..20befb6185e2d 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -581,10 +581,15 @@ SYSCALL_DEFINE2(setns, int, fd, int, flags)
 		if (flags && (ns->ns_type != flags))
 			err = -EINVAL;
 		flags = ns->ns_type;
-	} else if (!IS_ERR(pidfd_pid(fd_file(f)))) {
-		err = check_setns_flags(flags);
 	} else {
-		err = -EINVAL;
+		struct pid *pid = pidfd_pid(fd_file(f));
+
+		if (!IS_ERR(pid))
+			err = check_setns_flags(flags);
+		else if (PTR_ERR(pid) == -ESRCH)
+			err = -ESRCH;
+		else
+			err = -EINVAL;
 	}
 	if (err)
 		goto out;
diff --git a/kernel/signal.c b/kernel/signal.c
index fdee0b012a117..4c7d95981263e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3996,7 +3996,7 @@ static struct pid *pidfd_to_pid(const struct file *file)
 	struct pid *pid;
 
 	pid = pidfd_pid(file);
-	if (!IS_ERR(pid))
+	if (!IS_ERR(pid) || PTR_ERR(pid) != -EBADF)
 		return pid;
 
 	return tgid_pidfd_to_pid(file);
-- 
2.52.0

