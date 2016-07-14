From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/5] namespaces: move user_ns into ns_common
Date: Thu, 14 Jul 2016 11:20:15 -0700
Message-ID: <1468520419-28220-2-git-send-email-avagin@openvz.org>
References: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468520419-28220-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, containers@lists.linux-foundation.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

Every namespace has a pointer to an user namespace where is was created,
but they're all privately embedded in the individual namespace specific
structures.

Now we are going to add an user-space interface to get an owning user
namespace, so it looks reasonable to move it into ns_common.

Originally this idea was suggested by James Bottomley.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 drivers/net/bonding/bond_main.c         |  2 +-
 drivers/net/tun.c                       |  4 ++--
 fs/mount.h                              |  1 -
 fs/namespace.c                          | 14 +++++++-------
 fs/pnode.c                              |  4 ++--
 fs/proc/root.c                          |  2 +-
 include/linux/cgroup.h                  |  1 -
 include/linux/ipc_namespace.h           |  3 ---
 include/linux/ns_common.h               |  1 +
 include/linux/pid_namespace.h           |  1 -
 include/linux/user_namespace.h          |  8 ++++++--
 include/linux/utsname.h                 |  1 -
 include/net/net_namespace.h             |  1 -
 init/version.c                          |  2 +-
 ipc/mqueue.c                            |  2 +-
 ipc/msgutil.c                           |  2 +-
 ipc/namespace.c                         |  6 +++---
 ipc/shm.c                               |  2 +-
 ipc/util.c                              |  4 ++--
 kernel/cgroup.c                         | 12 ++++++------
 kernel/pid.c                            |  2 +-
 kernel/pid_namespace.c                  |  8 ++++----
 kernel/reboot.c                         |  2 +-
 kernel/sys.c                            |  4 ++--
 kernel/user_namespace.c                 |  4 ++++
 kernel/utsname.c                        |  6 +++---
 net/8021q/vlan.c                        | 12 ++++++------
 net/bridge/br_ioctl.c                   | 22 +++++++++++-----------
 net/bridge/br_sysfs_br.c                |  4 ++--
 net/bridge/br_sysfs_if.c                |  2 +-
 net/bridge/netfilter/ebtables.c         |  8 ++++----
 net/core/dev_ioctl.c                    |  4 ++--
 net/core/ethtool.c                      |  2 +-
 net/core/neighbour.c                    |  2 +-
 net/core/net-sysfs.c                    |  6 +++---
 net/core/net_namespace.c                |  6 +++---
 net/core/rtnetlink.c                    |  6 +++---
 net/core/scm.c                          |  2 +-
 net/core/sock.c                         | 10 +++++-----
 net/core/sock_diag.c                    |  2 +-
 net/core/sysctl_net_core.c              |  2 +-
 net/ieee802154/6lowpan/reassembly.c     |  2 +-
 net/ieee802154/socket.c                 |  8 ++++----
 net/ipv4/af_inet.c                      |  4 ++--
 net/ipv4/arp.c                          |  2 +-
 net/ipv4/devinet.c                      |  4 ++--
 net/ipv4/fib_frontend.c                 |  2 +-
 net/ipv4/ip_options.c                   |  6 +++---
 net/ipv4/ip_sockglue.c                  |  6 +++---
 net/ipv4/ip_tunnel.c                    |  4 ++--
 net/ipv4/ipmr.c                         |  2 +-
 net/ipv4/netfilter/arp_tables.c         |  8 ++++----
 net/ipv4/netfilter/ip_tables.c          |  8 ++++----
 net/ipv4/route.c                        |  2 +-
 net/ipv4/tcp.c                          |  2 +-
 net/ipv4/tcp_cong.c                     |  2 +-
 net/ipv6/addrconf.c                     |  4 ++--
 net/ipv6/af_inet6.c                     |  4 ++--
 net/ipv6/anycast.c                      |  2 +-
 net/ipv6/datagram.c                     |  6 +++---
 net/ipv6/ip6_flowlabel.c                |  2 +-
 net/ipv6/ip6_gre.c                      |  4 ++--
 net/ipv6/ip6_tunnel.c                   |  4 ++--
 net/ipv6/ip6_vti.c                      |  4 ++--
 net/ipv6/ip6mr.c                        |  2 +-
 net/ipv6/ipv6_sockglue.c                |  8 ++++----
 net/ipv6/netfilter/ip6_tables.c         |  8 ++++----
 net/ipv6/reassembly.c                   |  2 +-
 net/ipv6/route.c                        |  4 ++--
 net/ipv6/sit.c                          |  8 ++++----
 net/key/af_key.c                        |  2 +-
 net/llc/af_llc.c                        |  2 +-
 net/netfilter/ipset/ip_set_core.c       |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c          |  6 +++---
 net/netfilter/ipvs/ip_vs_lblc.c         |  2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c        |  2 +-
 net/netfilter/nf_conntrack_acct.c       |  2 +-
 net/netfilter/nf_conntrack_ecache.c     |  2 +-
 net/netfilter/nf_conntrack_expect.c     |  4 ++--
 net/netfilter/nf_conntrack_helper.c     |  2 +-
 net/netfilter/nf_conntrack_proto_dccp.c |  2 +-
 net/netfilter/nf_conntrack_standalone.c |  6 +++---
 net/netfilter/nf_conntrack_timestamp.c  |  2 +-
 net/netfilter/nfnetlink_log.c           |  4 ++--
 net/netfilter/x_tables.c                |  4 ++--
 net/netlink/af_netlink.c                |  8 ++++----
 net/netlink/genetlink.c                 |  2 +-
 net/packet/af_packet.c                  |  2 +-
 net/sched/cls_api.c                     |  2 +-
 net/sched/sch_api.c                     |  6 +++---
 net/sctp/socket.c                       |  6 +++---
 net/sysctl_net.c                        |  6 +++---
 net/unix/sysctl_net_unix.c              |  2 +-
 net/xfrm/xfrm_sysctl.c                  |  2 +-
 94 files changed, 197 insertions(+), 196 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a2afa3b..5ebe22a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3425,7 +3425,7 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 
 	net = dev_net(bond_dev);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e16487c..2730608 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -487,7 +487,7 @@ static inline bool tun_not_capable(struct tun_struct *tun)
 
 	return ((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
 		  (gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
-		!ns_capable(net->user_ns, CAP_NET_ADMIN);
+		!ns_capable(net->ns.user_ns, CAP_NET_ADMIN);
 }
 
 static void tun_set_real_num_queues(struct tun_struct *tun)
@@ -1737,7 +1737,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		int queues = ifr->ifr_flags & IFF_MULTI_QUEUE ?
 			     MAX_TAP_QUEUES : 1;
 
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		err = security_tun_dev_create();
 		if (err < 0)
diff --git a/fs/mount.h b/fs/mount.h
index 14db05d..532dd92 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -9,7 +9,6 @@ struct mnt_namespace {
 	struct ns_common	ns;
 	struct mount *	root;
 	struct list_head	list;
-	struct user_namespace	*user_ns;
 	u64			seq;	/* Sequence number to prevent loops */
 	wait_queue_head_t poll;
 	u64 event;
diff --git a/fs/namespace.c b/fs/namespace.c
index 419f746..22b0dbc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1582,7 +1582,7 @@ out_unlock:
  */
 static inline bool may_mount(void)
 {
-	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
+	return ns_capable(current->nsproxy->mnt_ns->ns.user_ns, CAP_SYS_ADMIN);
 }
 
 static inline bool may_mandlock(void)
@@ -2187,7 +2187,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
 	    !(mnt_flags & MNT_NODEV)) {
 		/* Was the nodev implicitly added in mount? */
-		if ((mnt->mnt_ns->user_ns != &init_user_ns) &&
+		if ((mnt->mnt_ns->ns.user_ns != &init_user_ns) &&
 		    !(sb->s_type->fs_flags & FS_USERNS_DEV_MOUNT)) {
 			mnt_flags |= MNT_NODEV;
 		} else {
@@ -2386,7 +2386,7 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
 			int mnt_flags, const char *name, void *data)
 {
 	struct file_system_type *type;
-	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
+	struct user_namespace *user_ns = current->nsproxy->mnt_ns->ns.user_ns;
 	struct vfsmount *mnt;
 	int err;
 
@@ -2744,7 +2744,7 @@ dput_out:
 static void free_mnt_ns(struct mnt_namespace *ns)
 {
 	ns_free_inum(&ns->ns);
-	put_user_ns(ns->user_ns);
+	put_user_ns(ns->ns.user_ns);
 	kfree(ns);
 }
 
@@ -2777,7 +2777,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct user_namespace *user_ns)
 	INIT_LIST_HEAD(&new_ns->list);
 	init_waitqueue_head(&new_ns->poll);
 	new_ns->event = 0;
-	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->ns.user_ns = get_user_ns(user_ns);
 	return new_ns;
 }
 
@@ -2807,7 +2807,7 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 	namespace_lock();
 	/* First pass: copy the tree topology */
 	copy_flags = CL_COPY_UNBINDABLE | CL_EXPIRE;
-	if (user_ns != ns->user_ns)
+	if (user_ns != ns->ns.user_ns)
 		copy_flags |= CL_SHARED_TO_SLAVE | CL_UNPRIVILEGED;
 	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
 	if (IS_ERR(new)) {
@@ -3326,7 +3326,7 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	struct mnt_namespace *mnt_ns = to_mnt_ns(ns);
 	struct path root;
 
-	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
+	if (!ns_capable(mnt_ns->ns.user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_CHROOT) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
diff --git a/fs/pnode.c b/fs/pnode.c
index 9989970..e051f11 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -244,7 +244,7 @@ static int propagate_one(struct mount *m)
 	}
 		
 	/* Notice when we are propagating across user namespaces */
-	if (m->mnt_ns->user_ns != user_ns)
+	if (m->mnt_ns->ns.user_ns != user_ns)
 		type |= CL_UNPRIVILEGED;
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
@@ -286,7 +286,7 @@ int propagate_mnt(struct mount *dest_mnt, struct mountpoint *dest_mp,
 	 * propagate_one(); everything is serialized by namespace_sem,
 	 * so globals will do just fine.
 	 */
-	user_ns = current->nsproxy->mnt_ns->user_ns;
+	user_ns = current->nsproxy->mnt_ns->ns.user_ns;
 	last_dest = dest_mnt;
 	first_source = source_mnt;
 	last_source = source_mnt;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 0670278..aae5104 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -113,7 +113,7 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		options = data;
 
 		/* Does the mounter have privilege over the pid namespace? */
-		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		if (!ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN))
 			return ERR_PTR(-EPERM);
 	}
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a20320c..f531cc5 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -619,7 +619,6 @@ static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 struct cgroup_namespace {
 	atomic_t		count;
 	struct ns_common	ns;
-	struct user_namespace	*user_ns;
 	struct css_set          *root_cset;
 };
 
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 1eee6bc..0f9d806 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -56,9 +56,6 @@ struct ipc_namespace {
 	unsigned int    mq_msg_default;
 	unsigned int    mq_msgsize_default;
 
-	/* user_ns which owns the ipc ns */
-	struct user_namespace *user_ns;
-
 	struct ns_common ns;
 };
 
diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
index 85a5c8c..af2f30d 100644
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -4,6 +4,7 @@
 struct proc_ns_operations;
 
 struct ns_common {
+	struct user_namespace *user_ns; /* Owning user namespace */
 	atomic_long_t stashed;
 	const struct proc_ns_operations *ops;
 	unsigned int inum;
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 918b117..b1802c6 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -39,7 +39,6 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct fs_pin *bacct;
 #endif
-	struct user_namespace *user_ns;
 	struct work_struct proc_work;
 	kgid_t pid_gid;
 	int hide_pid;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 8297e5b..a941b44 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -27,11 +27,15 @@ struct user_namespace {
 	struct uid_gid_map	gid_map;
 	struct uid_gid_map	projid_map;
 	atomic_t		count;
-	struct user_namespace	*parent;
 	int			level;
 	kuid_t			owner;
 	kgid_t			group;
-	struct ns_common	ns;
+
+	/* ->ns.user_ns and ->parent are synonyms */
+	union {
+		struct user_namespace	*parent;
+		struct ns_common	ns;
+	};
 	unsigned long		flags;
 
 	/* Register of per-UID persistent keyrings for this namespace */
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 5093f58..78c9ef8 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -23,7 +23,6 @@ extern struct user_namespace init_user_ns;
 struct uts_namespace {
 	struct kref kref;
 	struct new_utsname name;
-	struct user_namespace *user_ns;
 	struct ns_common ns;
 };
 extern struct uts_namespace init_uts_ns;
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 4089abc..acb714e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -59,7 +59,6 @@ struct net {
 	struct list_head	cleanup_list;	/* namespaces on death row */
 	struct list_head	exit_list;	/* Use only net_mutex */
 
-	struct user_namespace   *user_ns;	/* Owning user namespace */
 	spinlock_t		nsid_lock;
 	struct idr		netns_ids;
 
diff --git a/init/version.c b/init/version.c
index fe41a63..51ac701 100644
--- a/init/version.c
+++ b/init/version.c
@@ -34,7 +34,7 @@ struct uts_namespace init_uts_ns = {
 		.machine	= UTS_MACHINE,
 		.domainname	= UTS_DOMAINNAME,
 	},
-	.user_ns = &init_user_ns,
+	.ns.user_ns = &init_user_ns,
 	.ns.inum = PROC_UTS_INIT_INO,
 #ifdef CONFIG_UTS_NS
 	.ns.ops = &utsns_operations,
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ade739f..378cec6 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -331,7 +331,7 @@ static struct dentry *mqueue_mount(struct file_system_type *fs_type,
 		/* Don't allow mounting unless the caller has CAP_SYS_ADMIN
 		 * over the ipc namespace.
 		 */
-		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+		if (!ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN))
 			return ERR_PTR(-EPERM);
 
 		data = ns;
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index ed81aaf..b2e570c 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -30,7 +30,7 @@ DEFINE_SPINLOCK(mq_lock);
  */
 struct ipc_namespace init_ipc_ns = {
 	.count		= ATOMIC_INIT(1),
-	.user_ns = &init_user_ns,
+	.ns.user_ns = &init_user_ns,
 	.ns.inum = PROC_IPC_INIT_INO,
 #ifdef CONFIG_IPC_NS
 	.ns.ops = &ipcns_operations,
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 068caf1..d9f663b8 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -46,7 +46,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	msg_init_ns(ns);
 	shm_init_ns(ns);
 
-	ns->user_ns = get_user_ns(user_ns);
+	ns->ns.user_ns = get_user_ns(user_ns);
 
 	return ns;
 }
@@ -97,7 +97,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	shm_exit_ns(ns);
 	atomic_dec(&nr_ipc_ns);
 
-	put_user_ns(ns->user_ns);
+	put_user_ns(ns->ns.user_ns);
 	ns_free_inum(&ns->ns);
 	kfree(ns);
 }
@@ -155,7 +155,7 @@ static void ipcns_put(struct ns_common *ns)
 static int ipcns_install(struct nsproxy *nsproxy, struct ns_common *new)
 {
 	struct ipc_namespace *ns = to_ipc_ns(new);
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	if (!ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/ipc/shm.c b/ipc/shm.c
index 1328251..20546f1 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -1024,7 +1024,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			goto out_unlock0;
 		}
 
-		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
+		if (!ns_capable(ns->ns.user_ns, CAP_IPC_LOCK)) {
 			kuid_t euid = current_euid();
 			if (!uid_eq(euid, shp->shm_perm.uid) &&
 			    !uid_eq(euid, shp->shm_perm.cuid)) {
diff --git a/ipc/util.c b/ipc/util.c
index 798cad1..2a1a700 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -491,7 +491,7 @@ int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
 		granted_mode >>= 3;
 	/* is there some bit set in requested_mode but not in granted_mode? */
 	if ((requested_mode & ~granted_mode & 0007) &&
-	    !ns_capable(ns->user_ns, CAP_IPC_OWNER))
+	    !ns_capable(ns->ns.user_ns, CAP_IPC_OWNER))
 		return -1;
 
 	return security_ipc_permission(ipcp, flag);
@@ -700,7 +700,7 @@ struct kern_ipc_perm *ipcctl_pre_down_nolock(struct ipc_namespace *ns,
 
 	euid = current_euid();
 	if (uid_eq(euid, ipcp->cuid) || uid_eq(euid, ipcp->uid)  ||
-	    ns_capable(ns->user_ns, CAP_SYS_ADMIN))
+	    ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN))
 		return ipcp; /* successful lookup */
 err:
 	return ERR_PTR(err);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 75c0ff0..3635600 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -221,7 +221,7 @@ static u16 have_free_callback __read_mostly;
 /* cgroup namespace for init task */
 struct cgroup_namespace init_cgroup_ns = {
 	.count		= { .counter = 2, },
-	.user_ns	= &init_user_ns,
+	.ns.user_ns	= &init_user_ns,
 	.ns.ops		= &cgroupns_operations,
 	.ns.inum	= PROC_CGROUP_INIT_INO,
 	.root_cset	= &init_css_set,
@@ -2094,7 +2094,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	get_cgroup_ns(ns);
 
 	/* Check if the caller has permission to mount. */
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
+	if (!ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN)) {
 		put_cgroup_ns(ns);
 		return ERR_PTR(-EPERM);
 	}
@@ -5609,7 +5609,7 @@ int __init cgroup_init(void)
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_dfl_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_legacy_base_files));
 
-	get_user_ns(init_cgroup_ns.user_ns);
+	get_user_ns(init_cgroup_ns.ns.user_ns);
 
 	mutex_lock(&cgroup_mutex);
 
@@ -6285,7 +6285,7 @@ static struct cgroup_namespace *alloc_cgroup_ns(void)
 void free_cgroup_ns(struct cgroup_namespace *ns)
 {
 	put_css_set(ns->root_cset);
-	put_user_ns(ns->user_ns);
+	put_user_ns(ns->ns.user_ns);
 	ns_free_inum(&ns->ns);
 	kfree(ns);
 }
@@ -6324,7 +6324,7 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 		return new_ns;
 	}
 
-	new_ns->user_ns = get_user_ns(user_ns);
+	new_ns->ns.user_ns = get_user_ns(user_ns);
 	new_ns->root_cset = cset;
 
 	return new_ns;
@@ -6340,7 +6340,7 @@ static int cgroupns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	struct cgroup_namespace *cgroup_ns = to_cg_ns(ns);
 
 	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
-	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
+	    !ns_capable(cgroup_ns->ns.user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Don't need to do anything if we are attaching to our own cgroupns. */
diff --git a/kernel/pid.c b/kernel/pid.c
index f66162f..c63f992d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -78,7 +78,7 @@ struct pid_namespace init_pid_ns = {
 	.nr_hashed = PIDNS_HASH_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
-	.user_ns = &init_user_ns,
+	.ns.user_ns = &init_user_ns,
 	.ns.inum = PROC_PID_INIT_INO,
 #ifdef CONFIG_PID_NS
 	.ns.ops = &pidns_operations,
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a65ba13..3529a03 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -113,7 +113,7 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 	kref_init(&ns->kref);
 	ns->level = level;
 	ns->parent = get_pid_ns(parent_pid_ns);
-	ns->user_ns = get_user_ns(user_ns);
+	ns->ns.user_ns = get_user_ns(user_ns);
 	ns->nr_hashed = PIDNS_HASH_ADDING;
 	INIT_WORK(&ns->proc_work, proc_cleanup_work);
 
@@ -146,7 +146,7 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 	ns_free_inum(&ns->ns);
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
-	put_user_ns(ns->user_ns);
+	put_user_ns(ns->ns.user_ns);
 	call_rcu(&ns->rcu, delayed_free_pidns);
 }
 
@@ -276,7 +276,7 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 	struct pid_namespace *pid_ns = task_active_pid_ns(current);
 	struct ctl_table tmp = *table;
 
-	if (write && !ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
+	if (write && !ns_capable(pid_ns->ns.user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/*
@@ -362,7 +362,7 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	struct pid_namespace *active = task_active_pid_ns(current);
 	struct pid_namespace *ancestor, *new = to_pid_ns(ns);
 
-	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN) ||
+	if (!ns_capable(new->ns.user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index bd30a97..38f81a6 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -285,7 +285,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	int ret = 0;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!ns_capable(pid_ns->user_ns, CAP_SYS_BOOT))
+	if (!ns_capable(pid_ns->ns.user_ns, CAP_SYS_BOOT))
 		return -EPERM;
 
 	/* For safety, we require "magic" arguments. */
diff --git a/kernel/sys.c b/kernel/sys.c
index 89d5be4..9db5647 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1217,7 +1217,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->ns.user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	if (len < 0 || len > __NEW_UTS_LEN)
@@ -1268,7 +1268,7 @@ SYSCALL_DEFINE2(setdomainname, char __user *, name, int, len)
 	int errno;
 	char tmp[__NEW_UTS_LEN];
 
-	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
+	if (!ns_capable(current->nsproxy->uts_ns->ns.user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	if (len < 0 || len > __NEW_UTS_LEN)
 		return -EINVAL;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 9bafc21..a5bc78c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -96,6 +96,10 @@ int create_user_ns(struct cred *new)
 	ns->ns.ops = &userns_operations;
 
 	atomic_set(&ns->count, 1);
+
+	/* ->ns.user_ns and ->parent are synonyms. */
+	BUILD_BUG_ON(&ns->ns.user_ns != &ns->parent);
+
 	/* Leave the new->user_ns reference with the new user namespace. */
 	ns->parent = parent_ns;
 	ns->level = parent_ns->level + 1;
diff --git a/kernel/utsname.c b/kernel/utsname.c
index 831ea71..40a119a 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -52,7 +52,7 @@ static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
-	ns->user_ns = get_user_ns(user_ns);
+	ns->ns.user_ns = get_user_ns(user_ns);
 	up_read(&uts_sem);
 	return ns;
 }
@@ -85,7 +85,7 @@ void free_uts_ns(struct kref *kref)
 	struct uts_namespace *ns;
 
 	ns = container_of(kref, struct uts_namespace, kref);
-	put_user_ns(ns->user_ns);
+	put_user_ns(ns->ns.user_ns);
 	ns_free_inum(&ns->ns);
 	kfree(ns);
 }
@@ -120,7 +120,7 @@ static int utsns_install(struct nsproxy *nsproxy, struct ns_common *new)
 {
 	struct uts_namespace *ns = to_uts_ns(new);
 
-	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
+	if (!ns_capable(ns->ns.user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 82a116b..6c46a80 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -541,7 +541,7 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 	switch (args.cmd) {
 	case SET_VLAN_INGRESS_PRIORITY_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		vlan_dev_set_ingress_priority(dev,
 					      args.u.skb_priority,
@@ -551,7 +551,7 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 
 	case SET_VLAN_EGRESS_PRIORITY_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = vlan_dev_set_egress_priority(dev,
 						   args.u.skb_priority,
@@ -560,7 +560,7 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 
 	case SET_VLAN_FLAG_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = vlan_dev_change_flags(dev,
 					    args.vlan_qos ? args.u.flag : 0,
@@ -569,7 +569,7 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 
 	case SET_VLAN_NAME_TYPE_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		if ((args.u.name_type >= 0) &&
 		    (args.u.name_type < VLAN_NAME_TYPE_HIGHEST)) {
@@ -585,14 +585,14 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 
 	case ADD_VLAN_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = register_vlan_device(dev, args.u.VID);
 		break;
 
 	case DEL_VLAN_CMD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		unregister_vlan_dev(dev, NULL);
 		err = 0;
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index d99b200..2fdea4f 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -90,7 +90,7 @@ static int add_del_if(struct net_bridge *br, int ifindex, int isadd)
 	struct net_device *dev;
 	int ret;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	dev = __dev_get_by_index(net, ifindex);
@@ -182,28 +182,28 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	}
 
 	case BRCTL_SET_BRIDGE_FORWARD_DELAY:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		ret = br_set_forward_delay(br, args[1]);
 		break;
 
 	case BRCTL_SET_BRIDGE_HELLO_TIME:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		ret = br_set_hello_time(br, args[1]);
 		break;
 
 	case BRCTL_SET_BRIDGE_MAX_AGE:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		ret = br_set_max_age(br, args[1]);
 		break;
 
 	case BRCTL_SET_AGEING_TIME:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		ret = br_set_ageing_time(br, args[1]);
@@ -243,7 +243,7 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	}
 
 	case BRCTL_SET_BRIDGE_STP_STATE:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		br_stp_set_enabled(br, args[1]);
@@ -251,7 +251,7 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		break;
 
 	case BRCTL_SET_BRIDGE_PRIORITY:
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		br_stp_set_bridge_priority(br, args[1]);
@@ -260,7 +260,7 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	case BRCTL_SET_PORT_PRIORITY:
 	{
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		spin_lock_bh(&br->lock);
@@ -274,7 +274,7 @@ static int old_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	case BRCTL_SET_PATH_COST:
 	{
-		if (!ns_capable(dev_net(dev)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(dev_net(dev)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		spin_lock_bh(&br->lock);
@@ -337,7 +337,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
 	{
 		char buf[IFNAMSIZ];
 
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(buf, (void __user *)args[1], IFNAMSIZ))
@@ -367,7 +367,7 @@ int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd, void __user *uar
 	{
 		char buf[IFNAMSIZ];
 
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(buf, uarg, IFNAMSIZ))
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index beb4707..06d417e 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -36,7 +36,7 @@ static ssize_t store_bridge_parm(struct device *d,
 	unsigned long val;
 	int err;
 
-	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(br->dev)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	val = simple_strtoul(buf, &endp, 0);
@@ -285,7 +285,7 @@ static ssize_t group_addr_store(struct device *d,
 	u8 new_addr[6];
 	int i;
 
-	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(br->dev)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (sscanf(buf, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 1e04d4d..e7ceab1 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -241,7 +241,7 @@ static ssize_t brport_store(struct kobject *kobj,
 	char *endp;
 	unsigned long val;
 
-	if (!ns_capable(dev_net(p->dev)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(dev_net(p->dev)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	val = simple_strtoul(buf, &endp, 0);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5a61f35..dab0cc2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1496,7 +1496,7 @@ static int do_ebt_set_ctl(struct sock *sk,
 	int ret;
 	struct net *net = sock_net(sk);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1519,7 +1519,7 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	struct ebt_table *t;
 	struct net *net = sock_net(sk);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (copy_from_user(&tmp, user, sizeof(tmp)))
@@ -2303,7 +2303,7 @@ static int compat_do_ebt_set_ctl(struct sock *sk,
 	int ret;
 	struct net *net = sock_net(sk);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -2327,7 +2327,7 @@ static int compat_do_ebt_get_ctl(struct sock *sk, int cmd,
 	struct ebt_table *t;
 	struct net *net = sock_net(sk);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	/* try real handler in case userland supplied needed padding */
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index b94b1d2..a705922 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -474,7 +474,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSIFNAME:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		dev_load(net, ifr.ifr_name);
 		rtnl_lock();
@@ -522,7 +522,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
 	case SIOCSHWTSTAMP:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		/* fall through */
 	case SIOCBONDSLAVEINFOQUERY:
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index f403481..27a3085 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2480,7 +2480,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GTUNABLE:
 		break;
 	default:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 	}
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 510cd62..8df69fd 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3169,7 +3169,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	}
 
 	/* Don't export sysctls to unprivileged users */
-	if (neigh_parms_net(p)->user_ns != &init_user_ns)
+	if (neigh_parms_net(p)->ns.user_ns != &init_user_ns)
 		t->neigh_vars[0].procname = NULL;
 
 	switch (neigh_parms_family(p)) {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7a0b616..eb20bc7 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -85,7 +85,7 @@ static ssize_t netdev_store(struct device *dev, struct device_attribute *attr,
 	unsigned long new;
 	int ret = -EINVAL;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	ret = kstrtoul(buf, 0, &new);
@@ -362,7 +362,7 @@ static ssize_t ifalias_store(struct device *dev, struct device_attribute *attr,
 	size_t count = len;
 	ssize_t ret;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	/* ignore trailing newline */
@@ -1390,7 +1390,7 @@ static bool net_current_may_mount(void)
 {
 	struct net *net = current->nsproxy->net_ns;
 
-	return ns_capable(net->user_ns, CAP_SYS_ADMIN);
+	return ns_capable(net->ns.user_ns, CAP_SYS_ADMIN);
 }
 
 static void *net_grab_current_ns(void)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 2c2eb1b..3433f0c 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -279,7 +279,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	atomic_set(&net->count, 1);
 	atomic_set(&net->passive, 1);
 	net->dev_base_seq = 1;
-	net->user_ns = user_ns;
+	net->ns.user_ns = user_ns;
 	idr_init(&net->netns_ids);
 	spin_lock_init(&net->nsid_lock);
 
@@ -444,7 +444,7 @@ static void cleanup_net(struct work_struct *work)
 	/* Finally it is safe to free my network namespace structure */
 	list_for_each_entry_safe(net, tmp, &net_exit_list, exit_list) {
 		list_del_init(&net->exit_list);
-		put_user_ns(net->user_ns);
+		put_user_ns(net->ns.user_ns);
 		net_drop_ns(net);
 	}
 }
@@ -987,7 +987,7 @@ static int netns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 {
 	struct net *net = to_net_ns(ns);
 
-	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
+	if (!ns_capable(net->ns.user_ns, CAP_SYS_ADMIN) ||
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d69c464..ea7ba06 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1785,7 +1785,7 @@ static int do_setlink(const struct sk_buff *skb,
 			err = PTR_ERR(net);
 			goto errout;
 		}
-		if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		if (!netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN)) {
 			put_net(net);
 			err = -EPERM;
 			goto errout;
@@ -2430,7 +2430,7 @@ replay:
 			return PTR_ERR(dest_net);
 
 		err = -EPERM;
-		if (!netlink_ns_capable(skb, dest_net->user_ns, CAP_NET_ADMIN))
+		if (!netlink_ns_capable(skb, dest_net->ns.user_ns, CAP_NET_ADMIN))
 			goto out;
 
 		if (tb[IFLA_LINK_NETNSID]) {
@@ -2442,7 +2442,7 @@ replay:
 				goto out;
 			}
 			err = -EPERM;
-			if (!netlink_ns_capable(skb, link_net->user_ns, CAP_NET_ADMIN))
+			if (!netlink_ns_capable(skb, link_net->ns.user_ns, CAP_NET_ADMIN))
 				goto out;
 		}
 
diff --git a/net/core/scm.c b/net/core/scm.c
index 2696aef..1a2301a 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -54,7 +54,7 @@ static __inline__ int scm_check_creds(struct ucred *creds)
 		return -EINVAL;
 
 	if ((creds->pid == task_tgid_vnr(current) ||
-	     ns_capable(task_active_pid_ns(current)->user_ns, CAP_SYS_ADMIN)) &&
+	     ns_capable(task_active_pid_ns(current)->ns.user_ns, CAP_SYS_ADMIN)) &&
 	    ((uid_eq(uid, cred->uid)   || uid_eq(uid, cred->euid) ||
 	      uid_eq(uid, cred->suid)) || ns_capable(cred->user_ns, CAP_SETUID)) &&
 	    ((gid_eq(gid, cred->gid)   || gid_eq(gid, cred->egid) ||
diff --git a/net/core/sock.c b/net/core/sock.c
index 08bf97e..321ca3c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL(sk_capable);
  */
 bool sk_net_capable(const struct sock *sk, int cap)
 {
-	return sk_ns_capable(sk, sock_net(sk)->user_ns, cap);
+	return sk_ns_capable(sk, sock_net(sk)->ns.user_ns, cap);
 }
 EXPORT_SYMBOL(sk_net_capable);
 
@@ -534,7 +534,7 @@ static int sock_setbindtodevice(struct sock *sk, char __user *optval,
 
 	/* Sorry... */
 	ret = -EPERM;
-	if (!ns_capable(net->user_ns, CAP_NET_RAW))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_RAW))
 		goto out;
 
 	ret = -EINVAL;
@@ -778,7 +778,7 @@ set_rcvbuf:
 
 	case SO_PRIORITY:
 		if ((val >= 0 && val <= 6) ||
-		    ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		    ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 			sk->sk_priority = val;
 		else
 			ret = -EPERM;
@@ -945,7 +945,7 @@ set_rcvbuf:
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 			ret = -EPERM;
 		else
 			sk->sk_mark = val;
@@ -1921,7 +1921,7 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 
 	switch (cmsg->cmsg_type) {
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 6b10573..7151b43 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -303,7 +303,7 @@ static int sock_diag_bind(struct net *net, int group)
 
 int sock_diag_destroy(struct sock *sk, int err)
 {
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (!sk->sk_prot->diag_destroy)
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 0df2aa6..6f6749d 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -441,7 +441,7 @@ static __net_init int sysctl_core_net_init(struct net *net)
 		tbl[0].data = &net->core.sysctl_somaxconn;
 
 		/* Don't export any sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns) {
+		if (net->ns.user_ns != &init_user_ns) {
 			tbl[0].procname = NULL;
 		}
 	}
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 30d875d..9d002f4 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -512,7 +512,7 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 		table[2].data = &ieee802154_lowpan->frags.timeout;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			table[0].procname = NULL;
 	}
 
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index e0bd013..6353184 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -895,8 +895,8 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		ro->want_ack = !!val;
 		break;
 	case WPAN_SECURITY:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN) &&
+		    !ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 			err = -EPERM;
 			break;
 		}
@@ -919,8 +919,8 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
 		}
 		break;
 	case WPAN_SECURITY_LEVEL:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN) &&
+		    !ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d39e9e4..bec3946 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -309,7 +309,7 @@ lookup_protocol:
 
 	err = -EPERM;
 	if (sock->type == SOCK_RAW && !kern &&
-	    !ns_capable(net->user_ns, CAP_NET_RAW))
+	    !ns_capable(net->ns.user_ns, CAP_NET_RAW))
 		goto out_rcu_unlock;
 
 	sock->ops = answer->ops;
@@ -475,7 +475,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	snum = ntohs(addr->sin_port);
 	err = -EACCES;
 	if (snum && snum < PROT_SOCK &&
-	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+	    !ns_capable(net->ns.user_ns, CAP_NET_BIND_SERVICE))
 		goto out;
 
 	/*      We keep a pair of addresses. rcv_saddr is the one
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 89a8cac4..22517fb 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1140,7 +1140,7 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	switch (cmd) {
 	case SIOCDARP:
 	case SIOCSARP:
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 	case SIOCGARP:
 		err = copy_from_user(&r, arg, sizeof(struct arpreq));
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e333bc8..fc8f1f2 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -961,7 +961,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 
 	case SIOCSIFFLAGS:
 		ret = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto out;
 		break;
 	case SIOCSIFADDR:	/* Set interface address (and family) */
@@ -969,7 +969,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	case SIOCSIFDSTADDR:	/* Set the destination address */
 	case SIOCSIFNETMASK: 	/* Set the netmask for the interface */
 		ret = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto out;
 		ret = -EINVAL;
 		if (sin->sin_family != AF_INET)
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index ef2ebeb..fbc7311 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -581,7 +581,7 @@ int ip_rt_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	switch (cmd) {
 	case SIOCADDRT:		/* Add a route */
 	case SIOCDELRT:		/* Delete a route */
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(&rt, arg, sizeof(rt)))
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 4d158ff..dda262e 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -407,7 +407,7 @@ int ip_options_compile(struct net *net,
 					optptr[2] += 8;
 					break;
 				default:
-					if (!skb && !ns_capable(net->user_ns, CAP_NET_RAW)) {
+					if (!skb && !ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 						pp_ptr = optptr + 3;
 						goto error;
 					}
@@ -442,7 +442,7 @@ int ip_options_compile(struct net *net,
 				opt->router_alert = optptr - iph;
 			break;
 		case IPOPT_CIPSO:
-			if ((!skb && !ns_capable(net->user_ns, CAP_NET_RAW)) || opt->cipso) {
+			if ((!skb && !ns_capable(net->ns.user_ns, CAP_NET_RAW)) || opt->cipso) {
 				pp_ptr = optptr;
 				goto error;
 			}
@@ -455,7 +455,7 @@ int ip_options_compile(struct net *net,
 		case IPOPT_SEC:
 		case IPOPT_SID:
 		default:
-			if (!skb && !ns_capable(net->user_ns, CAP_NET_RAW)) {
+			if (!skb && !ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 				pp_ptr = optptr;
 				goto error;
 			}
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 71a52f4d..474af75 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1138,14 +1138,14 @@ mc_msf_out:
 	case IP_IPSEC_POLICY:
 	case IP_XFRM_POLICY:
 		err = -EPERM;
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = xfrm_user_policy(sk, optname, optval, optlen);
 		break;
 
 	case IP_TRANSPARENT:
-		if (!!val && !ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!!val && !ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_RAW) &&
+		    !ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN)) {
 			err = -EPERM;
 			break;
 		}
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index d8f5e0a..4ddc520 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -765,7 +765,7 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 		if (p->iph.ttl)
 			p->iph.frag_off |= htons(IP_DF);
@@ -821,7 +821,7 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 
 	case SIOCDELTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		if (dev == itn->fb_tunnel_dev) {
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 5ad48ec..df292fa 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1272,7 +1272,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, char __user *optval,
 	}
 	if (optname != MRT_INIT) {
 		if (sk != rcu_access_pointer(mrt->mroute_sk) &&
-		    !ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+		    !ns_capable(net->ns.user_ns, CAP_NET_ADMIN)) {
 			ret = -EACCES;
 			goto out_unlock;
 		}
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2033f92..e123093 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1300,7 +1300,7 @@ static int compat_do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user,
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1434,7 +1434,7 @@ static int compat_do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user,
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1455,7 +1455,7 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1478,7 +1478,7 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 54906e0..b29238a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1554,7 +1554,7 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1656,7 +1656,7 @@ compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1678,7 +1678,7 @@ do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1702,7 +1702,7 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a1f2830..ddb0003 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2787,7 +2787,7 @@ static __net_init int sysctl_route_net_init(struct net *net)
 			goto err_dup;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			tbl[0].procname = NULL;
 	}
 	tbl[0].extra1 = net;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5c7ed14..467b6cc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2273,7 +2273,7 @@ EXPORT_SYMBOL(tcp_disconnect);
 
 static inline bool tcp_can_repair_sock(const struct sock *sk)
 {
-	return ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN) &&
+	return ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN) &&
 		((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_ESTABLISHED));
 }
 
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 882caa4..385d0f4 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -354,7 +354,7 @@ int tcp_set_congestion_control(struct sock *sk, const char *name)
 	if (!ca)
 		err = -ENOENT;
 	else if (!((ca->flags & TCP_CONG_NON_RESTRICTED) ||
-		   ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)))
+		   ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN)))
 		err = -EPERM;
 	else if (!try_module_get(ca->owner))
 		err = -EBUSY;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 47f837a..9aaabf8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2781,7 +2781,7 @@ int addrconf_add_ifaddr(struct net *net, void __user *arg)
 	struct in6_ifreq ireq;
 	int err;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (copy_from_user(&ireq, arg, sizeof(struct in6_ifreq)))
@@ -2800,7 +2800,7 @@ int addrconf_del_ifaddr(struct net *net, void __user *arg)
 	struct in6_ifreq ireq;
 	int err;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (copy_from_user(&ireq, arg, sizeof(struct in6_ifreq)))
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index bfa86f0..1491cbd 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -161,7 +161,7 @@ lookup_protocol:
 
 	err = -EPERM;
 	if (sock->type == SOCK_RAW && !kern &&
-	    !ns_capable(net->user_ns, CAP_NET_RAW))
+	    !ns_capable(net->ns.user_ns, CAP_NET_RAW))
 		goto out_rcu_unlock;
 
 	sock->ops = answer->ops;
@@ -286,7 +286,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		return -EINVAL;
 
 	snum = ntohs(addr->sin6_port);
-	if (snum && snum < PROT_SOCK && !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+	if (snum && snum < PROT_SOCK && !ns_capable(net->ns.user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
 	lock_sock(sk);
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index 514ac25..e168ca3 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -62,7 +62,7 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 
 	ASSERT_RTNL();
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 	if (ipv6_addr_is_multicast(addr))
 		return -EINVAL;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 37874e2..92204ba 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -837,7 +837,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
+			if (!ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 				err = -EPERM;
 				goto exit_f;
 			}
@@ -857,7 +857,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
+			if (!ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 				err = -EPERM;
 				goto exit_f;
 			}
@@ -882,7 +882,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 				err = -EINVAL;
 				goto exit_f;
 			}
-			if (!ns_capable(net->user_ns, CAP_NET_RAW)) {
+			if (!ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 				err = -EPERM;
 				goto exit_f;
 			}
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index b912f0d..c07e37e 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -569,7 +569,7 @@ int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 		rcu_read_unlock_bh();
 
 		if (freq.flr_share == IPV6_FL_S_NONE &&
-		    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
+		    ns_capable(net->ns.user_ns, CAP_NET_ADMIN)) {
 			fl = fl_lookup(net, freq.flr_label);
 			if (fl) {
 				err = fl6_renew(fl, freq.flr_linger, freq.flr_expires);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 776d145..7f23d34 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -852,7 +852,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		err = -EFAULT;
@@ -901,7 +901,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 
 	case SIOCDELTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		if (dev == ign->fb_tunnel_dev) {
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 7b0481e..fa9443c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1484,7 +1484,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
 		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
@@ -1520,7 +1520,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	case SIOCDELTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 
 		if (dev == ip6n->fb_tnl_dev) {
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index d90a11f..ece8758 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -743,7 +743,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
 		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
@@ -775,7 +775,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		break;
 	case SIOCDELTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 
 		if (dev == ip6n->fb_tnl_dev) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 487ef3b..87a6a20 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1669,7 +1669,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, char __user *optval, uns
 		return -ENOENT;
 
 	if (optname != MRT6_INIT) {
-		if (sk != mrt->mroute6_sk && !ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (sk != mrt->mroute6_sk && !ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EACCES;
 	}
 
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index a9895e1..d5dc2aa 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -365,8 +365,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case IPV6_TRANSPARENT:
-		if (valbool && !ns_capable(net->user_ns, CAP_NET_ADMIN) &&
-		    !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		if (valbool && !ns_capable(net->ns.user_ns, CAP_NET_ADMIN) &&
+		    !ns_capable(net->ns.user_ns, CAP_NET_RAW)) {
 			retv = -EPERM;
 			break;
 		}
@@ -404,7 +404,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 		/* hop-by-hop / destination options are privileged option */
 		retv = -EPERM;
-		if (optname != IPV6_RTHDR && !ns_capable(net->user_ns, CAP_NET_RAW))
+		if (optname != IPV6_RTHDR && !ns_capable(net->ns.user_ns, CAP_NET_RAW))
 			break;
 
 		opt = rcu_dereference_protected(np->opt,
@@ -785,7 +785,7 @@ done:
 	case IPV6_IPSEC_POLICY:
 	case IPV6_XFRM_POLICY:
 		retv = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			break;
 		retv = xfrm_user_policy(sk, optname, optval, optlen);
 		break;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 63e06c3..0f92561 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1573,7 +1573,7 @@ compat_do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user,
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1675,7 +1675,7 @@ compat_do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1697,7 +1697,7 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
@@ -1721,7 +1721,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	switch (cmd) {
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 2160d5d..4efbd91 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -645,7 +645,7 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 		table[2].data = &net->ipv6.frags.timeout;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			table[0].procname = NULL;
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 520b788..938a7aa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2468,7 +2468,7 @@ int ipv6_route_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	switch (cmd) {
 	case SIOCADDRT:		/* Add a route */
 	case SIOCDELRT:		/* Delete a route */
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		err = copy_from_user(&rtmsg, arg,
 				     sizeof(struct in6_rtmsg));
@@ -3594,7 +3594,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			table[0].procname = NULL;
 	}
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 0619ac7..196f476 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1181,7 +1181,7 @@ ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		err = -EFAULT;
@@ -1229,7 +1229,7 @@ ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	case SIOCDELTUNNEL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		if (dev == sitn->fb_tunnel_dev) {
@@ -1260,7 +1260,7 @@ ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCDELPRL:
 	case SIOCCHGPRL:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 		err = -EINVAL;
 		if (dev == sitn->fb_tunnel_dev)
@@ -1287,7 +1287,7 @@ ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCCHG6RD:
 	case SIOCDEL6RD:
 		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 			goto done;
 
 		err = -EFAULT;
diff --git a/net/key/af_key.c b/net/key/af_key.c
index f9c9ecb..47183e9 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -141,7 +141,7 @@ static int pfkey_create(struct net *net, struct socket *sock, int protocol,
 	struct sock *sk;
 	int err;
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 8ae3ed9..41c3da3 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -160,7 +160,7 @@ static int llc_ui_create(struct net *net, struct socket *sock, int protocol,
 	struct sock *sk;
 	int rc = -ESOCKTNOSUPPORT;
 
-	if (!ns_capable(net->user_ns, CAP_NET_RAW))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_RAW))
 		return -EPERM;
 
 	if (!net_eq(net, &init_net))
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a748b0c..46745a7 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1901,7 +1901,7 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
 	struct net *net = sock_net(sk);
 	struct ip_set_net *inst = ip_set_pernet(net);
 
-	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 	if (optval != SO_IP_SET)
 		return -EBADF;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c3c809b..a02b3b3 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2360,7 +2360,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	struct netns_ipvs *ipvs = net_ipvs(net);
 
 	BUILD_BUG_ON(sizeof(arg) > 255);
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX)
@@ -2678,7 +2678,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 
 	BUG_ON(!net);
 	BUILD_BUG_ON(sizeof(arg) > 255);
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+	if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_GET_MAX)
@@ -3906,7 +3906,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 			return -ENOMEM;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			tbl[0].procname = NULL;
 	} else
 		tbl = vs_vars;
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index cccf4d6..23a3ec3 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -564,7 +564,7 @@ static int __net_init __ip_vs_lblc_init(struct net *net)
 			return -ENOMEM;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			ipvs->lblc_ctl_table[0].procname = NULL;
 
 	} else
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 796d70e..704ad5c 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -750,7 +750,7 @@ static int __net_init __ip_vs_lblcr_init(struct net *net)
 			return -ENOMEM;
 
 		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
+		if (net->ns.user_ns != &init_user_ns)
 			ipvs->lblcr_ctl_table[0].procname = NULL;
 	} else
 		ipvs->lblcr_ctl_table = vs_vars_table;
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 45da11a..9303901 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -74,7 +74,7 @@ static int nf_conntrack_acct_init_sysctl(struct net *net)
 	table[0].data = &net->ct.sysctl_acct;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->ct.acct_sysctl_header = register_net_sysctl(net, "net/netfilter",
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index d28011b..22411e5 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -358,7 +358,7 @@ static int nf_conntrack_event_init_sysctl(struct net *net)
 	table[0].data = &net->ct.sysctl_events;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->ct.event_sysctl_header =
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 9e36931..c1e6242 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -618,8 +618,8 @@ static int exp_proc_init(struct net *net)
 	if (!proc)
 		return -ENOMEM;
 
-	root_uid = make_kuid(net->user_ns, 0);
-	root_gid = make_kgid(net->user_ns, 0);
+	root_uid = make_kuid(net->ns.user_ns, 0);
+	root_gid = make_kgid(net->ns.user_ns, 0);
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 #endif /* CONFIG_NF_CONNTRACK_PROCFS */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 196cb39..4cff85b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -67,7 +67,7 @@ static int nf_conntrack_helper_init_sysctl(struct net *net)
 	table[0].data = &net->ct.sysctl_auto_assign_helper;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->ct.helper_sysctl_header =
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 399a38f..766dbee 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -841,7 +841,7 @@ static int dccp_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *pn,
 	pn->ctl_table[7].data = &dn->dccp_loose;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		pn->ctl_table[0].procname = NULL;
 #endif
 	return 0;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c026c47..8796e36 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -397,8 +397,8 @@ static int nf_conntrack_standalone_init_proc(struct net *net)
 	if (!pde)
 		goto out_nf_conntrack;
 
-	root_uid = make_kuid(net->user_ns, 0);
-	root_gid = make_kgid(net->user_ns, 0);
+	root_uid = make_kuid(net->ns.user_ns, 0);
+	root_gid = make_kgid(net->ns.user_ns, 0);
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(pde, root_uid, root_gid);
 
@@ -512,7 +512,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[4].data = &net->ct.sysctl_log_invalid;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index 7a394df..43bd240 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -52,7 +52,7 @@ static int nf_conntrack_tstamp_init_sysctl(struct net *net)
 	table[0].data = &net->ct.sysctl_tstamp;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->ct.tstamp_sysctl_header = register_net_sysctl(net,	"net/netfilter",
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 11f81c8..5428b8e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1072,8 +1072,8 @@ static int __net_init nfnl_log_net_init(struct net *net)
 	if (!proc)
 		return -ENOMEM;
 
-	root_uid = make_kuid(net->user_ns, 0);
-	root_gid = make_kgid(net->user_ns, 0);
+	root_uid = make_kuid(net->ns.user_ns, 0);
+	root_gid = make_kgid(net->ns.user_ns, 0);
 	if (uid_valid(root_uid) && gid_valid(root_gid))
 		proc_set_user(proc, root_uid, root_gid);
 #endif
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2675d58..d840aa6 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1493,8 +1493,8 @@ int xt_proto_init(struct net *net, u_int8_t af)
 
 
 #ifdef CONFIG_PROC_FS
-	root_uid = make_kuid(net->user_ns, 0);
-	root_gid = make_kgid(net->user_ns, 0);
+	root_uid = make_kuid(net->ns.user_ns, 0);
+	root_gid = make_kgid(net->ns.user_ns, 0);
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 627f898..070e24d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -828,14 +828,14 @@ EXPORT_SYMBOL(netlink_capable);
  */
 bool netlink_net_capable(const struct sk_buff *skb, int cap)
 {
-	return netlink_ns_capable(skb, sock_net(skb->sk)->user_ns, cap);
+	return netlink_ns_capable(skb, sock_net(skb->sk)->ns.user_ns, cap);
 }
 EXPORT_SYMBOL(netlink_net_capable);
 
 static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
-		ns_capable(sock_net(sock->sk)->user_ns, CAP_NET_ADMIN);
+		ns_capable(sock_net(sock->sk)->ns.user_ns, CAP_NET_ADMIN);
 }
 
 static void
@@ -1323,7 +1323,7 @@ static void do_one_broadcast(struct sock *sk,
 		if (!peernet_has_id(sock_net(sk), p->net))
 			return;
 
-		if (!file_ns_capable(sk->sk_socket->file, p->net->user_ns,
+		if (!file_ns_capable(sk->sk_socket->file, p->net->ns.user_ns,
 				     CAP_NET_BROADCAST))
 			return;
 	}
@@ -1586,7 +1586,7 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 		err = 0;
 		break;
 	case NETLINK_LISTEN_ALL_NSID:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_BROADCAST))
+		if (!ns_capable(sock_net(sk)->ns.user_ns, CAP_NET_BROADCAST))
 			return -EPERM;
 
 		if (val)
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index a09132a..831e863 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -561,7 +561,7 @@ static int genl_family_rcv_msg(struct genl_family *family,
 		return -EPERM;
 
 	if ((ops->flags & GENL_UNS_ADMIN_PERM) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+	    !netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP) {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 9f0983f..8172443 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3208,7 +3208,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	__be16 proto = (__force __be16)protocol; /* weird, but documented */
 	int err;
 
-	if (!ns_capable(net->user_ns, CAP_NET_RAW))
+	if (!ns_capable(net->ns.user_ns, CAP_NET_RAW))
 		return -EPERM;
 	if (sock->type != SOCK_DGRAM && sock->type != SOCK_RAW &&
 	    sock->type != SOCK_PACKET)
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a75864d..249a340 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -140,7 +140,7 @@ static int tc_ctl_tfilter(struct sk_buff *skb, struct nlmsghdr *n)
 	int tp_created = 0;
 
 	if ((n->nlmsg_type != RTM_GETTFILTER) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+	    !netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 replay:
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index ddf047d..783f495 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1123,7 +1123,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n)
 	int err;
 
 	if ((n->nlmsg_type != RTM_GETQDISC) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+	    !netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, NULL);
@@ -1190,7 +1190,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n)
 	struct Qdisc *q, *p;
 	int err;
 
-	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+	if (!netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 replay:
@@ -1539,7 +1539,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n)
 	int err;
 
 	if ((n->nlmsg_type != RTM_GETTCLASS) &&
-	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
+	    !netlink_ns_capable(skb, net->ns.user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, NULL);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 67154b8..bb65b08 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -361,7 +361,7 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	}
 
 	if (snum && snum < PROT_SOCK &&
-	    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
+	    !ns_capable(net->ns.user_ns, CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
 	/* See if the address matches any of the addresses we may have
@@ -1153,7 +1153,7 @@ static int __sctp_connect(struct sock *sk,
 				 * be permitted to open new associations.
 				 */
 				if (ep->base.bind_addr.port < PROT_SOCK &&
-				    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE)) {
+				    !ns_capable(net->ns.user_ns, CAP_NET_BIND_SERVICE)) {
 					err = -EACCES;
 					goto out_free;
 				}
@@ -1815,7 +1815,7 @@ static int sctp_sendmsg(struct sock *sk, struct msghdr *msg, size_t msg_len)
 			 * associations.
 			 */
 			if (ep->base.bind_addr.port < PROT_SOCK &&
-			    !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE)) {
+			    !ns_capable(net->ns.user_ns, CAP_NET_BIND_SERVICE)) {
 				err = -EACCES;
 				goto out_unlock;
 			}
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index ed98c1f..cb46bc9 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -42,11 +42,11 @@ static int net_ctl_permissions(struct ctl_table_header *head,
 			       struct ctl_table *table)
 {
 	struct net *net = container_of(head->set, struct net, sysctls);
-	kuid_t root_uid = make_kuid(net->user_ns, 0);
-	kgid_t root_gid = make_kgid(net->user_ns, 0);
+	kuid_t root_uid = make_kuid(net->ns.user_ns, 0);
+	kgid_t root_gid = make_kgid(net->ns.user_ns, 0);
 
 	/* Allow network administrator to have same access as root. */
-	if (ns_capable(net->user_ns, CAP_NET_ADMIN) ||
+	if (ns_capable(net->ns.user_ns, CAP_NET_ADMIN) ||
 	    uid_eq(root_uid, current_euid())) {
 		int mode = (table->mode >> 6) & 7;
 		return (mode << 6) | (mode << 3) | mode;
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index b3d5150..b5aec8a 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -35,7 +35,7 @@ int __net_init unix_sysctl_register(struct net *net)
 		goto err_alloc;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	table[0].data = &net->unx.sysctl_max_dgram_qlen;
diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
index 05a6e3d..8d4b41f 100644
--- a/net/xfrm/xfrm_sysctl.c
+++ b/net/xfrm/xfrm_sysctl.c
@@ -55,7 +55,7 @@ int __net_init xfrm_sysctl_init(struct net *net)
 	table[3].data = &net->xfrm.sysctl_acq_expires;
 
 	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
+	if (net->ns.user_ns != &init_user_ns)
 		table[0].procname = NULL;
 
 	net->xfrm.sysctl_hdr = register_net_sysctl(net, "net/core", table);
-- 
2.5.5
