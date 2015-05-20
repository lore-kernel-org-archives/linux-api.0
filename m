From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 9/9] y2038: ipc: report long times to user space
Date: Wed, 20 May 2015 17:07:25 +0200
Message-ID: <1432134445-804487-10-git-send-email-arnd@arndb.de>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de>
Return-path: <libc-alpha-return-59085-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1432134445-804487-1-git-send-email-arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

The shmid64_ds/semid64_ds/msqid64_ds data structures have been extended
to contain extra fields for storing the upper bits of the time stamps,
this patch does the other half of the job and converts the internal
data structures to use time64_t, and fill the new fields on 32-bit
architectures as well as 32-bit tasks running on a 64-bit kernel
in compat mode. There should be no change for native 64-bit tasks.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/msg.h |  7 ++++---
 include/linux/sem.h |  3 ++-
 include/linux/shm.h |  7 ++++---
 ipc/compat.c        |  8 ++++++++
 ipc/msg.c           | 23 ++++++++++++++---------
 ipc/sem.c           | 32 +++++++++++++++++++-------------
 ipc/shm.c           | 21 +++++++++++++--------
 7 files changed, 64 insertions(+), 37 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index f3f302f9c197..10a0d8c99567 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -2,6 +2,7 @@
 #define _LINUX_MSG_H
 
 #include <linux/list.h>
+#include <linux/time.h>
 #include <uapi/linux/msg.h>
 
 /* one msg_msg structure for each message */
@@ -17,9 +18,9 @@ struct msg_msg {
 /* one msq_queue structure for each present queue on the system */
 struct msg_queue {
 	struct kern_ipc_perm q_perm;
-	time_t q_stime;			/* last msgsnd time */
-	time_t q_rtime;			/* last msgrcv time */
-	time_t q_ctime;			/* last change time */
+	time64_t q_stime;		/* last msgsnd time */
+	time64_t q_rtime;		/* last msgrcv time */
+	time64_t q_ctime;		/* last change time */
 	unsigned long q_cbytes;		/* current number of bytes on queue */
 	unsigned long q_qnum;		/* number of messages in queue */
 	unsigned long q_qbytes;		/* max number of bytes on queue */
diff --git a/include/linux/sem.h b/include/linux/sem.h
index 976ce3a19f1b..b408983f029e 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -4,6 +4,7 @@
 #include <linux/atomic.h>
 #include <linux/rcupdate.h>
 #include <linux/cache.h>
+#include <linux/time.h>
 #include <uapi/linux/sem.h>
 
 struct task_struct;
@@ -12,7 +13,7 @@ struct task_struct;
 struct sem_array {
 	struct kern_ipc_perm	____cacheline_aligned_in_smp
 				sem_perm;	/* permissions .. see ipc.h */
-	time_t			sem_ctime;	/* last change time */
+	time64_t		sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	pending_alter;	/* pending operations */
 						/* that alter the array */
diff --git a/include/linux/shm.h b/include/linux/shm.h
index 6fb801686ad6..0a28ae1be608 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -2,6 +2,7 @@
 #define _LINUX_SHM_H_
 
 #include <linux/list.h>
+#include <linux/time.h>
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
 #include <asm/shmparam.h>
@@ -12,9 +13,9 @@ struct shmid_kernel /* private to the kernel */
 	struct file		*shm_file;
 	unsigned long		shm_nattch;
 	unsigned long		shm_segsz;
-	time_t			shm_atim;
-	time_t			shm_dtim;
-	time_t			shm_ctim;
+	time64_t		shm_atim;
+	time64_t		shm_dtim;
+	time64_t		shm_ctim;
 	pid_t			shm_cprid;
 	pid_t			shm_lprid;
 	struct user_struct	*mlock_user;
diff --git a/ipc/compat.c b/ipc/compat.c
index 2bbdb093d1be..2505f628e221 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -215,7 +215,9 @@ static inline int put_compat_semid64_ds(struct semid64_ds *sem64,
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
 	err  = __put_compat_ipc64_perm(&sem64->sem_perm, &up64->sem_perm);
+	err |= __put_user(sem64->sem_otime >> 32, &up64->sem_otime_high);
 	err |= __put_user(sem64->sem_otime, &up64->sem_otime);
+	err |= __put_user(sem64->sem_ctime >> 32, &up64->sem_ctime_high);
 	err |= __put_user(sem64->sem_ctime, &up64->sem_ctime);
 	err |= __put_user(sem64->sem_nsems, &up64->sem_nsems);
 	return err;
@@ -465,8 +467,11 @@ static inline int put_compat_msqid64_ds(struct msqid64_ds *m64,
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
 	err  = __put_compat_ipc64_perm(&m64->msg_perm, &up64->msg_perm);
+	err |= __put_user(m64->msg_stime >> 32, &up64->msg_stime_high);
 	err |= __put_user(m64->msg_stime, &up64->msg_stime);
+	err |= __put_user(m64->msg_rtime >> 32, &up64->msg_rtime_high);
 	err |= __put_user(m64->msg_rtime, &up64->msg_rtime);
+	err |= __put_user(m64->msg_ctime >> 32, &up64->msg_ctime_high);
 	err |= __put_user(m64->msg_ctime, &up64->msg_ctime);
 	err |= __put_user(m64->msg_cbytes, &up64->msg_cbytes);
 	err |= __put_user(m64->msg_qnum, &up64->msg_qnum);
@@ -585,8 +590,11 @@ static inline int put_compat_shmid64_ds(struct shmid64_ds *sem64,
 	if (!access_ok(VERIFY_WRITE, up64, sizeof(*up64)))
 		return -EFAULT;
 	err  = __put_compat_ipc64_perm(&sem64->shm_perm, &up64->shm_perm);
+	err |= __put_user(sem64->shm_atime >> 32, &up64->shm_atime_high);
 	err |= __put_user(sem64->shm_atime, &up64->shm_atime);
+	err |= __put_user(sem64->shm_dtime >> 32, &up64->shm_dtime_high);
 	err |= __put_user(sem64->shm_dtime, &up64->shm_dtime);
+	err |= __put_user(sem64->shm_ctime >> 32, &up64->shm_ctime_high);
 	err |= __put_user(sem64->shm_ctime, &up64->shm_ctime);
 	err |= __put_user(sem64->shm_segsz, &up64->shm_segsz);
 	err |= __put_user(sem64->shm_nattch, &up64->shm_nattch);
diff --git a/ipc/msg.c b/ipc/msg.c
index 2b6fdbb9e0e9..1b7a7248dc97 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -145,7 +145,7 @@ static int newque(struct ipc_namespace *ns, struct ipc_params *params)
 	}
 
 	msq->q_stime = msq->q_rtime = 0;
-	msq->q_ctime = get_seconds();
+	msq->q_ctime = ktime_get_real_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
 	msq->q_qbytes = ns->msg_ctlmnb;
 	msq->q_lspid = msq->q_lrpid = 0;
@@ -385,7 +385,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 
 		msq->q_qbytes = msqid64.msg_qbytes;
 
-		msq->q_ctime = get_seconds();
+		msq->q_ctime = ktime_get_real_seconds();
 		/* sleeping receivers might be excluded by
 		 * stricter permissions.
 		 */
@@ -497,6 +497,11 @@ static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
 		tbuf.msg_ctime  = msq->q_ctime;
+#ifndef CONFIG_64BIT
+		tbuf.msg_stime_high = msq->q_stime >> 32;
+		tbuf.msg_rtime_high = msq->q_rtime >> 32;
+		tbuf.msg_ctime_high = msq->q_ctime >> 32;
+#endif
 		tbuf.msg_cbytes = msq->q_cbytes;
 		tbuf.msg_qnum   = msq->q_qnum;
 		tbuf.msg_qbytes = msq->q_qbytes;
@@ -585,7 +590,7 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 			} else {
 				msr->r_msg = NULL;
 				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
-				msq->q_rtime = get_seconds();
+				msq->q_rtime = ktime_get_real_seconds();
 				wake_up_process(msr->r_tsk);
 				/*
 				 * Ensure that the wakeup is visible before
@@ -694,7 +699,7 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 
 	}
 	msq->q_lspid = task_tgid_vnr(current);
-	msq->q_stime = get_seconds();
+	msq->q_stime = ktime_get_real_seconds();
 
 	if (!pipelined_send(msq, msg)) {
 		/* no one is waiting for this message, enqueue it */
@@ -886,7 +891,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
 
 			list_del(&msg->m_list);
 			msq->q_qnum--;
-			msq->q_rtime = get_seconds();
+			msq->q_rtime = ktime_get_real_seconds();
 			msq->q_lrpid = task_tgid_vnr(current);
 			msq->q_cbytes -= msg->m_ts;
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
@@ -1016,7 +1021,7 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 	struct msg_queue *msq = it;
 
 	seq_printf(s,
-		   "%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
+		   "%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10llu %10llu %10llu\n",
 		   msq->q_perm.key,
 		   msq->q_perm.id,
 		   msq->q_perm.mode,
@@ -1028,9 +1033,9 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 		   from_kgid_munged(user_ns, msq->q_perm.gid),
 		   from_kuid_munged(user_ns, msq->q_perm.cuid),
 		   from_kgid_munged(user_ns, msq->q_perm.cgid),
-		   msq->q_stime,
-		   msq->q_rtime,
-		   msq->q_ctime);
+		   (u64)msq->q_stime,
+		   (u64)msq->q_rtime,
+		   (u64)msq->q_ctime);
 
 	return 0;
 }
diff --git a/ipc/sem.c b/ipc/sem.c
index 84d354a34df3..3b8fb9eef16e 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -99,7 +99,7 @@ struct sem {
 					/* that alter the semaphore */
 	struct list_head pending_const; /* pending single-sop operations */
 					/* that do not alter the semaphore*/
-	time_t	sem_otime;	/* candidate for sem_otime */
+	time64_t	sem_otime;	/* candidate for sem_otime */
 } ____cacheline_aligned_in_smp;
 
 /* One queue for each sleeping process in the system. */
@@ -528,7 +528,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
-	sma->sem_ctime = get_seconds();
+	sma->sem_ctime = ktime_get_real_seconds();
 
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
@@ -940,10 +940,10 @@ again:
 static void set_semotime(struct sem_array *sma, struct sembuf *sops)
 {
 	if (sops == NULL) {
-		sma->sem_base[0].sem_otime = get_seconds();
+		sma->sem_base[0].sem_otime = ktime_get_real_seconds();
 	} else {
 		sma->sem_base[sops[0].sem_num].sem_otime =
-							get_seconds();
+							ktime_get_real_seconds();
 	}
 }
 
@@ -1151,14 +1151,14 @@ static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in,
 	}
 }
 
-static time_t get_semotime(struct sem_array *sma)
+static time64_t get_semotime(struct sem_array *sma)
 {
 	int i;
-	time_t res;
+	time64_t res;
 
 	res = sma->sem_base[0].sem_otime;
 	for (i = 1; i < sma->sem_nsems; i++) {
-		time_t to = sma->sem_base[i].sem_otime;
+		time64_t to = sma->sem_base[i].sem_otime;
 
 		if (to > res)
 			res = to;
@@ -1210,6 +1210,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 	case SEM_STAT:
 	{
 		struct semid64_ds tbuf;
+		time64_t semotime;
 		int id = 0;
 
 		memset(&tbuf, 0, sizeof(tbuf));
@@ -1239,9 +1240,14 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 			goto out_unlock;
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
-		tbuf.sem_otime = get_semotime(sma);
+		semotime = get_semotime(sma);
+		tbuf.sem_otime = semotime;
 		tbuf.sem_ctime = sma->sem_ctime;
 		tbuf.sem_nsems = sma->sem_nsems;
+#ifndef CONFIG_64BIT
+		tbuf.sem_ctime_high = sma->sem_ctime >> 32;
+		tbuf.sem_ctime_high = semotime >> 32;
+#endif
 		rcu_read_unlock();
 		if (copy_semid_to_user(p, &tbuf, version))
 			return -EFAULT;
@@ -1317,7 +1323,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 
 	curr->semval = val;
 	curr->sempid = task_tgid_vnr(current);
-	sma->sem_ctime = get_seconds();
+	sma->sem_ctime = ktime_get_real_seconds();
 	/* maybe some queued-up processes were waiting for this */
 	do_smart_update(sma, NULL, 0, 0, &tasks);
 	sem_unlock(sma, -1);
@@ -1443,7 +1449,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
 		}
-		sma->sem_ctime = get_seconds();
+		sma->sem_ctime = ktime_get_real_seconds();
 		/* maybe some queued-up processes were waiting for this */
 		do_smart_update(sma, NULL, 0, 0, &tasks);
 		err = 0;
@@ -1559,7 +1565,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 		err = ipc_update_perm(&semid64.sem_perm, ipcp);
 		if (err)
 			goto out_unlock0;
-		sma->sem_ctime = get_seconds();
+		sma->sem_ctime = ktime_get_real_seconds();
 		break;
 	default:
 		err = -EINVAL;
@@ -2179,7 +2185,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 {
 	struct user_namespace *user_ns = seq_user_ns(s);
 	struct sem_array *sma = it;
-	time_t sem_otime;
+	u64 sem_otime;
 
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
@@ -2192,7 +2198,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	sem_otime = get_semotime(sma);
 
 	seq_printf(s,
-		   "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
+		   "%10d %10d  %4o %10u %5u %5u %5u %5u %10llu %10llu\n",
 		   sma->sem_perm.key,
 		   sma->sem_perm.id,
 		   sma->sem_perm.mode,
diff --git a/ipc/shm.c b/ipc/shm.c
index 6d767071c367..d6272640c148 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -192,7 +192,7 @@ static void shm_open(struct vm_area_struct *vma)
 
 	shp = shm_lock(sfd->ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
-	shp->shm_atim = get_seconds();
+	shp->shm_atim = ktime_get_real_seconds();
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_nattch++;
 	shm_unlock(shp);
@@ -260,7 +260,7 @@ static void shm_close(struct vm_area_struct *vma)
 	shp = shm_lock(ns, sfd->id);
 	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
-	shp->shm_dtim = get_seconds();
+	shp->shm_dtim = ktime_get_real_seconds();
 	shp->shm_nattch--;
 	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
@@ -559,7 +559,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->shm_cprid = task_tgid_vnr(current);
 	shp->shm_lprid = 0;
 	shp->shm_atim = shp->shm_dtim = 0;
-	shp->shm_ctim = get_seconds();
+	shp->shm_ctim = ktime_get_real_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
@@ -813,7 +813,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 		err = ipc_update_perm(&shmid64.shm_perm, ipcp);
 		if (err)
 			goto out_unlock0;
-		shp->shm_ctim = get_seconds();
+		shp->shm_ctim = ktime_get_real_seconds();
 		break;
 	default:
 		err = -EINVAL;
@@ -922,6 +922,11 @@ static int shmctl_nolock(struct ipc_namespace *ns, int shmid,
 		tbuf.shm_atime	= shp->shm_atim;
 		tbuf.shm_dtime	= shp->shm_dtim;
 		tbuf.shm_ctime	= shp->shm_ctim;
+#ifndef CONFIG_64BIT
+		tbuf.shm_atime_high = shp->shm_atim >> 32;
+		tbuf.shm_dtime_high = shp->shm_dtim >> 32;
+		tbuf.shm_ctime_high = shp->shm_ctim >> 32;
+#endif
 		tbuf.shm_cpid	= shp->shm_cprid;
 		tbuf.shm_lpid	= shp->shm_lprid;
 		tbuf.shm_nattch	= shp->shm_nattch;
@@ -1344,7 +1349,7 @@ static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
 
 	seq_printf(s,
 		   "%10d %10d  %4o " SIZE_SPEC " %5u %5u  "
-		   "%5lu %5u %5u %5u %5u %10lu %10lu %10lu "
+		   "%5lu %5u %5u %5u %5u %10llu %10llu %10llu "
 		   SIZE_SPEC " " SIZE_SPEC "\n",
 		   shp->shm_perm.key,
 		   shp->shm_perm.id,
@@ -1357,9 +1362,9 @@ static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
 		   from_kgid_munged(user_ns, shp->shm_perm.gid),
 		   from_kuid_munged(user_ns, shp->shm_perm.cuid),
 		   from_kgid_munged(user_ns, shp->shm_perm.cgid),
-		   shp->shm_atim,
-		   shp->shm_dtim,
-		   shp->shm_ctim,
+		   (u64)shp->shm_atim,
+		   (u64)shp->shm_dtim,
+		   (u64)shp->shm_ctim,
 		   rss * PAGE_SIZE,
 		   swp * PAGE_SIZE);
 
-- 
2.1.0.rc2
