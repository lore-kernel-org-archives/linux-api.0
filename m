Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A77415F38;
	Fri, 25 Sep 2026 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358837; cv=none; b=d5oPoHTzK2b2//l+837pyfdKyMyH7LJQUXlUL8/IAQieHDLtHYoOkrPu/y93zzna1+YHSLe0FEFbXzBaWOer0Bcd4p4Wsyi+Jmgz/WDqWcXrj8A0aLQo2YJ11UqdPMTVKEhbv8JvxhdZT0M3KyW7SH4SMBZssMv0I1L1p1Q7REA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358837; c=relaxed/simple;
	bh=IdTNKOgYtzdiCUoapL69X3cwyQoc21jGNHFCl2kqQsI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BUREowXUNz3sHlKdo9PuV1lbhLDvnr9hBsQFoJ8kK6KD/X0S9RJEX3cQvkMvsFr7ZEU0iRRHXtGcZUPWuF5NRYXwu+tLycBHxw2/eyxjM8O1F45uCFbuj3buT49eLMzWdWem+spvCpN11Z+f0HMlze0RGRbG5AE4fmAmnPkZkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=fBjPclmu; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="fBjPclmu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=5POWp4lN1rJVdMk+ziwJzvaWOiHgKEg+VQWA3+Kv8rI=; b=fBjPclmu5FCJ8QJJVRgLw0o6qV
	9rCKk7D43HTzzW6EDEtha+PyQh/PyOpuhmW5SoLUU7IN2yTS/ihg+QEaXWuDxvGkJBLIUoiMKviJB
	w5H6hIUZqEgp5+RfnUZQl2IG2wHLn+XbyoVOsOpcdETLQiDIMjlDOu6eUJrV4YKDiC3l2qY0qZ7lN
	pjS3FhYAuJZdo1IEc6uSoZbBAp93RWt83s8vtpXCQRSeWqxI8OUZbCCsdf6uZBj2IW5LIK6ZiD+IW
	FZds7Xkpg3HPGBK3hZAvBy+RV5f9JNZowPwELKEDZ7jE8kmV09K7Um1kEcxIxD+FZ+Fq0fRT9giMl
	VsuXY4dQ==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA7K-007GQg-OI; Fri, 25 Sep 2026 19:53:50 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 25 Sep 2026 14:53:28 -0300
Subject: [PATCH v7 05/10] futex: Create get_robust_list2() syscall
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-tonyk-robust_futex-v7-5-d1095991152c@igalia.com>
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
For some reason I wasn't able to use put_user() for 32-bit lists.. it
kept corrupting the value due to wrong write size I believe.
copy_to_user() worked fine nonetheless.
---
 kernel/futex/syscalls.c | 61 +++++++++++++++++++++++++++++++++++++++++++++----
 kernel/sys_ni.c         |  1 +
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 6275c84052ec..596204870f65 100644
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
@@ -154,6 +162,51 @@ SYSCALL_DEFINE4(set_robust_list2, struct robust_list_head *, head, unsigned int,
 	return -EINVAL;
 }
 
+SYSCALL_DEFINE4(get_robust_list2, int, pid,
+		void __user * __user *, head_ptr,
+		unsigned int, index, unsigned int, flags)
+{
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
+	if (entry & FUTEX_ROBUST_LIST_ENTRY_32BIT) {
+		entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+
+		if (copy_to_user(head_ptr, &entry, sizeof(u32)))
+			return -EFAULT;
+
+		return 0;
+	} else {
+		struct robust_list_head *head;
+
+		entry &= FUTEX_ROBUST_LIST_ENTRY_MASK;
+		head = (__force struct robust_list_head __user *)entry;
+
+		return put_user(head, head_ptr);
+	}
+}
+
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
@@ -542,7 +595,7 @@ COMPAT_SYSCALL_DEFINE3(get_robust_list, int, pid,
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
2.55.0

