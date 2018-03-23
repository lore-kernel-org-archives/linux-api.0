From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 02/11] shm/security: Pass kern_ipc_perm not
	shmid_kernel into the shm security hooks
Date: Fri, 23 Mar 2018 14:16:05 -0500
Message-ID: <20180323191614.32489-2-ebiederm@xmission.com>
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

All of the implementations of security hooks that take shmid_kernel only
access shm_perm the struct kern_ipc_perm member.  This means the
dependencies of the shm security hooks can be simplified by passing
the kern_ipc_perm member of shmid_kernel..

Making this change will allow struct shmid_kernel to become private to ipc/shm.c.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/lsm_hooks.h  | 10 +++++-----
 include/linux/security.h   | 21 ++++++++++-----------
 ipc/shm.c                  | 17 +++++++----------
 security/security.c        | 10 +++++-----
 security/selinux/hooks.c   | 28 ++++++++++++++--------------
 security/smack/smack_lsm.c | 22 +++++++++++-----------
 6 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index e4a94863a88c..cac7a8082c43 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1585,11 +1585,11 @@ union security_list_options {
 				struct task_struct *target, long type,
 				int mode);
 
-	int (*shm_alloc_security)(struct shmid_kernel *shp);
-	void (*shm_free_security)(struct shmid_kernel *shp);
-	int (*shm_associate)(struct shmid_kernel *shp, int shmflg);
-	int (*shm_shmctl)(struct shmid_kernel *shp, int cmd);
-	int (*shm_shmat)(struct shmid_kernel *shp, char __user *shmaddr,
+	int (*shm_alloc_security)(struct kern_ipc_perm *shp);
+	void (*shm_free_security)(struct kern_ipc_perm *shp);
+	int (*shm_associate)(struct kern_ipc_perm *shp, int shmflg);
+	int (*shm_shmctl)(struct kern_ipc_perm *shp, int cmd);
+	int (*shm_shmat)(struct kern_ipc_perm *shp, char __user *shmaddr,
 				int shmflg);
 
 	int (*sem_alloc_security)(struct kern_ipc_perm *sma);
diff --git a/include/linux/security.h b/include/linux/security.h
index fa7adac4b99a..f390755808ea 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -49,7 +49,6 @@ struct qstr;
 struct iattr;
 struct fown_struct;
 struct file_operations;
-struct shmid_kernel;
 struct msg_msg;
 struct msg_queue;
 struct xattr;
@@ -362,11 +361,11 @@ int security_msg_queue_msgsnd(struct msg_queue *msq,
 			      struct msg_msg *msg, int msqflg);
 int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 			      struct task_struct *target, long type, int mode);
-int security_shm_alloc(struct shmid_kernel *shp);
-void security_shm_free(struct shmid_kernel *shp);
-int security_shm_associate(struct shmid_kernel *shp, int shmflg);
-int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
-int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg);
+int security_shm_alloc(struct kern_ipc_perm *shp);
+void security_shm_free(struct kern_ipc_perm *shp);
+int security_shm_associate(struct kern_ipc_perm *shp, int shmflg);
+int security_shm_shmctl(struct kern_ipc_perm *shp, int cmd);
+int security_shm_shmat(struct kern_ipc_perm *shp, char __user *shmaddr, int shmflg);
 int security_sem_alloc(struct kern_ipc_perm *sma);
 void security_sem_free(struct kern_ipc_perm *sma);
 int security_sem_associate(struct kern_ipc_perm *sma, int semflg);
@@ -1077,26 +1076,26 @@ static inline int security_msg_queue_msgrcv(struct msg_queue *msq,
 	return 0;
 }
 
-static inline int security_shm_alloc(struct shmid_kernel *shp)
+static inline int security_shm_alloc(struct kern_ipc_perm *shp)
 {
 	return 0;
 }
 
-static inline void security_shm_free(struct shmid_kernel *shp)
+static inline void security_shm_free(struct kern_ipc_perm *shp)
 { }
 
-static inline int security_shm_associate(struct shmid_kernel *shp,
+static inline int security_shm_associate(struct kern_ipc_perm *shp,
 					 int shmflg)
 {
 	return 0;
 }
 
-static inline int security_shm_shmctl(struct shmid_kernel *shp, int cmd)
+static inline int security_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
 {
 	return 0;
 }
 
-static inline int security_shm_shmat(struct shmid_kernel *shp,
+static inline int security_shm_shmat(struct kern_ipc_perm *shp,
 				     char __user *shmaddr, int shmflg)
 {
 	return 0;
diff --git a/ipc/shm.c b/ipc/shm.c
index 4643865e9171..387a786e7be1 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -181,7 +181,7 @@ static void shm_rcu_free(struct rcu_head *head)
 							rcu);
 	struct shmid_kernel *shp = container_of(ptr, struct shmid_kernel,
 							shm_perm);
-	security_shm_free(shp);
+	security_shm_free(&shp->shm_perm);
 	kvfree(shp);
 }
 
@@ -554,7 +554,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	shp->mlock_user = NULL;
 
 	shp->shm_perm.security = NULL;
-	error = security_shm_alloc(shp);
+	error = security_shm_alloc(&shp->shm_perm);
 	if (error) {
 		kvfree(shp);
 		return error;
@@ -635,10 +635,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
  */
 static inline int shm_security(struct kern_ipc_perm *ipcp, int shmflg)
 {
-	struct shmid_kernel *shp;
-
-	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
-	return security_shm_associate(shp, shmflg);
+	return security_shm_associate(ipcp, shmflg);
 }
 
 /*
@@ -835,7 +832,7 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 
 	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
 
-	err = security_shm_shmctl(shp, cmd);
+	err = security_shm_shmctl(&shp->shm_perm, cmd);
 	if (err)
 		goto out_unlock1;
 
@@ -934,7 +931,7 @@ static int shmctl_stat(struct ipc_namespace *ns, int shmid,
 	if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
 		goto out_unlock;
 
-	err = security_shm_shmctl(shp, cmd);
+	err = security_shm_shmctl(&shp->shm_perm, cmd);
 	if (err)
 		goto out_unlock;
 
@@ -978,7 +975,7 @@ static int shmctl_do_lock(struct ipc_namespace *ns, int shmid, int cmd)
 	}
 
 	audit_ipc_obj(&(shp->shm_perm));
-	err = security_shm_shmctl(shp, cmd);
+	err = security_shm_shmctl(&shp->shm_perm, cmd);
 	if (err)
 		goto out_unlock1;
 
@@ -1348,7 +1345,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg,
 	if (ipcperms(ns, &shp->shm_perm, acc_mode))
 		goto out_unlock;
 
-	err = security_shm_shmat(shp, shmaddr, shmflg);
+	err = security_shm_shmat(&shp->shm_perm, shmaddr, shmflg);
 	if (err)
 		goto out_unlock;
 
diff --git a/security/security.c b/security/security.c
index d3b9aeb6b73b..77b69bd6f234 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1195,27 +1195,27 @@ int security_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 	return call_int_hook(msg_queue_msgrcv, 0, msq, msg, target, type, mode);
 }
 
-int security_shm_alloc(struct shmid_kernel *shp)
+int security_shm_alloc(struct kern_ipc_perm *shp)
 {
 	return call_int_hook(shm_alloc_security, 0, shp);
 }
 
-void security_shm_free(struct shmid_kernel *shp)
+void security_shm_free(struct kern_ipc_perm *shp)
 {
 	call_void_hook(shm_free_security, shp);
 }
 
-int security_shm_associate(struct shmid_kernel *shp, int shmflg)
+int security_shm_associate(struct kern_ipc_perm *shp, int shmflg)
 {
 	return call_int_hook(shm_associate, 0, shp, shmflg);
 }
 
-int security_shm_shmctl(struct shmid_kernel *shp, int cmd)
+int security_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
 {
 	return call_int_hook(shm_shmctl, 0, shp, cmd);
 }
 
-int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg)
+int security_shm_shmat(struct kern_ipc_perm *shp, char __user *shmaddr, int shmflg)
 {
 	return call_int_hook(shm_shmat, 0, shp, shmaddr, shmflg);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index cce994e9fc0a..14f9e6c08273 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5674,53 +5674,53 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 }
 
 /* Shared Memory security operations */
-static int selinux_shm_alloc_security(struct shmid_kernel *shp)
+static int selinux_shm_alloc_security(struct kern_ipc_perm *shp)
 {
 	struct ipc_security_struct *isec;
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 	int rc;
 
-	rc = ipc_alloc_security(&shp->shm_perm, SECCLASS_SHM);
+	rc = ipc_alloc_security(shp, SECCLASS_SHM);
 	if (rc)
 		return rc;
 
-	isec = shp->shm_perm.security;
+	isec = shp->security;
 
 	ad.type = LSM_AUDIT_DATA_IPC;
-	ad.u.ipc_id = shp->shm_perm.key;
+	ad.u.ipc_id = shp->key;
 
 	rc = avc_has_perm(sid, isec->sid, SECCLASS_SHM,
 			  SHM__CREATE, &ad);
 	if (rc) {
-		ipc_free_security(&shp->shm_perm);
+		ipc_free_security(shp);
 		return rc;
 	}
 	return 0;
 }
 
-static void selinux_shm_free_security(struct shmid_kernel *shp)
+static void selinux_shm_free_security(struct kern_ipc_perm *shp)
 {
-	ipc_free_security(&shp->shm_perm);
+	ipc_free_security(shp);
 }
 
-static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
+static int selinux_shm_associate(struct kern_ipc_perm *shp, int shmflg)
 {
 	struct ipc_security_struct *isec;
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = shp->shm_perm.security;
+	isec = shp->security;
 
 	ad.type = LSM_AUDIT_DATA_IPC;
-	ad.u.ipc_id = shp->shm_perm.key;
+	ad.u.ipc_id = shp->key;
 
 	return avc_has_perm(sid, isec->sid, SECCLASS_SHM,
 			    SHM__ASSOCIATE, &ad);
 }
 
 /* Note, at this point, shp is locked down */
-static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
+static int selinux_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
 {
 	int perms;
 	int err;
@@ -5749,11 +5749,11 @@ static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		return 0;
 	}
 
-	err = ipc_has_perm(&shp->shm_perm, perms);
+	err = ipc_has_perm(shp, perms);
 	return err;
 }
 
-static int selinux_shm_shmat(struct shmid_kernel *shp,
+static int selinux_shm_shmat(struct kern_ipc_perm *shp,
 			     char __user *shmaddr, int shmflg)
 {
 	u32 perms;
@@ -5763,7 +5763,7 @@ static int selinux_shm_shmat(struct shmid_kernel *shp,
 	else
 		perms = SHM__READ | SHM__WRITE;
 
-	return ipc_has_perm(&shp->shm_perm, perms);
+	return ipc_has_perm(shp, perms);
 }
 
 /* Semaphore security operations */
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0402b8c1aec1..a3398c7f32c9 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2950,9 +2950,9 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
  *
  * Returns a pointer to the smack value
  */
-static struct smack_known *smack_of_shm(struct shmid_kernel *shp)
+static struct smack_known *smack_of_shm(struct kern_ipc_perm *shp)
 {
-	return (struct smack_known *)shp->shm_perm.security;
+	return (struct smack_known *)shp->security;
 }
 
 /**
@@ -2961,9 +2961,9 @@ static struct smack_known *smack_of_shm(struct shmid_kernel *shp)
  *
  * Returns 0
  */
-static int smack_shm_alloc_security(struct shmid_kernel *shp)
+static int smack_shm_alloc_security(struct kern_ipc_perm *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
+	struct kern_ipc_perm *isp = shp;
 	struct smack_known *skp = smk_of_current();
 
 	isp->security = skp;
@@ -2976,9 +2976,9 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
  *
  * Clears the blob pointer
  */
-static void smack_shm_free_security(struct shmid_kernel *shp)
+static void smack_shm_free_security(struct kern_ipc_perm *shp)
 {
-	struct kern_ipc_perm *isp = &shp->shm_perm;
+	struct kern_ipc_perm *isp = shp;
 
 	isp->security = NULL;
 }
@@ -2990,7 +2990,7 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smk_curacc_shm(struct shmid_kernel *shp, int access)
+static int smk_curacc_shm(struct kern_ipc_perm *shp, int access)
 {
 	struct smack_known *ssp = smack_of_shm(shp);
 	struct smk_audit_info ad;
@@ -2998,7 +2998,7 @@ static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
-	ad.a.u.ipc_id = shp->shm_perm.id;
+	ad.a.u.ipc_id = shp->id;
 #endif
 	rc = smk_curacc(ssp, access, &ad);
 	rc = smk_bu_current("shm", ssp, access, rc);
@@ -3012,7 +3012,7 @@ static int smk_curacc_shm(struct shmid_kernel *shp, int access)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
+static int smack_shm_associate(struct kern_ipc_perm *shp, int shmflg)
 {
 	int may;
 
@@ -3027,7 +3027,7 @@ static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
+static int smack_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
 {
 	int may;
 
@@ -3062,7 +3062,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
+static int smack_shm_shmat(struct kern_ipc_perm *shp, char __user *shmaddr,
 			   int shmflg)
 {
 	int may;
-- 
2.14.1
