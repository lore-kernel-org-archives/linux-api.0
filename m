Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053744D17A1;
	Fri, 25 Sep 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358855; cv=none; b=jjKDxYMPgSsE36bTig1vSinZb00GWgudI1Vgr6FEmFQl8nUYj8F7YvfXoNx2QY7/bA1upDIRbEZFLXmCrDcjJEECOBt4Wj4PF7ImbGNTV23xL0Xf1RwVCovRNGg//ew2jBpqnSP984pTlvxiusLCJ83g6JA3CINwi3VXJuuWfog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358855; c=relaxed/simple;
	bh=YI1l9BRjX2cQ/pTyHMP40cTkX7wJaE9FwqmHN/pBHKc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OsFYIdue/hSazN+G+PCkSPKHfPb3czEys6DbIivWC3MftydF/SbRbIO2G1VvQ57XAUIkM/Ous3KATsDT/n2YMcZzWJXG3frHLU7Gbh6Fe3JeIcgwydfTS9CnW7BTg0GS4uQEV+C+3lrmnni6x8Vav/gP9t3TOsNuU5isq/A2yNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=VoJvmtLp; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="VoJvmtLp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=4zI2yJ+8E/8xZ05IEFLHiWdGz0SSnblOg7s5ng8htq0=; b=VoJvmtLp/mDLnWAjtEG+2NAuKd
	pid92Ua8z1u7QZCUnfRelZUBJ45B1x9oPx3ze646aPLZYdjZeMkbNTiRGrRuJo7Y1ZwAdFXeo5UoY
	4jgiRw3FE0s35LIr98kXbgE7w34ackjqjBVK5YSn6dMk9Uvtm8VUnKxiXtd45JJ2H9EO8vb+PEoIF
	hOlay5qA4wedMPOYfLur+oegn/Q/9BZb40fSTGI76N6ijEwfZewtbbzQJWl0iBVUMNdtBslAU4dAS
	yORoT9Wq4qYICw1l46lP9eALPbg/tM/y96JmFk0rCSaWOaXsjq30UjRYUM5SwP6R1vmlSU5KKu3G0
	+X3o2Q+A==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7b-007GQg-Hj; Fri, 25 Sep 2026 19:54:07 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:33 -0300
Subject: [PATCH v7 10/10] futex: Use new robust list API internally
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-10-d1095991152c@igalia.com>
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

The new robust list API internals can handle any kind of robust list, so
to simplify the code, reuse the same mechanisms for the original API and
when calling the original set syscall, set the head in the array of
lists. The first two indexes of the array of robust lists are reserved
for the original API lists, the native robust list and the compat robust
list.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/futex.h       |  4 ----
 include/linux/futex_types.h |  6 ------
 kernel/futex/core.c         | 34 +++++++++++++++---------------
 kernel/futex/syscalls.c     | 50 +++++++++++++++++++++++----------------------
 4 files changed, 44 insertions(+), 50 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 049dbe7aed18..f8987e2a0fc3 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -91,10 +91,6 @@ static inline void futex_init_task(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->futex.pi_state_list);
 	tsk->futex.state = FUTEX_STATE_OK;
 	mutex_init(&tsk->futex.exit_mutex);
-	tsk->futex.robust_list = NULL;
-#ifdef CONFIG_COMPAT
-	tsk->futex.robust_list32 = NULL;
-#endif
 	tsk->futex.robust_lists = NULL;
 }
 
diff --git a/include/linux/futex_types.h b/include/linux/futex_types.h
index 089a9f3edfe1..9b03629d0bd1 100644
--- a/include/linux/futex_types.h
+++ b/include/linux/futex_types.h
@@ -13,8 +13,6 @@ struct robust_list_head;
 
 /**
  * struct futex_sched_data - Futex related per task data
- * @robust_list:	User space registered robust list pointer
- * @compat_robust_list:	User space registered robust list pointer for compat tasks
  * @pi_state_list:	List head for Priority Inheritance (PI) state management
  * @pi_state_cache:	Pointer to cache one PI state object per task
  * @exit_mutex:		Mutex for serializing exit
@@ -22,10 +20,6 @@ struct robust_list_head;
  * @robust_lists:	List of robust lists heads
  */
 struct futex_sched_data {
-	struct robust_list_head __user		*robust_list;
-#ifdef CONFIG_COMPAT
-	struct robust_list_head32 __user *robust_list32;
-#endif
 	struct list_head			pi_state_list;
 	struct futex_pi_state			*pi_state_cache;
 	struct mutex				exit_mutex;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 4a692f169cef..40753112ad6b 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -96,6 +96,13 @@ int futex_robust_list_create(uintptr_t head, enum robust_list2_cmd cmd)
 	}
 
 	switch (cmd) {
+	case FUTEX_ROBUST_LIST_SET_COMPAT:
+		entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
+		index = FUTEX_ROBUST_LIST_COMPAT_IDX;
+		fallthrough;
+	case FUTEX_ROBUST_LIST_SET_NATIVE:
+		index = FUTEX_ROBUST_LIST_NATIVE_IDX;
+		goto exit;
 	case FUTEX_ROBUST_LIST_CMD_CREATE_32:
 		entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
 		fallthrough;
@@ -1284,7 +1291,8 @@ static void exit_robust_list(struct task_struct *curr, struct robust_list_head _
 
 static bool robust_list_clear_pending(unsigned long __user *pop)
 {
-	struct robust_list_head __user *head = current->futex.robust_list;
+	struct robust_list_head __user *head = (struct robust_list_head __user *)
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_NATIVE_IDX];
 
 	if (!put_user(0UL, pop))
 		return true;
@@ -1299,7 +1307,8 @@ static bool robust_list_clear_pending(unsigned long __user *pop)
 	 * that's mostly an academic exercise.
 	 */
 	if (pop == (unsigned long __user *)&head->list_op_pending)
-		current->futex.robust_list = NULL;
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_NATIVE_IDX] = 0;
+
 	return false;
 }
 
@@ -1402,14 +1411,16 @@ static void exit_robust_list32(struct task_struct *curr, struct robust_list_head
 
 static bool robust_list_clear_pending32(u32 __user *pop)
 {
-	struct robust_list_head32 __user *head = current->futex.robust_list32;
+	struct robust_list_head32 __user *head =
+		(struct robust_list_head32 __user *)
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_COMPAT_IDX];
 
 	if (!put_user(0U, pop))
 		return true;
 
 	/* See comment in robust_list_clear_pending(). */
 	if (pop == &head->list_op_pending)
-		current->futex.robust_list32 = NULL;
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_COMPAT_IDX] = 0;
 	return false;
 }
 #else
@@ -1517,6 +1528,9 @@ bool futex_robust_list_clear_pending(void __user *pop, unsigned int flags)
 {
 	bool size32bit = !!(flags & FLAGS_ROBUST_LIST32);
 
+	if (!current->futex.robust_lists)
+		return false;
+
 	if (!IS_ENABLED(CONFIG_64BIT) && !size32bit)
 		return false;
 
@@ -1581,18 +1595,6 @@ static void exit_robust_lists(struct task_struct *tsk)
 
 static void futex_cleanup(struct task_struct *tsk)
 {
-	if (unlikely(tsk->futex.robust_list)) {
-		exit_robust_list(tsk, tsk->futex.robust_list);
-		tsk->futex.robust_list = NULL;
-	}
-
-#ifdef CONFIG_64BIT
-	if (unlikely(tsk->futex.robust_list32)) {
-		exit_robust_list32(tsk, tsk->futex.robust_list32);
-		tsk->futex.robust_list32 = NULL;
-	}
-#endif
-
 	if (unlikely(tsk->futex.robust_lists))
 		exit_robust_lists(tsk);
 
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 596204870f65..f5ee8dd17414 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -27,21 +27,19 @@
  */
 SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head, size_t, len)
 {
-	/* The kernel knows only one size for now. */
+	int ret;
+
+	/*
+	 * The kernel knows only one size for now:
+	 */
 	if (unlikely(len != sizeof(*head)))
 		return -EINVAL;
 
-	current->futex.robust_list = head;
-	return 0;
-}
-
-static inline void __user *futex_task_robust_list(struct task_struct *p, bool compat)
-{
-#ifdef CONFIG_COMPAT
-	if (compat)
-		return p->futex.robust_list32;
-#endif
-	return p->futex.robust_list;
+	ret = futex_robust_list_create((uintptr_t) head,
+				       FUTEX_ROBUST_LIST_SET_NATIVE);
+	if (ret >= 0)
+		return 0;
+	return ret;
 }
 
 static void __user *futex_get_robust_list_common(int pid, bool compat, int index)
@@ -50,6 +48,9 @@ static void __user *futex_get_robust_list_common(int pid, bool compat, int index
 	void __user *head;
 	int ret;
 
+	if (index >= FUTEX_ROBUST_LIST2_MAX_IDX)
+		return (void __user *)ERR_PTR(-EINVAL);
+
 	scoped_guard(rcu) {
 		if (pid) {
 			p = find_task_by_vpid(pid);
@@ -74,11 +75,8 @@ static void __user *futex_get_robust_list_common(int pid, bool compat, int index
 	if (index >= 0) {
 		scoped_guard(mutex, &p->futex.exit_mutex) {
 			uintptr_t *rl = p->futex.robust_lists;
-
 			head = rl ? (void __user *) rl[index] : NULL;
 		}
-	} else {
-		head = futex_task_robust_list(p, compat);
 	}
 
 	up_read(&p->signal->exec_update_lock);
@@ -103,7 +101,11 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
 		size_t __user *, len_ptr)
 {
-	struct robust_list_head __user *head = futex_get_robust_list_common(pid, false, -1);
+	struct robust_list_head __user *head =
+		futex_get_robust_list_common(pid, false, FUTEX_ROBUST_LIST_NATIVE_IDX);
+
+	head = (struct robust_list_head __user *)
+		((uintptr_t) head & FUTEX_ROBUST_LIST_ENTRY_MASK);
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
@@ -162,8 +164,7 @@ SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head *, head, unsigned int,
 	return -EINVAL;
 }
 
-SYSCALL_DEFINE4(get_robust_list2, int, pid,
-		void __user * __user *, head_ptr,
+SYSCALL_DEFINE4(get_robust_list2, int, pid, void __user * __user *, head_ptr,
 		unsigned int, index, unsigned int, flags)
 {
 	void __user *entry_ptr;
@@ -586,22 +587,23 @@ COMPAT_SYSCALL_DEFINE2(set_robust_list, struct robust_list_head32 __user *, head
 	if (unlikely(len != sizeof(*head)))
 		return -EINVAL;
 
-	current->futex.robust_list32 = head;
-
-	return 0;
+	return futex_robust_list_create((uintptr_t) head,
+					FUTEX_ROBUST_LIST_SET_COMPAT);
 }
 
 COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 			compat_uptr_t __user *, head_ptr,
 			compat_size_t __user *, len_ptr)
 {
-	struct robust_list_head32 __user *head = futex_get_robust_list_common(pid, true, -1);
+	struct robust_list_head32 __user *head =
+		futex_get_robust_list_common(pid, true, FUTEX_ROBUST_LIST_COMPAT_IDX);
 
-	if (IS_ERR(head))
-		return PTR_ERR(head);
+	head = (struct robust_list_head32 __user *)
+		((uintptr_t) head & FUTEX_ROBUST_LIST_ENTRY_MASK);
 
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
+
 	return put_user(ptr_to_compat(head), head_ptr);
 }
 #endif /* CONFIG_COMPAT */

-- 
2.55.0

