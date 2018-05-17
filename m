From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] proc: Don't allow empty /proc/PID/cmdline for user tasks
Date: Wed, 16 May 2018 18:21:49 -0700
Message-ID: <20180517012149.GA1718769@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, kernel-team <kernel-team@fb.com>, Lennart Poettering <lennart@poettering.net>
List-Id: linux-api@vger.kernel.org

Kernel threads have empty /proc/PID/cmdline and some userland tools
including ps(1) and older versions of systemd use this to detect
kernel threads.  However, any userland program can emulate the
behavior by making its argvs unavailable and trick the affected tools
into thinking that the task is a kernel thread.  Linus's reproducer
follows.

  #include <sys/prctl.h>
  #include <sys/mman.h>

  int main(void)
  {
	  char empty[16384];
	  unsigned long ptr;

	  asm volatile("" :"=r" (ptr) : "0" (empty):"memory");
	  ptr = (ptr+4095) & ~4095;
	  munmap((void *)ptr, 32768);

	  sleep(1000);
	  return 0;
  }

Compiling the above program into nullcmdline and running it on an
unpatche kernel shows the following behavior.

  $ ./nullcmdline &
  [1] 2382031
  [devbig577 ~/tmp]$ hexdump -C /proc/2382031/comm
  00000000  6e 75 6c 6c 63 6d 64 6c  69 6e 65 0a              |nullcmdline.|
  0000000c
  $ hexdump -C /proc/2382031/cmdline
  $ ps 2382031
      PID TTY      STAT   TIME COMMAND
  2382031 pts/2    S      0:00 [nullcmdline]

The empty cmdline makes ps(1) think that nullcmdline is a kernel
thread and put brackets around its name (comm), which is mostly a
nuisance but it's possible that this confusion can lead to more
harmful confusions.

This patch fixes the issue by making proc_pid_cmdline_read() never
return empty string for user tasks.  If the result is empty for
whatever reason, comm string is returned.  Even when the comm string
is empty, it still returns the null termnation character.  On a
patched kernel, running the same command as above gives us.

  $ ./nullcmdline &
  [1] 2317
  [test ~]# hexdump -C /proc/2317/comm
  00000000  6e 75 6c 6c 63 6d 64 6c  69 6e 65 0a              |nullcmdline.|
  0000000c
  $ hexdump -C /proc/2317/cmdline
  00000000  6e 75 6c 6c 63 6d 64 6c  69 6e 65 00              |nullcmdline.|
  0000000c
  $ ps 2317
    PID TTY      STAT   TIME COMMAND
   2317 pts/0    S      0:00 nullcmdline

Note that cmdline is a dup of comm and ps(1) is no longer confused.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello,

Linus, this patch is somewhat different from the rest of workqueue
changes and it could make sense to apply separately, so please feel
free to apply directly.  If you want it to be routed together with the
other workqueue changes, please let me know.

Thanks.

 fs/proc/base.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -224,9 +224,10 @@ static ssize_t proc_pid_cmdline_read(str
 	if (!tsk)
 		return -ESRCH;
 	mm = get_task_mm(tsk);
-	put_task_struct(tsk);
-	if (!mm)
-		return 0;
+	if (!mm) {
+		rv = 0;
+		goto out_put_task;
+	}
 	/* Check if process spawned far enough to have cmdline. */
 	if (!mm->env_end) {
 		rv = 0;
@@ -367,8 +368,23 @@ out_free_page:
 	free_page((unsigned long)page);
 out_mmput:
 	mmput(mm);
+out_put_task:
+	/*
+	 * Some userland tools use empty cmdline to distinguish kthreads.
+	 * Avoid empty cmdline for user tasks by returning tsk->comm with
+	 * \0 termination when empty.
+	 */
+	if (*pos == 0 && rv == 0 && !(tsk->flags & PF_KTHREAD)) {
+		char tcomm[TASK_COMM_LEN];
+
+		get_task_comm(tcomm, tsk);
+		rv = min(strlen(tcomm) + 1, count);
+		if (copy_to_user(buf, tsk->comm, rv))
+			rv = -EFAULT;
+	}
 	if (rv > 0)
 		*pos += rv;
+	put_task_struct(tsk);
 	return rv;
 }
 
