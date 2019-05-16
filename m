From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH RFC 4/5] mm/ksm, proc: introduce remote merge
Date: Thu, 16 May 2019 11:42:33 +0200
Message-ID: <20190516094234.9116-5-oleksandr@redhat.com>
References: <20190516094234.9116-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516094234.9116-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use previously introduced remote madvise knob to mark task's
anonymous memory as mergeable.

To force merging task's VMAs, "merge" hint is used:

   # echo merge > /proc/<pid>/madvise

Force unmerging is done similarly:

   # echo unmerge > /proc/<pid>/madvise

To achieve this, previously introduced ksm_madvise_*() helpers
are used.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 fs/proc/base.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f69532d6b74f..6677580080ed 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -94,6 +94,8 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/stat.h>
 #include <linux/posix-timers.h>
+#include <linux/mman.h>
+#include <linux/ksm.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -2960,15 +2962,63 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 static ssize_t madvise_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos)
 {
+	/* For now, only KSM hints are implemented */
+#ifdef CONFIG_KSM
+	char buffer[PROC_NUMBUF];
+	int behaviour;
 	struct task_struct *task;
+	struct mm_struct *mm;
+	int err = 0;
+	struct vm_area_struct *vma;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	if (!memcmp("merge", buffer, min(sizeof("merge")-1, count)))
+		behaviour = MADV_MERGEABLE;
+	else if (!memcmp("unmerge", buffer, min(sizeof("unmerge")-1, count)))
+		behaviour = MADV_UNMERGEABLE;
+	else
+		return -EINVAL;
 
 	task = get_proc_task(file_inode(file));
 	if (!task)
 		return -ESRCH;
 
+	mm = get_task_mm(task);
+	if (!mm) {
+		err = -EINVAL;
+		goto out_put_task_struct;
+	}
+
+	down_write(&mm->mmap_sem);
+	switch (behaviour) {
+	case MADV_MERGEABLE:
+	case MADV_UNMERGEABLE:
+		vma = mm->mmap;
+		while (vma) {
+			if (behaviour == MADV_MERGEABLE)
+				ksm_madvise_merge(vma->vm_mm, vma, &vma->vm_flags);
+			else
+				ksm_madvise_unmerge(vma, vma->vm_start, vma->vm_end, &vma->vm_flags);
+			vma = vma->vm_next;
+		}
+		break;
+	}
+	up_write(&mm->mmap_sem);
+
+	mmput(mm);
+
+out_put_task_struct:
 	put_task_struct(task);
 
-	return count;
+	return err ? err : count;
+#else
+	return -EINVAL;
+#endif /* CONFIG_KSM */
 }
 
 static const struct file_operations proc_madvise_operations = {
-- 
2.21.0
