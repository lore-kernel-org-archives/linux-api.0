From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] signal: make put_signal_struct() public
Date: Fri, 11 Mar 2016 10:41:22 -0500
Message-ID: <1457710888-31182-5-git-send-email-tj@kernel.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, pjt@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

This will be used from cgroup while implementing in-process resource
control.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h | 2 ++
 kernel/fork.c         | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f1e81e1..80d6ed1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2034,6 +2034,8 @@ static inline int is_global_init(struct task_struct *tsk)
 
 extern struct pid *cad_pid;
 
+extern void put_signal_struct(struct signal_struct *sig);
+
 extern void free_task(struct task_struct *tsk);
 #define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2e391c7..fd826de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -239,7 +239,7 @@ static inline void free_signal_struct(struct signal_struct *sig)
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static inline void put_signal_struct(struct signal_struct *sig)
+void put_signal_struct(struct signal_struct *sig)
 {
 	if (atomic_dec_and_test(&sig->sigcnt))
 		free_signal_struct(sig);
-- 
2.5.0
