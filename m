Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D974302E1;
	Thu, 16 Jul 2026 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212583; cv=pass; b=aB2UHsVKpMebZEY9sGGQsPQP95SQOl4ereZnKZKQUQr11K11xo+Fnp+0Da9lPTefTAJFqH/8+nUwhSAAiDvaiR94S7uGP9GmLn55DogN6sTBbrIaLg94QL7Ek7isMbdmIGNMroehdbLa2jSK5B8Cf9ni3YOUk2F5GFQPVC4kgP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212583; c=relaxed/simple;
	bh=UF+uKKitkyHE4Bs9P9cDQvid7nKd39UR1kDZcZd11xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/2VEECZ+T8Ravd2O4OJ9Ulsf9RV4n47pfQ1zSSHsmPxS+E3lE5m29lEDSwU0lBrdKZVdmY7GZVGozTHS1do+sQ7ByDnVjyo1et+fynxHc8iCnpRbYs7b8K+kQd4ziTwAU/YMDKjdYHfY4pevZzH5tqDrjUWCF4vW9hHemdX/pU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Ye3rs0MS; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Ye3rs0MS"
ARC-Seal: i=1; a=rsa-sha256; t=1784212392; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=jznrEKQdfJK9XlXLcrwXp+M8yZtQRw2PwL7zl54fcjtEVz6vmhH8bl0X+MXWpJRmWfCboECKYLXqtNARRLsmfdXi3brdOq6Promtrd0y2F4BlrHokWOsTFd4/Orz/69DXccypqrEurxZ7tNUYSAcpYwJ3i7YJP9tlZST0Q5/O+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212392; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4WlGJlssUl95Sy+7ZPm60xZZ+Av02JpGkVDZJY42NWU=; 
	b=Xkelz1J9SKXGI1ETZ7bxCTxKBpH53gqotNR/jBZjWm0bNQcP0Zp1nZ/m+pRm2NRriNMae33rGCEg4jXMgpkaEMyHP13mAMilGNDq3ewpAe7JFtV01FH0U1KbgUYf4qw49Ed4lChBM9z5T5zaYykg2e+U+3OSmfABS4R4clGuZV8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212392;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4WlGJlssUl95Sy+7ZPm60xZZ+Av02JpGkVDZJY42NWU=;
	b=Ye3rs0MS2ukDX+2xyNEMYeevu/o4eWER+D22wvIpwNj1OeTLZYWEJDP6z6/ijY0F
	sQGMAIOUEUfdNZnL9rP0A6OJnGPU/ervlYSefajfn/w4dJMHer5zULGF2HwEa/qoP3y
	FG5jUxQdbY8XSQe+/uAyWimxw2ApcipNIRHWj05c=
Received: by mx.zohomail.com with SMTPS id 1784212390537743.799194073505;
	Thu, 16 Jul 2026 07:33:10 -0700 (PDT)
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
Subject: [RFC PATCH 06/24] exec: expose execveat internals to process builders
Date: Thu, 16 Jul 2026 22:31:32 +0800
Message-ID: <35cbc4c456675c2613ed4682d88aad8af83370cf.1784204592.git.me@linux.beauty>
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

Move struct user_arg_ptr and its native and compat constructors to an
fs-private header. Expose do_execveat_common() within fs so a process
builder can enter the normal exec path without synthesizing a userspace
execveat() syscall.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS        |  1 +
 fs/exec.c          | 28 ++++------------------------
 fs/exec_internal.h | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 24 deletions(-)
 create mode 100644 fs/exec_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d7f94f09f414..85b1306cb2ff3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9757,6 +9757,7 @@ F:	Documentation/userspace-api/ELF.rst
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
+F:	fs/exec_internal.h
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
 F:	include/linux/binfmts.h
diff --git a/fs/exec.c b/fs/exec.c
index d5993cedc829a..1a256ba26425e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -76,6 +76,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "exec_internal.h"
 
 #include <trace/events/sched.h>
 
@@ -291,17 +292,6 @@ static int bprm_mm_init(struct linux_binprm *bprm)
 	return err;
 }
 
-struct user_arg_ptr {
-#ifdef CONFIG_COMPAT
-	bool is_compat;
-#endif
-	union {
-		const char __user *const __user *native;
-#ifdef CONFIG_COMPAT
-		const compat_uptr_t __user *compat;
-#endif
-	} ptr;
-};
 
 static const char __user *get_user_arg_ptr(struct user_arg_ptr argv, int nr)
 {
@@ -1805,10 +1795,9 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
-static int do_execveat_common(int fd, struct filename *filename,
-			      struct user_arg_ptr argv,
-			      struct user_arg_ptr envp,
-			      int flags)
+int do_execveat_common(int fd, struct filename *filename,
+		       struct user_arg_ptr argv,
+		       struct user_arg_ptr envp, int flags)
 {
 	int retval;
 
@@ -1935,10 +1924,6 @@ void set_binfmt(struct linux_binfmt *new)
 }
 EXPORT_SYMBOL(set_binfmt);
 
-static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
-{
-	return (struct user_arg_ptr){.ptr.native = p};
-}
 
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
@@ -1963,11 +1948,6 @@ SYSCALL_DEFINE5(execveat,
 
 #ifdef CONFIG_COMPAT
 
-static inline struct user_arg_ptr compat_arg(const compat_uptr_t __user *p)
-{
-	return (struct user_arg_ptr){.is_compat = true, .ptr.compat = p};
-}
-
 COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
 	const compat_uptr_t __user *, envp)
diff --git a/fs/exec_internal.h b/fs/exec_internal.h
new file mode 100644
index 0000000000000..bf6a873e98426
--- /dev/null
+++ b/fs/exec_internal.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _FS_EXEC_INTERNAL_H
+#define _FS_EXEC_INTERNAL_H
+
+#include <linux/compat.h>
+#include <linux/compiler_types.h>
+#include <linux/types.h>
+
+struct filename;
+
+struct user_arg_ptr {
+#ifdef CONFIG_COMPAT
+	bool is_compat;
+#endif
+	union {
+		const char __user *const __user *native;
+#ifdef CONFIG_COMPAT
+		const compat_uptr_t __user *compat;
+#endif
+	} ptr;
+};
+
+static inline struct user_arg_ptr
+native_arg(const char __user *const __user *p)
+{
+	return (struct user_arg_ptr){.ptr.native = p};
+}
+
+#ifdef CONFIG_COMPAT
+static inline struct user_arg_ptr compat_arg(const compat_uptr_t __user *p)
+{
+	return (struct user_arg_ptr){.is_compat = true, .ptr.compat = p};
+}
+#endif
+
+int do_execveat_common(int fd, struct filename *filename,
+		       struct user_arg_ptr argv,
+		       struct user_arg_ptr envp, int flags);
+
+#endif /* _FS_EXEC_INTERNAL_H */
-- 
2.52.0

