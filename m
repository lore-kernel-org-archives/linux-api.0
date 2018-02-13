From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH 2/3] ipc/sem: introduce shmctl(SEM_STAT_ALL)
Date: Tue, 13 Feb 2018 09:41:35 -0800
Message-ID: <20180213174136.6346-3-dave@stgolabs.net>
References: <20180213174136.6346-1-dave@stgolabs.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213174136.6346-1-dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There is a permission discrepancy when consulting shm ipc
object metadata between /proc/sysvipc/sem (0444) and the
SEM_STAT semctl command. The later does permission checks
for the object vs S_IRUGO. As such there can be cases where
EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking
(albeit no writing to the sma metadata), this behavior goes
way back and showing all the objects regardless of the
permissions was most likely an overlook - so we are stuck
with it. Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).
Some applications require getting the procfs info (without
root privileges) and can be rather slow in comparison with
a syscall -- up to 500x in some reported cases for shm.

This patch introduces a new SEM_STAT_ALL command such that
the sem ipc object permissions are ignored, and only audited
instead. In addition, I've left the lsm security hook checks
in place, as if some policy can block the call, then the user
has no other choice than just parsing the procfs file.

Signed-off-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
---
 include/uapi/linux/sem.h |  1 +
 ipc/sem.c                | 17 ++++++++++++-----
 security/selinux/hooks.c |  1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
index 9c3e745b0656..fde93f635660 100644
--- a/include/uapi/linux/sem.h
+++ b/include/uapi/linux/sem.h
@@ -19,6 +19,7 @@
 /* ipcs ctl cmds */
 #define SEM_STAT 18
 #define SEM_INFO 19
+#define SEM_STAT_ALL 20
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
diff --git a/ipc/sem.c b/ipc/sem.c
index a4af04979fd2..cb2737c7f1d6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1190,14 +1190,14 @@ static int semctl_stat(struct ipc_namespace *ns, int semid,
 	memset(semid64, 0, sizeof(*semid64));
 
 	rcu_read_lock();
-	if (cmd == SEM_STAT) {
+	if (cmd == SEM_STAT || cmd == SEM_STAT_ALL) {
 		sma = sem_obtain_object(ns, semid);
 		if (IS_ERR(sma)) {
 			err = PTR_ERR(sma);
 			goto out_unlock;
 		}
 		id = sma->sem_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		sma = sem_obtain_object_check(ns, semid);
 		if (IS_ERR(sma)) {
 			err = PTR_ERR(sma);
@@ -1205,9 +1205,14 @@ static int semctl_stat(struct ipc_namespace *ns, int semid,
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
-		goto out_unlock;
+	/* see comment for SHM_STAT_ALL */
+	if (cmd == SEM_STAT_ALL)
+		audit_ipc_obj(&sma->sem_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_sem_semctl(sma, cmd);
 	if (err)
@@ -1596,6 +1601,7 @@ SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, unsigned long, arg)
 		return semctl_info(ns, semid, cmd, p);
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ALL:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
@@ -1697,6 +1703,7 @@ COMPAT_SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, int, arg)
 		return semctl_info(ns, semid, cmd, p);
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ALL:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index dc2a9a0f6ddf..aa965742bba9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5847,6 +5847,7 @@ static int selinux_sem_semctl(struct sem_array *sma, int cmd)
 		break;
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ALL:
 		perms = SEM__GETATTR | SEM__ASSOCIATE;
 		break;
 	default:
-- 
2.13.6
