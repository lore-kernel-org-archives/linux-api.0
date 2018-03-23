From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 11/11] ipc/sem: Fix semctl(..., GETPID,
	...) between pid namespaces
Date: Fri, 23 Mar 2018 14:16:14 -0500
Message-ID: <20180323191614.32489-11-ebiederm@xmission.com>
References: <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vadmobdw.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Today the last process to update a semaphore is remembered and
reported in the pid namespace of that process.  If there are processes
in any other pid namespace querying that process id with GETPID the
result will be unusable nonsense as it does not make any
sense in your own pid namespace.

Due to ipc_update_pid I don't think you will be able to get System V
ipc semaphores into a troublesome cache line ping-pong.  Using struct
pids from separate process are not a problem because they do not share
a cache line.  Using struct pid from different threads of the same
process are unlikely to be a problem as the reference count update
can be avoided.

Further linux futexes are a much better tool for the job of mutual
exclusion between processes than System V semaphores.  So I expect
programs that  are performance limited by their interprocess mutual
exclusion primitive will be using futexes.

So while it is possible that enhancing the storage of the last
rocess of a System V semaphore from an integer to a struct pid
will cause a performance regression because of the effect
of frequently updating the pid reference count.  I don't expect
that to happen in practice.

This change updates semctl(..., GETPID, ...) to return the
process id of the last process to update a semphore inthe
pid namespace of the calling process.

Fixes: b488893a390e ("pid namespaces: changes to show virtual ids to user")
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 ipc/sem.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index d661c491b0a5..47b263960524 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -98,7 +98,7 @@ struct sem {
 	 *  - semctl, via SETVAL and SETALL.
 	 *  - at task exit when performing undo adjustments (see exit_sem).
 	 */
-	int	sempid;
+	struct pid *sempid;
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head pending_alter; /* pending single-sop operations */
 					/* that alter the semaphore */
@@ -128,7 +128,7 @@ struct sem_queue {
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
-	int			pid;	 /* process id of requesting process */
+	struct pid		*pid;	 /* process id of requesting process */
 	int			status;	 /* completion status of operation */
 	struct sembuf		*sops;	 /* array of pending operations */
 	struct sembuf		*blocking; /* the operation that blocked */
@@ -628,7 +628,8 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
  */
 static int perform_atomic_semop_slow(struct sem_array *sma, struct sem_queue *q)
 {
-	int result, sem_op, nsops, pid;
+	int result, sem_op, nsops;
+	struct pid *pid;
 	struct sembuf *sop;
 	struct sem *curr;
 	struct sembuf *sops;
@@ -666,7 +667,7 @@ static int perform_atomic_semop_slow(struct sem_array *sma, struct sem_queue *q)
 	sop--;
 	pid = q->pid;
 	while (sop >= sops) {
-		sma->sems[sop->sem_num].sempid = pid;
+		ipc_update_pid(&sma->sems[sop->sem_num].sempid, pid);
 		sop--;
 	}
 
@@ -753,7 +754,7 @@ static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
 			un->semadj[sop->sem_num] = undo;
 		}
 		curr->semval += sem_op;
-		curr->sempid = q->pid;
+		ipc_update_pid(&curr->sempid, q->pid);
 	}
 
 	return 0;
@@ -1160,6 +1161,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 			unlink_queue(sma, q);
 			wake_up_sem_queue_prepare(q, -EIDRM, &wake_q);
 		}
+		ipc_update_pid(&sem->sempid, NULL);
 	}
 
 	/* Remove the semaphore set from the IDR */
@@ -1352,7 +1354,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 		un->semadj[semnum] = 0;
 
 	curr->semval = val;
-	curr->sempid = task_tgid_vnr(current);
+	ipc_update_pid(&curr->sempid, task_tgid(current));
 	sma->sem_ctime = ktime_get_real_seconds();
 	/* maybe some queued-up processes were waiting for this */
 	do_smart_update(sma, NULL, 0, 0, &wake_q);
@@ -1473,7 +1475,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 
 		for (i = 0; i < nsems; i++) {
 			sma->sems[i].semval = sem_io[i];
-			sma->sems[i].sempid = task_tgid_vnr(current);
+			ipc_update_pid(&sma->sems[i].sempid, task_tgid(current));
 		}
 
 		ipc_assert_locked_object(&sma->sem_perm);
@@ -1505,7 +1507,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		err = curr->semval;
 		goto out_unlock;
 	case GETPID:
-		err = curr->sempid;
+		err = pid_vnr(curr->sempid);
 		goto out_unlock;
 	case GETNCNT:
 		err = count_semcnt(sma, semnum, 0);
@@ -2024,7 +2026,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 	queue.sops = sops;
 	queue.nsops = nsops;
 	queue.undo = un;
-	queue.pid = task_tgid_vnr(current);
+	queue.pid = task_tgid(current);
 	queue.alter = alter;
 	queue.dupsop = dupsop;
 
@@ -2318,7 +2320,7 @@ void exit_sem(struct task_struct *tsk)
 					semaphore->semval = 0;
 				if (semaphore->semval > SEMVMX)
 					semaphore->semval = SEMVMX;
-				semaphore->sempid = task_tgid_vnr(current);
+				ipc_update_pid(&semaphore->sempid, task_tgid(current));
 			}
 		}
 		/* maybe some queued-up processes were waiting for this */
-- 
2.14.1
