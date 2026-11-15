Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763897;
	b=zYlkaFrvDrOQnu34bNyp1q48Ouql+ft8lLvgYGZ7ap9J0FHP1E2KzxhypJz6gZTi8XCy
	 pLb9upYyjkVBdmXdmQkaUL0f1RL0tjXeXgRZgwTf4HbgO613sh66UCuPR9+1shZPi5YUS
	 5vXOK5dp22A+QAleLMCW/MBR/Prb1Dhn5BH7HH5lnPXC9nIK1KCFI1fAcGqx5QQM75/xG
	 tfJXLviozQOpmcjkNyulSvwTcvo00LFGAlIWcf2e05TzswqSwovg5sn0m3DXrVgDZD8jW
	 QeMovFvtWlX5i3NsxfFyDVPdtsyUuKdqB9uOcbxlLtcFFqo/HAFV4PCNvTt9LoJlLoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763897;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=QhZI2sBJ2chpTLhYKqQXCpmkUmafEnw9RV7t2jep/88=;
	b=BtGEsoBsBFlALI8V/ZaMRDXyoH/y6FBTRZOVoOJ6xktTK8Be0DhHUwm9WMYSNfJdPkRd
	 75wPp99k8c3y+Aii2j/lGKwp8kVNhpHj+AjSARoYqCf2xccbn+FVyAt1HpDaDIY1zX/RX
	 tzHwC3Vr6EJZBTbJeHHJnpyZ8qZnA8VeMnazgB1Ga/+U8QuTBS+iu9LMhoiPcTB3wBhmM
	 qiEKzu236fyTcJtOl/ZEDi62oEvckg3kbpTMLzxmWA3sAQh3IOdOJMp61YurxZxnbL1yZ
	 uwZbyyHMWTzh30kdYEzNG38fl6SY+mWVC92h6RdfjgaeIhKC1E8HuTWc/cJibdm9utw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=GVmrh6gj;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6F5606A88A;
	Sun, 15 Nov 2026 17:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC6F5606A88A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=GVmrh6gj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=QhZI2sBJ2chpTLhYKqQXCpmkUmafEnw9RV7t2jep/88=; t=1794763896; x=2110123896; 
	b=GVmrh6gjMSvGkewD0cI4OzdHERwzqxPlQB9Kcnan3fUihsCxc4r9155rLxWFluxQlYdway0odh3
	nVDt26Ik7hsKXJZtyprg1BEm/rjZVp6Ojml3jzJtd6rDfBsy6pGQoUJjRVUeTPUXpkWCW3KBm1beP
	ryES4jQq5DQcvSKMcmerr7XP/TVcpvav7J5TTIu4kzCgR7ejVdMZWm1InOxsa+cztn0NDjYlgNTAb
	7GrDm1Usr6RPl3PrBJANYjjXU+852Yez6841j1oTPssvxOte/zHEGFxbPBSL/4gM0o33M7q8a3VMe
	+c2DldJIyy78evCf3KCEve7nvV1W2UO3CZ0w==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4e-00B0BK-IV; Sun, 15 Nov 2026 18:31:28 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:13 -0300
Subject: [PATCH v8 04/10] futex: Create set_robust_list2() syscall
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
Message-Id: <20261115-tonyk-robust_futex-v8-4-a4fe47333a28@igalia.com>
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

Emulators (like FEX-Emu, to run x86 apps on top of Aarch64) have two
special needs about robust lists: to be able to register more than one
robust list, one of the app being emulated and one list for the emulator
itself; and to be able to walk on 32-bit robusts lists on a 64-bit
platform without compat entry points.

The current syscall allows for one robust list per task (on x86-64, it
can have two if compat is enabled) and on Aarch64 there's no way to
parse a 32-bit robust list. The current syscall cannot be expanded to
solve both needs, so create a new syscall, set_robust_list2() with the
following signature:

  sys_set_robust_list2(struct robust_list_head *head, unsigned int cmd,
		       unsigned int flags)

The new syscall allows to set multiple lists per task, of 64-bit or
32-bit types.

 - `*head` is the same structure used in the current syscall.
 - `cmd` defines the operation to perform:
   - `FUTEX_ROBUST_LIST_CMD_CREATE_{32, 64}` sets a new robust list head,
   the kernel returns the index of the list. User can choose between 32 or
   64 bit for pointer size of the list head.
   - FUTEX_ROBUST_LIST_CMD_MODIFY_{32, 64}` change the `*head` value of a
   list. Setting it to NULL destroys an index and let it free to be
   allocated by other CREATE caller.
   - `FUTEX_ROBUST_LIST_CMD_LIST_LIMIT` gets the limit of lists per task
 - `flag` is unused now but can be used to expand the interface

The array of lists is dynamically allocated in the first use, but has a
fixed size determined by the kernel. 8 slots are more than enough to
cover the target use case and allows for more use cases. The command for
getting the list limit allows to userspace check if the kernel ever
expands this list. The first two slots are reserved for the kernel, to
store the original syscall robust_list_head's.

The array of lists is destroyed only during task exit.

The `FUTEX_ROBUST_LIST_CMD_CREATE_64` operation is only available for
64-bit kernels. In such kernels, lists created with
`FUTEX_ROBUST_LIST_CMD_SET_32` are marked with
`FUTEX_ROBUST_LIST_ENTRY_32BIT` and the kernel handles it with a special
function exit_robust_list32() to be able to walk in a list of 32-bit
pointers.

For 32-bit kernels, there's no special function available as every user
list and list handling functions will all have the same bitness.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/futex.h       |  24 ++++++++
 include/linux/futex_types.h |   2 +
 include/uapi/linux/futex.h  |  18 ++++++
 kernel/futex/core.c         | 138 +++++++++++++++++++++++++++++++++++++++++---
 kernel/futex/futex.h        |   5 ++
 kernel/futex/syscalls.c     |  55 ++++++++++++++++++
 kernel/sys_ni.c             |   1 +
 7 files changed, 236 insertions(+), 7 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 93316876a4ee..03a3973a7068 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/ktime.h>
 #include <linux/mm_types.h>
+#include <linux/compat.h>
 
 #include <uapi/linux/futex.h>
 
@@ -66,6 +67,28 @@ enum {
 	FUTEX_STATE_DEAD,
 };
 
+#define FUTEX_ROBUST_LIST_NATIVE_IDX	0
+#define FUTEX_ROBUST_LIST_COMPAT_IDX	1
+#define FUTEX_ROBUST_LIST2_IDX		2
+#define FUTEX_ROBUST_LISTS_PER_USER	8
+#define FUTEX_ROBUST_LIST2_MAX_IDX	(FUTEX_ROBUST_LIST2_IDX + FUTEX_ROBUST_LISTS_PER_USER)
+
+/*
+ * List entries without _32BIT flag are using the native machine size
+ */
+#define FUTEX_ROBUST_LIST_ENTRY_INUSE	0x1UL
+#define FUTEX_ROBUST_LIST_ENTRY_32BIT	0x2UL
+#define FUTEX_ROBUST_LIST_ENTRY_MASK	(~0x3UL)
+
+static inline bool futex_in_32bit_syscall(void)
+{
+#ifdef CONFIG_X86
+	return !IS_ENABLED(CONFIG_64BIT) || in_32bit_syscall();
+#else
+	return !IS_ENABLED(CONFIG_64BIT);
+#endif
+}
+
 static inline void futex_init_task(struct task_struct *tsk)
 {
 	memset(&tsk->futex, 0, sizeof(tsk->futex));
@@ -76,6 +99,7 @@ static inline void futex_init_task(struct task_struct *tsk)
 #ifdef CONFIG_COMPAT
 	tsk->futex.robust_list32 = NULL;
 #endif
+	tsk->futex.robust_lists = NULL;
 }
 
 void futex_exit_recursive(struct task_struct *tsk);
diff --git a/include/linux/futex_types.h b/include/linux/futex_types.h
index f58616d7e20b..58321314ecab 100644
--- a/include/linux/futex_types.h
+++ b/include/linux/futex_types.h
@@ -18,6 +18,7 @@ struct robust_list_head;
  * @pi_state_cache:	Pointer to cache one PI state object per task
  * @exit_mutex:		Mutex for serializing exit
  * @state:		Futex handling state to handle exit races correctly
+ * @robust_lists:	List of robust lists heads
  */
 struct futex_sched_data {
 	struct robust_list_head __user		*robust_list;
@@ -28,6 +29,7 @@ struct futex_sched_data {
 	struct futex_pi_state			*pi_state_cache;
 	struct mutex				exit_mutex;
 	unsigned int				state;
+	uintptr_t				*robust_lists;
 };
 
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index b39f8a23a84b..becf43230df4 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -189,6 +189,24 @@ struct robust_list_head32 {
 	__u32			list_op_pending;
 };
 
+/*
+ * Commands for set_robust_list2 syscall
+ */
+enum robust_list2_cmd {
+	FUTEX_ROBUST_LIST_CMD_CREATE_64,
+	FUTEX_ROBUST_LIST_CMD_CREATE_32,
+	FUTEX_ROBUST_LIST_CMD_MODIFY_64,
+	FUTEX_ROBUST_LIST_CMD_MODIFY_32,
+	FUTEX_ROBUST_LIST_CMD_LIST_LIMIT,
+	FUTEX_ROBUST_LIST_CMD_USER_MAX,
+
+	/*
+	 * Kernel internal, rejected for user space
+	 */
+	FUTEX_ROBUST_LIST_SET_NATIVE = 128,
+	FUTEX_ROBUST_LIST_SET_COMPAT,
+};
+
 /*
  * Are there any waiters for this robust futex:
  */
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 6fce97012015..dd6fa8035fb6 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -73,6 +73,90 @@ struct futex_private_hash {
 	struct futex_hash_bucket queues[];
 };
 
+int futex_robust_list_create(uintptr_t head, enum robust_list2_cmd cmd)
+{
+	uintptr_t *rl = current->futex.robust_lists, entry = FUTEX_ROBUST_LIST_ENTRY_INUSE;
+	unsigned int index;
+
+	if (!rl) {
+		rl = kcalloc(FUTEX_ROBUST_LIST2_MAX_IDX, sizeof(*rl), GFP_KERNEL);
+		if (!rl)
+			return -ENOMEM;
+
+		scoped_guard(mutex, &current->futex.exit_mutex) {
+			/* check if another thread set the list before us */
+			if (current->futex.robust_lists) {
+				kfree(rl);
+				rl = current->futex.robust_lists;
+			} else {
+				current->futex.robust_lists = rl;
+			}
+		}
+
+	}
+
+	switch (cmd) {
+	case FUTEX_ROBUST_LIST_CMD_CREATE_32:
+		if (head)
+			entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
+		fallthrough;
+	case FUTEX_ROBUST_LIST_CMD_CREATE_64:
+		/* Search for an empty slot */
+		for (index = FUTEX_ROBUST_LIST2_IDX;
+		     index < FUTEX_ROBUST_LIST2_MAX_IDX; index++) {
+			if (rl[index] == 0)
+				goto exit;
+		}
+		return -ENOSPC;
+	default:
+		return -EINVAL;
+	}
+
+exit:
+	entry |= head;
+	scoped_guard(mutex, &current->futex.exit_mutex)
+		rl[index] = entry;
+
+	return index;
+}
+
+int futex_robust_list_modify(uintptr_t head, enum robust_list2_cmd cmd,
+			     unsigned int index)
+{
+	uintptr_t *rl = current->futex.robust_lists, entry = head;
+
+	if (index >= FUTEX_ROBUST_LIST2_MAX_IDX - FUTEX_ROBUST_LIST2_IDX)
+		return -EINVAL;
+
+	/* See comment about index mapping at sys_set_robust_list2() */
+	index += FUTEX_ROBUST_LIST2_IDX;
+
+	if (!rl || !rl[index])
+		return -ENOENT;
+
+	switch (cmd) {
+	case FUTEX_ROBUST_LIST_CMD_MODIFY_64:
+		if (rl[index] & FUTEX_ROBUST_LIST_ENTRY_32BIT)
+			return -EINVAL;
+		if (futex_in_32bit_syscall())
+			return -EINVAL;
+		break;
+	case FUTEX_ROBUST_LIST_CMD_MODIFY_32:
+		if (!(rl[index]  & FUTEX_ROBUST_LIST_ENTRY_32BIT))
+			return -EINVAL;
+		if (entry)
+			entry |= FUTEX_ROBUST_LIST_ENTRY_32BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	scoped_guard(mutex, &current->futex.exit_mutex)
+		rl[index] = entry;
+
+	return 0;
+}
+
 /*
  * Fault injections for futexes.
  */
@@ -1148,9 +1232,8 @@ static inline int fetch_robust_entry(struct robust_list __user **entry,
  *
  * We silently return on any sign of list-walking problem.
  */
-static void exit_robust_list(struct task_struct *curr)
+static void exit_robust_list(struct task_struct *curr, struct robust_list_head __user *head)
 {
-	struct robust_list_head __user *head = curr->futex.robust_list;
 	unsigned int limit = ROBUST_LIST_LIMIT, cur_mod, next_mod, pend_mod;
 	struct robust_list __user *entry, *next_entry, *pending;
 	unsigned long futex_offset;
@@ -1263,9 +1346,8 @@ static inline int fetch_robust_entry32(compat_uptr_t *uentry,
  *
  * We silently return on any sign of list-walking problem.
  */
-static void exit_robust_list32(struct task_struct *curr)
+static void exit_robust_list32(struct task_struct *curr, struct robust_list_head32 __user *head)
 {
-	struct robust_list_head32 __user *head = curr->futex.robust_list32;
 	unsigned int limit = ROBUST_LIST_LIMIT, cur_mod, next_mod, pend_mod;
 	struct robust_list __user *entry, *next_entry, *pending;
 	u32 uentry, next_uentry, upending;
@@ -1342,7 +1424,12 @@ static bool robust_list_clear_pending32(u32 __user *pop)
 }
 #else
 static bool robust_list_clear_pending32(u32 __user *pop_addr) { return false; }
-#endif
+
+static void exit_robust_list32(struct task_struct *curr, struct robust_list_head32 __user *head)
+{
+	pr_crit("32-bit kernel should never call %s", __func__);
+}
+#endif /* CONFIG_64BIT */
 
 #ifdef CONFIG_FUTEX_PI
 
@@ -1465,16 +1552,53 @@ void __futex_fixup_robust_unlock(struct pt_regs *regs, struct futex_unlock_cs_ra
 }
 #endif /* CONFIG_FUTEX_ROBUST_UNLOCK */
 
+static void exit_robust_lists(struct task_struct *tsk)
+{
+	uintptr_t *rl = tsk->futex.robust_lists;
+
+	tsk->futex.robust_lists = NULL;
+
+	for (unsigned int idx = 0; idx < FUTEX_ROBUST_LIST2_MAX_IDX; idx++) {
+		uintptr_t entry = rl[idx];
+
+		if (!(entry & FUTEX_ROBUST_LIST_ENTRY_MASK))
+			continue;
+
+		/*
+		 * If the list type is the same as the kernel bitness, always
+		 * calls exit_robust_list(). exit_robust_list32() is only for
+		 * 32-bit lists in a 64-bit kernel.
+		 */
+		if (IS_ENABLED(CONFIG_64BIT) && (entry & FUTEX_ROBUST_LIST_ENTRY_32BIT)) {
+			struct robust_list_head32 __user *head;
+
+			entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+
+			head = (__force struct robust_list_head32 __user *)entry;
+			exit_robust_list32(tsk, head);
+		} else {
+			struct robust_list_head __user *head;
+
+			entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+
+			head = (__force struct robust_list_head __user *)entry;
+			exit_robust_list(tsk, head);
+		}
+	}
+
+	kfree(rl);
+}
+
 static void futex_cleanup(struct task_struct *tsk)
 {
 	if (unlikely(tsk->futex.robust_list)) {
-		exit_robust_list(tsk);
+		exit_robust_list(tsk, tsk->futex.robust_list);
 		tsk->futex.robust_list = NULL;
 	}
 
 #ifdef CONFIG_64BIT
 	if (unlikely(tsk->futex.robust_list32)) {
-		exit_robust_list32(tsk);
+		exit_robust_list32(tsk, tsk->futex.robust_list32);
 		tsk->futex.robust_list32 = NULL;
 	}
 #endif
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index f00f0863ed44..7706d2b6f8a9 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -478,4 +478,9 @@ extern int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, i
 
 bool futex_robust_list_clear_pending(void __user *pop, unsigned int flags);
 
+int futex_robust_list_create(uintptr_t head, enum robust_list2_cmd cmd);
+
+int futex_robust_list_modify(uintptr_t head, enum robust_list2_cmd cmd, unsigned
+			     int index);
+
 #endif /* _FUTEX_H */
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 4a45bace75fc..48e87b5e4e33 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -105,6 +105,61 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 	return put_user(head, head_ptr);
 }
 
+SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head * __user, head, unsigned int,
+		cmd, unsigned int, index, unsigned int, flags)
+{
+	uintptr_t entry = (__force uintptr_t)head;
+	size_t align = sizeof(u32);
+	int ret;
+
+	if (flags)
+		return -EINVAL;
+
+	if (cmd >= FUTEX_ROBUST_LIST_CMD_USER_MAX)
+		return -EINVAL;
+
+	if (cmd == FUTEX_ROBUST_LIST_CMD_CREATE_64 ||
+	    cmd == FUTEX_ROBUST_LIST_CMD_MODIFY_64) {
+		if (futex_in_32bit_syscall())
+			return -EOPNOTSUPP;
+		align = sizeof(u64);
+	}
+
+	switch (cmd) {
+	case FUTEX_ROBUST_LIST_CMD_CREATE_64:
+	case FUTEX_ROBUST_LIST_CMD_CREATE_32:
+		if (index)
+			return -EINVAL;
+
+		if (entry % align)
+			return -EINVAL;
+
+		/*
+		 * The first two indexes are reserved for the kernel to be used
+		 * with the legacy syscall, so we hide them from userspace.
+		 *
+		 * We map [0, FUTEX_ROBUST_LISTS_PER_USER) to
+		 *  [FUTEX_ROBUST_LIST2_IDX, FUTEX_ROBUST_LIST2_MAX_IDX)
+		 */
+		ret = futex_robust_list_create(entry, cmd);
+
+		if (ret >= 0)
+			ret -= FUTEX_ROBUST_LIST2_IDX;
+
+		return ret;
+
+	case FUTEX_ROBUST_LIST_CMD_MODIFY_64:
+	case FUTEX_ROBUST_LIST_CMD_MODIFY_32:
+		if (entry % align)
+			return -EINVAL;
+		return futex_robust_list_modify(entry, cmd, index);
+	case FUTEX_ROBUST_LIST_CMD_LIST_LIMIT:
+		return FUTEX_ROBUST_LISTS_PER_USER;
+	}
+
+	return -EINVAL;
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c8be0abaa407..0bb92b3cb589 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -172,6 +172,7 @@ COND_SYSCALL_COMPAT(fadvise64_64);
 COND_SYSCALL(lsm_get_self_attr);
 COND_SYSCALL(lsm_set_self_attr);
 COND_SYSCALL(lsm_list_modules);
+COND_SYSCALL(set_robust_list2);
 
 /* CONFIG_MMU only */
 COND_SYSCALL(swapon);

-- 
2.56.1

