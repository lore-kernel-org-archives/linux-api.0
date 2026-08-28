Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575C53A9D84;
	Fri, 28 Aug 2026 22:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955840; cv=none; b=LB2ChQiacZTH+Uvu1XWlMjXxWYrBhTeOaSB0Heb4BO5uBU0+h3lzZIctn2y8lB4As4LtEl3vp2l9o+PKkPbkIjTmAMCuFBjqbFBwGuh/ZY/fkaTxH8CgOWS5DedhJ5/TVkTQWEiTiL7iS9nlRhTUiHBKtP3RDyiOGoafYn8enmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955840; c=relaxed/simple;
	bh=ZWqheJd1NEAZN8PnzaImedNHmcoUsnwyF5Cxa3W7GQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RNahqh0Dxpl8zqai46EfHXdBowu6OFUc9gz8EgVmrbcSYxfERQxXryR+JJqUfHWbKfoKkqICnZ0tEiK25ee8sXlxnbZf4cDjd7WRx7wU7MTWbHL0eZW4HwOZ4lOPWDBzon9nwiC+qBBv8nIoVKUPFPBDCfG50TAQQXbXq66KlS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O5gjeQ22; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O5gjeQ22"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955835; x=1819491835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZWqheJd1NEAZN8PnzaImedNHmcoUsnwyF5Cxa3W7GQY=;
  b=O5gjeQ2209lTnQHGep1xBqq1/JqPyF63B/lB5Zh+gaPJwQV/GomyIzXV
   h76CeQBOx5biDVswcIZ+6nhgeHJ3g2u2VvmGK1TAcEaoChZpomeIBirdQ
   dhetcHKdjTBp/gMCTo/ZH/LvLGiXqkKuy6NgT0sTEJLTLa43BUoI9s32L
   IqqAzDDipT7+EkKfSs48y42vUxlfTszR74mWxuLNDTzxVfSwXLT8cYzA2
   YBrKTOqVt4EODiapaucbk1Ai1FAs4mbOdLmniYLUV4x02ZxCV3rQCLDHP
   5NQ36WQNwpFuvYSo4lxyZVcYFe3vCbwgiUvrfo6y/fedsNma3XG5QwRaA
   w==;
X-CSE-ConnectionGUID: p/f/T1h3TuGPCI72V/kVmw==
X-CSE-MsgGUID: hbqu2CDeQNyrRk423dOVDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412343"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412343"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:54 -0700
X-CSE-ConnectionGUID: ZszoZ9BlRk6RNbzAJMi23Q==
X-CSE-MsgGUID: /Q6ss92zSOy48RZSb+67BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540277"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:54 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Qais Yousef <qyousef@layalina.io>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jianyong Wu <jianyong.wu@outlook.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Vern Hao <vernhao@tencent.com>,
	Vern Hao <haoxing990@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Aubrey Li <aubrey.li@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Chen Yu <yu.chen.surf@gmail.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Tim Chen <tim.c.chen@intel.com>,
	Josh Don <joshdon@google.com>,
	Luo Gengkun <luogengkun2@huawei.com>,
	Gavin Guo <gavinguo@igalia.com>,
	Yi Lai <yi1.lai@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 4/7] sched/cache: Add prctl to manage per process cache scheduling groups
Date: Fri, 28 Aug 2026 15:29:11 -0700
Message-Id: <50fe2db1a62ea2376a87d0c14778b1ff456d11ec.1787955777.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1787955777.git.tim.c.chen@linux.intel.com>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Derived from core scheduling's prctl interface.

Implement the controls for cache aware scheduling on a process:

int prctl(PR_SCHED_CACHE, unsigned long subop, pid_t pid,
          unsigned long arg4, unsigned long type);

pid argument: the PID of the task the operation applies to, that is the
destination of the group assignment. 0 means "the calling task."

pid_type : PIDTYPE_PID targets the single thread, PIDTYPE_TGID the whole
thread group and PIDTYPE_PGID the process group of that task.
PR_SCHED_CACHE_GET only accepts PIDTYPE_PID.

arg4 argument: the address to store the cookie for PR_SCHED_CACHE_GET,
the pid to take the group from for PR_SCHED_CACHE_SHARE_FROM, where 0
means "the calling task".

The second argument (subop) selects one of the following operations:

1. PR_SCHED_CACHE_GET

Retrieve the cache aware scheduling cookie of a task.

  u64 cookie;
  prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_GET, pid, (unsigned long)&cookie,
        PIDTYPE_PID);

2. PR_SCHED_CACHE_CREATE

Create a new cache scheduling group and assign it to the target pid,

  prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_CREATE, pid, 0, PIDTYPE_TGID);

3. PR_SCHED_CACHE_SHARE_FROM

Copy the group of the task given in arg4 to the target task.

  /* pull 1234's group onto the caller */
  prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_SHARE_FROM, 0, 1234, PIDTYPE_PID);

  /* push the caller's group onto the thread group of 1234 */
  prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_SHARE_FROM, 1234, 0, PIDTYPE_TGID);

  /* let the thread group of 1234 share 5678's group */
  prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_SHARE_FROM, 1234, 5678, PIDTYPE_TGID);

Unlike the core scheduling's PR_SCHED_CORE_SHARE_FROM and
PR_SCHED_CORE_SHARE_TO, there is no need to involve the current task: a
daemon(scheqos, eg) can handle two tasks without joining their group,
which would pollute the group's per LLC occupancy statistics.

Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 fs/exec.c                  |  18 ++-
 include/linux/sched.h      |   4 +
 include/uapi/linux/prctl.h |   7 +
 kernel/exit.c              |  13 +-
 kernel/fork.c              |  25 +++-
 kernel/sched/cache_sched.c | 274 +++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c        |   8 +-
 kernel/sys.c               |   5 +
 8 files changed, 341 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a501e2ec84a0..4448ea123481 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -884,12 +884,22 @@ static int exec_mmap(struct linux_binprm *bprm)
 	{
 		struct sched_cache_group *old_grp, *new_grp;
 
-		old_grp = rcu_dereference_protected(tsk->sched_cache_grp, true);
-
-		/* Acquire the reference before publishing the pointer. */
+		/*
+		 * Acquire the reference before publishing the pointer: once
+		 * tsk->sched_cache_grp is visible, a concurrent
+		 * prctl(PR_SCHED_CACHE) writer may pick the group up as its
+		 * old_grp and drop a reference we have not taken yet.
+		 *
+		 * pi_lock serializes the exchange against such a writer. IRQs
+		 * are already disabled here, so a plain raw_spin_lock()
+		 * suffices.
+		 */
 		new_grp = sched_cache_group_get(mm->sched_cache_grp);
 
-		rcu_assign_pointer(tsk->sched_cache_grp, new_grp);
+		raw_spin_lock(&tsk->pi_lock);
+		old_grp = sched_cache_grp_replace(tsk, new_grp);
+		raw_spin_unlock(&tsk->pi_lock);
+
 		if (old_grp)
 			sched_cache_group_put(old_grp);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e25347aa2cc5..79f0079c3aa1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2407,7 +2407,11 @@ void sched_cache_group_put(struct sched_cache_group *grp);
 struct sched_cache_group *sched_cache_group_get(struct sched_cache_group *grp);
 struct sched_cache_group *task_cache_group_get(struct task_struct *p);
 struct sched_cache_group *
+sched_cache_grp_replace(struct task_struct *p, struct sched_cache_group *grp);
+struct sched_cache_group *
 sched_cache_alloc_group(struct sched_cache_time __percpu *pcpu_sched);
+int sched_cache_prctl(int option, unsigned long arg2, unsigned long arg3,
+		      unsigned long arg4, unsigned long arg5);
 
 #else
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..fed7bb028f9a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -416,4 +416,11 @@ struct prctl_mm_map {
 # define PR_CFI_DISABLE		_BITUL(1)
 # define PR_CFI_LOCK		_BITUL(2)
 
+/* Cache-aware scheduling */
+#define PR_SCHED_CACHE			82
+# define PR_SCHED_CACHE_GET		0
+# define PR_SCHED_CACHE_CREATE		1
+# define PR_SCHED_CACHE_SHARE_FROM	2
+# define PR_SCHED_CACHE_MAX		3
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index 83fa28b3416b..d140429046d2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -592,10 +592,17 @@ static void exit_mm(void)
 
 #ifdef CONFIG_SCHED_CACHE
 	{
-		struct sched_cache_group *grp =
-			rcu_dereference_protected(current->sched_cache_grp, true);
+		struct sched_cache_group *grp;
+		unsigned long flags;
 
-		rcu_assign_pointer(current->sched_cache_grp, NULL);
+		/*
+		 * pi_lock serializes the clear against a concurrent
+		 * prctl(PR_SCHED_CACHE) writer targeting this task, so the
+		 * reference is dropped exactly once.
+		 */
+		raw_spin_lock_irqsave(&current->pi_lock, flags);
+		grp = sched_cache_grp_replace(current, NULL);
+		raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
 		if (grp)
 			sched_cache_group_put(grp);
diff --git a/kernel/fork.c b/kernel/fork.c
index 195b7807ddbb..9399f5e2070e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1601,13 +1601,28 @@ static int copy_mm(u64 clone_flags, struct task_struct *tsk)
 	tsk->active_mm = mm;
 #ifdef CONFIG_SCHED_CACHE
 	{
+		struct sched_cache_group *grp;
+
 		/*
-		 * A task holds its own reference on the group, separate from
-		 * the reference held by its mm_struct. Acquire it before
-		 * publishing the pointer.
+		 * For CLONE_VM (threads): inherit the parent's
+		 * sched_cache_grp, which may be a cookie-based group different
+		 * from mm->sched_cache_grp. For kernel thread, don't assign
+		 * it a sched cache group.
+		 *
+		 * For new processes (own mm): use the new mm's group. The mm
+		 * has just been created and is not visible to anyone else, so
+		 * there is no race against a concurrent writer and the mm's
+		 * own reference keeps the group alive. Take the refcount
+		 * directly, without RCU.
 		 */
-		struct sched_cache_group *grp =
-			sched_cache_group_get(mm->sched_cache_grp);
+		if (clone_flags & CLONE_VM) {
+			if (tsk->flags & PF_KTHREAD)
+				grp = NULL;
+			else
+				grp = task_cache_group_get(current);
+		} else {
+			grp = sched_cache_group_get(mm->sched_cache_grp);
+		}
 
 		rcu_assign_pointer(tsk->sched_cache_grp, grp);
 	}
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
index 860209a47931..d1932f0c5ee8 100644
--- a/kernel/sched/cache_sched.c
+++ b/kernel/sched/cache_sched.c
@@ -83,3 +83,277 @@ sched_cache_alloc_group(struct sched_cache_time __percpu *_pcpu_sched)
 	sched_cache_group_init(grp, _pcpu_sched);
 	return grp;
 }
+
+static struct sched_cache_group *sched_cache_alloc_all(void)
+{
+	struct sched_cache_time __percpu *pcpu_sched;
+
+	pcpu_sched = alloc_percpu(struct sched_cache_time);
+	if (!pcpu_sched)
+		return NULL;
+
+	return sched_cache_alloc_group(pcpu_sched);
+}
+
+#ifdef CONFIG_NUMA_BALANCING
+/*
+ * When prctl() moves a task between groups, move its footprint estimate too:
+ * otherwise the group it leaves over-estimates its footprint forever, and the
+ * group it joins under-estimates it once the task exits.
+ */
+static void sched_cache_xfer_footprint(struct task_struct *p,
+				       struct sched_cache_group *old,
+				       struct sched_cache_group *new)
+{
+	unsigned long fp, sub;
+
+	if (!old || !new || old == new)
+		return;
+
+	sub = READ_ONCE(p->total_numa_faults);
+	if (!sub)
+		return;
+
+	fp = READ_ONCE(old->footprint);
+	sub = min(fp, sub);
+	WRITE_ONCE(old->footprint, fp - sub);
+
+	fp = READ_ONCE(new->footprint);
+	WRITE_ONCE(new->footprint, fp + sub);
+}
+#else
+static inline void sched_cache_xfer_footprint(struct task_struct *p,
+					      struct sched_cache_group *old,
+					      struct sched_cache_group *new)
+{
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
+/* Swap a task's cache group pointer and return the previous one. */
+struct sched_cache_group *
+sched_cache_grp_replace(struct task_struct *p, struct sched_cache_group *grp)
+{
+	struct sched_cache_group *old;
+
+	lockdep_assert_held(&p->pi_lock);
+	old = rcu_dereference_protected(p->sched_cache_grp,
+					lockdep_is_held(&p->pi_lock));
+	rcu_assign_pointer(p->sched_cache_grp, grp);
+
+	return old;
+}
+
+static void __sched_cache_set(struct task_struct *p,
+			      struct sched_cache_group *grp)
+{
+	struct sched_cache_group *old_grp;
+	unsigned long flags;
+
+	grp = sched_cache_group_get(grp);
+
+	/*
+	 * p->pi_lock serializes the exchange against concurrent writers
+	 * (other prctl callers as well as exec_mmap()/exit_mm()). Without
+	 * it two writers could fetch the same old pointer and each drop a
+	 * reference, over-decrementing the refcount.
+	 */
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+
+	/*
+	 * Avoid increasing the refcount for an exiting task,
+	 * otherwise the grp can not be put after the task exits,
+	 * and cause memory leak:
+	 * CPU0 (prctl)                    CPU1 (task exiting)
+	 * ----                            ----
+	 *                                 exit_mm()
+	 *                                   put(p->sched_cache_grp)
+	 *                                    free(old_grp)
+	 *
+	 * __sched_cache_set(p, new_grp)
+	 *
+	 *                                   free_task()
+	 *                                     free(p)
+	 * the "freed" p is unable to put new_grp
+	 *
+	 * PF_EXITING is set in exit_signals() without p->pi_lock held, so this
+	 * test on its own would only narrow the window. What closes it is that
+	 * exit_mm() takes p->pi_lock to clear the pointer, and exit_signals()
+	 * runs before exit_mm(). So of the two possible orders:
+	 *
+	 *  - we get pi_lock before exit_mm() does: we install new_grp and its
+	 *    reference, and exit_mm() subsequently drops it, because it puts
+	 *    whatever sched_cache_grp_replace() hands back.
+	 *
+	 *  - we get pi_lock after exit_mm() released it: the lock's release/
+	 *    acquire ordering makes the PF_EXITING store visible to us, so the
+	 *    test below fires and we install nothing.
+	 *
+	 * Either way the reference is dropped exactly once. The test is thus
+	 * about not leaving a reference behind on a task that is already past
+	 * exit_mm(), not about racing with the PF_EXITING store itself.
+	 */
+	if (p->flags & PF_EXITING) {
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		if (grp)
+			sched_cache_group_put(grp);
+		return;
+	}
+
+	old_grp = sched_cache_grp_replace(p, grp);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+
+	/* Carry this task's footprint estimate to the group it just joined. */
+	sched_cache_xfer_footprint(p, old_grp, grp);
+
+	if (old_grp)
+		sched_cache_group_put(old_grp);
+}
+
+static struct task_struct *sched_cache_find_get_task(unsigned long vpid)
+{
+	struct task_struct *p;
+
+	guard(rcu)();
+	p = vpid ? find_task_by_vpid(vpid) : current;
+	if (p)
+		get_task_struct(p);
+
+	return p;
+}
+
+/*
+ * arg2: subcommand,
+ * arg3: destination pid, SHARE_FROM copies the group of arg4 to arg3
+ * arg4: source pid, or cookie out ptr for GET
+ * arg5: pid type, the scope of the destination
+ *
+ */
+int sched_cache_prctl(int option, unsigned long arg2, unsigned long arg3,
+		      unsigned long arg4, unsigned long arg5)
+{
+	struct task_struct *dst = NULL, *src = NULL, *p;
+	struct sched_cache_group *grp = NULL;
+	enum pid_type type = arg5;
+	struct pid *pid_grp;
+	int err = 0;
+
+	if (arg2 >= PR_SCHED_CACHE_MAX || arg3 > INT_MAX ||
+	    arg5 > PIDTYPE_PGID)
+		return -EINVAL;
+
+	/* only GET and SHARE_FROM take a 4th argument */
+	if (arg4 && arg2 != PR_SCHED_CACHE_GET &&
+	    arg2 != PR_SCHED_CACHE_SHARE_FROM)
+		return -EINVAL;
+
+	dst = sched_cache_find_get_task(arg3);
+	if (!dst)
+		return -ESRCH;
+
+	if (dst->flags & PF_KTHREAD) {
+		err = -EINVAL;
+		goto out_task;
+	}
+
+	if (!ptrace_may_access(dst, PTRACE_MODE_READ_REALCREDS)) {
+		err = -EPERM;
+		goto out_task;
+	}
+
+	switch (arg2) {
+	case PR_SCHED_CACHE_GET: {
+		unsigned long id = 0;
+
+		if (type != PIDTYPE_PID || arg4 & 7) {
+			err = -EINVAL;
+			goto out_task;
+		}
+
+		grp = task_cache_group_get(dst);
+		if (grp)
+			ptr_to_hashval((void *)grp, &id);
+
+		if (arg4)
+			err = put_user((u64)id, (u64 __user *)arg4);
+
+		goto out_group;
+	}
+
+	case PR_SCHED_CACHE_CREATE:
+		/*
+		 * Allocator owns ref 1, __sched_cache_set() acquires ref 2.
+		 * The sched_cache_group_put() at out_group: drops ref 1, leaving
+		 * ref 1 held by the task.
+		 */
+		grp = sched_cache_alloc_all();
+		if (!grp) {
+			err = -ENOMEM;
+			goto out_task;
+		}
+		break;
+
+	case PR_SCHED_CACHE_SHARE_FROM:
+		if (arg4 > INT_MAX) {
+			err = -EINVAL;
+			goto out_task;
+		}
+
+		src = sched_cache_find_get_task(arg4);
+		if (!src) {
+			err = -ESRCH;
+			goto out_task;
+		}
+
+		if (src->flags & PF_KTHREAD) {
+			err = -EINVAL;
+			goto out_task;
+		}
+
+		if (!ptrace_may_access(src, PTRACE_MODE_READ_REALCREDS)) {
+			err = -EPERM;
+			goto out_task;
+		}
+
+		/* copy the group of src to dst */
+		grp = task_cache_group_get(src);
+		if (!grp) {
+			err = -ENOENT;
+			goto out_task;
+		}
+		break;
+
+	default:
+		err = -EINVAL;
+		goto out_task;
+	}
+
+	if (type == PIDTYPE_PID) {
+		__sched_cache_set(dst, grp);
+		goto out_group;
+	}
+
+	read_lock(&tasklist_lock);
+	pid_grp = task_pid_type(dst, type);
+
+	do_each_pid_thread(pid_grp, type, p) {
+		if (!ptrace_may_access(p, PTRACE_MODE_READ_REALCREDS)) {
+			err = -EPERM;
+			goto out_tasklist;
+		}
+	} while_each_pid_thread(pid_grp, type, p);
+
+	do_each_pid_thread(pid_grp, type, p) {
+		__sched_cache_set(p, grp);
+	} while_each_pid_thread(pid_grp, type, p);
+out_tasklist:
+	read_unlock(&tasklist_lock);
+
+out_group:
+	sched_cache_group_put(grp);
+out_task:
+	if (src)
+		put_task_struct(src);
+	if (dst)
+		put_task_struct(dst);
+	return err;
+}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be1f3568c3aa..d422b62ba987 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1484,7 +1484,13 @@ static bool invalid_llc_nr(struct sched_cache_group *grp, struct task_struct *p,
 {
 	int scale;
 
-	if (get_nr_threads(p) <= 1)
+	/*
+	 * Single threaded process that is not grouped with other threads
+	 * do not need cache aware scheduling.
+	 * A single-threaded process has a refcount of 2: from the mm and task
+	 * respectively.
+	 */
+	if (refcount_read(&grp->refcnt) <= 2 && get_nr_threads(p) <= 1)
 		return true;
 
 	/*
diff --git a/kernel/sys.c b/kernel/sys.c
index df69bd71de03..f13f1904654b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2907,6 +2907,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg3 & PR_CFI_LOCK && !(arg3 & PR_CFI_DISABLE))
 			error = arch_prctl_lock_branch_landing_pad_state(me);
 		break;
+#ifdef CONFIG_SCHED_CACHE
+	case PR_SCHED_CACHE:
+		error = sched_cache_prctl(option, arg2, arg3, arg4, arg5);
+		break;
+#endif
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;
-- 
2.32.0

