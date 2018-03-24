From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 13/11] ipc/smack: Tidy up from the change in type of the ipc security hooks
Date: Sat, 24 Mar 2018 00:42:01 -0500
Message-ID: <87y3iikp1y.fsf_-_@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
        <87vadzqqq6.fsf@xmission.com>
        <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
        <877eqejowd.fsf@xmission.com>
        <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
        <87a7v2z2qa.fsf@xmission.com> <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vadmobdw.fsf_-_@xmission.com> (Eric W. Biederman's message of
        "Fri, 23 Mar 2018 14:11:23 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: esyr@redhat.com, jannh@google.com, khlebnikov@yandex-team.ru, linux-api@vger.kernel.org, serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org, prakash.sangappa@oracle.com, linux-security-module@vger.kernel.org, luto@kernel.org, oleg@redhat.com, akpm@linux-foundation.org, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org


Rename the variables shp, sma, msq to isp. As that is how the code already
refers to those variables.

Collapse smack_of_shm, smack_of_sem, and smack_of_msq into smack_of_ipc,
as the three functions had become completely identical.

Collapse smack_shm_alloc_security, smack_sem_alloc_security and
smack_msg_queue_alloc_security into smack_ipc_alloc_security as the
three functions had become identical.

Collapse smack_shm_free_security, smack_sem_free_security and
smack_msg_queue_free_security into smack_ipc_free_security as the three
functions had become identical.

Requested-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 security/smack/smack_lsm.c | 197 +++++++++++++--------------------------------
 1 file changed, 58 insertions(+), 139 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d960c2ea8d79..0735b8db158b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2945,25 +2945,24 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
 }
 
 /**
- * smack_of_shm - the smack pointer for the shm
- * @shp: the object
+ * smack_of_ipc - the smack pointer for the ipc
+ * @isp: the object
  *
  * Returns a pointer to the smack value
  */
-static struct smack_known *smack_of_shm(struct kern_ipc_perm *shp)
+static struct smack_known *smack_of_ipc(struct kern_ipc_perm *isp)
 {
-	return (struct smack_known *)shp->security;
+	return (struct smack_known *)isp->security;
 }
 
 /**
- * smack_shm_alloc_security - Set the security blob for shm
- * @shp: the object
+ * smack_ipc_alloc_security - Set the security blob for ipc
+ * @isp: the object
  *
  * Returns 0
  */
-static int smack_shm_alloc_security(struct kern_ipc_perm *shp)
+static int smack_ipc_alloc_security(struct kern_ipc_perm *isp)
 {
-	struct kern_ipc_perm *isp = shp;
 	struct smack_known *skp = smk_of_current();
 
 	isp->security = skp;
@@ -2971,34 +2970,32 @@ static int smack_shm_alloc_security(struct kern_ipc_perm *shp)
 }
 
 /**
- * smack_shm_free_security - Clear the security blob for shm
- * @shp: the object
+ * smack_ipc_free_security - Clear the security blob for ipc
+ * @isp: the object
  *
  * Clears the blob pointer
  */
-static void smack_shm_free_security(struct kern_ipc_perm *shp)
+static void smack_ipc_free_security(struct kern_ipc_perm *isp)
 {
-	struct kern_ipc_perm *isp = shp;
-
 	isp->security = NULL;
 }
 
 /**
  * smk_curacc_shm : check if current has access on shm
- * @shp : the object
+ * @isp : the object
  * @access : access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smk_curacc_shm(struct kern_ipc_perm *shp, int access)
+static int smk_curacc_shm(struct kern_ipc_perm *isp, int access)
 {
-	struct smack_known *ssp = smack_of_shm(shp);
+	struct smack_known *ssp = smack_of_ipc(isp);
 	struct smk_audit_info ad;
 	int rc;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
-	ad.a.u.ipc_id = shp->id;
+	ad.a.u.ipc_id = isp->id;
 #endif
 	rc = smk_curacc(ssp, access, &ad);
 	rc = smk_bu_current("shm", ssp, access, rc);
@@ -3007,27 +3004,27 @@ static int smk_curacc_shm(struct kern_ipc_perm *shp, int access)
 
 /**
  * smack_shm_associate - Smack access check for shm
- * @shp: the object
+ * @isp: the object
  * @shmflg: access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_associate(struct kern_ipc_perm *shp, int shmflg)
+static int smack_shm_associate(struct kern_ipc_perm *isp, int shmflg)
 {
 	int may;
 
 	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(isp, may);
 }
 
 /**
  * smack_shm_shmctl - Smack access check for shm
- * @shp: the object
+ * @isp: the object
  * @cmd: what it wants to do
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
+static int smack_shm_shmctl(struct kern_ipc_perm *isp, int cmd)
 {
 	int may;
 
@@ -3051,81 +3048,42 @@ static int smack_shm_shmctl(struct kern_ipc_perm *shp, int cmd)
 	default:
 		return -EINVAL;
 	}
-	return smk_curacc_shm(shp, may);
+	return smk_curacc_shm(isp, may);
 }
 
 /**
  * smack_shm_shmat - Smack access for shmat
- * @shp: the object
+ * @isp: the object
  * @shmaddr: unused
  * @shmflg: access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_shm_shmat(struct kern_ipc_perm *shp, char __user *shmaddr,
+static int smack_shm_shmat(struct kern_ipc_perm *ipc, char __user *shmaddr,
 			   int shmflg)
 {
 	int may;
 
 	may = smack_flags_to_may(shmflg);
-	return smk_curacc_shm(shp, may);
-}
-
-/**
- * smack_of_sem - the smack pointer for the sem
- * @sma: the object
- *
- * Returns a pointer to the smack value
- */
-static struct smack_known *smack_of_sem(struct kern_ipc_perm *sma)
-{
-	return (struct smack_known *)sma->security;
-}
-
-/**
- * smack_sem_alloc_security - Set the security blob for sem
- * @sma: the object
- *
- * Returns 0
- */
-static int smack_sem_alloc_security(struct kern_ipc_perm *sma)
-{
-	struct kern_ipc_perm *isp = sma;
-	struct smack_known *skp = smk_of_current();
-
-	isp->security = skp;
-	return 0;
-}
-
-/**
- * smack_sem_free_security - Clear the security blob for sem
- * @sma: the object
- *
- * Clears the blob pointer
- */
-static void smack_sem_free_security(struct kern_ipc_perm *sma)
-{
-	struct kern_ipc_perm *isp = sma;
-
-	isp->security = NULL;
+	return smk_curacc_shm(ipc, may);
 }
 
 /**
  * smk_curacc_sem : check if current has access on sem
- * @sma : the object
+ * @isp : the object
  * @access : access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smk_curacc_sem(struct kern_ipc_perm *sma, int access)
+static int smk_curacc_sem(struct kern_ipc_perm *isp, int access)
 {
-	struct smack_known *ssp = smack_of_sem(sma);
+	struct smack_known *ssp = smack_of_ipc(isp);
 	struct smk_audit_info ad;
 	int rc;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
-	ad.a.u.ipc_id = sma->id;
+	ad.a.u.ipc_id = isp->id;
 #endif
 	rc = smk_curacc(ssp, access, &ad);
 	rc = smk_bu_current("sem", ssp, access, rc);
@@ -3134,27 +3092,27 @@ static int smk_curacc_sem(struct kern_ipc_perm *sma, int access)
 
 /**
  * smack_sem_associate - Smack access check for sem
- * @sma: the object
+ * @isp: the object
  * @semflg: access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_sem_associate(struct kern_ipc_perm *sma, int semflg)
+static int smack_sem_associate(struct kern_ipc_perm *isp, int semflg)
 {
 	int may;
 
 	may = smack_flags_to_may(semflg);
-	return smk_curacc_sem(sma, may);
+	return smk_curacc_sem(isp, may);
 }
 
 /**
  * smack_sem_shmctl - Smack access check for sem
- * @sma: the object
+ * @isp: the object
  * @cmd: what it wants to do
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_sem_semctl(struct kern_ipc_perm *sma, int cmd)
+static int smack_sem_semctl(struct kern_ipc_perm *isp, int cmd)
 {
 	int may;
 
@@ -3184,12 +3142,12 @@ static int smack_sem_semctl(struct kern_ipc_perm *sma, int cmd)
 		return -EINVAL;
 	}
 
-	return smk_curacc_sem(sma, may);
+	return smk_curacc_sem(isp, may);
 }
 
 /**
  * smack_sem_semop - Smack checks of semaphore operations
- * @sma: the object
+ * @isp: the object
  * @sops: unused
  * @nsops: unused
  * @alter: unused
@@ -3198,67 +3156,28 @@ static int smack_sem_semctl(struct kern_ipc_perm *sma, int cmd)
  *
  * Returns 0 if access is allowed, error code otherwise
  */
-static int smack_sem_semop(struct kern_ipc_perm *sma, struct sembuf *sops,
+static int smack_sem_semop(struct kern_ipc_perm *isp, struct sembuf *sops,
 			   unsigned nsops, int alter)
 {
-	return smk_curacc_sem(sma, MAY_READWRITE);
-}
-
-/**
- * smack_msg_alloc_security - Set the security blob for msg
- * @msq: the object
- *
- * Returns 0
- */
-static int smack_msg_queue_alloc_security(struct kern_ipc_perm *msq)
-{
-	struct kern_ipc_perm *kisp = msq;
-	struct smack_known *skp = smk_of_current();
-
-	kisp->security = skp;
-	return 0;
-}
-
-/**
- * smack_msg_free_security - Clear the security blob for msg
- * @msq: the object
- *
- * Clears the blob pointer
- */
-static void smack_msg_queue_free_security(struct kern_ipc_perm *msq)
-{
-	struct kern_ipc_perm *kisp = msq;
-
-	kisp->security = NULL;
-}
-
-/**
- * smack_of_msq - the smack pointer for the msq
- * @msq: the object
- *
- * Returns a pointer to the smack label entry
- */
-static struct smack_known *smack_of_msq(struct kern_ipc_perm *msq)
-{
-	return (struct smack_known *)msq->security;
+	return smk_curacc_sem(isp, MAY_READWRITE);
 }
 
 /**
  * smk_curacc_msq : helper to check if current has access on msq
- * @msq : the msq
+ * @isp : the msq
  * @access : access requested
  *
  * return 0 if current has access, error otherwise
  */
-static int smk_curacc_msq(struct kern_ipc_perm *msq, int access)
+static int smk_curacc_msq(struct kern_ipc_perm *isp, int access)
 {
-	struct smack_known *msp = smack_of_msq(msq);
+	struct smack_known *msp = smack_of_ipc(isp);
 	struct smk_audit_info ad;
 	int rc;
 
 #ifdef CONFIG_AUDIT
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
-	ad.a.u.ipc_id = msq->id;
+	ad.a.u.ipc_id = isp->id;
 #endif
 	rc = smk_curacc(msp, access, &ad);
 	rc = smk_bu_current("msq", msp, access, rc);
@@ -3267,27 +3186,27 @@ static int smk_curacc_msq(struct kern_ipc_perm *msq, int access)
 
 /**
  * smack_msg_queue_associate - Smack access check for msg_queue
- * @msq: the object
+ * @isp: the object
  * @msqflg: access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_msg_queue_associate(struct kern_ipc_perm *msq, int msqflg)
+static int smack_msg_queue_associate(struct kern_ipc_perm *isp, int msqflg)
 {
 	int may;
 
 	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(isp, may);
 }
 
 /**
  * smack_msg_queue_msgctl - Smack access check for msg_queue
- * @msq: the object
+ * @isp: the object
  * @cmd: what it wants to do
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_msg_queue_msgctl(struct kern_ipc_perm *msq, int cmd)
+static int smack_msg_queue_msgctl(struct kern_ipc_perm *isp, int cmd)
 {
 	int may;
 
@@ -3310,29 +3229,29 @@ static int smack_msg_queue_msgctl(struct kern_ipc_perm *msq, int cmd)
 		return -EINVAL;
 	}
 
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(isp, may);
 }
 
 /**
  * smack_msg_queue_msgsnd - Smack access check for msg_queue
- * @msq: the object
+ * @isp: the object
  * @msg: unused
  * @msqflg: access requested
  *
  * Returns 0 if current has the requested access, error code otherwise
  */
-static int smack_msg_queue_msgsnd(struct kern_ipc_perm *msq, struct msg_msg *msg,
+static int smack_msg_queue_msgsnd(struct kern_ipc_perm *isp, struct msg_msg *msg,
 				  int msqflg)
 {
 	int may;
 
 	may = smack_flags_to_may(msqflg);
-	return smk_curacc_msq(msq, may);
+	return smk_curacc_msq(isp, may);
 }
 
 /**
  * smack_msg_queue_msgsnd - Smack access check for msg_queue
- * @msq: the object
+ * @isp: the object
  * @msg: unused
  * @target: unused
  * @type: unused
@@ -3340,10 +3259,10 @@ static int smack_msg_queue_msgsnd(struct kern_ipc_perm *msq, struct msg_msg *msg
  *
  * Returns 0 if current has read and write access, error code otherwise
  */
-static int smack_msg_queue_msgrcv(struct kern_ipc_perm *msq, struct msg_msg *msg,
+static int smack_msg_queue_msgrcv(struct kern_ipc_perm *isp, struct msg_msg *msg,
 			struct task_struct *target, long type, int mode)
 {
-	return smk_curacc_msq(msq, MAY_READWRITE);
+	return smk_curacc_msq(isp, MAY_READWRITE);
 }
 
 /**
@@ -4756,21 +4675,21 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(msg_msg_alloc_security, smack_msg_msg_alloc_security),
 	LSM_HOOK_INIT(msg_msg_free_security, smack_msg_msg_free_security),
 
-	LSM_HOOK_INIT(msg_queue_alloc_security, smack_msg_queue_alloc_security),
-	LSM_HOOK_INIT(msg_queue_free_security, smack_msg_queue_free_security),
+	LSM_HOOK_INIT(msg_queue_alloc_security, smack_ipc_alloc_security),
+	LSM_HOOK_INIT(msg_queue_free_security, smack_ipc_free_security),
 	LSM_HOOK_INIT(msg_queue_associate, smack_msg_queue_associate),
 	LSM_HOOK_INIT(msg_queue_msgctl, smack_msg_queue_msgctl),
 	LSM_HOOK_INIT(msg_queue_msgsnd, smack_msg_queue_msgsnd),
 	LSM_HOOK_INIT(msg_queue_msgrcv, smack_msg_queue_msgrcv),
 
-	LSM_HOOK_INIT(shm_alloc_security, smack_shm_alloc_security),
-	LSM_HOOK_INIT(shm_free_security, smack_shm_free_security),
+	LSM_HOOK_INIT(shm_alloc_security, smack_ipc_alloc_security),
+	LSM_HOOK_INIT(shm_free_security, smack_ipc_free_security),
 	LSM_HOOK_INIT(shm_associate, smack_shm_associate),
 	LSM_HOOK_INIT(shm_shmctl, smack_shm_shmctl),
 	LSM_HOOK_INIT(shm_shmat, smack_shm_shmat),
 
-	LSM_HOOK_INIT(sem_alloc_security, smack_sem_alloc_security),
-	LSM_HOOK_INIT(sem_free_security, smack_sem_free_security),
+	LSM_HOOK_INIT(sem_alloc_security, smack_ipc_alloc_security),
+	LSM_HOOK_INIT(sem_free_security, smack_ipc_free_security),
 	LSM_HOOK_INIT(sem_associate, smack_sem_associate),
 	LSM_HOOK_INIT(sem_semctl, smack_sem_semctl),
 	LSM_HOOK_INIT(sem_semop, smack_sem_semop),
-- 
2.14.1
