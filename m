From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH NOTFORMERGE 1/5] mm: rename madvise_core to madvise_common
Date: Sun, 16 Jun 2019 10:58:31 +0200
Message-ID: <20190616085835.953-2-oleksandr@redhat.com>
References: <20190616085835.953-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190616085835.953-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

"core" usually means something very different within the kernel land,
thus lets just follow the way it is handled in mutexes, rw_semaphores
etc and name common things as "_common".

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 mm/madvise.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 94d782097afd..edb7184f665c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -998,7 +998,7 @@ process_madvise_behavior_valid(int behavior)
 }
 
 /*
- * madvise_core - request behavior hint to address range of the target process
+ * madvise_common - request behavior hint to address range of the target process
  *
  * @task: task_struct got behavior hint, not giving the hint
  * @mm: mm_struct got behavior hint, not giving the hint
@@ -1009,7 +1009,7 @@ process_madvise_behavior_valid(int behavior)
  * @task could be a zombie leader if it calls sys_exit so accessing mm_struct
  * via task->mm is prohibited. Please use @mm insetad of task->mm.
  */
-static int madvise_core(struct task_struct *task, struct mm_struct *mm,
+static int madvise_common(struct task_struct *task, struct mm_struct *mm,
 			unsigned long start, size_t len_in, int behavior)
 {
 	unsigned long end, tmp;
@@ -1132,7 +1132,7 @@ static int pr_madvise_copy_param(struct pr_madvise_param __user *u_param,
 	return ret;
 }
 
-static int process_madvise_core(struct task_struct *tsk, struct mm_struct *mm,
+static int process_madvise_common(struct task_struct *tsk, struct mm_struct *mm,
 				int *behaviors,
 				struct iov_iter *iter,
 				const struct iovec *range_vec,
@@ -1144,7 +1144,7 @@ static int process_madvise_core(struct task_struct *tsk, struct mm_struct *mm,
 	for (i = 0; i < riovcnt && iov_iter_count(iter); i++) {
 		err = -EINVAL;
 		if (process_madvise_behavior_valid(behaviors[i]))
-			err = madvise_core(tsk, mm,
+			err = madvise_common(tsk, mm,
 				(unsigned long)range_vec[i].iov_base,
 				range_vec[i].iov_len, behaviors[i]);
 
@@ -1220,7 +1220,7 @@ static int process_madvise_core(struct task_struct *tsk, struct mm_struct *mm,
  */
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
-	return madvise_core(current, current->mm, start, len_in, behavior);
+	return madvise_common(current, current->mm, start, len_in, behavior);
 }
 
 
@@ -1252,7 +1252,7 @@ SYSCALL_DEFINE3(process_madvise, int, pidfd,
 
 	/*
 	 * We don't support cookie to gaurantee address space atomicity yet.
-	 * Once we implment cookie, process_madvise_core need to hold mmap_sme
+	 * Once we implment cookie, process_madvise_common need to hold mmap_sme
 	 * during entire operation to guarantee atomicity.
 	 */
 	if (params.cookie != 0)
@@ -1316,7 +1316,7 @@ SYSCALL_DEFINE3(process_madvise, int, pidfd,
 		goto release_task;
 	}
 
-	ret = process_madvise_core(task, mm, behaviors, &iter, iov_r, nr_elem);
+	ret = process_madvise_common(task, mm, behaviors, &iter, iov_r, nr_elem);
 	mmput(mm);
 release_task:
 	put_task_struct(task);
-- 
2.22.0
