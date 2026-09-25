Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEADC3F86E6;
	Fri, 25 Sep 2026 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358829; cv=none; b=dHwzilrHj9Q/ER9E7SvlKGicNyXW/a61WQh+u4ukHF4OSblke2TDJkbJgH5PX1Jsy2rXH8sc2hzsAOYoYjczk0xTIEY0AO1qMNlv51F8KVtF9cBbhkNW9I07/5G0B6yvPgrqgTnHHFabS+LTpvsH/nUzcaIYCGev1UaskFwIhXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358829; c=relaxed/simple;
	bh=HSXNCnIXv4VV1ReSHAGPYg5GUBU8IufuXcJSaOc5Ti8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lgOpNc5fLg+AkrqfwjyZa0jaY7hPHt6xuNwv+oicvX8v95zQgJsyjaaA8C8WGpa7stuIFDL3em4N40cejHjxx1mnatqcH9QAcJvesaa/w7eOo0H3fCVeSdC9VIHadafWfw6r17tuahfG/zwvhaZsdh6dNNAERR4jsC+hP+YEz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=YitHadZS; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="YitHadZS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=SurK3TGYfpTo583lyRJISR2Hl5XvlB4mz52/MfgA7l0=; b=YitHadZSELd7dJuYpw4ZY7gxlq
	pNwuz20j2oLjQleFrBRv0lYwN32RIudV2LW+Ryos0532M/Y0/YYAnV5xnrQdKV7pkLHs7gIau4iE3
	KSS7GDQoeH8rYA0b/nROohgosbOU6l6KkmILEVKQ1vvAohmdR5ZVMoaU6KUOo9Af/SelyVxxKHt1I
	iotnWwQodIY/ctzx1LARG4Iwn6EZ+4bGs8HoOgJnMYyzSpFimyAfhJkVOPlLTmiL3+aPbOLCzC50W
	Pk+HPkKvybdp7vmWfrs0jLq/bnBh5XLHRtsiXtb/h1CS8WjnHcCsA7Lu3mNuNBWB8BfKzLRi6FXS7
	ZPRPOUfw==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7A-007GQg-MK; Fri, 25 Sep 2026 19:53:40 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:25 -0300
Subject: [PATCH v7 02/10] futex: Use explicit sizes for compat_robust_list
 structs
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-2-d1095991152c@igalia.com>
References: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
In-Reply-To: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

There are two functions for handling robust lists during a task exit:
exit_robust_list() and compat_exit_robust_list(). The first one handles
either 64-bit or 32-bit lists, depending on the kernel bitness.
compat_exit_robust_list() exists only in 64-bit kernels that supports
32-bit syscalls entry points (also known as compat entry points).

The new syscall set_robust_list2() needs to handle both 64-bit and
32-bit robust lists, regardless of compat entry being enabled, so it
needs to have both functions always available.

In preparation for this, use explicit size for struct members of
compat_robust_list and compat_robust_list_head. Rename the structs and
compat_exit_robust_list() to make clear which bitness it handles.

Keep exit_robust_list() as it is: used to handle the native bit size of
the kernel.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/compat.h      | 13 +++----------
 include/linux/futex.h       |  4 ++++
 include/linux/futex_types.h |  2 +-
 include/linux/sched.h       |  2 --
 include/uapi/linux/futex.h  | 10 ++++++++++
 kernel/futex/core.c         | 34 +++++++++++++++++-----------------
 kernel/futex/syscalls.c     |  9 +++++----
 7 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 8da0a15c95f4..eceb085efb69 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -389,15 +389,8 @@ struct compat_ifconf {
 	compat_caddr_t  ifcbuf;
 };
 
-struct compat_robust_list {
-	compat_uptr_t			next;
-};
-
-struct compat_robust_list_head {
-	struct compat_robust_list	list;
-	compat_long_t			futex_offset;
-	compat_uptr_t			list_op_pending;
-};
+struct robust_list32;
+struct robust_list_head32;
 
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
 struct compat_old_sigaction {
@@ -676,7 +669,7 @@ asmlinkage long compat_sys_waitid(int, compat_pid_t,
 		struct compat_siginfo __user *, int,
 		struct compat_rusage __user *);
 asmlinkage long
-compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
+compat_sys_set_robust_list(struct robust_list_head32 __user *head,
 			   compat_size_t len);
 asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 18ed18d5cbc1..1d1a8a627a8b 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -68,6 +68,10 @@ static inline void futex_init_task(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->futex.pi_state_list);
 	tsk->futex.state = FUTEX_STATE_OK;
 	mutex_init(&tsk->futex.exit_mutex);
+	tsk->futex.robust_list = NULL;
+#ifdef CONFIG_COMPAT
+	tsk->futex.robust_list32 = NULL;
+#endif
 }
 
 void futex_exit_recursive(struct task_struct *tsk);
diff --git a/include/linux/futex_types.h b/include/linux/futex_types.h
index d320c0571f0c..2c9ad20f3be8 100644
--- a/include/linux/futex_types.h
+++ b/include/linux/futex_types.h
@@ -23,7 +23,7 @@ struct robust_list_head;
 struct futex_sched_data {
 	struct robust_list_head __user		*robust_list;
 #ifdef CONFIG_COMPAT
-	struct compat_robust_list_head __user	*compat_robust_list;
+	struct robust_list_head32 __user *robust_list32;
 #endif
 	struct list_head			pi_state_list;
 	struct futex_pi_state			*pi_state_cache;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 705970d07614..317e55884120 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1360,9 +1360,7 @@ struct task_struct {
 	u32				closid;
 	u32				rmid;
 #endif
-
 	struct futex_sched_data		futex;
-
 #ifdef CONFIG_PERF_EVENTS
 	u8				perf_recursion[PERF_NR_CONTEXTS];
 	struct perf_event_context	*perf_event_ctxp;
diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index 10a36c551675..b39f8a23a84b 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -179,6 +179,16 @@ struct robust_list_head {
 	struct robust_list __user *list_op_pending;
 };
 
+struct robust_list32 {
+	__u32 next;
+};
+
+struct robust_list_head32 {
+	struct robust_list32	list;
+	__s32			futex_offset;
+	__u32			list_op_pending;
+};
+
 /*
  * Are there any waiters for this robust futex:
  */
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index a061f54b606d..4b1bf211c3dc 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1235,9 +1235,10 @@ static void __user *futex_uaddr(struct robust_list __user *entry,
 /*
  * Fetch a robust-list pointer. Bit 0 signals PI futexes:
  */
-static inline int
-compat_fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **entry,
-		   compat_uptr_t __user *head, unsigned int *pflags)
+static inline int fetch_robust_entry32(compat_uptr_t *uentry,
+				       struct robust_list __user **entry,
+				       compat_uptr_t __user *head,
+				       unsigned int *pflags)
 {
 	if (get_user(*uentry, head))
 		return -EFAULT;
@@ -1254,9 +1255,9 @@ compat_fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **ent
  *
  * We silently return on any sign of list-walking problem.
  */
-static void compat_exit_robust_list(struct task_struct *curr)
+static void exit_robust_list32(struct task_struct *curr)
 {
-	struct compat_robust_list_head __user *head = current->futex.compat_robust_list;
+	struct robust_list_head32 __user *head = curr->futex.robust_list32;
 	unsigned int limit = ROBUST_LIST_LIMIT, cur_mod, next_mod, pend_mod;
 	struct robust_list __user *entry, *next_entry, *pending;
 	compat_uptr_t uentry, next_uentry, upending;
@@ -1267,7 +1268,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
 	 */
-	if (compat_fetch_robust_entry(&uentry, &entry, &head->list.next, &cur_mod))
+	if (fetch_robust_entry32(&uentry, &entry, &head->list.next, &cur_mod))
 		return;
 	/*
 	 * Fetch the relative futex offset:
@@ -1278,7 +1279,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	 * Fetch any possibly pending lock-add first, and handle it
 	 * if it exists:
 	 */
-	if (compat_fetch_robust_entry(&upending, &pending, &head->list_op_pending, &pend_mod))
+	if (fetch_robust_entry32(&upending, &pending, &head->list_op_pending, &pend_mod))
 		return;
 
 	next_entry = NULL;	/* avoid warning with gcc */
@@ -1287,7 +1288,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 		 * Fetch the next entry in the list before calling
 		 * handle_futex_death:
 		 */
-		rc = compat_fetch_robust_entry(&next_uentry, &next_entry,
+		rc = fetch_robust_entry32(&next_uentry, &next_entry,
 			(compat_uptr_t __user *)&entry->next, &next_mod);
 		/*
 		 * A pending lock might already be on the list, so
@@ -1319,20 +1320,20 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	}
 }
 
-static bool compat_robust_list_clear_pending(u32 __user *pop)
+static bool robust_list_clear_pending32(u32 __user *pop)
 {
-	struct compat_robust_list_head __user *head = current->futex.compat_robust_list;
+	struct robust_list_head32 __user *head = current->futex.robust_list32;
 
 	if (!put_user(0U, pop))
 		return true;
 
 	/* See comment in robust_list_clear_pending(). */
 	if (pop == &head->list_op_pending)
-		current->futex.compat_robust_list = NULL;
+		current->futex.robust_list32 = NULL;
 	return false;
 }
 #else
-static bool compat_robust_list_clear_pending(u32 __user *pop_addr) { return false; }
+static bool robust_list_clear_pending32(u32 __user *pop_addr) { return false; }
 #endif
 
 #ifdef CONFIG_FUTEX_PI
@@ -1435,7 +1436,7 @@ bool futex_robust_list_clear_pending(void __user *pop, unsigned int flags)
 		return false;
 
 	if (IS_ENABLED(CONFIG_64BIT) && size32bit)
-		return compat_robust_list_clear_pending(pop);
+		return robust_list_clear_pending32(pop);
 
 	return robust_list_clear_pending(pop);
 }
@@ -1464,12 +1465,11 @@ static void futex_cleanup(struct task_struct *tsk)
 	}
 
 #ifdef CONFIG_COMPAT
-	if (unlikely(tsk->futex.compat_robust_list)) {
-		compat_exit_robust_list(tsk);
-		tsk->futex.compat_robust_list = NULL;
+	if (unlikely(tsk->futex.robust_list32)) {
+		exit_robust_list32(tsk);
+		tsk->futex.robust_list32 = NULL;
 	}
 #endif
-
 	if (unlikely(!list_empty(&tsk->futex.pi_state_list)))
 		exit_pi_state_list(tsk);
 }
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 2fa19d9d008d..4a45bace75fc 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -39,7 +39,7 @@ static inline void __user *futex_task_robust_list(struct task_struct *p, bool co
 {
 #ifdef CONFIG_COMPAT
 	if (compat)
-		return p->futex.compat_robust_list;
+		return p->futex.robust_list32;
 #endif
 	return p->futex.robust_list;
 }
@@ -478,13 +478,14 @@ SYSCALL_DEFINE4(futex_requeue,
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE2(set_robust_list, struct compat_robust_list_head __user *, head,
+COMPAT_SYSCALL_DEFINE2(set_robust_list, struct robust_list_head32 __user *, head,
 		       compat_size_t, len)
 {
 	if (unlikely(len != sizeof(*head)))
 		return -EINVAL;
 
-	current->futex.compat_robust_list = head;
+	current->futex.robust_list32 = head;
+
 	return 0;
 }
 
@@ -492,7 +493,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 			compat_uptr_t __user *, head_ptr,
 			compat_size_t __user *, len_ptr)
 {
-	struct compat_robust_list_head __user *head = futex_get_robust_list_common(pid, true);
+	struct robust_list_head32 __user *head = futex_get_robust_list_common(pid, true);
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);

-- 
2.55.0

