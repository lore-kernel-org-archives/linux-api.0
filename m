Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763901;
	b=PLnLYM4fqkttmqn495Hf9JT+Mggb8oX3CqZK942FBpf0x3maXUSC2hjiEN1OYOLtr4v0
	 9EkzoNzo/ACAS3ORtorsrVgOtlhZwIR4CMQOOWd7XVc7q1wp7mZun4ht6/6F9KGqK/k5z
	 iqHr1sdbzxPjGwCe8xIclW2N9tUtj6k5Sq7pdhpWk4H5Q9bktFq8WF9ENfvtRmALyTfWX
	 cC9H6tkq2xv3c4Va4SYd+zjpWPAVP/T99RWB+c8wksfEAIy3hfaQHbYOOprIh7vOi+TrQ
	 KM9WPLDrA2G1HpwnUXwohNEuX26s8Qdk4nZZkY3y69gd5g5vXGilbr+86TNp/qQiHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763901;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=WOZOFFSui0i8Owi/OxzM7wAYN1WFEwdEtQFYUCz8xAg=;
	b=VnoeDdHxMwOX1d/30usb09/bMFMwbXhvOx+cmJ7flLz08nhj2e4saBAC8C34ieyuCwjp
	 wQjd6YWYfBA3Eyy8fxBXGX2NgO9xRoDwmt/JuGXyBW4/9zGMLv3asvVqbXWdQ49KRNNMs
	 7abCZVOLj1YCrV9jdTcKRcyfUHE66gkSJRNLerfSLi3IkxJZ63KQFdOwbqxn7dd1R0WTh
	 1K4v9GFGL8pmWuGSoGnmQUKaPaco3YXjPP5qXbGNn6YLReULbXhIjsLjaLatOdaw//Ivx
	 lOnydrMzByXbBEl14Q+xkmYKMktX2BaTEpn9o9IhLQ4uDh6bIlvTC727ennV+hjTvqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=BwT9tFaI;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7576606A31D;
	Sun, 15 Nov 2026 17:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7576606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=BwT9tFaI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=WOZOFFSui0i8Owi/OxzM7wAYN1WFEwdEtQFYUCz8xAg=; t=1794763900; x=2110123900; 
	b=BwT9tFaII/RoKCSc+/lWne9+v0/EW7xVk/YQMH77yBgYkuKBbOYtWyJg53BEsfzwAGXLhNZdKpC
	5FaqTP5OFbRTqcugXO6DTQZfKO1xyWej5j8AMXFlICxzWi46hoMEnCc2fyu1iaCdcSiL/IiPurNNN
	dWACl2f2uMhDeWkMxam3GqtQl6yJsdFlb1eI7wbjg4rTfcK8a3Fo8e8vQRladMR1a1qzKQXI0u4XI
	lYLlN73k5DpzJoxP1EXX8Bvqi9N4/aTcPG2+kfy8B+B8n0SImcY6GZBoUc8I94kYeEMwKzHIqi7si
	HtpJTTI7Mcax6dpGzUW+fp8rZEVN2TCgD1PQ==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4i-00B0BK-3A; Sun, 15 Nov 2026 18:31:32 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 15 Nov 2026 14:31:14 -0300
Subject: [PATCH v8 05/10] futex: Create get_robust_list2() syscall
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
Message-Id: <20261115-tonyk-robust_futex-v8-5-a4fe47333a28@igalia.com>
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

As in the original robust list interface, to pair with
set_robust_list2(), create a get_robust_list2() syscall with the
following signature:

  get_robust_list2(int pid, void __user **head_ptr, unsigned int index,
		   unsigned int flags)

  - `pid` sets with task's list should be returned. If is 0, it gets the
    list of the calling task.
  - `index` is the index of the list to get
  - `flags` is unused but can be used for expanding the interface

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 kernel/futex/syscalls.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sys_ni.c         |  1 +
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 48e87b5e4e33..0ecb32afd5e1 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -44,7 +44,7 @@ static inline void __user *futex_task_robust_list(struct task_struct *p, bool co
 	return p->futex.robust_list;
 }
 
-static void __user *futex_get_robust_list_common(int pid, bool compat)
+static void __user *futex_get_robust_list_common(int pid, bool compat, int index)
 {
 	struct task_struct *p = current;
 	void __user *head;
@@ -71,7 +71,15 @@ static void __user *futex_get_robust_list_common(int pid, bool compat)
 	if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS))
 		goto err_unlock;
 
-	head = futex_task_robust_list(p, compat);
+	if (index >= 0) {
+		scoped_guard(mutex, &p->futex.exit_mutex) {
+			uintptr_t *rl = p->futex.robust_lists;
+
+			head = rl ? (void __user *) rl[index] : NULL;
+		}
+	} else {
+		head = futex_task_robust_list(p, compat);
+	}
 
 	up_read(&p->signal->exec_update_lock);
 	put_task_struct(p);
@@ -95,7 +103,7 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
 		size_t __user *, len_ptr)
 {
-	struct robust_list_head __user *head = futex_get_robust_list_common(pid, false);
+	struct robust_list_head __user *head = futex_get_robust_list_common(pid, false, -1);
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
@@ -160,6 +168,56 @@ SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head * __user, head, unsign
 	return -EINVAL;
 }
 
+SYSCALL_DEFINE4(get_robust_list2, int, pid,
+		void __user * __user *, head_ptr,
+		unsigned int, index, unsigned int, flags)
+{
+	struct robust_list_head *head;
+	void __user *entry_ptr;
+	uintptr_t entry;
+
+	if (index >= FUTEX_ROBUST_LISTS_PER_USER)
+		return -EINVAL;
+
+	if (flags)
+		return -EINVAL;
+
+	/*
+	 * The first two indexes are reserved for the kernel to be used with the
+	 * legacy syscall, so we hide them from userspace.
+	 *
+	 * We map [0, FUTEX_ROBUST_LISTS_PER_USER) to
+	 *  [FUTEX_ROBUST_LIST2_IDX, FUTEX_ROBUST_LIST2_MAX_IDX)
+	 */
+	index += FUTEX_ROBUST_LIST2_IDX;
+
+	entry_ptr = futex_get_robust_list_common(pid, false, index);
+	if (IS_ERR(entry_ptr))
+		return PTR_ERR(entry_ptr);
+
+	entry = (uintptr_t) entry_ptr;
+
+	if (futex_in_32bit_syscall()) {
+		u32 entry32;
+
+		if (entry && !(entry & FUTEX_ROBUST_LIST_ENTRY_32BIT))
+			return -EOPNOTSUPP;
+
+		entry32 = (u32)entry;
+		entry32 &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+
+		if (copy_to_user(head_ptr, &entry32, sizeof(entry32)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+	head = (__force struct robust_list_head __user *)entry;
+
+	return put_user(head, head_ptr);
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
@@ -548,7 +606,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
 			compat_uptr_t __user *, head_ptr,
 			compat_size_t __user *, len_ptr)
 {
-	struct robust_list_head32 __user *head = futex_get_robust_list_common(pid, true);
+	struct robust_list_head32 __user *head = futex_get_robust_list_common(pid, true, -1);
 
 	if (IS_ERR(head))
 		return PTR_ERR(head);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 0bb92b3cb589..d8bbcd87d535 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -173,6 +173,7 @@ COND_SYSCALL(lsm_get_self_attr);
 COND_SYSCALL(lsm_set_self_attr);
 COND_SYSCALL(lsm_list_modules);
 COND_SYSCALL(set_robust_list2);
+COND_SYSCALL(get_robust_list2);
 
 /* CONFIG_MMU only */
 COND_SYSCALL(swapon);

-- 
2.56.1

