From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 4/5] ipc: simplify ipc initialization
Date: Fri,  1 Jun 2018 09:01:24 -0700
Message-ID: <20180601160125.30031-5-dave@stgolabs.net>
References: <20180601160125.30031-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601160125.30031-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

Now that we know that rhashtable_init() will not fail, we
can get rid of a lot of the unnecessary cleanup paths when
the call errored out.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 ipc/msg.c       |  9 ++++-----
 ipc/namespace.c | 20 ++++----------------
 ipc/sem.c       | 10 ++++------
 ipc/shm.c       |  9 ++++-----
 ipc/util.c      | 18 +++++-------------
 ipc/util.h      | 18 +++++++++---------
 6 files changed, 30 insertions(+), 54 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 3b6545302598..62545ce19173 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -1228,7 +1228,7 @@ COMPAT_SYSCALL_DEFINE5(msgrcv, int, msqid, compat_uptr_t, msgp,
 }
 #endif
 
-int msg_init_ns(struct ipc_namespace *ns)
+void msg_init_ns(struct ipc_namespace *ns)
 {
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
@@ -1236,7 +1236,7 @@ int msg_init_ns(struct ipc_namespace *ns)
 
 	atomic_set(&ns->msg_bytes, 0);
 	atomic_set(&ns->msg_hdrs, 0);
-	return ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
+	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -1277,12 +1277,11 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 }
 #endif
 
-int __init msg_init(void)
+void __init msg_init(void)
 {
-	const int err = msg_init_ns(&init_ipc_ns);
+	msg_init_ns(&init_ipc_ns);
 
 	ipc_init_proc_interface("sysvipc/msg",
 				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
 				IPC_MSG_IDS, sysvipc_msg_proc_show);
-	return err;
 }
diff --git a/ipc/namespace.c b/ipc/namespace.c
index f59a89966f92..21607791d62c 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -55,28 +55,16 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	ns->user_ns = get_user_ns(user_ns);
 	ns->ucounts = ucounts;
 
-	err = sem_init_ns(ns);
+	err = mq_init_ns(ns);
 	if (err)
 		goto fail_put;
-	err = msg_init_ns(ns);
-	if (err)
-		goto fail_destroy_sem;
-	err = shm_init_ns(ns);
-	if (err)
-		goto fail_destroy_msg;
 
-	err = mq_init_ns(ns);
-	if (err)
-		goto fail_destroy_shm;
+	sem_init_ns(ns);
+	msg_init_ns(ns);
+	shm_init_ns(ns);
 
 	return ns;
 
-fail_destroy_shm:
-	shm_exit_ns(ns);
-fail_destroy_msg:
-	msg_exit_ns(ns);
-fail_destroy_sem:
-	sem_exit_ns(ns);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
diff --git a/ipc/sem.c b/ipc/sem.c
index 20f649eed8c6..78ea913ee0d8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -220,14 +220,14 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #define sc_semopm	sem_ctls[2]
 #define sc_semmni	sem_ctls[3]
 
-int sem_init_ns(struct ipc_namespace *ns)
+void sem_init_ns(struct ipc_namespace *ns)
 {
 	ns->sc_semmsl = SEMMSL;
 	ns->sc_semmns = SEMMNS;
 	ns->sc_semopm = SEMOPM;
 	ns->sc_semmni = SEMMNI;
 	ns->used_sems = 0;
-	return ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
+	ipc_init_ids(&ns->ids[IPC_SEM_IDS]);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -239,14 +239,12 @@ void sem_exit_ns(struct ipc_namespace *ns)
 }
 #endif
 
-int __init sem_init(void)
+void __init sem_init(void)
 {
-	const int err = sem_init_ns(&init_ipc_ns);
-
+	sem_init_ns(&init_ipc_ns);
 	ipc_init_proc_interface("sysvipc/sem",
 				"       key      semid perms      nsems   uid   gid  cuid  cgid      otime      ctime\n",
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
-	return err;
 }
 
 /**
diff --git a/ipc/shm.c b/ipc/shm.c
index 051a3e1fb8df..e602a6fc3991 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -95,14 +95,14 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp);
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it);
 #endif
 
-int shm_init_ns(struct ipc_namespace *ns)
+void shm_init_ns(struct ipc_namespace *ns)
 {
 	ns->shm_ctlmax = SHMMAX;
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
-	return ipc_init_ids(&shm_ids(ns));
+	ipc_init_ids(&shm_ids(ns));
 }
 
 /*
@@ -135,9 +135,8 @@ void shm_exit_ns(struct ipc_namespace *ns)
 
 static int __init ipc_ns_init(void)
 {
-	const int err = shm_init_ns(&init_ipc_ns);
-	WARN(err, "ipc: sysv shm_init_ns failed: %d\n", err);
-	return err;
+	shm_init_ns(&init_ipc_ns);
+	return 0;
 }
 
 pure_initcall(ipc_ns_init);
diff --git a/ipc/util.c b/ipc/util.c
index 823e09e72c58..06d7c575847c 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -87,16 +87,12 @@ struct ipc_proc_iface {
  */
 static int __init ipc_init(void)
 {
-	int err_sem, err_msg;
-
 	proc_mkdir("sysvipc", NULL);
-	err_sem = sem_init();
-	WARN(err_sem, "ipc: sysv sem_init failed: %d\n", err_sem);
-	err_msg = msg_init();
-	WARN(err_msg, "ipc: sysv msg_init failed: %d\n", err_msg);
+	sem_init();
+	msg_init();
 	shm_init();
 
-	return err_msg ? err_msg : err_sem;
+	return 0;
 }
 device_initcall(ipc_init);
 
@@ -115,21 +111,17 @@ static const struct rhashtable_params ipc_kht_params = {
  * Set up the sequence range to use for the ipc identifier range (limited
  * below IPCMNI) then initialise the keys hashtable and ids idr.
  */
-int ipc_init_ids(struct ipc_ids *ids)
+void ipc_init_ids(struct ipc_ids *ids)
 {
-	int err;
 	ids->in_use = 0;
 	ids->seq = 0;
 	init_rwsem(&ids->rwsem);
-	err = rhashtable_init(&ids->key_ht, &ipc_kht_params);
-	if (err)
-		return err;
+	rhashtable_init(&ids->key_ht, &ipc_kht_params);
 	idr_init(&ids->ipcs_idr);
 	ids->max_id = -1;
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	ids->next_id = -1;
 #endif
-	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
diff --git a/ipc/util.h b/ipc/util.h
index 0aba3230d007..65fad8a94da8 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -18,8 +18,8 @@
 #define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
 #define SEQ_MULTIPLIER	(IPCMNI)
 
-int sem_init(void);
-int msg_init(void);
+void sem_init(void);
+void msg_init(void);
 void shm_init(void);
 
 struct ipc_namespace;
@@ -34,17 +34,17 @@ static inline void mq_put_mnt(struct ipc_namespace *ns) { }
 #endif
 
 #ifdef CONFIG_SYSVIPC
-int sem_init_ns(struct ipc_namespace *ns);
-int msg_init_ns(struct ipc_namespace *ns);
-int shm_init_ns(struct ipc_namespace *ns);
+void sem_init_ns(struct ipc_namespace *ns);
+void msg_init_ns(struct ipc_namespace *ns);
+void shm_init_ns(struct ipc_namespace *ns);
 
 void sem_exit_ns(struct ipc_namespace *ns);
 void msg_exit_ns(struct ipc_namespace *ns);
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
-static inline int sem_init_ns(struct ipc_namespace *ns) { return 0; }
-static inline int msg_init_ns(struct ipc_namespace *ns) { return 0; }
-static inline int shm_init_ns(struct ipc_namespace *ns) { return 0; }
+static inline void sem_init_ns(struct ipc_namespace *ns) { }
+static inline void msg_init_ns(struct ipc_namespace *ns) { }
+static inline void shm_init_ns(struct ipc_namespace *ns) { }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
 static inline void msg_exit_ns(struct ipc_namespace *ns) { }
@@ -83,7 +83,7 @@ struct ipc_ops {
 struct seq_file;
 struct ipc_ids;
 
-int ipc_init_ids(struct ipc_ids *);
+void ipc_init_ids(struct ipc_ids *);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
-- 
2.16.3
