Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C43437844;
	Thu, 16 Jul 2026 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212905; cv=pass; b=t82Q6hXivP7znba5MU+M11va/neVGOjjYKEAT09ICZV2NfrNKGiiEGI8rYmY1JPzkTopTgR6CeftVHN4AbIGTBdUAhkAbACyJwwz8lrAbXcMT1W/aRjiWSj62J5Hwd/Qa6eZCzI6B1DXwWCVAr1C8QvLfR+pCGtr802DJKzBWGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212905; c=relaxed/simple;
	bh=ttyd9g4M4Oojhto0nseHAXqqhUKi5G/yOw73KUdYZZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/bfVkQ4pW8ln2g12Z/PR9Jd4NcHjmXNBrH8IZNmcGp/68dcRCFht7EEJuBVMf2nscoSOjBjxuCqx5q92YI3025WifbesPMXqcljghyEB9S8EF91WAvDSIZz52S0Yfdq3AZfB4cmmQN7aTNHfmAUMysGJ+fagZ7u60awQ34ZuNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=lsr4e9mo; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="lsr4e9mo"
ARC-Seal: i=1; a=rsa-sha256; t=1784212490; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=i8zpP5LHxDjWUFBIMr9F5Ya5iUzpShu0G/C/ob2EOSvkT2jCeBAP4A0ZzGriMJp8Uy25XvwuSX0aZL1MJNSjnoaS2Gzfv2/1wYL833wu+syUlHsOrs//gmLz6sOdbMyY0pnzR4811uCMkbV5OJRkrJExY7SmU9ERZiER9Xxq7GU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212490; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MnKSghhM4T6Z1xfA6Jwi8vqE/9OZUSpMDE8lVv8sYoo=; 
	b=Plm8AiIgQKoll2Ww/X9nACYiP0diWUbpkTElyptvVyzJmJ+LJ1x/4/umpdhweZSMK4VJ3nAVcM+LH/dE0tNJUE0sjIWJUmI3U+R8lhHXTUjzp/Y3L7nY51+8hJvsRee7LWU26vZgA7CF9WPfXR/y/0Gr3wGhaez8KRF9+vTPess=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212490;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MnKSghhM4T6Z1xfA6Jwi8vqE/9OZUSpMDE8lVv8sYoo=;
	b=lsr4e9moWNYb4eSaOYGeAMWDT08MXzfzOP3JE+aiPMgys2Zyax40I+ygqRb+rOsE
	J3AiCfVuuFYdMtRDXuqE86DOqBWrFrcJ9LOI90Lq0MsIQLEOWfIkufAwV6uD7hMKw0E
	jDdPsySbY4ZeN27r/us/PDk1/dT9b07EFrGWEfjM=
Received: by mx.zohomail.com with SMTPS id 1784212488400857.4930366975865;
	Thu, 16 Jul 2026 07:34:48 -0700 (PDT)
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
Subject: [RFC PATCH 16/24] audit: add pidfd spawn child contexts
Date: Thu, 16 Jul 2026 22:31:42 +0800
Message-ID: <3d54188702aa809839b24210cf0cd77de897f1e3.1784204592.git.me@linux.beauty>
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

Kernel-mediated spawn executes file setup and exec from initial child task
work, not from a second syscall entry. Representing that work as another
AUDIT_SYSCALL record duplicates the source pidfd_spawn_run transaction and
invents a syscall that the child never entered.

Add a dedicated audit context and AUDIT_PIDFD_SPAWN record. Carry the
originating syscall number and arguments. Existing syscall exit filters can
then select the child transaction. CWD, PATH, and EXECVE records remain
correlated with it. Let the child close the transaction with an explicit
result instead of rewriting an architecture syscall-return frame.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/audit.h      |  31 +++++++++++
 include/uapi/linux/audit.h |   1 +
 kernel/audit.h             |   1 +
 kernel/auditsc.c           | 105 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 45abb3722d304..872624a9fba08 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -323,6 +323,9 @@ extern int  audit_alloc(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
 extern void __audit_uring_entry(u8 op);
 extern void __audit_uring_exit(int success, long code);
+void __audit_pidfd_spawn_entry(int major, unsigned long a0, unsigned long a1,
+			       unsigned long a2, unsigned long a3);
+void __audit_pidfd_spawn_exit(int success, long code);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -373,6 +376,22 @@ static inline void audit_uring_exit(int success, long code)
 	if (unlikely(audit_context()))
 		__audit_uring_exit(success, code);
 }
+
+static inline void audit_pidfd_spawn_entry(int major, unsigned long a0,
+					   unsigned long a1,
+					   unsigned long a2,
+					   unsigned long a3)
+{
+	if (unlikely(audit_context()))
+		__audit_pidfd_spawn_entry(major, a0, a1, a2, a3);
+}
+
+static inline void audit_pidfd_spawn_exit(int success, long code)
+{
+	if (unlikely(audit_context()))
+		__audit_pidfd_spawn_exit(success, code);
+}
+
 static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
@@ -380,6 +399,7 @@ static inline void audit_syscall_entry(int major, unsigned long a0,
 	if (unlikely(audit_context()))
 		__audit_syscall_entry(major, a0, a1, a2, a3);
 }
+
 static inline void audit_syscall_exit(void *pt_regs)
 {
 	if (unlikely(audit_context())) {
@@ -611,10 +631,21 @@ static inline void audit_uring_entry(u8 op)
 { }
 static inline void audit_uring_exit(int success, long code)
 { }
+
+static inline void audit_pidfd_spawn_entry(int major, unsigned long a0,
+					   unsigned long a1,
+					   unsigned long a2,
+					   unsigned long a3)
+{ }
+
+static inline void audit_pidfd_spawn_exit(int success, long code)
+{ }
+
 static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
 { }
+
 static inline void audit_syscall_exit(void *pt_regs)
 { }
 static inline bool audit_dummy_context(void)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index e8f5ce677df73..e09fb5222293a 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -122,6 +122,7 @@
 #define AUDIT_OPENAT2		1337	/* Record showing openat2 how args */
 #define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
 #define AUDIT_DM_EVENT		1339	/* Device Mapper events */
+#define AUDIT_PIDFD_SPAWN	1340	/* pidfd spawn child operation */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.h b/kernel/audit.h
index 92d5e723d570b..2f740df7beecf 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -112,6 +112,7 @@ struct audit_context {
 		AUDIT_CTX_UNUSED,	/* audit_context is currently unused */
 		AUDIT_CTX_SYSCALL,	/* in use by syscall */
 		AUDIT_CTX_URING,	/* in use by io_uring */
+		AUDIT_CTX_PIDFD_SPAWN,	/* pidfd spawn child operation */
 	} context;
 	enum audit_state    state, current_state;
 	struct audit_stamp  stamp;	/* event identifier */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6610e667c728a..8f6d84a902239 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1649,6 +1649,30 @@ static void audit_log_uring(struct audit_context *ctx)
 	audit_log_end(ab);
 }
 
+/**
+ * audit_log_pidfd_spawn - generate an AUDIT_PIDFD_SPAWN record
+ * @ctx: the audit context
+ */
+static void audit_log_pidfd_spawn(struct audit_context *ctx)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(ctx, GFP_KERNEL, AUDIT_PIDFD_SPAWN);
+	if (!ab)
+		return;
+	audit_log_format(ab, "arch=%x syscall=%d", ctx->arch, ctx->major);
+	if (ctx->return_valid != AUDITSC_INVALID)
+		audit_log_format(ab, " success=%s exit=%ld",
+				 str_yes_no(ctx->return_valid == AUDITSC_SUCCESS),
+				 ctx->return_code);
+	audit_log_format(ab, " a0=%lx a1=%lx a2=%lx a3=%lx items=%d",
+			 ctx->argv[0], ctx->argv[1], ctx->argv[2],
+			 ctx->argv[3], ctx->name_count);
+	audit_log_task_info(ab);
+	audit_log_key(ab, ctx->filterkey);
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(void)
 {
 	int i, call_panic = 0;
@@ -1687,6 +1711,9 @@ static void audit_log_exit(void)
 	case AUDIT_CTX_URING:
 		audit_log_uring(context);
 		break;
+	case AUDIT_CTX_PIDFD_SPAWN:
+		audit_log_pidfd_spawn(context);
+		break;
 	default:
 		BUG();
 		break;
@@ -1782,7 +1809,8 @@ static void audit_log_exit(void)
 		audit_log_name(context, n, NULL, i++, &call_panic);
 	}
 
-	if (context->context == AUDIT_CTX_SYSCALL)
+	if (context->context == AUDIT_CTX_SYSCALL ||
+	    context->context == AUDIT_CTX_PIDFD_SPAWN)
 		audit_log_proctitle();
 
 	/* Send end of event record to help user space know we are finished */
@@ -1818,7 +1846,8 @@ void __audit_free(struct task_struct *tsk)
 	if (tsk == current && !context->dummy) {
 		context->return_valid = AUDITSC_INVALID;
 		context->return_code = 0;
-		if (context->context == AUDIT_CTX_SYSCALL) {
+		if (context->context == AUDIT_CTX_SYSCALL ||
+		    context->context == AUDIT_CTX_PIDFD_SPAWN) {
 			audit_filter_syscall(tsk, context);
 			audit_filter_inodes(tsk, context);
 			if (context->current_state == AUDIT_STATE_RECORD)
@@ -1967,6 +1996,78 @@ void __audit_uring_exit(int success, long code)
 	audit_reset_context(ctx);
 }
 
+/**
+ * __audit_pidfd_spawn_entry - start a pidfd spawn child audit context
+ * @major: originating pidfd_spawn_run syscall number
+ * @a0: originating syscall argument 0
+ * @a1: originating syscall argument 1
+ * @a2: originating syscall argument 2
+ * @a3: originating syscall argument 3
+ */
+void __audit_pidfd_spawn_entry(int major, unsigned long a0, unsigned long a1,
+			       unsigned long a2, unsigned long a3)
+{
+	struct audit_context *context = audit_context();
+	enum audit_state state;
+
+	if (!audit_enabled || !context)
+		return;
+
+	WARN_ON(context->context != AUDIT_CTX_UNUSED);
+	WARN_ON(context->name_count);
+	if (context->context != AUDIT_CTX_UNUSED || context->name_count) {
+		audit_panic("unrecoverable error in audit_pidfd_spawn_entry()");
+		return;
+	}
+
+	state = context->state;
+	if (state == AUDIT_STATE_DISABLED)
+		return;
+
+	context->dummy = !audit_n_rules;
+	if (!context->dummy && state == AUDIT_STATE_BUILD) {
+		context->prio = 0;
+		if (auditd_test_task(current))
+			return;
+	}
+
+	context->arch = syscall_get_arch(current);
+	context->major = major;
+	context->argv[0] = a0;
+	context->argv[1] = a1;
+	context->argv[2] = a2;
+	context->argv[3] = a3;
+	context->context = AUDIT_CTX_PIDFD_SPAWN;
+	context->current_state = state;
+	ktime_get_coarse_real_ts64(&context->stamp.ctime);
+}
+
+/**
+ * __audit_pidfd_spawn_exit - finish a pidfd spawn child audit context
+ * @success: whether child-side setup succeeded
+ * @return_code: child-side setup result
+ */
+void __audit_pidfd_spawn_exit(int success, long return_code)
+{
+	struct audit_context *context = audit_context();
+
+	if (!context || context->dummy ||
+	    context->context != AUDIT_CTX_PIDFD_SPAWN)
+		goto out;
+
+	if (!list_empty(&context->killed_trees))
+		audit_kill_trees(context);
+
+	audit_return_fixup(context, success, return_code);
+	audit_filter_syscall(current, context);
+	audit_filter_inodes(current, context);
+	if (context->current_state == AUDIT_STATE_RECORD)
+		audit_log_exit();
+
+out:
+	audit_reset_context(context);
+}
+
 /**
  * __audit_syscall_entry - fill in an audit record at syscall entry
  * @major: major syscall type (function)
-- 
2.52.0

