From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 06/11] bpf,landlock: Add a new map type: inode
Date: Tue, 27 Feb 2018 01:41:16 +0100
Message-ID: <20180227004121.3633-7-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-11972-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho
List-Id: linux-api@vger.kernel.org

This new map store arbitrary 64-bits values referenced by inode keys.
The map can be updated from user space with file descriptor pointing to
inodes tied to a file system.  From an eBPF (Landlock) program point of
view, such a map is read-only and can only be used to retrieved a
64-bits value tied to a given inode.  This is useful to recognize an
inode tagged by user space, without access right to this inode (i.e. no
need to have a write access to this inode).

This also add new BPF map object types: landlock_tag_object and
landlock_chain.  The landlock_chain pointer is needed to be able to
handle multiple tags per inode.  The landlock_tag_object is needed to
update a reference to a list of shared tags.  This is typically used by
a struct file (reference) and a struct inode (shared list of tags).
This way, we can account the process/user for the number of tagged
files, while still being able to read the tags from the pointed inode.

Add dedicated BPF functions to handle this type of map:
* bpf_inode_map_update_elem()
* bpf_inode_map_lookup_elem()
* bpf_inode_map_delete_elem()

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Jann Horn <jann@thejh.net>
---

Changes since v7:
* new design with a dedicated map and a BPF function to tie a value to
  an inode
* add the ability to set or get a tag on an inode from a Landlock
  program

Changes since v6:
* remove WARN_ON() for missing dentry->d_inode
* refactor bpf_landlock_func_proto() (suggested by Kees Cook)

Changes since v5:
* cosmetic fixes and rebase

Changes since v4:
* use a file abstraction (handle) to wrap inode, dentry, path and file
  structs
* remove bpf_landlock_cmp_fs_beneath()
* rename the BPF helper and move it to kernel/bpf/
* tighten helpers accessible by a Landlock rule

Changes since v3:
* remove bpf_landlock_cmp_fs_prop() (suggested by Alexei Starovoitov)
* add hooks dealing with struct inode and struct path pointers:
  inode_permission and inode_getattr
* add abstraction over eBPF helper arguments thanks to wrapping structs
* add bpf_landlock_get_fs_mode() helper to check file type and mode
* merge WARN_ON() (suggested by Kees Cook)
* fix and update bpf_helpers.h
* use BPF_CALL_* for eBPF helpers (suggested by Alexei Starovoitov)
* make handle arraymap safe (RCU) and remove buggy synchronize_rcu()
* factor out the arraymay walk
* use size_t to index array (suggested by Jann Horn)

Changes since v2:
* add MNT_INTERNAL check to only add file handle from user-visible FS
  (e.g. no anonymous inode)
* replace struct file* with struct path* in map_landlock_handle
* add BPF protos
* fix bpf_landlock_cmp_fs_prop_with_struct_file()
---
 include/linux/bpf.h            |  18 ++
 include/linux/bpf_types.h      |   3 +
 include/linux/landlock.h       |  24 +++
 include/uapi/linux/bpf.h       |  22 ++-
 kernel/bpf/Makefile            |   3 +
 kernel/bpf/core.c              |   1 +
 kernel/bpf/helpers.c           |  38 +++++
 kernel/bpf/inodemap.c          | 318 +++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |  27 ++-
 kernel/bpf/verifier.c          |  25 +++
 security/landlock/Makefile     |   1 +
 security/landlock/tag.c        | 373 +++++++++++++++++++++++++++++++++++++++++
 security/landlock/tag.h        |  36 ++++
 security/landlock/tag_fs.c     |  59 +++++++
 security/landlock/tag_fs.h     |  26 +++
 tools/include/uapi/linux/bpf.h |  22 ++-
 16 files changed, 993 insertions(+), 3 deletions(-)
 create mode 100644 kernel/bpf/inodemap.c
 create mode 100644 security/landlock/tag.c
 create mode 100644 security/landlock/tag.h
 create mode 100644 security/landlock/tag_fs.c
 create mode 100644 security/landlock/tag_fs.h

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 377b2f3519f3..c9b940a44c3e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -127,6 +127,10 @@ enum bpf_arg_type {
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
+
+	ARG_PTR_TO_INODE,	/* pointer to a struct inode */
+	ARG_PTR_TO_LL_TAG_OBJ,	/* pointer to a struct landlock_tag_object */
+	ARG_PTR_TO_LL_CHAIN,	/* pointer to a struct landlock_chain */
 };
 
 /* type of values returned from helper functions */
@@ -184,6 +188,9 @@ enum bpf_reg_type {
 	PTR_TO_PACKET_META,	 /* skb->data - meta_len */
 	PTR_TO_PACKET,		 /* reg points to skb->data */
 	PTR_TO_PACKET_END,	 /* skb->data + headlen */
+	PTR_TO_INODE,		 /* reg points to struct inode */
+	PTR_TO_LL_TAG_OBJ,	 /* reg points to struct landlock_tag_object */
+	PTR_TO_LL_CHAIN,	 /* reg points to struct landlock_chain */
 };
 
 /* The information passed from prog-specific *_is_valid_access
@@ -306,6 +313,10 @@ struct bpf_event_entry {
 	struct rcu_head rcu;
 };
 
+
+u64 bpf_tail_call(u64 ctx, u64 r2, u64 index, u64 r4, u64 r5);
+u64 bpf_get_stackid(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
+
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
 int bpf_prog_calc_tag(struct bpf_prog *fp);
 
@@ -447,6 +458,10 @@ void bpf_fd_array_map_clear(struct bpf_map *map);
 int bpf_fd_htab_map_update_elem(struct bpf_map *map, struct file *map_file,
 				void *key, void *value, u64 map_flags);
 int bpf_fd_htab_map_lookup_elem(struct bpf_map *map, void *key, u32 *value);
+int bpf_inode_map_update_elem(struct bpf_map *map, int *key, u64 *value,
+			      u64 flags);
+int bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value);
+int bpf_inode_map_delete_elem(struct bpf_map *map, int *key);
 
 int bpf_get_file_flag(int flags);
 
@@ -686,6 +701,9 @@ extern const struct bpf_func_proto bpf_skb_vlan_push_proto;
 extern const struct bpf_func_proto bpf_skb_vlan_pop_proto;
 extern const struct bpf_func_proto bpf_get_stackid_proto;
 extern const struct bpf_func_proto bpf_sock_map_update_proto;
+extern const struct bpf_func_proto bpf_inode_map_lookup_proto;
+extern const struct bpf_func_proto bpf_inode_get_tag_proto;
+extern const struct bpf_func_proto bpf_landlock_set_tag_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 0ca019f3ae4a..44dca1fa9d01 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -50,3 +50,6 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKMAP, sock_map_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
 #endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_MAP_TYPE(BPF_MAP_TYPE_INODE, inode_ops)
+#endif
diff --git a/include/linux/landlock.h b/include/linux/landlock.h
index 933d65c00075..e85c2c0ab582 100644
--- a/include/linux/landlock.h
+++ b/include/linux/landlock.h
@@ -15,6 +15,30 @@
 #include <linux/errno.h>
 #include <linux/sched.h> /* task_struct */
 
+struct inode;
+struct landlock_chain;
+struct landlock_tag_object;
+
+#ifdef CONFIG_SECURITY_LANDLOCK
+extern u64 landlock_get_inode_tag(const struct inode *inode,
+		const struct landlock_chain *chain);
+extern int landlock_set_object_tag(struct landlock_tag_object *tag_obj,
+		struct landlock_chain *chain, u64 value);
+#else /* CONFIG_SECURITY_LANDLOCK */
+static inline u64 landlock_get_inode_tag(const struct inode *inode,
+		const struct landlock_chain *chain)
+{
+	WARN_ON(1);
+	return 0;
+}
+static inline int landlock_set_object_tag(struct landlock_tag_object *tag_obj,
+		struct landlock_chain *chain, u64 value)
+{
+	WARN_ON(1);
+	return -ENOTSUPP;
+}
+#endif /* CONFIG_SECURITY_LANDLOCK */
+
 #if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
 extern int landlock_seccomp_prepend_prog(unsigned int flags,
 		const int __user *user_bpf_fd);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2433aa1a0fd4..6dffd4ec7036 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -114,6 +114,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_DEVMAP,
 	BPF_MAP_TYPE_SOCKMAP,
 	BPF_MAP_TYPE_CPUMAP,
+	BPF_MAP_TYPE_INODE,
 };
 
 enum bpf_prog_type {
@@ -708,6 +709,22 @@ union bpf_attr {
  * int bpf_override_return(pt_regs, rc)
  *	@pt_regs: pointer to struct pt_regs
  *	@rc: the return value to set
+ *
+ * u64 bpf_inode_map_lookup(map, key)
+ *     @map: pointer to inode map
+ *     @key: pointer to inode
+ *     Return: value tied to this key, or zero if none
+ *
+ * u64 bpf_inode_get_tag(inode, chain)
+ *     @inode: pointer to struct inode
+ *     @chain: pointer to struct landlock_chain
+ *     Return: tag tied to this inode and chain, or zero if none
+ *
+ * int bpf_landlock_set_tag(tag_obj, chain, value)
+ *     @tag_obj: pointer pointing to a taggable object (e.g. inode)
+ *     @chain: pointer to struct landlock_chain
+ *     @value: value of the tag
+ *     Return: 0 on success or negative error code
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -769,7 +786,10 @@ union bpf_attr {
 	FN(perf_prog_read_value),	\
 	FN(getsockopt),			\
 	FN(override_return),		\
-	FN(sock_ops_cb_flags_set),
+	FN(sock_ops_cb_flags_set),	\
+	FN(inode_map_lookup),		\
+	FN(inode_get_tag),		\
+	FN(landlock_set_tag),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index a713fd23ec88..68069d9630e1 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -18,3 +18,6 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
 endif
 obj-$(CONFIG_CGROUP_BPF) += cgroup.o
+ifeq ($(CONFIG_SECURITY_LANDLOCK),y)
+obj-$(CONFIG_BPF_SYSCALL) += inodemap.o
+endif
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e4567f7434af..e32b184c0281 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1772,6 +1772,7 @@ const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_sock_map_update_proto __weak;
+const struct bpf_func_proto bpf_inode_map_update_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3d24e238221e..794bd6f604fc 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/uidgid.h>
 #include <linux/filter.h>
+#include <linux/landlock.h>
 
 /* If kernel subsystem is allowing eBPF programs to call this function,
  * inside its own verifier_ops->get_func_proto() callback it should return
@@ -179,3 +180,40 @@ const struct bpf_func_proto bpf_get_current_comm_proto = {
 	.arg1_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg2_type	= ARG_CONST_SIZE,
 };
+
+BPF_CALL_2(bpf_inode_get_tag, void *, inode, void *, chain)
+{
+	if (WARN_ON(!inode))
+		return 0;
+	if (WARN_ON(!chain))
+		return 0;
+
+	return landlock_get_inode_tag(inode, chain);
+}
+
+const struct bpf_func_proto bpf_inode_get_tag_proto = {
+	.func		= bpf_inode_get_tag,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_INODE,
+	.arg2_type	= ARG_PTR_TO_LL_CHAIN,
+};
+
+BPF_CALL_3(bpf_landlock_set_tag, void *, tag_obj, void *, chain, u64, value)
+{
+	if (WARN_ON(!tag_obj))
+		return -EFAULT;
+	if (WARN_ON(!chain))
+		return -EFAULT;
+
+	return landlock_set_object_tag(tag_obj, chain, value);
+}
+
+const struct bpf_func_proto bpf_landlock_set_tag_proto = {
+	.func		= bpf_landlock_set_tag,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_LL_TAG_OBJ,
+	.arg2_type	= ARG_PTR_TO_LL_CHAIN,
+	.arg3_type	= ARG_ANYTHING,
+};
diff --git a/kernel/bpf/inodemap.c b/kernel/bpf/inodemap.c
new file mode 100644
index 000000000000..27714d2bc1c7
--- /dev/null
+++ b/kernel/bpf/inodemap.c
@@ -0,0 +1,318 @@
+/*
+ * inode map for Landlock
+ *
+ * Copyright © 2017-2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/resource.h> /* RLIMIT_NOFILE */
+#include <linux/bpf.h>
+#include <linux/err.h>
+#include <linux/file.h> /* fput() */
+#include <linux/filter.h> /* BPF_CALL_2() */
+#include <linux/fs.h> /* struct file */
+#include <linux/mm.h>
+#include <linux/mount.h> /* MNT_INTERNAL */
+#include <linux/path.h> /* struct path */
+#include <linux/sched/signal.h> /* rlimit() */
+#include <linux/security.h>
+#include <linux/slab.h>
+
+struct inode_elem {
+	struct inode *inode;
+	u64 value;
+};
+
+struct inode_array {
+	struct bpf_map map;
+	size_t nb_entries;
+	struct inode_elem elems[0];
+};
+
+/* must call iput(inode) after this call */
+static struct inode *inode_from_fd(int ufd, bool check_access)
+{
+	struct inode *ret;
+	struct fd f;
+	int deny;
+
+	f = fdget(ufd);
+	if (unlikely(!f.file || !file_inode(f.file))) {
+		ret = ERR_PTR(-EBADF);
+		goto put_fd;
+	}
+	/* TODO: add this check when called from an eBPF program too (already
+	 * checked by the LSM parent hooks anyway) */
+	if (unlikely(IS_PRIVATE(file_inode(f.file)))) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	/* check if the FD is tied to a mount point */
+	/* TODO: add this check when called from an eBPF program too */
+	if (unlikely(!f.file->f_path.mnt || f.file->f_path.mnt->mnt_flags &
+				MNT_INTERNAL)) {
+		ret = ERR_PTR(-EINVAL);
+		goto put_fd;
+	}
+	if (check_access) {
+		/* need to be allowed to access attributes from this file to
+		 * then be able to compare an inode to this entry */
+		deny = security_inode_getattr(&f.file->f_path);
+		if (deny) {
+			ret = ERR_PTR(deny);
+			goto put_fd;
+		}
+	}
+	ret = file_inode(f.file);
+	ihold(ret);
+
+put_fd:
+	fdput(f);
+	return ret;
+}
+
+/* (never) called from eBPF program */
+static int fake_map_delete_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+/* called from syscall */
+static int sys_inode_map_delete_elem(struct bpf_map *map, struct inode *key)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	struct inode *inode;
+	int i;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (array->elems[i].inode == key) {
+			inode = xchg(&array->elems[i].inode, NULL);
+			array->nb_entries--;
+			iput(inode);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+/* called from syscall */
+int bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
+{
+	struct inode *inode;
+	int err;
+
+	inode = inode_from_fd(*key, false);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	err = sys_inode_map_delete_elem(map, inode);
+	iput(inode);
+	return err;
+}
+
+static void inode_map_free(struct bpf_map *map)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	int i;
+
+	synchronize_rcu();
+	for (i = 0; i < array->map.max_entries; i++)
+		iput(array->elems[i].inode);
+	bpf_map_area_free(array);
+}
+
+static struct bpf_map *inode_map_alloc(union bpf_attr *attr)
+{
+	int numa_node = bpf_map_attr_numa_node(attr);
+	struct inode_array *array;
+	u64 array_size;
+
+	/* only allow root to create this type of map (for now), should be
+	 * removed when Landlock will be usable by unprivileged users */
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	/* the key is a file descriptor and the value must be 64-bits (for
+	 * now) */
+	if (attr->max_entries == 0 || attr->key_size != sizeof(u32) ||
+	    attr->value_size != FIELD_SIZEOF(struct inode_elem, value) ||
+	    attr->map_flags & ~(BPF_F_RDONLY | BPF_F_WRONLY) ||
+	    numa_node != NUMA_NO_NODE)
+		return ERR_PTR(-EINVAL);
+
+	if (attr->value_size > KMALLOC_MAX_SIZE)
+		/* if value_size is bigger, the user space won't be able to
+		 * access the elements.
+		 */
+		return ERR_PTR(-E2BIG);
+
+	/*
+	 * Limit number of entries in an inode map to the maximum number of
+	 * open files for the current process. The maximum number of file
+	 * references (including all inode maps) for a process is then
+	 * (RLIMIT_NOFILE - 1) * RLIMIT_NOFILE. If the process' RLIMIT_NOFILE
+	 * is 0, then any entry update is forbidden.
+	 *
+	 * An eBPF program can inherit all the inode map FD. The worse case is
+	 * to fill a bunch of arraymaps, create an eBPF program, close the
+	 * inode map FDs, and start again. The maximum number of inode map
+	 * entries can then be close to RLIMIT_NOFILE^3.
+	 */
+	if (attr->max_entries > rlimit(RLIMIT_NOFILE))
+		return ERR_PTR(-EMFILE);
+
+	array_size = sizeof(*array);
+	array_size += (u64) attr->max_entries * sizeof(struct inode_elem);
+
+	/* make sure there is no u32 overflow later in round_up() */
+	if (array_size >= U32_MAX - PAGE_SIZE)
+		return ERR_PTR(-ENOMEM);
+
+	/* allocate all map elements and zero-initialize them */
+	array = bpf_map_area_alloc(array_size, numa_node);
+	if (!array)
+		return ERR_PTR(-ENOMEM);
+
+	/* copy mandatory map attributes */
+	array->map.key_size = attr->key_size;
+	array->map.map_flags = attr->map_flags;
+	array->map.map_type = attr->map_type;
+	array->map.max_entries = attr->max_entries;
+	array->map.numa_node = numa_node;
+	array->map.pages = round_up(array_size, PAGE_SIZE) >> PAGE_SHIFT;
+	array->map.value_size = attr->value_size;
+
+	return &array->map;
+}
+
+/* (never) called from eBPF program */
+static void *fake_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	WARN_ON(1);
+	return ERR_PTR(-EINVAL);
+}
+
+/* called from syscall (wrapped) and eBPF program */
+static u64 inode_map_lookup_elem(struct bpf_map *map, struct inode *key)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	size_t i;
+	u64 ret = 0;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	/* TODO: use rbtree to switch to O(log n) */
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (array->elems[i].inode == key) {
+			ret = array->elems[i].value;
+			break;
+		}
+	}
+	return ret;
+}
+
+/* key is an FD when called from a syscall, but an inode pointer when called
+ * from an eBPF program */
+
+/* called from syscall */
+int bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value)
+{
+	struct inode *inode;
+
+	inode = inode_from_fd(*key, false);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	*value = inode_map_lookup_elem(map, inode);
+	iput(inode);
+	if (!value)
+		return -ENOENT;
+	return 0;
+}
+
+/* (never) called from eBPF program */
+static int fake_map_update_elem(struct bpf_map *map, void *key, void *value,
+				u64 flags)
+{
+	WARN_ON(1);
+	/* do not leak an inode accessed by a Landlock program */
+	return -EINVAL;
+}
+
+/* called from syscall */
+static int sys_inode_map_update_elem(struct bpf_map *map, struct inode *key,
+		u64 *value, u64 flags)
+{
+	struct inode_array *array = container_of(map, struct inode_array, map);
+	size_t i;
+
+	if (unlikely(flags != BPF_ANY))
+		return -EINVAL;
+
+	if (unlikely(array->nb_entries >= array->map.max_entries))
+		/* all elements were pre-allocated, cannot insert a new one */
+		return -E2BIG;
+
+	for (i = 0; i < array->map.max_entries; i++) {
+		if (!array->elems[i].inode) {
+			/* the inode (key) is already grabbed by the caller */
+			ihold(key);
+			array->elems[i].inode = key;
+			array->elems[i].value = *value;
+			array->nb_entries++;
+			return 0;
+		}
+	}
+	WARN_ON(1);
+	return -ENOENT;
+}
+
+/* called from syscall */
+int bpf_inode_map_update_elem(struct bpf_map *map, int *key, u64 *value,
+			      u64 flags)
+{
+	struct inode *inode;
+	int err;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	inode = inode_from_fd(*key, true);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	err = sys_inode_map_update_elem(map, inode, value, flags);
+	iput(inode);
+	return err;
+}
+
+/* called from syscall or (never) from eBPF program */
+static int fake_map_get_next_key(struct bpf_map *map, void *key,
+				 void *next_key)
+{
+	/* do not leak a file descriptor */
+	return -EINVAL;
+}
+
+/* void map for eBPF program */
+const struct bpf_map_ops inode_ops = {
+	.map_alloc = inode_map_alloc,
+	.map_free = inode_map_free,
+	.map_get_next_key = fake_map_get_next_key,
+	.map_lookup_elem = fake_map_lookup_elem,
+	.map_delete_elem = fake_map_delete_elem,
+	.map_update_elem = fake_map_update_elem,
+};
+
+BPF_CALL_2(bpf_inode_map_lookup, struct bpf_map *, map, void *, key)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return inode_map_lookup_elem(map, key);
+}
+
+const struct bpf_func_proto bpf_inode_map_lookup_proto = {
+	.func		= bpf_inode_map_lookup,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_INODE,
+};
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 90d7de6d7393..fd140da20e68 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -554,6 +554,22 @@ int __weak bpf_stackmap_copy(struct bpf_map *map, void *key, void *value)
 	return -ENOTSUPP;
 }
 
+int __weak bpf_inode_map_update_elem(struct bpf_map *map, int *key,
+				     u64 *value, u64 flags)
+{
+	return -ENOTSUPP;
+}
+
+int __weak bpf_inode_map_lookup_elem(struct bpf_map *map, int *key, u64 *value)
+{
+	return -ENOTSUPP;
+}
+
+int __weak bpf_inode_map_delete_elem(struct bpf_map *map, int *key)
+{
+	return -ENOTSUPP;
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define BPF_MAP_LOOKUP_ELEM_LAST_FIELD value
 
@@ -614,6 +630,8 @@ static int map_lookup_elem(union bpf_attr *attr)
 		err = bpf_fd_array_map_lookup_elem(map, key, value);
 	} else if (IS_FD_HASH(map)) {
 		err = bpf_fd_htab_map_lookup_elem(map, key, value);
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		err = bpf_inode_map_lookup_elem(map, key, value);
 	} else {
 		rcu_read_lock();
 		ptr = map->ops->map_lookup_elem(map, key);
@@ -719,6 +737,10 @@ static int map_update_elem(union bpf_attr *attr)
 		err = bpf_fd_htab_map_update_elem(map, f.file, key, value,
 						  attr->flags);
 		rcu_read_unlock();
+	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
+		rcu_read_lock();
+		err = bpf_inode_map_update_elem(map, key, value, attr->flags);
+		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
 		err = map->ops->map_update_elem(map, key, value, attr->flags);
@@ -776,7 +798,10 @@ static int map_delete_elem(union bpf_attr *attr)
 	preempt_disable();
 	__this_cpu_inc(bpf_prog_active);
 	rcu_read_lock();
-	err = map->ops->map_delete_elem(map, key);
+	if (map->map_type == BPF_MAP_TYPE_INODE)
+		err = bpf_inode_map_delete_elem(map, key);
+	else
+		err = map->ops->map_delete_elem(map, key);
 	rcu_read_unlock();
 	__this_cpu_dec(bpf_prog_active);
 	preempt_enable();
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ed0905338bb6..4a13dda251a8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -224,6 +224,9 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_PACKET]		= "pkt",
 	[PTR_TO_PACKET_META]	= "pkt_meta",
 	[PTR_TO_PACKET_END]	= "pkt_end",
+	[PTR_TO_INODE]		= "inode",
+	[PTR_TO_LL_TAG_OBJ]	= "landlock_tag_object",
+	[PTR_TO_LL_CHAIN]	= "landlock_chain",
 };
 
 static void print_liveness(struct bpf_verifier_env *env,
@@ -949,6 +952,9 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_PACKET_META:
 	case PTR_TO_PACKET_END:
 	case CONST_PTR_TO_MAP:
+	case PTR_TO_INODE:
+	case PTR_TO_LL_TAG_OBJ:
+	case PTR_TO_LL_CHAIN:
 		return true;
 	default:
 		return false;
@@ -1909,6 +1915,18 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		expected_type = PTR_TO_CTX;
 		if (type != expected_type)
 			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_INODE) {
+		expected_type = PTR_TO_INODE;
+		if (type != expected_type)
+			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_LL_TAG_OBJ) {
+		expected_type = PTR_TO_LL_TAG_OBJ;
+		if (type != expected_type)
+			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_LL_CHAIN) {
+		expected_type = PTR_TO_LL_CHAIN;
+		if (type != expected_type)
+			goto err_type;
 	} else if (arg_type_is_mem_ptr(arg_type)) {
 		expected_type = PTR_TO_STACK;
 		/* One exception here. In case function allows for NULL to be
@@ -2066,6 +2084,10 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		    func_id != BPF_FUNC_map_delete_elem)
 			goto error;
 		break;
+	case BPF_MAP_TYPE_INODE:
+		if (func_id != BPF_FUNC_inode_map_lookup)
+			goto error;
+		break;
 	default:
 		break;
 	}
@@ -2108,6 +2130,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_SOCKMAP)
 			goto error;
 		break;
+	case BPF_FUNC_inode_map_lookup:
+		if (map->map_type != BPF_MAP_TYPE_INODE)
+			goto error;
 	default:
 		break;
 	}
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 05fce359028e..0e1dd4612ecc 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := init.o chain.o \
+	tag.o tag_fs.o \
 	enforce.o enforce_seccomp.o
diff --git a/security/landlock/tag.c b/security/landlock/tag.c
new file mode 100644
index 000000000000..3f7f0f04f220
--- /dev/null
+++ b/security/landlock/tag.c
@@ -0,0 +1,373 @@
+/*
+ * Landlock LSM - tag helpers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/atomic.h>
+#include <linux/landlock.h> /* landlock_set_object_tag */
+#include <linux/rculist.h>
+#include <linux/refcount.h>
+#include <linux/slab.h>
+
+#include "chain.h"
+#include "tag.h"
+
+/* TODO: use a dedicated kmem_cache_alloc() instead of k*alloc() */
+
+/*
+ * @list_object: list of tags tied to a kernel object, e.g. inode
+ * @rcu_free: for freeing this tag
+ */
+struct landlock_tag {
+	struct list_head list_object;
+	struct rcu_head rcu_put;
+	struct landlock_chain *chain;
+	atomic64_t value;
+	/* usage is only for tag_ref, not for tag_root nor tag list */
+	refcount_t usage;
+};
+
+/* never return NULL */
+static struct landlock_tag *new_tag(struct landlock_chain *chain, u64 value)
+{
+	struct landlock_tag *tag;
+
+	tag = kzalloc(sizeof(*tag), GFP_ATOMIC);
+	if (!tag)
+		return ERR_PTR(-ENOMEM);
+	if (WARN_ON(!refcount_inc_not_zero(&chain->usage))) {
+		kfree(tag);
+		return ERR_PTR(-EFAULT);
+	}
+	tag->chain = chain;
+	INIT_LIST_HEAD(&tag->list_object);
+	refcount_set(&tag->usage, 1);
+	atomic64_set(&tag->value, value);
+	return tag;
+}
+
+static void free_tag(struct landlock_tag *tag)
+{
+	if (!tag)
+		return;
+	if (WARN_ON(refcount_read(&tag->usage)))
+		return;
+	landlock_put_chain(tag->chain);
+	kfree(tag);
+}
+
+struct landlock_tag_root {
+	spinlock_t appending;
+	struct list_head tag_list;
+	struct rcu_head rcu_put;
+	refcount_t tag_nb;
+};
+
+/* never return NULL */
+static struct landlock_tag_root *new_tag_root(struct landlock_chain *chain,
+		u64 value)
+{
+	struct landlock_tag_root *root;
+	struct landlock_tag *tag;
+
+	root = kzalloc(sizeof(*root), GFP_ATOMIC);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+	spin_lock_init(&root->appending);
+	refcount_set(&root->tag_nb, 1);
+	INIT_LIST_HEAD(&root->tag_list);
+
+	tag = new_tag(chain, value);
+	if (IS_ERR(tag)) {
+		kfree(root);
+		return ERR_CAST(tag);
+	}
+	list_add_tail(&tag->list_object, &root->tag_list);
+	return root;
+}
+
+static void free_tag_root(struct landlock_tag_root *root)
+{
+	if (!root)
+		return;
+	if (WARN_ON(refcount_read(&root->tag_nb)))
+		return;
+	/* the tag list should be singular it is a call from put_tag() or empty
+	 * if it is a call from landlock_set_tag():free_ref */
+	if (WARN_ON(!list_is_singular(&root->tag_list) &&
+				!list_empty(&root->tag_list)))
+		return;
+	kfree(root);
+}
+
+static void put_tag_root_rcu(struct rcu_head *head)
+{
+	struct landlock_tag_root *root;
+
+	root = container_of(head, struct landlock_tag_root, rcu_put);
+	free_tag_root(root);
+}
+
+/* return true if the tag_root is queued for freeing, false otherwise */
+static void put_tag_root(struct landlock_tag_root **root,
+		spinlock_t *root_lock)
+{
+	struct landlock_tag_root *freeme;
+
+	if (!root || WARN_ON(!root_lock))
+		return;
+
+	rcu_read_lock();
+	freeme = rcu_dereference(*root);
+	if (WARN_ON(!freeme))
+		goto out_rcu;
+	if (!refcount_dec_and_lock(&freeme->tag_nb, root_lock))
+		goto out_rcu;
+
+	rcu_assign_pointer(*root, NULL);
+	spin_unlock(root_lock);
+	call_rcu(&freeme->rcu_put, put_tag_root_rcu);
+
+out_rcu:
+	rcu_read_unlock();
+}
+
+static void put_tag_rcu(struct rcu_head *head)
+{
+	struct landlock_tag *tag;
+
+	tag = container_of(head, struct landlock_tag, rcu_put);
+	free_tag(tag);
+}
+
+/* put @tag if not recycled in an RCU */
+/* Only called to free an object; a chain deleting will happen after all the
+ * tagged struct files are deleted because their tied task is being deleted as
+ * well.  Then, there is no need to expressively delete the tag associated to a
+ * chain when this chain is getting deleted. */
+static void put_tag(struct landlock_tag *tag, struct landlock_tag_root **root,
+		spinlock_t *root_lock)
+{
+	if (!tag)
+		return;
+	if (!refcount_dec_and_test(&tag->usage))
+		return;
+	put_tag_root(root, root_lock);
+	list_del_rcu(&tag->list_object);
+	call_rcu(&tag->rcu_put, put_tag_rcu);
+}
+
+/*
+ * landlock_tag_ref - Account for tags
+ *
+ * @tag_nb: count the number of tags pointed by @tag, will free the struct when
+ *	    reaching zero
+ */
+struct landlock_tag_ref {
+	struct landlock_tag_ref *next;
+	struct landlock_tag *tag;
+};
+
+/* never return NULL */
+static struct landlock_tag_ref *landlock_new_tag_ref(void)
+{
+	struct landlock_tag_ref *ret;
+
+	ret = kzalloc(sizeof(*ret), GFP_ATOMIC);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+	return ret;
+}
+
+void landlock_free_tag_ref(struct landlock_tag_ref *tag_ref,
+		struct landlock_tag_root **tag_root, spinlock_t *root_lock)
+{
+	while (tag_ref) {
+		struct landlock_tag_ref *freeme = tag_ref;
+
+		tag_ref = tag_ref->next;
+		put_tag(freeme->tag, tag_root, root_lock);
+		kfree(freeme);
+	}
+}
+
+/* tweaked from rculist.h */
+#define list_for_each_entry_nopre_rcu(pos, head, member)		\
+	for (; &pos->member != (head);					\
+	     pos = list_entry_rcu((pos)->member.next, typeof(*(pos)), member))
+
+int landlock_set_tag(struct landlock_tag_ref **tag_ref,
+		struct landlock_tag_root **tag_root,
+		spinlock_t *root_lock,
+		struct landlock_chain *chain, u64 value)
+{
+	struct landlock_tag_root *root;
+	struct landlock_tag_ref *ref, **ref_next, **ref_walk, **ref_prev;
+	struct landlock_tag *tag, *last_tag;
+	int err;
+
+	if (WARN_ON(!tag_ref) || WARN_ON(!tag_root))
+		return -EFAULT;
+
+	/* start by looking for a (protected) ref to the tag */
+	ref_walk = tag_ref;
+	ref_prev = tag_ref;
+	ref_next = tag_ref;
+	tag = NULL;
+	while (*ref_walk) {
+		ref_next = &(*ref_walk)->next;
+		if (!WARN_ON(!(*ref_walk)->tag) &&
+				(*ref_walk)->tag->chain == chain) {
+			tag = (*ref_walk)->tag;
+			break;
+		}
+		ref_prev = ref_walk;
+		ref_walk = &(*ref_walk)->next;
+	}
+	if (tag) {
+		if (value) {
+			/* the tag already exist (and is protected) */
+			atomic64_set(&tag->value, value);
+		} else {
+			/* a value of zero means to delete the tag */
+			put_tag(tag, tag_root, root_lock);
+			*ref_prev = *ref_next;
+			kfree(*ref_walk);
+		}
+		return 0;
+	} else if (!value) {
+		/* do not create a tag with a value of zero */
+		return 0;
+	}
+
+	/* create a new tag and a dedicated ref earlier to keep a consistent
+	 * usage of the tag in case of memory allocation error */
+	ref = landlock_new_tag_ref();
+	if (IS_ERR(ref))
+		return PTR_ERR(ref);
+
+	/* lock-less as possible */
+	rcu_read_lock();
+	root = rcu_dereference(*tag_root);
+	/* if tag_root does not exist or is being deleted */
+	if (!root || !refcount_inc_not_zero(&root->tag_nb)) {
+		/* may need to create a new tag_root */
+		spin_lock(root_lock);
+		/* the root may have been created meanwhile, recheck */
+		root = rcu_dereference(*tag_root);
+		if (root) {
+			refcount_inc(&root->tag_nb);
+			spin_unlock(root_lock);
+		} else {
+			/* create a tag_root populated with the tag */
+			root = new_tag_root(chain, value);
+			if (IS_ERR(root)) {
+				spin_unlock(root_lock);
+				err = PTR_ERR(root);
+				tag_root = NULL;
+				goto free_ref;
+			}
+			rcu_assign_pointer(*tag_root, root);
+			spin_unlock(root_lock);
+			tag = list_first_entry(&root->tag_list, typeof(*tag),
+					list_object);
+			goto register_tag;
+		}
+	}
+
+	last_tag = NULL;
+	/* look for the tag */
+	list_for_each_entry_rcu(tag, &root->tag_list, list_object) {
+		/* ignore tag being deleted */
+		if (tag->chain == chain &&
+				refcount_inc_not_zero(&tag->usage)) {
+			atomic64_set(&tag->value, value);
+			goto register_tag;
+		}
+		last_tag = tag;
+	}
+	/*
+	 * Did not find a matching chain: lock tag_root, continue an exclusive
+	 * appending walk through the list (a new tag may have been appended
+	 * after the first walk), and if not matching one of the potential new
+	 * tags, then append a new one.
+	 */
+	spin_lock(&root->appending);
+	if (last_tag)
+		tag = list_entry_rcu(last_tag->list_object.next, typeof(*tag),
+				list_object);
+	else
+		tag = list_entry_rcu(root->tag_list.next, typeof(*tag),
+				list_object);
+	list_for_each_entry_nopre_rcu(tag, &root->tag_list, list_object) {
+		/* ignore tag being deleted */
+		if (tag->chain == chain &&
+				refcount_inc_not_zero(&tag->usage)) {
+			spin_unlock(&root->appending);
+			atomic64_set(&tag->value, value);
+			goto register_tag;
+		}
+	}
+	/* did not find any tag, create a new one */
+	tag = new_tag(chain, value);
+	if (IS_ERR(tag)) {
+		spin_unlock(&root->appending);
+		err = PTR_ERR(tag);
+		goto free_ref;
+	}
+	list_add_tail_rcu(&tag->list_object, &root->tag_list);
+	spin_unlock(&root->appending);
+
+register_tag:
+	rcu_read_unlock();
+	ref->tag = tag;
+	*ref_next = ref;
+	return 0;
+
+free_ref:
+	put_tag_root(tag_root, root_lock);
+	rcu_read_unlock();
+	landlock_free_tag_ref(ref, NULL, NULL);
+	return err;
+}
+
+int landlock_set_object_tag(struct landlock_tag_object *tag_obj,
+		struct landlock_chain *chain, u64 value)
+{
+	if (WARN_ON(!tag_obj))
+		return -EFAULT;
+	return landlock_set_tag(tag_obj->ref, tag_obj->root, tag_obj->lock,
+			chain, value);
+}
+
+u64 landlock_get_tag(const struct landlock_tag_root *tag_root,
+		const struct landlock_chain *chain)
+{
+	const struct landlock_tag_root *root;
+	struct landlock_tag *tag;
+	u64 ret = 0;
+
+	rcu_read_lock();
+	root = rcu_dereference(tag_root);
+	if (!root)
+		goto out_rcu;
+
+	/* no need to check if it is being deleted, it is guarded by RCU */
+	list_for_each_entry_rcu(tag, &root->tag_list, list_object) {
+		/* may return to-be-deleted tag */
+		if (tag->chain == chain) {
+			ret = atomic64_read(&tag->value);
+			goto out_rcu;
+		}
+	}
+
+out_rcu:
+	rcu_read_unlock();
+	return ret;
+}
diff --git a/security/landlock/tag.h b/security/landlock/tag.h
new file mode 100644
index 000000000000..71ad9f9ef16e
--- /dev/null
+++ b/security/landlock/tag.h
@@ -0,0 +1,36 @@
+/*
+ * Landlock LSM - tag headers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _SECURITY_LANDLOCK_TAG_H
+#define _SECURITY_LANDLOCK_TAG_H
+
+#include <linux/spinlock_types.h>
+
+struct landlock_tag;
+struct landlock_tag_root;
+struct landlock_tag_ref;
+
+struct landlock_tag_object {
+	spinlock_t *lock;
+	struct landlock_tag_root **root;
+	struct landlock_tag_ref **ref;
+};
+
+int landlock_set_tag(struct landlock_tag_ref **tag_ref,
+		struct landlock_tag_root **tag_root,
+		spinlock_t *root_lock,
+		struct landlock_chain *chain, u64 value);
+u64 landlock_get_tag(const struct landlock_tag_root *tag_root,
+		const struct landlock_chain *chain);
+void landlock_free_tag_ref(struct landlock_tag_ref *tag_ref,
+		struct landlock_tag_root **tag_root, spinlock_t *root_lock);
+
+#endif /* _SECURITY_LANDLOCK_TAG_H */
diff --git a/security/landlock/tag_fs.c b/security/landlock/tag_fs.c
new file mode 100644
index 000000000000..86a48e8a61f4
--- /dev/null
+++ b/security/landlock/tag_fs.c
@@ -0,0 +1,59 @@
+/*
+ * Landlock LSM - tag FS helpers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h> /* struct inode */
+#include <linux/landlock.h> /* landlock_get_inode_tag */
+#include <linux/slab.h>
+
+#include "tag_fs.h"
+#include "tag.h"
+
+u64 landlock_get_inode_tag(const struct inode *inode,
+		const struct landlock_chain *chain)
+{
+	return landlock_get_tag(inode->i_security, chain);
+}
+
+/* never return NULL */
+struct landlock_tag_fs *landlock_new_tag_fs(struct inode *inode)
+{
+	struct landlock_tag_fs *tag_fs;
+
+	tag_fs = kmalloc(sizeof(*tag_fs), GFP_KERNEL);
+	if (!tag_fs)
+		return ERR_PTR(-ENOMEM);
+	ihold(inode);
+	tag_fs->inode = inode;
+	tag_fs->ref = NULL;
+	return tag_fs;
+}
+
+void landlock_reset_tag_fs(struct landlock_tag_fs *tag_fs, struct inode *inode)
+{
+	if (WARN_ON(!tag_fs))
+		return;
+	landlock_free_tag_ref(tag_fs->ref, (struct landlock_tag_root **)
+			&tag_fs->inode->i_security, &tag_fs->inode->i_lock);
+	iput(tag_fs->inode);
+	ihold(inode);
+	tag_fs->inode = inode;
+	tag_fs->ref = NULL;
+}
+
+void landlock_free_tag_fs(struct landlock_tag_fs *tag_fs)
+{
+	if (!tag_fs)
+		return;
+	landlock_free_tag_ref(tag_fs->ref, (struct landlock_tag_root **)
+			&tag_fs->inode->i_security, &tag_fs->inode->i_lock);
+	iput(tag_fs->inode);
+	kfree(tag_fs);
+}
diff --git a/security/landlock/tag_fs.h b/security/landlock/tag_fs.h
new file mode 100644
index 000000000000..a73b84c43d35
--- /dev/null
+++ b/security/landlock/tag_fs.h
@@ -0,0 +1,26 @@
+/*
+ * Landlock LSM - tag FS headers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _SECURITY_LANDLOCK_TAG_FS_H
+#define _SECURITY_LANDLOCK_TAG_FS_H
+
+#include <linux/fs.h> /* struct inode */
+
+struct landlock_tag_fs {
+	struct inode *inode;
+	struct landlock_tag_ref *ref;
+};
+
+struct landlock_tag_fs *landlock_new_tag_fs(struct inode *inode);
+void landlock_reset_tag_fs(struct landlock_tag_fs *tag_fs, struct inode *inode);
+void landlock_free_tag_fs(struct landlock_tag_fs *tag_fs);
+
+#endif /* _SECURITY_LANDLOCK_TAG_FS_H */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2433aa1a0fd4..6dffd4ec7036 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -114,6 +114,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_DEVMAP,
 	BPF_MAP_TYPE_SOCKMAP,
 	BPF_MAP_TYPE_CPUMAP,
+	BPF_MAP_TYPE_INODE,
 };
 
 enum bpf_prog_type {
@@ -708,6 +709,22 @@ union bpf_attr {
  * int bpf_override_return(pt_regs, rc)
  *	@pt_regs: pointer to struct pt_regs
  *	@rc: the return value to set
+ *
+ * u64 bpf_inode_map_lookup(map, key)
+ *     @map: pointer to inode map
+ *     @key: pointer to inode
+ *     Return: value tied to this key, or zero if none
+ *
+ * u64 bpf_inode_get_tag(inode, chain)
+ *     @inode: pointer to struct inode
+ *     @chain: pointer to struct landlock_chain
+ *     Return: tag tied to this inode and chain, or zero if none
+ *
+ * int bpf_landlock_set_tag(tag_obj, chain, value)
+ *     @tag_obj: pointer pointing to a taggable object (e.g. inode)
+ *     @chain: pointer to struct landlock_chain
+ *     @value: value of the tag
+ *     Return: 0 on success or negative error code
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -769,7 +786,10 @@ union bpf_attr {
 	FN(perf_prog_read_value),	\
 	FN(getsockopt),			\
 	FN(override_return),		\
-	FN(sock_ops_cb_flags_set),
+	FN(sock_ops_cb_flags_set),	\
+	FN(inode_map_lookup),		\
+	FN(inode_get_tag),		\
+	FN(landlock_set_tag),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.16.2
