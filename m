Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174AD313543;
	Sat, 12 Sep 2026 01:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176292; cv=none; b=kk9ui0tP5uy3fVMP57KLKEpp53mAC8M7zhUP/wc5ZoqfsmjnZ9DzITg3IP4cvx2fn4xF/2nItzQbKbolQMLwAMj7HfTXGPR9jVa096rBdNOo1VjKDKMTlvwAVOHApvkwnnL+x6DmOFrMoAZMeGf79XTaXZmciu3vK2meAo1iLnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176292; c=relaxed/simple;
	bh=46inCMZBKL4Dn2MYeOCdxLCzeD1FLycLRZASs/WYhuo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fTzDeqd095sWv04eSqVDbUEmYZjNs7NWdGsOReJfC7Zkl0FBkSBRDlWXMMNa9Wjz7sGysv5UnhgdImhPFyPW6aoTnfpNLlB1OK07gz6KzOJ5saUlvazKtB1Hd/4ijzxw3JSVeL0APx+JnPJ1os10gFktSFat5iPmLM6wvG9IBxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=BK/GL7eD; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="BK/GL7eD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=1MfA022lMI6eopMpnYm97azulYzjdx+Jco4w94leDiw=; b=BK/GL7eD55uDTKsAow65LWzn6a
	XmUybhNhEKTSQfQiHaDzYluqMs125itTSVMDmTe4MZNORS3pDsjgWmoWWxmjzhW0anYFg91p0u0GZ
	O03UrpFPRpZMT3jhZUlL3LIJq1jGPABk4/oo//jF1K9/ogbaZJtQtW7JlTuURB0EjI2WFP0D9mCxi
	VeEI0NaS/jgQLSE1AErdw6bA+4j0sCd08Wx+0S2uQJ0LFrBa11V9NuVGDQYACC8QJZ9dsskd7LeLO
	3+F6ZnkBMl41pF4FPt/dez8r29mO9c/1F6NDHwKTVgTngYJxQ6bStUUiitf8YYbZsVmYNHu9VXRXF
	3aG4oACg==;
Received: from [177.172.123.122] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1x5CTu-000xjI-FN; Sat, 12 Sep 2026 03:24:38 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 11 Sep 2026 22:24:01 -0300
Subject: [PATCH v7 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260911-tonyk-long_name-v7-4-34e1ee1564ae@igalia.com>
References: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
In-Reply-To: <20260911-tonyk-long_name-v7-0-34e1ee1564ae@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Command name has been restrict to only 16 bytes, which is too limiting,
specially when debugging and tracing complex software with thousands of
threads and the need to differentiate them.

Just as it was done with kthreads in commit 6b59808bfe48 ("workqueue:
Show the latest workqueue name in /proc/PID/{comm,stat,status}"), support
long names for userspace threads as well.

To avoid buffer overflows, cap all existing userspace APIs to
TASK_COMM_LEN, and leave the full extended name for a new interface.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes from v5:
 - Fix blktrace buffer size
 - Fix i915 buffer size
---
 drivers/gpu/drm/i915/display/intel_display_driver.c |  4 ++--
 drivers/gpu/drm/i915/gem/i915_gem_context.c         |  4 ++--
 fs/proc/array.c                                     |  2 +-
 include/linux/sched.h                               |  5 +++--
 kernel/sys.c                                        | 10 +++++-----
 kernel/trace/blktrace.c                             |  6 ++++--
 6 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_driver.c b/drivers/gpu/drm/i915/display/intel_display_driver.c
index 70d112fd4287..e2b19b064722 100644
--- a/drivers/gpu/drm/i915/display/intel_display_driver.c
+++ b/drivers/gpu/drm/i915/display/intel_display_driver.c
@@ -435,8 +435,8 @@ void intel_display_driver_resume_access(struct intel_display *display)
  */
 bool intel_display_driver_check_access(struct intel_display *display)
 {
-	char current_task[TASK_COMM_LEN + 16];
-	char allowed_task[TASK_COMM_LEN + 16] = "none";
+	char current_task[TASK_COMM_EXT_LEN + 16];
+	char allowed_task[TASK_COMM_EXT_LEN + 16] = "none";
 
 	if (display->access.any_task_allowed ||
 	    display->access.allowed_task == current)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index c58ffa5a8fa6..b62b82c6de04 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1730,8 +1730,8 @@ static void gem_context_register(struct i915_gem_context *ctx,
 	ctx->pid = get_task_pid(current, PIDTYPE_PID);
 	ctx->client = i915_drm_client_get(fpriv->client);
 
-	snprintf(ctx->name, sizeof(ctx->name), "%s[%d]",
-		 current->comm, pid_nr(ctx->pid));
+	snprintf(ctx->name, sizeof(ctx->name), "%.*s[%d]",
+		 TASK_COMM_LEN - 1, current->comm, pid_nr(ctx->pid));
 
 	spin_lock(&ctx->client->ctx_lock);
 	list_add_tail_rcu(&ctx->client_link, &ctx->client->ctx_list);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 8ebb7cf1a7b0..0d70b21c803c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		strscpy_pad(tcomm, p->comm);
+		strscpy_pad(tcomm, p->comm, TASK_COMM_LEN);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ba2040566424..c4e0104e7ae9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -323,6 +323,7 @@ struct user_event_mm;
  */
 enum {
 	TASK_COMM_LEN = 16,
+	TASK_COMM_EXT_LEN = 64,
 };
 
 extern void sched_tick(void);
@@ -1187,7 +1188,7 @@ struct task_struct {
 	 * - set it with set_task_comm() to ensure it is always
 	 *   NUL-terminated and zero-padded
 	 */
-	char				comm[TASK_COMM_LEN];
+	char				comm[TASK_COMM_EXT_LEN];
 
 	struct nameidata		*nameidata;
 
@@ -2042,7 +2043,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
 {
 	const char *_src = tsk->comm;
-	size_t _len = min(len, TASK_COMM_LEN);
+	size_t _len = min(len, TASK_COMM_EXT_LEN);
 
 	if (!_len)
 		return;
diff --git a/kernel/sys.c b/kernel/sys.c
index 97df708c11a0..5ebd3c1dfddf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2535,7 +2535,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
 	struct task_struct *me = current;
-	unsigned char comm[sizeof(me->comm)];
+	unsigned char comm[TASK_COMM_LEN];
 	long error;
 
 	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
@@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = -EINVAL;
 		break;
 	case PR_SET_NAME:
-		comm[sizeof(me->comm) - 1] = 0;
+		comm[TASK_COMM_LEN - 1] = 0;
 		if (strncpy_from_user(comm, (char __user *)arg2,
-				      sizeof(me->comm) - 1) < 0)
+				      TASK_COMM_LEN - 1) < 0)
 			return -EFAULT;
 		set_task_comm(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		strscpy_pad(comm, me->comm);
-		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
+		strscpy_pad(comm, me->comm, TASK_COMM_LEN);
+		if (copy_to_user((char __user *)arg2, comm, TASK_COMM_LEN))
 			return -EFAULT;
 		break;
 	case PR_GET_ENDIAN:
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8cd2520b4c99..edc1377c3e3c 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -214,12 +214,14 @@ static void trace_note_tsk(struct task_struct *tsk)
 {
 	unsigned long flags;
 	struct blk_trace *bt;
+	char comm[TASK_COMM_LEN];
 
 	tsk->btrace_seq = blktrace_seq;
 	raw_spin_lock_irqsave(&running_trace_lock, flags);
 	list_for_each_entry(bt, &running_trace_list, running_list) {
-		trace_note(bt, tsk->pid, BLK_TN_PROCESS, tsk->comm,
-			   sizeof(tsk->comm), 0);
+		strscpy_pad(comm, tsk->comm);
+		trace_note(bt, tsk->pid, BLK_TN_PROCESS, comm,
+			   sizeof(comm), 0);
 	}
 	raw_spin_unlock_irqrestore(&running_trace_lock, flags);
 }

-- 
2.55.0

