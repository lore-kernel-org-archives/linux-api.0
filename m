Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763921;
	b=LReZcQETEFKgKM9NlZiVagCF3FBnnckCUvJhDOBUXYw6nlspiOXjpX2RX7s6gRIzZuVz
	 3uYuYWLhBeDbNW9FfXVcGkd6ibLqLpV8sY4LqT/q1hfqNoWy1lHxZgMR2OfJjUJxBfi2t
	 O95bSrPw3/9tXYwvNsZ4cfjoqkj8Vtrrjd22f2RaZf+pXL0TqdzJrn2a0GFrtrbOjJKi5
	 nkc2O2LRVPD7TgqhoT165MQ3hGis7CLBPfwIT73kv8A0nW6RPg3nAzgUgK/nXM8Xw4TV7
	 XDC5nT+JnjZFWHaGvblANgMkI0bAfJv9n3W3vn/K+Ebw5z9w1kf/kM1NfhbCQN2dkqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763921;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=dEd8hXaaiisAzwLdKenoopNjwVu5tcwGdy3pO4Jpuk8=;
	b=tZPDwlxJbk4xmsSzU1MZwveCGDH2h4QhmHK7yTdmgASOT2KzTZoRE+jilB/kWv1RxfhI
	 0tJWY9TP5/QN4Ua3zUfKJ9t63cdW63ndGKa5bK8n+LpAgln1m4+a9k1t1itXrr5naOgu7
	 ssRtuglqNP65h4vXtqEUQOfeP6Te3/UACA1K4il08uhMJlyb+ojCimKh4LXm4dkT0ZKlP
	 qZ4SqBiB0+IMcCi1eKX3OnpxyjgAxEWT2nYclAQV/54nTV6HJnDGKYxpE4XnIEBIq02lg
	 BspEA+0ALHRVVYuO26DiGRm22gIUqCUdyGSIfHpAjcLhnXf8paNaCcX7jAmHiZ6Ce1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b="qwd/To1G";
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC015606A336;
	Sun, 15 Nov 2026 17:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC015606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=qwd/To1G
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=dEd8hXaaiisAzwLdKenoopNjwVu5tcwGdy3pO4Jpuk8=; t=1794763920; x=2110123920; 
	b=qwd/To1GcYawLeXbpdAarDAH01O91H/2h+d1wdfyvUqum+088vIIEm5W+wR+1JfAYD/aNGQPyBF
	OQ+efO+8Q0+44XoBO8HpaSOTrb8RgX/rO5Lr1w7+efVGEDz6zIbbQrQezLSn8rDg8SJWq0MxzChTM
	Us0ZDrdvwR9sGl6KknERZBWYu/acS7tq45o4k7E8OJTCJmsF08VGN4rc1R0YlUVr3pJ+BOMiQjn2S
	lFLl+b/OiVBRfxDv52v+JOqc8/EsdepxD9jxm8/KG3GktMX8/hf6qvgfnfRpEjzH8yuly/CdR5jde
	IIlyiNE4SBgrTq8fOHVlI3HkdgZtIYJmfE4Q==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4z-00B0BK-NH; Sun, 15 Nov 2026 18:31:49 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:19 -0300
Subject: [PATCH v8 10/10] futex: Use new robust list API internally
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
Message-Id: <20261115-tonyk-robust_futex-v8-10-a4fe47333a28@igalia.com>
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
 kernel/futex/core.c         | 35 +++++++++++++++++--------------
 kernel/futex/syscalls.c     | 50 +++++++++++++++++++++++----------------------
 4 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 03a3973a7068..160e7e72b085 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -95,10 +95,6 @@ static inline void futex_init_task(struct task_struct *tsk)
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
index 58321314ecab..45c614923e46 100644
--- a/include/linux/futex_types.h
+++ b/include/linux/futex_types.h
@@ -12,8 +12,6 @@ struct robust_list_head;
 
 /**
  * struct futex_sched_data - Futex related per task data
- * @robust_list:	User space registered robust list pointer
- * @robust_list32:	User space registered robust list pointer for compat tasks
  * @pi_state_list:	List head for Priority Inheritance (PI) state management
  * @pi_state_cache:	Pointer to cache one PI state object per task
  * @exit_mutex:		Mutex for serializing exit
@@ -21,10 +19,6 @@ struct robust_list_head;
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
index dd6fa8035fb6..23880a9d8bac 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -96,6 +96,13 @@ int futex_robust_list_create(uintptr_t head, enum robust_list2_cmd cmd)
 	}
 
 	switch (cmd) {
+	case FUTEX_ROBUST_LIST_SET_COMPAT:
+		entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
+		index = FUTEX_ROBUST_LIST_COMPAT_IDX;
+		break;
+	case FUTEX_ROBUST_LIST_SET_NATIVE:
+		index = FUTEX_ROBUST_LIST_NATIVE_IDX;
+		break;
 	case FUTEX_ROBUST_LIST_CMD_CREATE_32:
 		if (head)
 			entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
@@ -1294,7 +1301,8 @@ static void exit_robust_list(struct task_struct *curr, struct robust_list_head _
 
 static bool robust_list_clear_pending(unsigned long __user *pop)
 {
-	struct robust_list_head __user *head = current->futex.robust_list;
+	struct robust_list_head __user *head = (struct robust_list_head __user *)
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_NATIVE_IDX];
 
 	if (!put_user(0UL, pop))
 		return true;
@@ -1309,7 +1317,8 @@ static bool robust_list_clear_pending(unsigned long __user *pop)
 	 * that's mostly an academic exercise.
 	 */
 	if (pop == (unsigned long __user *)&head->list_op_pending)
-		current->futex.robust_list = NULL;
+		current->futex.robust_lists[FUTEX_ROBUST_LIST_NATIVE_IDX] = 0;
+
 	return false;
 }
 
@@ -1412,14 +1421,16 @@ static void exit_robust_list32(struct task_struct *curr, struct robust_list_head
 
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
@@ -1527,6 +1538,9 @@ bool futex_robust_list_clear_pending(void __user *pop, unsigned int flags)
 {
 	bool size32bit = !!(flags & FLAGS_ROBUST_LIST32);
 
+	if (!current->futex.robust_lists)
+		return false;
+
 	if (!IS_ENABLED(CONFIG_64BIT) && !size32bit)
 		return false;
 
@@ -1591,17 +1605,8 @@ static void exit_robust_lists(struct task_struct *tsk)
 
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
+	if (unlikely(tsk->futex.robust_lists))
+		exit_robust_lists(tsk);
 
 	if (unlikely(!list_empty(&tsk->futex.pi_state_list)))
 		exit_pi_state_list(tsk);
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 0ecb32afd5e1..ba6730bfd47d 100644
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
@@ -103,11 +101,15 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
 		size_t __user *, len_ptr)
 {
-	struct robust_list_head __user *head = futex_get_robust_list_common(pid, false, -1);
+	struct robust_list_head __user *head =
+		futex_get_robust_list_common(pid, false, FUTEX_ROBUST_LIST_NATIVE_IDX);
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
+	head = (struct robust_list_head __user *)
+		((uintptr_t) head & FUTEX_ROBUST_LIST_ENTRY_MASK);
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(head, head_ptr);
@@ -168,8 +170,7 @@ SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head * __user, head, unsign
 	return -EINVAL;
 }
 
-SYSCALL_DEFINE4(get_robust_list2, int, pid,
-		void __user * __user *, head_ptr,
+SYSCALL_DEFINE4(get_robust_list2, int, pid, void __user * __user *, head_ptr,
 		unsigned int, index, unsigned int, flags)
 {
 	struct robust_list_head *head;
@@ -597,22 +598,23 @@ COMPAT_SYSCALL_DEFINE2(set_robust_list, struct robust_list_head32 __user *, head
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
2.56.1

