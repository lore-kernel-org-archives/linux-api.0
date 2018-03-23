From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 10/11] ipc/msg: Fix msgctl(..., IPC_STAT, ...) between pid namespaces
Date: Fri, 23 Mar 2018 14:16:13 -0500
Message-ID: <20180323191614.32489-10-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vadmobdw.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Today msg_lspid and msg_lrpid are remembered in the pid namespace of
the creator and the processes that last send or received a sysvipc
message.  If you have processes in multiple pid namespaces that is
just wrong.  The process ids reported will not make the least bit of
sense.

This fix is slightly more susceptible to a performance problem than
the related fix for System V shared memory.  By definition the pids
are updated by msgsnd and msgrcv, the fast path of System V message
queues.  The only concern over the previous implementation is the
incrementing and decrementing of the pid reference count.  As that is
the only difference and multiple updates by of the task_tgid by
threads in the same process have been shown in af_unix sockets to
create a cache line ping-pong between cpus of the same processor.

In this case I don't expect cache lines holding pid reference counts
to ping pong between cpus.  As senders and receivers update different
pids there is a natural separation there.  Further if multiple threads
of the same process either send or receive messages the pid will be
updated to the same value and ipc_update_pid will avoid the reference
count update.

Which means in the common case I expect msg_lspid and msg_lrpid to
remain constant, and reference counts not to be updated when messages
are sent.

In rare cases it may be possible to trigger the issue which was
observed for af_unix sockets, but it will require multiple processes
with multiple threads to be either sending or receiving messages.  It
just does not feel likely that anyone would do that in practice.

This change updates msgctl(..., IPC_STAT, ...) to return msg_lspid and
msg_lrpid in the pid namespace of the process calling stat.

This change also updates cat /proc/sysvipc/msg to return print msg_lspid
and msg_lrpid in the pid namespace of the process that opened the proc
file.

Fixes: b488893a390e ("pid namespaces: changes to show virtual ids to user")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 ipc/msg.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index af5a963306c4..825ad585a6ff 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -52,8 +52,8 @@ struct msg_queue {
 	unsigned long q_cbytes;		/* current number of bytes on queue */
 	unsigned long q_qnum;		/* number of messages in queue */
 	unsigned long q_qbytes;		/* max number of bytes on queue */
-	pid_t q_lspid;			/* pid of last msgsnd */
-	pid_t q_lrpid;			/* last receive pid */
+	struct pid *q_lspid;		/* pid of last msgsnd */
+	struct pid *q_lrpid;		/* last receive pid */
 
 	struct list_head q_messages;
 	struct list_head q_receivers;
@@ -154,7 +154,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	msq->q_ctime = ktime_get_real_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
 	msq->q_qbytes = ns->msg_ctlmnb;
-	msq->q_lspid = msq->q_lrpid = 0;
+	msq->q_lspid = msq->q_lrpid = NULL;
 	INIT_LIST_HEAD(&msq->q_messages);
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
@@ -267,6 +267,8 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		free_msg(msg);
 	}
 	atomic_sub(msq->q_cbytes, &ns->msg_bytes);
+	ipc_update_pid(&msq->q_lspid, NULL);
+	ipc_update_pid(&msq->q_lrpid, NULL);
 	ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
 }
 
@@ -536,8 +538,8 @@ static int msgctl_stat(struct ipc_namespace *ns, int msqid,
 	p->msg_cbytes = msq->q_cbytes;
 	p->msg_qnum   = msq->q_qnum;
 	p->msg_qbytes = msq->q_qbytes;
-	p->msg_lspid  = msq->q_lspid;
-	p->msg_lrpid  = msq->q_lrpid;
+	p->msg_lspid  = pid_vnr(msq->q_lspid);
+	p->msg_lrpid  = pid_vnr(msq->q_lrpid);
 
 	ipc_unlock_object(&msq->q_perm);
 	rcu_read_unlock();
@@ -741,7 +743,7 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg,
 				wake_q_add(wake_q, msr->r_tsk);
 				WRITE_ONCE(msr->r_msg, ERR_PTR(-E2BIG));
 			} else {
-				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
+				ipc_update_pid(&msq->q_lrpid, task_pid(msr->r_tsk));
 				msq->q_rtime = get_seconds();
 
 				wake_q_add(wake_q, msr->r_tsk);
@@ -842,7 +844,7 @@ static long do_msgsnd(int msqid, long mtype, void __user *mtext,
 
 	}
 
-	msq->q_lspid = task_tgid_vnr(current);
+	ipc_update_pid(&msq->q_lspid, task_tgid(current));
 	msq->q_stime = get_seconds();
 
 	if (!pipelined_send(msq, msg, &wake_q)) {
@@ -1060,7 +1062,7 @@ static long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, in
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
-			msq->q_lrpid = task_tgid_vnr(current);
+			ipc_update_pid(&msq->q_lrpid, task_tgid(current));
 			msq->q_cbytes -= msg->m_ts;
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
@@ -1202,6 +1204,7 @@ void msg_exit_ns(struct ipc_namespace *ns)
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 {
+	struct pid_namespace *pid_ns = ipc_seq_pid_ns(s);
 	struct user_namespace *user_ns = seq_user_ns(s);
 	struct kern_ipc_perm *ipcp = it;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
@@ -1213,8 +1216,8 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 		   msq->q_perm.mode,
 		   msq->q_cbytes,
 		   msq->q_qnum,
-		   msq->q_lspid,
-		   msq->q_lrpid,
+		   pid_nr_ns(msq->q_lspid, pid_ns),
+		   pid_nr_ns(msq->q_lrpid, pid_ns),
 		   from_kuid_munged(user_ns, msq->q_perm.uid),
 		   from_kgid_munged(user_ns, msq->q_perm.gid),
 		   from_kuid_munged(user_ns, msq->q_perm.cuid),
-- 
2.14.1
