From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/3] ipc/sem: introduce semctl(SEM_STAT_ANY)
Date: Thu, 15 Feb 2018 08:24:57 -0800
Message-ID: <20180215162458.10059-3-dave@stgolabs.net>
References: <20180215162458.10059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180215162458.10059-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, manfred@colorfullife.com, ebiederm@xmission.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
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

This patch introduces a new SEM_STAT_ANY command such that
the sem ipc object permissions are ignored, and only audited
instead. In addition, I've left the lsm security hook checks
in place, as if some policy can block the call, then the user
has no other choice than just parsing the procfs file.

Reported-by: Robert Kettler <robert.kettler@outlook.com>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/uapi/linux/sem.h   |  1 +
 ipc/sem.c                  | 17 ++++++++++++-----
 security/selinux/hooks.c   |  1 +
 security/smack/smack_lsm.c |  1 +
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
index 9c3e745b0656..39a1876f039e 100644
--- a/include/uapi/linux/sem.h
+++ b/include/uapi/linux/sem.h
@@ -19,6 +19,7 @@
 /* ipcs ctl cmds */
 #define SEM_STAT 18
 #define SEM_INFO 19
+#define SEM_STAT_ANY 20
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
diff --git a/ipc/sem.c b/ipc/sem.c
index a4af04979fd2..79acad0e0aa1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1190,14 +1190,14 @@ static int semctl_stat(struct ipc_namespace *ns, int semid,
 	memset(semid64, 0, sizeof(*semid64));
 
 	rcu_read_lock();
-	if (cmd == SEM_STAT) {
+	if (cmd == SEM_STAT || cmd == SEM_STAT_ANY) {
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
+	/* see comment for SHM_STAT_ANY */
+	if (cmd == SEM_STAT_ANY)
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
+	case SEM_STAT_ANY:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
@@ -1697,6 +1703,7 @@ COMPAT_SYSCALL_DEFINE4(semctl, int, semid, int, semnum, int, cmd, int, arg)
 		return semctl_info(ns, semid, cmd, p);
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		err = semctl_stat(ns, semid, cmd, &semid64);
 		if (err < 0)
 			return err;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 373dceede50d..38f71d12206a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5847,6 +5847,7 @@ static int selinux_sem_semctl(struct sem_array *sma, int cmd)
 		break;
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		perms = SEM__GETATTR | SEM__ASSOCIATE;
 		break;
 	default:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 51d22b03b0ae..d478c0940b00 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3167,6 +3167,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
 	case GETALL:
 	case IPC_STAT:
 	case SEM_STAT:
+	case SEM_STAT_ANY:
 		may = MAY_READ;
 		break;
 	case SETVAL:
-- 
2.13.6
