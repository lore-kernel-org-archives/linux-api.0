Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8231E85C;
	Thu, 16 Jul 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212777; cv=pass; b=PHWU/csU5pC5x6QmC2u46epy9V5sU95LzIoLCTjinioiRKoCDHGfEaQlR7WJnDMLFa7leXEN6J3mCQB61lzXoAo+heUFF5uvrC3/YTIM90zMsdCd6+dDwc6DHxHN3Fkb43OTyTjCzM7ZCFI/oGO+98Z0iucy5ul3YaQLunwCQT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212777; c=relaxed/simple;
	bh=E4eKLcP96sqKy8Dezsq799rz0kqd1K5kNdFvFhpEcrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llhtgzZNeNGfRUHlBg8/B73wBTbVio3JDsflTZzcfjWqGA3QyXbrKbAKszn2G3YYP5Il05fVu6XemOgPMmdMoYvew3v6FFDKf7YbWgoP9OiKJ0toXSKpHL8VbkIwcMs+3lwF7TMsHXjAEKNmMR6YlCgg2x52zDYJ1a9hSkvl5o4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XNl61S6r; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XNl61S6r"
ARC-Seal: i=1; a=rsa-sha256; t=1784212452; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hy5rDNBZast0eykBaCv6ufiedcfgKRjR6aygvTFCz9TLz+7Ex+FiiuXoE/pX23/5DZINbhepeFFqaDX0bTciMNF6kgyMzXJ2rxo79QmKi6mZoAeFbwyWPEKUiesziMmE9V4zMMQoHdimz8mGwPppX7sfJ/I+RUZauyKckPdC3vI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212452; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Cw1rlTuFfFp7SknXN1+aFGRpA9XFW1cANtJlt4dCukU=; 
	b=n3i/Q8R4YmNAYHsFnpboyZz1ATCWLh+wgymzuF0CEIN6OSt258N/S8SssncUoaMCKr4iwDtCYIzxpLAJi4rjawMfUxN+AUw6OilC1CAS2erp62FSZiWLuxNmlhp8PH3MEe7nbW7kQ/G1+AQHDkvMjXaFVlTdMn0+8JXsAdx3I/0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212452;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Cw1rlTuFfFp7SknXN1+aFGRpA9XFW1cANtJlt4dCukU=;
	b=XNl61S6rk5rPBadEXOlRistorXRQ0OvlSyV1M08qb4pTY/UKcLfDPAu54kD5xlB0
	QXZxQZIQvg8WNBdNoNvXg4Ti4Nd92jFkLHa3EKrfowi1Fth/KzX8rRDKIPaq6r8Dvpk
	0meql2eoflsNpcBn/2EqTkKAUWhgQocgDFQ0Vr2U=
Received: by mx.zohomail.com with SMTPS id 1784212448529805.8984322688145;
	Thu, 16 Jul 2026 07:34:08 -0700 (PDT)
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
Subject: [RFC PATCH 12/24] fork: let kernel callers create embryonic tasks
Date: Thu, 16 Jul 2026 22:31:38 +0800
Message-ID: <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty>
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

A kernel-created task can become visible before it has installed a new
executable image or a valid userspace register frame. Exposing such a task
through ptrace can disclose kernel setup state.

Add a task-local embryonic flag and an internal clone argument for callers
that need this lifecycle. Reject ptrace access until the creator clears the
flag. Clear it with release ordering and observe it with acquire ordering.
This orders visibility of the completed exec state with the transition.

Existing fork, vfork, clone, and kernel-thread callers leave the argument
unset and retain their current behavior.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 include/linux/sched.h      | 21 +++++++++++++++++++++
 include/linux/sched/task.h |  1 +
 kernel/fork.c              |  1 +
 kernel/ptrace.c            |  4 ++++
 4 files changed, 27 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 908aff695ef86..031ae92884c3c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1863,6 +1863,7 @@ static __always_inline bool is_user_task(struct task_struct *task)
 #define PFA_SPEC_IB_DISABLE		5	/* Indirect branch speculation restricted */
 #define PFA_SPEC_IB_FORCE_DISABLE	6	/* Indirect branch speculation permanently restricted */
 #define PFA_SPEC_SSB_NOEXEC		7	/* Speculative Store Bypass clear on execve() */
+#define PFA_EMBRYONIC_EXEC		8	/* No valid user register frame */
 
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -1905,6 +1906,26 @@ TASK_PFA_CLEAR(SPEC_IB_DISABLE, spec_ib_disable)
 TASK_PFA_TEST(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 TASK_PFA_SET(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 
+/* Clearing this bit publishes the register and security state from exec. */
+static inline bool task_is_embryonic_exec(struct task_struct *p)
+{
+	return test_bit_acquire(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
+/* The task is private during copy_process(), so no publication barrier. */
+static inline void task_init_embryonic_exec(struct task_struct *p, bool set)
+{
+	if (set)
+		__set_bit(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+	else
+		__clear_bit(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
+static inline void task_clear_embryonic_exec(struct task_struct *p)
+{
+	clear_bit_unlock(PFA_EMBRYONIC_EXEC, &p->atomic_flags);
+}
+
 static inline void
 current_restore_flags(unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 92b4e3bc31e66..5b7facf12b33b 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -45,6 +45,7 @@ struct kernel_clone_args {
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+	bool embryonic_exec;
 	unsigned int kill_seq;
 };
 
diff --git a/kernel/fork.c b/kernel/fork.c
index d16405c037c2f..e3ade83b2d4e2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2138,6 +2138,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_exec_state(clone_flags, p);
 	if (retval)
 		goto bad_fork_free;
+	task_init_embryonic_exec(p, args->embryonic_exec);
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
 		p->flags |= PF_KTHREAD;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d041645d9d17d..36eb9b154a397 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
 	guard(rcu)();
 	if (ptrace_parent(tsk) != current)
 		return false;
+	if (task_is_embryonic_exec(tsk))
+		return false;
 	es = task_exec_state_rcu(tsk);
 	return READ_ONCE(es->dumpable) == TASK_DUMPABLE_OWNER ||
 	       ptracer_capable(tsk, es->user_ns);
@@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		WARN(1, "denying ptrace access check without PTRACE_MODE_*CREDS\n");
 		return -EPERM;
 	}
+	if (task_is_embryonic_exec(task))
+		return -EPERM;
 
 	/* May we inspect the given task?
 	 * This check is used both for attaching with ptrace
-- 
2.52.0

