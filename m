Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3433D9DD3;
	Thu, 16 Jul 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212416; cv=pass; b=lHibpe6U31J8vZCGNO+nkPTOwE7uLV7G6qrfFsSgWxBzu2TNUz16MT6JMmkHzRh8JdVyzkDbAfAs5kHiHhoAE9Czu0Vrsaofc2vdEnGwa+4mAbMnv3+v+y+eTDo+mJQUDzLQAMMNeQBvIQ48nln4kdTzHXOG1b4C8CEzlvX+JP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212416; c=relaxed/simple;
	bh=KWI+YdvauWU1nRvAg7suCkRdbQKj6i1pSW5RNBvBo+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8wItWvFOTLZbHXiJzQpDA3TbH7sicmDTfOUfepbED975dtwdlHPUAxZXhTddHhHnPvrehyQwICwoD86d4ajY2ivl1Bt8Gor4CEu094IDBU7cCxs7gDOVCkvpYDU9jnnfJHWqxOU13NJJZFWoYo1ukT+kWrV7XwWGyqF/2bSE4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=N24KOIlz; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="N24KOIlz"
ARC-Seal: i=1; a=rsa-sha256; t=1784212346; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZdJsE/0vEBbNiFKex0KPVSttsR7Q+XLYM59HOOE6NnjfxN48EVscoT6PFAvUOUryJjUioA7U6axJMNlhQQZD3nhTnEH2zd5mNrGamY2NeJZnHiLflFYF50/ig3Yr2knfOsCIKvBTHMpnIrmmQc83p2KLtaC+4q/9SmMOhZY3rN4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212346; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vLgQRvjkegtFxDHYyQzzA8SOU5y1blwPrChppwxjEAg=; 
	b=nhOZOHQHgLC1lNxfAHlk5pJPevjCQBbZ1J8SVcVZRKzn1Bagho0HIQcPC55DCHubIo5qoldoxW1hh+gCuLWnpZKPGes0Q7KVxPh1dyBHmx9f5K+KWbWb5E3GT1Bxz66laJ2uM20ImuoYczTK6vE6FQl+vpil1zY75d5YVLAO0Mw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212346;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=vLgQRvjkegtFxDHYyQzzA8SOU5y1blwPrChppwxjEAg=;
	b=N24KOIlzocgoLAYjb7tmRFLoKMnyOcUpMYFTPduMUo0Fy6nZgVA9KukniwBxo1lc
	WDDXubl2fxzluRy1cfdN6UXul6Ow7OQFtJduxPRZhtXtdJpElaiGM5Vgc8Q4VfD6B8v
	eaqdWXyfueurVyHM/vnJXsPRUYr7Zizo8pysCBQE=
Received: by mx.zohomail.com with SMTPS id 1784212343415557.0920836372659;
	Thu, 16 Jul 2026 07:32:23 -0700 (PDT)
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
Subject: [RFC PATCH 01/24] pidfd: add spawn builder uapi
Date: Thu, 16 Jul 2026 22:31:27 +0800
Message-ID: <0ee77dd90ea5d00b66a3e017488ab64f610cf41a.1784204592.git.me@linux.beauty>
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

Define PIDFD_EMPTY, the fsconfig-style configuration command and path
key, and versioned run arguments for pidfd spawn builders. Add the
initial ordered file-action records.

Store userspace pointers in full-width aligned containers on every ABI.
Keep flags and reserved fields zero so later kernels can extend the
structures without changing their initial layout.

Suggested-by: Christian Brauner <brauner@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                            |  2 ++
 include/uapi/linux/pidfd.h             |  1 +
 include/uapi/linux/pidfd_spawn.h       | 49 ++++++++++++++++++++++++++
 tools/include/uapi/linux/pidfd_spawn.h | 49 ++++++++++++++++++++++++++
 4 files changed, 101 insertions(+)
 create mode 100644 include/uapi/linux/pidfd_spawn.h
 create mode 100644 tools/include/uapi/linux/pidfd_spawn.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8729cea57c3dd..b63bc1ee0171f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21287,7 +21287,9 @@ M:	Christian Brauner <christian@brauner.io>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git
+F:	include/uapi/linux/pidfd_spawn.h
 F:	samples/pidfd/
+F:	tools/include/uapi/linux/pidfd_spawn.h
 F:	tools/testing/selftests/clone3/
 F:	tools/testing/selftests/pidfd/
 K:	(?i)pidfd
diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 0919246a1611c..cad5b722e9f0e 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -10,6 +10,7 @@
 /* Flags for pidfd_open().  */
 #define PIDFD_NONBLOCK	O_NONBLOCK
 #define PIDFD_THREAD	O_EXCL
+#define PIDFD_EMPTY	(1U << 27)
 #ifdef __KERNEL__
 #include <linux/sched.h>
 #define PIDFD_STALE CLONE_PIDFD
diff --git a/include/uapi/linux/pidfd_spawn.h b/include/uapi/linux/pidfd_spawn.h
new file mode 100644
index 0000000000000..46d61e72435cc
--- /dev/null
+++ b/include/uapi/linux/pidfd_spawn.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_PIDFD_SPAWN_H
+#define _UAPI_LINUX_PIDFD_SPAWN_H
+
+#include <linux/types.h>
+
+#define PIDFD_SPAWN_RUN_SIZE_VER0	64
+#define PIDFD_SPAWN_ACTION_SIZE_VER0	32
+
+/* Commands for pidfd_config(). */
+#define PIDFD_CONFIG_SET_STRING	0
+
+/* String keys for pidfd_config(). */
+#define PIDFD_CONFIG_KEY_PATH	"path"
+
+struct pidfd_spawn_run_args {
+	__u32 flags;
+	__u32 nr_actions;
+	/* The next four fields are full-width userspace virtual addresses. */
+	__aligned_u64 path;
+	__aligned_u64 argv;
+	__aligned_u64 envp;
+	__aligned_u64 actions;
+	__u32 action_size;
+	__u32 reserved0;
+	__u64 reserved[2];
+};
+
+enum pidfd_spawn_action_type {
+	PIDFD_SPAWN_ACTION_DUP2 = 0,
+	PIDFD_SPAWN_ACTION_CLOSE_RANGE = 1,
+	PIDFD_SPAWN_ACTION_FCHDIR = 2,
+};
+
+struct pidfd_spawn_action {
+	__u32 type;
+	__u32 flags;
+	/*
+	 * DUP2 uses fd as the source and newfd as the destination.
+	 * CLOSE_RANGE uses fd as the first and newfd as the last descriptor.
+	 * FCHDIR uses fd as the directory descriptor and requires newfd to be 0.
+	 */
+	__u32 fd;
+	__u32 newfd;
+	__u64 reserved[2];
+};
+
+#endif /* _UAPI_LINUX_PIDFD_SPAWN_H */
diff --git a/tools/include/uapi/linux/pidfd_spawn.h b/tools/include/uapi/linux/pidfd_spawn.h
new file mode 100644
index 0000000000000..46d61e72435cc
--- /dev/null
+++ b/tools/include/uapi/linux/pidfd_spawn.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_LINUX_PIDFD_SPAWN_H
+#define _UAPI_LINUX_PIDFD_SPAWN_H
+
+#include <linux/types.h>
+
+#define PIDFD_SPAWN_RUN_SIZE_VER0	64
+#define PIDFD_SPAWN_ACTION_SIZE_VER0	32
+
+/* Commands for pidfd_config(). */
+#define PIDFD_CONFIG_SET_STRING	0
+
+/* String keys for pidfd_config(). */
+#define PIDFD_CONFIG_KEY_PATH	"path"
+
+struct pidfd_spawn_run_args {
+	__u32 flags;
+	__u32 nr_actions;
+	/* The next four fields are full-width userspace virtual addresses. */
+	__aligned_u64 path;
+	__aligned_u64 argv;
+	__aligned_u64 envp;
+	__aligned_u64 actions;
+	__u32 action_size;
+	__u32 reserved0;
+	__u64 reserved[2];
+};
+
+enum pidfd_spawn_action_type {
+	PIDFD_SPAWN_ACTION_DUP2 = 0,
+	PIDFD_SPAWN_ACTION_CLOSE_RANGE = 1,
+	PIDFD_SPAWN_ACTION_FCHDIR = 2,
+};
+
+struct pidfd_spawn_action {
+	__u32 type;
+	__u32 flags;
+	/*
+	 * DUP2 uses fd as the source and newfd as the destination.
+	 * CLOSE_RANGE uses fd as the first and newfd as the last descriptor.
+	 * FCHDIR uses fd as the directory descriptor and requires newfd to be 0.
+	 */
+	__u32 fd;
+	__u32 newfd;
+	__u64 reserved[2];
+};
+
+#endif /* _UAPI_LINUX_PIDFD_SPAWN_H */
-- 
2.52.0

