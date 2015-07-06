From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 15/24] proc: give task_struct instead of pid into first_tid
Date: Mon,  6 Jul 2015 11:47:16 +0300
Message-ID: <1436172445-6979-16-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

It will be more convenient when this function will be used in
task_diag.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/base.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 88cf6ae..af797d9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3225,19 +3225,17 @@ out_no_task:
  * In the case of a seek we start with the leader and walk nr
  * threads past it.
  */
-static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
+static struct task_struct *
+first_tid(struct task_struct *task, int tid, loff_t f_pos,
 					struct pid_namespace *ns)
 {
-	struct task_struct *pos, *task;
+	struct task_struct *pos;
 	unsigned long nr = f_pos;
 
 	if (nr != f_pos)	/* 32bit overflow? */
 		return NULL;
 
 	rcu_read_lock();
-	task = pid_task(pid, PIDTYPE_PID);
-	if (!task)
-		goto fail;
 
 	/* Attempt to start with the tid of a thread */
 	if (tid && nr) {
@@ -3294,7 +3292,7 @@ static struct task_struct *next_tid(struct task_struct *start)
 static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
-	struct task_struct *task;
+	struct task_struct *start, *task;
 	struct pid_namespace *ns;
 	int tid;
 
@@ -3304,13 +3302,17 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
+	start = get_proc_task(inode);
+	if (!start)
+		return 0;
+
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
 	ns = inode->i_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
-	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
+	for (task = first_tid(start, tid, ctx->pos - 2, ns);
 	     task;
 	     task = next_tid(task), ctx->pos++) {
 		char name[PROC_NUMBUF];
@@ -3327,6 +3329,8 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 		}
 	}
 
+	put_task_struct(start);
+
 	return 0;
 }
 
-- 
2.1.0
