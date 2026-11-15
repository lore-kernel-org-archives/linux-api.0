Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763896;
	b=m/jkVLHNg9O09kztqfe/dLegYUz0RGOlYdtdhZoiCbvuX1Dg9/pEYOiqEcO89qniwy/f
	 1JSCBFFlabx2fh/V2G2d/EqjA0ycFzBu25aJ5f8eKH85JURM7fNoaYz8NUAnVEAW1zunz
	 7S15BqPMK7JlXNxnUVqpMy2mHU372STGIDO9Fo2i0WHdAxKf45faUXP/RNZmlkB4xyaWT
	 s71O2/4ATS7UdkONQ/yoJUICyqURxEJR5q9eMTLkJ73ofXzADXcPkMnNLQrz/OKcLDKmM
	 CIeUzxCIi/pxhOVXt8PTw/XducPvvYfql2GFjZOsf3Zw5C/dN052ZPkwwqifhMF4Hcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763896;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=w+r/XphDL3A5QS6hV6nV6pkw89H7aXV3noIKVh0rz5k=;
	b=SeowWoaX8Xw8gg2z0W7nmTG0EH8ApzmklIcY3YC9utZV90/CQy5QLijJ9mGf29ngkN/4
	 NHrDj95A2KhQh1mAPbxkMH85fBbhwj+p6pDbYuXnEnDY0BCpOHH3zy3Ey9Kv+8tvrjSBG
	 fqW1MKY6grHJ26dyN3P/p8lFhn/y7Ahk1DceD57UDtH2+lqEnGnWNekWuf1LP1er0kBr8
	 jtY74f5RRBK6d7VlxgGZ6GarX51ccZXkWpgwvV/JS/8jII/GafufJWDEivG92T0D8UnfK
	 q748b53yigaetCppX5FrGGd1VpoQg+zlzQNxADO1QljDfY+pWqS68pCi7VR93AYLeLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PyAk1KaD;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C047A606A31A;
	Sun, 15 Nov 2026 17:31:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C047A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PyAk1KaD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=w+r/XphDL3A5QS6hV6nV6pkw89H7aXV3noIKVh0rz5k=; t=1794763895; x=2110123895; 
	b=PyAk1KaDbeEVRlnc3236UOi6CFuWJ0MU5ngkTEGgu3E4I3x01t0jrxHW21CKH23aLhFpfaoxZ4M
	8FQP5rhjvyr3tGixIy9/xcdNmZn/vvn9StfryWR6HcAgL3CjJm0NX3clL/7QA+Ik6YQeGGNGeRV/F
	yynZeSdTNOoN+wDBDdlMiBIWiCtLLafQhlUg5U9QWozbX16k23Uv3IxsoIzXzSJVMpbF0MuI8kmFN
	jrkPPViwejddteLf+8mYQ0/CBMdDH+Y38vqtEvSo2IQ0VmnOWvJuNZUVProhV1vi2xj0WD9jtjr7t
	aC3BrItEpQjKJENqTj8ceQqcqgbYHBK+zJBQ==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4X-00B0BK-H7; Sun, 15 Nov 2026 18:31:21 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:11 -0300
Subject: [PATCH v8 02/10] futex: Use explicit sizes for compat_robust_list
 structs
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261115-tonyk-robust_futex-v8-2-a4fe47333a28@igalia.com>
References: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
In-Reply-To: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
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
 include/linux/futex_types.h |  5 ++---
 include/uapi/linux/futex.h  | 10 ++++++++++
 kernel/futex/core.c         | 33 +++++++++++++++++----------------
 kernel/futex/syscalls.c     |  9 +++++----
 6 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ad37ca617e65..77bfef1b3bd2 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -390,15 +390,8 @@ struct compat_ifconf {
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
@@ -677,7 +670,7 @@ asmlinkage long compat_sys_waitid(int, compat_pid_t,
 		struct compat_siginfo __user *, int,
 		struct compat_rusage __user *);
 asmlinkage long
-compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
+compat_sys_set_robust_list(struct robust_list_head32 __user *head,
 			   compat_size_t len);
 asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
diff --git a/include/linux/futex.h b/include/linux/futex.h
index a895d8c69d66..93316876a4ee 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -72,6 +72,10 @@ static inline void futex_init_task(struct task_struct *tsk)
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
index 34b16f2828e7..f58616d7e20b 100644
--- a/include/linux/futex_types.h
+++ b/include/linux/futex_types.h
@@ -7,14 +7,13 @@
 #include <linux/mutex_types.h>
 #include <linux/types.h>
 
-struct compat_robust_list_head;
 struct futex_pi_state;
 struct robust_list_head;
 
 /**
  * struct futex_sched_data - Futex related per task data
  * @robust_list:	User space registered robust list pointer
- * @compat_robust_list:	User space registered robust list pointer for compat tasks
+ * @robust_list32:	User space registered robust list pointer for compat tasks
  * @pi_state_list:	List head for Priority Inheritance (PI) state management
  * @pi_state_cache:	Pointer to cache one PI state object per task
  * @exit_mutex:		Mutex for serializing exit
@@ -23,7 +22,7 @@ struct robust_list_head;
 struct futex_sched_data {
 	struct robust_list_head __user		*robust_list;
 #ifdef CONFIG_COMPAT
-	struct compat_robust_list_head __user	*compat_robust_list;
+	struct robust_list_head32 __user *robust_list32;
 #endif
 	struct list_head			pi_state_list;
 	struct futex_pi_state			*pi_state_cache;
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
index a240638f69e5..28a6ad4a8da4 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1243,9 +1243,10 @@ static void __user *futex_uaddr(struct robust_list __user *entry,
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
@@ -1262,9 +1263,9 @@ compat_fetch_robust_entry(compat_uptr_t *uentry, struct robust_list __user **ent
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
@@ -1275,7 +1276,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	 * Fetch the list head (which was registered earlier, via
 	 * sys_set_robust_list()):
 	 */
-	if (compat_fetch_robust_entry(&uentry, &entry, &head->list.next, &cur_mod))
+	if (fetch_robust_entry32(&uentry, &entry, &head->list.next, &cur_mod))
 		return;
 	/*
 	 * Fetch the relative futex offset:
@@ -1286,7 +1287,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 	 * Fetch any possibly pending lock-add first, and handle it
 	 * if it exists:
 	 */
-	if (compat_fetch_robust_entry(&upending, &pending, &head->list_op_pending, &pend_mod))
+	if (fetch_robust_entry32(&upending, &pending, &head->list_op_pending, &pend_mod))
 		return;
 
 	next_entry = NULL;	/* avoid warning with gcc */
@@ -1295,7 +1296,7 @@ static void compat_exit_robust_list(struct task_struct *curr)
 		 * Fetch the next entry in the list before calling
 		 * handle_futex_death:
 		 */
-		rc = compat_fetch_robust_entry(&next_uentry, &next_entry,
+		rc = fetch_robust_entry32(&next_uentry, &next_entry,
 			(compat_uptr_t __user *)&entry->next, &next_mod);
 		/*
 		 * A pending lock might already be on the list, so
@@ -1327,20 +1328,20 @@ static void compat_exit_robust_list(struct task_struct *curr)
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
@@ -1443,7 +1444,7 @@ bool futex_robust_list_clear_pending(void __user *pop, unsigned int flags)
 		return false;
 
 	if (IS_ENABLED(CONFIG_64BIT) && size32bit)
-		return compat_robust_list_clear_pending(pop);
+		return robust_list_clear_pending32(pop);
 
 	return robust_list_clear_pending(pop);
 }
@@ -1472,9 +1473,9 @@ static void futex_cleanup(struct task_struct *tsk)
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
2.56.1

