From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/3] ipc/msg: introduce shmctl(MSG_STAT_ALL)
Date: Tue, 13 Feb 2018 09:41:36 -0800
Message-ID: <20180213174136.6346-4-dave@stgolabs.net>
References: <20180213174136.6346-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180213174136.6346-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mhocko@kernel.org, mtk.manpages@gmail.com, keescook@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

There is a permission discrepancy when consulting msq ipc
object metadata between /proc/sysvipc/msg (0444) and the
MSG_STAT shmctl command. The later does permission checks
for the object vs S_IRUGO. As such there can be cases where
EACCESS is returned via syscall but the info is displayed
anyways in the procfs files.

While this might have security implications via info leaking
(albeit no writing to the msq metadata), this behavior goes
way back and showing all the objects regardless of the
permissions was most likely an overlook - so we are stuck
with it. Furthermore, modifying either the syscall or the
procfs file can cause userspace programs to break (ie ipcs).
Some applications require getting the procfs info (without
root privileges) and can be rather slow in comparison with
a syscall -- up to 500x in some reported cases for shm.

This patch introduces a new MSG_STAT_ALL command such that
the msq ipc object permissions are ignored, and only audited
instead. In addition, I've left the lsm security hook checks
in place, as if some policy can block the call, then the user
has no other choice than just parsing the procfs file.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/uapi/linux/msg.h |  1 +
 ipc/msg.c                | 17 ++++++++++++-----
 security/selinux/hooks.c |  1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/msg.h b/include/uapi/linux/msg.h
index 5d5ab81dc9be..fe9bdfb25a2f 100644
--- a/include/uapi/linux/msg.h
+++ b/include/uapi/linux/msg.h
@@ -7,6 +7,7 @@
 /* ipcs ctl commands */
 #define MSG_STAT 11
 #define MSG_INFO 12
+#define MSG_STAT_ALL 13
 
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
diff --git a/ipc/msg.c b/ipc/msg.c
index 0dcc6699dc53..533c9ac2fb13 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -483,14 +483,14 @@ static int msgctl_stat(struct ipc_namespace *ns, int msqid,
 	memset(p, 0, sizeof(*p));
 
 	rcu_read_lock();
-	if (cmd == MSG_STAT) {
+	if (cmd == MSG_STAT || cmd == MSG_STAT_ALL) {
 		msq = msq_obtain_object(ns, msqid);
 		if (IS_ERR(msq)) {
 			err = PTR_ERR(msq);
 			goto out_unlock;
 		}
 		id = msq->q_perm.id;
-	} else {
+	} else { /* IPC_STAT */
 		msq = msq_obtain_object_check(ns, msqid);
 		if (IS_ERR(msq)) {
 			err = PTR_ERR(msq);
@@ -498,9 +498,14 @@ static int msgctl_stat(struct ipc_namespace *ns, int msqid,
 		}
 	}
 
-	err = -EACCES;
-	if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-		goto out_unlock;
+	/* see comment for SHM_STAT_ALL */
+	if (cmd == MSG_STAT_ALL)
+		audit_ipc_obj(&msq->q_perm);
+	else {
+		err = -EACCES;
+		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
+			goto out_unlock;
+	}
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
@@ -558,6 +563,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 		return err;
 	}
 	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+	case MSG_STAT_ALL:
 	case IPC_STAT:
 		err = msgctl_stat(ns, msqid, cmd, &msqid64);
 		if (err < 0)
@@ -671,6 +677,7 @@ COMPAT_SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, void __user *, uptr)
 	}
 	case IPC_STAT:
 	case MSG_STAT:
+	case MSG_STAT_ALL:
 		err = msgctl_stat(ns, msqid, cmd, &msqid64);
 		if (err < 0)
 			return err;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index aa965742bba9..457e80f6b4e7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5591,6 +5591,7 @@ static int selinux_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 				    SECCLASS_SYSTEM, SYSTEM__IPC_INFO, NULL);
 	case IPC_STAT:
 	case MSG_STAT:
+	case MSG_STAT_ALL:
 		perms = MSGQ__GETATTR | MSGQ__ASSOCIATE;
 		break;
 	case IPC_SET:
-- 
2.13.6
