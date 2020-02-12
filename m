From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 8/8] mm: support both pid and pidfd for process_madvise
Date: Wed, 12 Feb 2020 15:39:46 -0800
Message-ID: <20200212233946.246210-9-minchan@kernel.org>
References: <20200212233946.246210-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200212233946.246210-1-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, Joel Fernandes <joel@joelfernandes.org>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Minchan Kim <minchan@kernel.org>, Christian Brauner <christian@brauner.io>, Kirill Tkhai <ktkhai@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

There is a demand[1] to support pid as well pidfd for process_madvise
to reduce unnecessary syscall to get pidfd if the user has control of
the target process(ie, they could guarantee the process is not gone
or pid is not reused. Or, it might be okay to give a hint to wrong
process).

This patch aims for supporting both options like waitid(2). So, the
syscall is currently,

	int process_madvise(int which, pid_t pid, void *addr,
		size_t length, int advise, unsigned long flag);

@which is actually idtype_t for userspace libray and currently,
it supports P_PID and P_PIDFD.

[1]  https://lore.kernel.org/linux-mm/9d849087-3359-c4ab-fbec-859e8186c509@virtuozzo.com/

Cc: Christian Brauner <christian@brauner.io>
Suggested-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/syscalls.h |  3 ++-
 mm/madvise.c             | 34 ++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e4cd2c2f8bb4..f5ada20e2943 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -876,7 +876,8 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);
-asmlinkage long sys_process_madvise(int pidfd, unsigned long start,
+
+asmlinkage long sys_process_madvise(int which, pid_t pid, unsigned long start,
 			size_t len, int behavior, unsigned long flags);
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
diff --git a/mm/madvise.c b/mm/madvise.c
index b1237466657e..32833d0ba574 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1190,11 +1190,10 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 	return do_madvise(current, start, len_in, behavior);
 }
 
-SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
+SYSCALL_DEFINE6(process_madvise, int, which, pid_t, upid, unsigned long, start,
 		size_t, len_in, int, behavior, unsigned long, flags)
 {
 	int ret;
-	struct fd f;
 	struct pid *pid;
 	struct task_struct *task;
 	struct mm_struct *mm;
@@ -1205,20 +1204,31 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
 	if (!process_madvise_behavior_valid(behavior))
 		return -EINVAL;
 
-	f = fdget(pidfd);
-	if (!f.file)
-		return -EBADF;
+	switch (which) {
+	case P_PID:
+		if (upid <= 0)
+			return -EINVAL;
+
+		pid = find_get_pid(upid);
+		if (!pid)
+			return -ESRCH;
+		break;
+	case P_PIDFD:
+		if (upid < 0)
+			return -EINVAL;
 
-	pid = pidfd_pid(f.file);
-	if (IS_ERR(pid)) {
-		ret = PTR_ERR(pid);
-		goto fdput;
+		pid = pidfd_get_pid(upid);
+		if (IS_ERR(pid))
+			return PTR_ERR(pid);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task) {
 		ret = -ESRCH;
-		goto fdput;
+		goto put_pid;
 	}
 
 	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
@@ -1231,7 +1241,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, unsigned long, start,
 	mmput(mm);
 release_task:
 	put_task_struct(task);
-fdput:
-	fdput(f);
+put_pid:
+	put_pid(pid);
 	return ret;
 }
-- 
2.25.0.225.g125e21ebc7-goog
