From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Subject: [REVIEW][PATCH 01/11] sem/security: Pass kern_ipc_perm not sem_array
	into the sem security hooks
Date: Fri, 23 Mar 2018 14:16:04 -0500
Message-ID: <20180323191614.32489-1-ebiederm@xmission.com>
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

All of the implementations of security hooks that take sem_array only
access sem_perm the struct kern_ipc_perm member.  This means the
dependencies of the sem security hooks can be simplified by passing
the kern_ipc_perm member of sem_array.

Making this change will allow struct sem and struct sem_array
to become private to ipc/sem.c.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 include/linux/lsm_hooks.h  | 10 +++++-----
 include/linux/security.h   | 21 ++++++++++-----------
 ipc/sem.c                  | 19 ++++++++-----------
 security/security.c        | 10 +++++-----
 security/selinux/hooks.c   | 28 ++++++++++++++--------------
 security/smack/smack_lsm.c | 22 +++++++++++-----------
 6 files changed, 53 insertions(+), 57 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7161d8e7ee79..e4a94863a88c 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1592,11 +1592,11 @@ union security_list_options {
 	int (*shm_shmat)(struct shmid_kernel *shp, char __user *shmaddr,
 				int shmflg);
 
-	int (*sem_alloc_security)(struct sem_array *sma);
-	void (*sem_free_security)(struct sem_array *sma);
-	int (*sem_associate)(struct sem_array *sma, int semflg);
-	int (*sem_semctl)(struct sem_array *sma, int cmd);
-	int (*sem_semop)(struct sem_array *sma, struct sembuf *sops,
+	int (*sem_alloc_security)(struct kern_ipc_perm *sma);
+	void (*sem_free_security)(struct kern_ipc_perm *sma);
+	int (*sem_associate)(struct kern_ipc_perm *sma, int semflg);
+	int (*sem_semctl)(struct kern_ipc_perm *sma, int cmd);
+	int (*sem_semop)(struct kern_ipc_perm *sma, struct sembuf *sops,
 				unsigned nsops, int alter);
 
 	int (*netlink_send)(struct sock *sk, struct sk_buff *skb);
diff --git a/include/linux/security.h b/include/linux/security.h
index 73f1ef625d40..fa7adac4b99a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -36,7 +36,6 @@ struct linux_binprm;
 struct cred;
 struct rlimit;
 struct siginfo;
-struct sem_array;
 struct sembuf;
 struct kern_ipc_perm;
 struct audit_context;
@@ -368,11 +367,11 @@ void security_shm_free(struct shmid_kernel *shp);
 int security_shm_associate(struct shmid_kernel *shp, int shmflg);
 int security_shm_shmctl(struct shmid_kernel *shp, int cmd);
 int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmflg);
-int security_sem_alloc(struct sem_array *sma);
-void security_sem_free(struct sem_array *sma);
-int security_sem_associate(struct sem_array *sma, int semflg);
-int security_sem_semctl(struct sem_array *sma, int cmd);
-int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
+int security_sem_alloc(struct kern_ipc_perm *sma);
+void security_sem_free(struct kern_ipc_perm *sma);
+int security_sem_associate(struct kern_ipc_perm *sma, int semflg);
+int security_sem_semctl(struct kern_ipc_perm *sma, int cmd);
+int security_sem_semop(struct kern_ipc_perm *sma, struct sembuf *sops,
 			unsigned nsops, int alter);
 void security_d_instantiate(struct dentry *dentry, struct inode *inode);
 int security_getprocattr(struct task_struct *p, char *name, char **value);
@@ -1103,25 +1102,25 @@ static inline int security_shm_shmat(struct shmid_kernel *shp,
 	return 0;
 }
 
-static inline int security_sem_alloc(struct sem_array *sma)
+static inline int security_sem_alloc(struct kern_ipc_perm *sma)
 {
 	return 0;
 }
 
-static inline void security_sem_free(struct sem_array *sma)
+static inline void security_sem_free(struct kern_ipc_perm *sma)
 { }
 
-static inline int security_sem_associate(struct sem_array *sma, int semflg)
+static inline int security_sem_associate(struct kern_ipc_perm *sma, int semflg)
 {
 	return 0;
 }
 
-static inline int security_sem_semctl(struct sem_array *sma, int cmd)
+static inline int security_sem_semctl(struct kern_ipc_perm *sma, int cmd)
 {
 	return 0;
 }
 
-static inline int security_sem_semop(struct sem_array *sma,
+static inline int security_sem_semop(struct kern_ipc_perm *sma,
 				     struct sembuf *sops, unsigned nsops,
 				     int alter)
 {
diff --git a/ipc/sem.c b/ipc/sem.c
index a4af04979fd2..01f5c63670ae 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -265,7 +265,7 @@ static void sem_rcu_free(struct rcu_head *head)
 	struct kern_ipc_perm *p = container_of(head, struct kern_ipc_perm, rcu);
 	struct sem_array *sma = container_of(p, struct sem_array, sem_perm);
 
-	security_sem_free(sma);
+	security_sem_free(&sma->sem_perm);
 	kvfree(sma);
 }
 
@@ -495,7 +495,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	sma->sem_perm.key = key;
 
 	sma->sem_perm.security = NULL;
-	retval = security_sem_alloc(sma);
+	retval = security_sem_alloc(&sma->sem_perm);
 	if (retval) {
 		kvfree(sma);
 		return retval;
@@ -535,10 +535,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
  */
 static inline int sem_security(struct kern_ipc_perm *ipcp, int semflg)
 {
-	struct sem_array *sma;
-
-	sma = container_of(ipcp, struct sem_array, sem_perm);
-	return security_sem_associate(sma, semflg);
+	return security_sem_associate(ipcp, semflg);
 }
 
 /*
@@ -1209,7 +1206,7 @@ static int semctl_stat(struct ipc_namespace *ns, int semid,
 	if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
 		goto out_unlock;
 
-	err = security_sem_semctl(sma, cmd);
+	err = security_sem_semctl(&sma->sem_perm, cmd);
 	if (err)
 		goto out_unlock;
 
@@ -1300,7 +1297,7 @@ static int semctl_setval(struct ipc_namespace *ns, int semid, int semnum,
 		return -EACCES;
 	}
 
-	err = security_sem_semctl(sma, SETVAL);
+	err = security_sem_semctl(&sma->sem_perm, SETVAL);
 	if (err) {
 		rcu_read_unlock();
 		return -EACCES;
@@ -1354,7 +1351,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	if (ipcperms(ns, &sma->sem_perm, cmd == SETALL ? S_IWUGO : S_IRUGO))
 		goto out_rcu_wakeup;
 
-	err = security_sem_semctl(sma, cmd);
+	err = security_sem_semctl(&sma->sem_perm, cmd);
 	if (err)
 		goto out_rcu_wakeup;
 
@@ -1545,7 +1542,7 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 
 	sma = container_of(ipcp, struct sem_array, sem_perm);
 
-	err = security_sem_semctl(sma, cmd);
+	err = security_sem_semctl(&sma->sem_perm, cmd);
 	if (err)
 		goto out_unlock1;
 
@@ -1962,7 +1959,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 		goto out_free;
 	}
 
-	error = security_sem_semop(sma, sops, nsops, alter);
+	error = security_sem_semop(&sma->sem_perm, sops, nsops, alter);
 	if (error) {
 		rcu_read_unlock();
 		goto out_free;
diff --git a/security/security.c b/security/security.c
index 1cd8526cb0b7..d3b9aeb6b73b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1220,27 +1220,27 @@ int security_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr, int shmfl
 	return call_int_hook(shm_shmat, 0, shp, shmaddr, shmflg);
 }
 
-int security_sem_alloc(struct sem_array *sma)
+int security_sem_alloc(struct kern_ipc_perm *sma)
 {
 	return call_int_hook(sem_alloc_security, 0, sma);
 }
 
-void security_sem_free(struct sem_array *sma)
+void security_sem_free(struct kern_ipc_perm *sma)
 {
 	call_void_hook(sem_free_security, sma);
 }
 
-int security_sem_associate(struct sem_array *sma, int semflg)
+int security_sem_associate(struct kern_ipc_perm *sma, int semflg)
 {
 	return call_int_hook(sem_associate, 0, sma, semflg);
 }
 
-int security_sem_semctl(struct sem_array *sma, int cmd)
+int security_sem_semctl(struct kern_ipc_perm *sma, int cmd)
 {
 	return call_int_hook(sem_semctl, 0, sma, cmd);
 }
 
-int security_sem_semop(struct sem_array *sma, struct sembuf *sops,
+int security_sem_semop(struct kern_ipc_perm *sma, struct sembuf *sops,
 			unsigned nsops, int alter)
 {
 	return call_int_hook(sem_semop, 0, sma, sops, nsops, alter);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8644d864e3c1..cce994e9fc0a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5767,53 +5767,53 @@ static int selinux_shm_shmat(struct shmid_kernel *shp,
 }
 
 /* Semaphore security operations */
-static int selinux_sem_alloc_security(struct sem_array *sma)
+static int selinux_sem_alloc_security(struct kern_ipc_perm *sma)
 {
 	struct ipc_security_struct *isec;
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 	int rc;
 
-	rc = ipc_alloc_security(&sma->sem_perm, SECCLASS_SEM);
+	rc = ipc_alloc_security(sma, SECCLASS_SEM);
 	if (rc)
 		return rc;
 
-	isec = sma->sem_perm.security;
+	isec = sma->security;
 
 	ad.type = LSM_AUDIT_DATA_IPC;
-	ad.u.ipc_id = sma->sem_perm.key;
+	ad.u.ipc_id = sma->key;
 
 	rc = avc_has_perm(sid, isec->sid, SECCLASS_SEM,
 			  SEM__CREATE, &ad);
 	if (rc) {
-		ipc_free_security(&sma->sem_perm);
+		ipc_free_security(sma);
 		return rc;
 	}
 	return 0;
 }
 
-static void selinux_sem_free_security(struct sem_array *sma)
+static void selinux_sem_free_security(struct kern_ipc_perm *sma)
 {
-	ipc_free_security(&sma->sem_perm);
+	ipc_free_security(sma);
 }
 
-static int selinux_sem_associate(struct sem_array *sma, int semflg)
+static int selinux_sem_associate(struct kern_ipc_perm *sma, int semflg)
 {
 	struct ipc_security_struct *isec;
 	struct common_audit_data ad;
 	u32 sid = current_sid();
 
-	isec = sma->sem_perm.security;
+	isec = sma->security;
 
 	ad.type = LSM_AUDIT_DATA_IPC;
-	ad.u.ipc_id = sma->sem_perm.key;
+	ad.u.ipc_id = sma->key;
 
 	return avc_has_perm(sid, isec->sid, SECCLASS_SEM,
 			    SEM__ASSOCIATE, &ad);
 }
 
 /* Note, at this point, sma is locked down */
-static int selinux_sem_semctl(struct sem_array *sma, int cmd)
+static int selinux_sem_semctl(struct kern_ipc_perm *sma, int cmd)
 {
 	int err;
 	u32 perms;
@@ -5851,11 +5851,11 @@ static int selinux_sem_semctl(struct sem_array *sma, int cmd)
 		return 0;
 	}
 
-	err = ipc_has_perm(&sma->sem_perm, perms);
+	err = ipc_has_perm(sma, perms);
 	return err;
 }
 
-static int selinux_sem_semop(struct sem_array *sma,
+static int selinux_sem_semop(struct kern_ipc_perm *sma,
 			     struct sembuf *sops, unsigned nsops, int alter)
 {
 	u32 perms;
@@ -5865,7 +5865,7 @@ static int selinux_sem_semop(struct sem_array *sma,
 	else
 		perms = SEM__READ;
 
-	return ipc_has_perm(&sma->sem_perm, perms);
+	return ipc_has_perm(sma, perms);
 }
 
 static int selinux_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 03fdecba93bb..0402b8c1aec1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3077,9 +3077,9 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
  *
  * Returns a pointer to the smack value
  */
-static struct smack_known *smack_of_sem(struct sem_array *sma)
+static struct smack_known *smack_of_sem(struct kern_ipc_perm *sma)
 {
-	return (struct smack_known *)sma->sem_perm.security;
+	return (struct smack_known *)sma->security;
 }
 
 /**
@@ -3088,9 +3088,9 @@ static struct smack_known *smack_of_sem(struct sem_array *sma)
  *
  * Returns 0
  */
-static int smack_sem_alloc_security(struct sem_array *sma)
+static int smack_sem_alloc_security(struct kern_ipc_perm *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
+	struct kern_ipc_perm *isp = sma;
 	struct smack_known *skp = smk_of_current();
 
 	isp->security = skp;
@@ -3103,9 +3103,9 @@ static int smack_sem_alloc_security(struct sem_array *sma)
  *
  * Clears the blob pointer
  */
-static void smack_sem_free_security(struct sem_array *sma)
+static void smack_sem_free_security(struct kern_ipc_perm *sma)
 {
-	struct kern_ipc_perm *isp = &sma->sem_perm;
+	struct kern_ipc_perm *isp = sma;
 
 	isp->security = NULL;
 }
@@ -3117,7 +3117,7 @@ static void smack_sem_free_security(struct sem_array *sma)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smk_curacc_sem(struct sem_array *sma, int access)
+static int smk_curacc_sem(struct kern_ipc_perm *sma, int access)
 {
 	struct smack_known *ssp = smack_of_sem(sma);
 	struct smk_audit_info ad;
@@ -3125,7 +3125,7 @@ static int smk_curacc_sem(struct sem_array *sma, int access)
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
-	ad.a.u.ipc_id = sma->sem_perm.id;
+	ad.a.u.ipc_id = sma->id;
 #endif
 	rc = smk_curacc(ssp, access, &ad);
 	rc = smk_bu_current("sem", ssp, access, rc);
@@ -3139,7 +3139,7 @@ static int smk_curacc_sem(struct sem_array *sma, int access)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_sem_associate(struct sem_array *sma, int semflg)
+static int smack_sem_associate(struct kern_ipc_perm *sma, int semflg)
 {
 	int may;
 
@@ -3154,7 +3154,7 @@ static int smack_sem_associate(struct sem_array *sma, int semflg)
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_sem_semctl(struct sem_array *sma, int cmd)
+static int smack_sem_semctl(struct kern_ipc_perm *sma, int cmd)
 {
 	int may;
 
@@ -3198,7 +3198,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
  *
  * Returns 0 if access is allowed, error code otherwise
  */
-static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
+static int smack_sem_semop(struct kern_ipc_perm *sma, struct sembuf *sops,
 			   unsigned nsops, int alter)
 {
 	return smk_curacc_sem(sma, MAY_READWRITE);
-- 
2.14.1
