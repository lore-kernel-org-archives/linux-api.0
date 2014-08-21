From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 1/8] namespaces: assign each namespace instance a serial
	number
Date: Wed, 20 Aug 2014 21:09:34 -0400
Message-ID: <d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Generate and assign a serial number per namespace instance since boot.

Use a serial number per namespace (unique across one boot of one kernel)
instead of the inode number (which is claimed to have had the right to change
reserved and is not necessarily unique if there is more than one proc fs) to
uniquely identify it per kernel boot.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/mount.h                     |    1 +
 fs/namespace.c                 |    1 +
 include/linux/ipc_namespace.h  |    1 +
 include/linux/nsproxy.h        |    8 ++++++++
 include/linux/pid_namespace.h  |    1 +
 include/linux/user_namespace.h |    1 +
 include/linux/utsname.h        |    1 +
 include/net/net_namespace.h    |    1 +
 init/version.c                 |    1 +
 ipc/msgutil.c                  |    1 +
 ipc/namespace.c                |    2 ++
 kernel/nsproxy.c               |   17 +++++++++++++++++
 kernel/pid.c                   |    1 +
 kernel/pid_namespace.c         |    2 ++
 kernel/user.c                  |    1 +
 kernel/user_namespace.c        |    2 ++
 kernel/utsname.c               |    2 ++
 net/core/net_namespace.c       |    8 +++++++-
 18 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index d55297f..c076f99 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -5,6 +5,7 @@
 struct mnt_namespace {
 	atomic_t		count;
 	unsigned int		proc_inum;
+	long long	serial_num;
 	struct mount *	root;
 	struct list_head	list;
 	struct user_namespace	*user_ns;
diff --git a/fs/namespace.c b/fs/namespace.c
index 182bc41..9af49ff 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2486,6 +2486,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 		kfree(new_ns);
 		return ERR_PTR(ret);
 	}
+	new_ns->serial_num = ns_serial();
 	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
 	atomic_set(&new_ns->count, 1);
 	new_ns->root = NULL;
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 35e7eca..8ccfb2d 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -69,6 +69,7 @@ struct ipc_namespace {
 	struct user_namespace *user_ns;
 
 	unsigned int	proc_inum;
+	long long	serial_num;
 };
 
 extern struct ipc_namespace init_ipc_ns;
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d..8e5fe0d 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -66,6 +66,14 @@ static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
 	return rcu_dereference(tsk->nsproxy);
 }
 
+long long ns_serial(void);
+enum {
+	NS_IPC_INIT_SN	= 1,
+	NS_UTS_INIT_SN	= 2,
+	NS_USER_INIT_SN	= 3,
+	NS_PID_INIT_SN	= 4,
+};
+
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
 void exit_task_namespaces(struct task_struct *tsk);
 void switch_task_namespaces(struct task_struct *tsk, struct nsproxy *new);
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 7246ef3..4d8023e 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -43,6 +43,7 @@ struct pid_namespace {
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	unsigned int proc_inum;
+	long long	serial_num;
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 4836ba3..159ac26 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -27,6 +27,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	long long	serial_num;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 239e277..8490197 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -24,6 +24,7 @@ struct uts_namespace {
 	struct new_utsname name;
 	struct user_namespace *user_ns;
 	unsigned int proc_inum;
+	long long	serial_num;
 };
 extern struct uts_namespace init_uts_ns;
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 361d260..5238a06 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -61,6 +61,7 @@ struct net {
 	struct user_namespace   *user_ns;	/* Owning user namespace */
 
 	unsigned int		proc_inum;
+	long long	serial_num;
 
 	struct proc_dir_entry 	*proc_net;
 	struct proc_dir_entry 	*proc_net_stat;
diff --git a/init/version.c b/init/version.c
index 1a4718e..cfdcb85 100644
--- a/init/version.c
+++ b/init/version.c
@@ -36,6 +36,7 @@ struct uts_namespace init_uts_ns = {
 	},
 	.user_ns = &init_user_ns,
 	.proc_inum = PROC_UTS_INIT_INO,
+	.serial_num = NS_UTS_INIT_SN /* ns_serial() */,
 };
 EXPORT_SYMBOL_GPL(init_uts_ns);
 
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 7e70959..9aa66ae 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -32,6 +32,7 @@ struct ipc_namespace init_ipc_ns = {
 	.count		= ATOMIC_INIT(1),
 	.user_ns = &init_user_ns,
 	.proc_inum = PROC_IPC_INIT_INO,
+	.serial_num = NS_IPC_INIT_SN /* ns_serial() */,
 };
 
 atomic_t nr_ipc_ns = ATOMIC_INIT(1);
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 59451c1..76dac5c 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -41,6 +41,8 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	}
 	atomic_inc(&nr_ipc_ns);
 
+	ns->serial_num = ns_serial();
+
 	sem_init_ns(ns);
 	msg_init_ns(ns);
 	shm_init_ns(ns);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..93cb380 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -41,6 +41,23 @@ struct nsproxy init_nsproxy = {
 #endif
 };
 
+/**
+ * ns_serial - compute a serial number for the namespace
+ *
+ * Compute a serial number for the namespace to uniquely identify it in
+ * audit records.
+ */
+long long ns_serial(void)
+{
+	static atomic64_t serial = ATOMIC_INIT(4); /* reserved for IPC, UTS, user, PID */
+	long long ret;
+
+	ret = atomic64_add_return(1, &serial);
+	BUG_ON(!ret);
+
+	return ret;
+}
+
 static inline struct nsproxy *create_nsproxy(void)
 {
 	struct nsproxy *nsproxy;
diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..3bf7127 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -80,6 +80,7 @@ struct pid_namespace init_pid_ns = {
 	.child_reaper = &init_task,
 	.user_ns = &init_user_ns,
 	.proc_inum = PROC_PID_INIT_INO,
+	.serial_num = NS_PID_INIT_SN /* ns_serial() */,
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index db95d8e..40a8b36 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -109,6 +109,8 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 	if (err)
 		goto out_free_map;
 
+	ns->serial_num = ns_serial();
+
 	kref_init(&ns->kref);
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
diff --git a/kernel/user.c b/kernel/user.c
index 4efa393..2f597e0 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.serial_num = NS_USER_INIT_SN /* ns_serial() */,
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index fcc0256..5c5c399 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -92,6 +92,8 @@ int create_user_ns(struct cred *new)
 		return ret;
 	}
 
+	ns->serial_num = ns_serial();
+
 	atomic_set(&ns->count, 1);
 	/* Leave the new->user_ns reference with the new user namespace. */
 	ns->parent = parent_ns;
diff --git a/kernel/utsname.c b/kernel/utsname.c
index fd39312..d0cf7b5 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -48,6 +48,8 @@ static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
 		return ERR_PTR(err);
 	}
 
+	ns->serial_num = ns_serial();
+
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
 	ns->user_ns = get_user_ns(user_ns);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 85b6269..3b5cfdb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -384,7 +384,13 @@ EXPORT_SYMBOL_GPL(get_net_ns_by_pid);
 
 static __net_init int net_ns_net_init(struct net *net)
 {
-	return proc_alloc_inum(&net->proc_inum);
+	int ret;
+
+	ret = proc_alloc_inum(&net->proc_inum);
+	if (ret)
+		return ret;
+	net->serial_num = ns_serial();
+	return 0;
 }
 
 static __net_exit void net_ns_net_exit(struct net *net)
-- 
1.7.1
