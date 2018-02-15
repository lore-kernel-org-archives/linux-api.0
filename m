From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 1/3] ipc/shm: introduce shmctl(SHM_STAT_ANY)
Date: Thu, 15 Feb 2018 08:24:56 -0800
Message-ID: <20180215162458.10059-2-dave@stgolabs.net>
References: <20180215162458.10059-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180215162458.10059-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mhocko@kernel.org, mtk.manpages@gmail.com, robert.kettler@outlook.com, manfred@colorfullife.com, ebiederm@xmission.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

There is a permission discrepancy when consulting shm ipc
object metadata between /proc/sysvipc/shm (0444) and the
SHM_STAT shmctl command. The later does permission checks
for the object vs S_IRUGO. As such there can be cases where
EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking
(albeit no writing to the shm metadata), this behavior goes
way back and showing all the objects regardless of the
permissions was most likely an overlook - so we are stuck
with it. Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).
Some applications require getting the procfs info (without
root privileges) and can be rather slow in comparison with
a syscall -- up to 500x in some reported cases.

This patch introduces a new SHM_STAT_ANY command such that
the shm ipc object permissions are ignored, and only audited
instead. In addition, I've left the lsm security hook checks
in place, as if some policy can block the call, then the user
has no other choice than just parsing the procfs file.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/uapi/linux/shm.h   |  5 +++--
 ipc/shm.c                  | 23 ++++++++++++++++++-----
 security/selinux/hooks.c   |  1 +
 security/smack/smack_lsm.c |  1 +
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 4de12a39b075..dde1344f047c 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -83,8 +83,9 @@ struct shmid_ds {
 #define SHM_UNLOCK 	12
 
 /* ipcs ctl commands */
-#define SHM_STAT 	13
-#define SHM_INFO 	14
+#define SHM_STAT	13
+#define SHM_INFO	14
+#define SHM_STAT_ANY    15
 
 /* Obsolete, used only for backwards compatibility */
 struct	shminfo {
diff --git a/ipc/shm.c b/ipc/shm.c
index 4643865e9171..60827d9c3716 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -915,14 +915,14 @@ static int shmctl_stat(struct ipc_namespace *ns, int shmid,
 	memset(tbuf, 0, sizeof(*tbuf));
 
 	rcu_read_lock();
-	if (cmd == SHM_STAT) {
+	if (cmd == SHM_STAT || cmd == SHM_STAT_ANY) {
 		shp = shm_obtain_object(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
 			goto out_unlock;
 		}
 		id = shp->shm_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		shp = shm_obtain_object_check(ns, shmid);
 		if (IS_ERR(shp)) {
 			err = PTR_ERR(shp);
@@ -930,9 +930,20 @@ static int shmctl_stat(struct ipc_namespace *ns, int shmid,
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
-		goto out_unlock;
+	/*
+	 * Semantically SHM_STAT_ANY ought to be identical to
+	 * that functionality provided by the /proc/sysvipc/
+	 * interface. As such, only audit these calls and
+	 * do not do traditional S_IRUGO permission checks on
+	 * the ipc object.
+	 */
+	if (cmd == SHM_STAT_ANY)
+		audit_ipc_obj(&shp->shm_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_shm_shmctl(shp, cmd);
 	if (err)
@@ -1072,6 +1083,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 		return err;
 	}
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 	case IPC_STAT: {
 		err = shmctl_stat(ns, shmid, cmd, &sem64);
 		if (err < 0)
@@ -1245,6 +1257,7 @@ COMPAT_SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, void __user *, uptr)
 		return err;
 	}
 	case IPC_STAT:
+	case SHM_STAT_ANY:
 	case SHM_STAT:
 		err = shmctl_stat(ns, shmid, cmd, &sem64);
 		if (err < 0)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 35ef1e9045e8..373dceede50d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5734,6 +5734,7 @@ static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
 				    SECCLASS_SYSTEM, SYSTEM__IPC_INFO, NULL);
 	case IPC_STAT:
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 		perms = SHM__GETATTR | SHM__ASSOCIATE;
 		break;
 	case IPC_SET:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 03fdecba93bb..51d22b03b0ae 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3034,6 +3034,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 	switch (cmd) {
 	case IPC_STAT:
 	case SHM_STAT:
+	case SHM_STAT_ANY:
 		may = MAY_READ;
 		break;
 	case IPC_SET:
-- 
2.13.6
