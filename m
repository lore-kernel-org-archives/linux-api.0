Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219761;
	b=jKcY08KCMIRCLZkaMcUUU4uVBVRpkCeJ9gWmd4DtyLeRipZc8SHZzferc8h6BKvSuGgz
	 qXZ+xtcuNDuEQlmgzhBMy3GfXB9On+wuN7eGax8dcDpo63rQrjQHkr6xKQoS2iU9NldDn
	 5V+d3RJJCXSJgfNsRnb05XqIyXYe1Jm0AMHp6SktT+eqoensCdd1Dm/Fxn5XIjxAQbyx1
	 Db6vg4cUH0mN7M0rnwqCXfK4QH+o6073/31OPQo8DSYAJ/jMssjG4KMbU0DoAv/eDSlb8
	 r7lK78YmAlsQ+oBLvem9xFnGKBpRmPHvZORgpytJp2MpKwR2uNV8KW7mqMZ1xckJWNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zNByz1cvQxXYiGlb00UoEIrZVev30KNAmMpQc5i0HeQ=;
	b=ZhiQhnc9L6lflH/vjicV52dW0ob3jfeZ2iuvPh77/2syifztYXU+fAvHjVc0vEKC2Shj
	 iseCBmyWpVC1lVOTHGVQCAf9JWDsXCFn7o85HavxajaznYPfhEgbxmeJqMbB3lI0E/CSI
	 rVcGuXHU1VyJcxMvXC/HGdNVEVCZOLhrjG1py+LQ0GGggxbiJ4s6FqfLPRrPy3CBmfBx2
	 I0UqLoSWcjRTD0Cl2k8049LMTu7zwt5PfpJrKKjYQO9RreE5VfGBlCrM6ttjZ5LQyrTaj
	 /hz+cxgR5MIoZ+BIgHVnVNWKf+uMXaEzWRgf/SWR6pig2Ceqf3QsNGQzRAu/ISKy8Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DgvjwAuA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1850B606A681;
	Sat, 21 Nov 2026 00:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DgvjwAuA
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 145591F000EB;
	Sat, 21 Nov 2026 00:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219760;
	bh=zNByz1cvQxXYiGlb00UoEIrZVev30KNAmMpQc5i0HeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgvjwAuA4evD2NAopgo/ca0SjPxqqK/hvb5R1ZvOHHIWlqk/qi5gebP4NfOZkEkn4
	 C/QlxJUi9p8wQ5/ufBePIQ4A/QXM4QDtWDBPmDPTBq9AeLxp4X9HXnNXD/uLPj5Mqk
	 TqOgHQoDeC8TLL2zkpM7cppd+GVGetWGAXs5sIMkeUbK6vJ7YiVtEa5Pox18ueZ8ea
	 4CD7WybrxO1L5b3cLJHM7ZgrgC4lTDixXDoIDfvsbDyOJnc8vzTw/OpuOBZDG3iUwC
	 WmsxjKmB+nsrL4extMqshKIuzbMpzsyzEmfOY79se2F1wguH/69eg02sJqoxKPWrHK
	 y/PF1++NVhH5A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 06/25] mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
Date: Sat, 21 Nov 2026 02:08:25 +0200
Message-ID: <20261121000844.1863324-7-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

move_mount() currently resolves target paths only against the caller's
filesystem view or anonymous mount fds, preventing an external manager
from populating an empty mount namespace or hot-mounting into an
existing container's mount namespace without entering it first.

Add MOVE_MOUNT_T_MNTNS to attach detached anonymous mount trees into a
target mount namespace nsfs file descriptor. Installing "/" attaches the
initial root mount onto the nullfs root of an empty mount namespace at
most once, while relative target paths resolve with LOOKUP_IN_ROOT
beneath the live mount namespace root and reject root-mount aliases
under namespace_lock().

Check CAP_SYS_ADMIN in the target mount namespace's owning user
namespace instead of caller may_mount(), check nsfs mount loops against
the destination mount namespace, and lock moved mount trees inside
attach_recursive_mnt() when crossing user namespace boundaries.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 226 +++++++++++++++++++++++++++++++------
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 191 insertions(+), 38 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index b2dc84c0d0d6..b65f1fdd9281 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2202,7 +2202,8 @@ struct mnt_namespace *mnt_ns_from_dentry(struct dentry *dentry)
 	return to_mnt_ns(get_proc_ns(dentry->d_inode));
 }
 
-static bool mnt_ns_loop(struct dentry *dentry)
+static bool mnt_ns_loop_target(struct dentry *dentry,
+			       struct mnt_namespace *target_mnt_ns)
 {
 	/* Could bind mounting the mount namespace inode cause a
 	 * mount namespace loop?
@@ -2212,7 +2213,12 @@ static bool mnt_ns_loop(struct dentry *dentry)
 	if (!mnt_ns)
 		return false;
 
-	return current->nsproxy->mnt_ns->ns.ns_id >= mnt_ns->ns.ns_id;
+	return target_mnt_ns->ns.ns_id >= mnt_ns->ns.ns_id;
+}
+
+static bool mnt_ns_loop(struct dentry *dentry)
+{
+	return mnt_ns_loop_target(dentry, current->nsproxy->mnt_ns);
 }
 
 struct mount *copy_tree(struct mount *src_root, struct dentry *dentry,
@@ -2423,10 +2429,11 @@ static bool __has_children(struct mount *mnt, struct dentry *dentry)
  *
  * locks: mount_locked_reader || namespace_shared && pinned(subtree)
  */
-static bool check_for_nsfs_mounts(struct mount *subtree)
+static bool check_for_nsfs_mounts(struct mount *subtree,
+				  struct mnt_namespace *target_mnt_ns)
 {
 	for (struct mount *p = subtree; p; p = next_mnt(p, subtree))
-		if (mnt_ns_loop(p->mnt.mnt_root))
+		if (mnt_ns_loop_target(p->mnt.mnt_root, target_mnt_ns))
 			return false;
 	return true;
 }
@@ -2464,7 +2471,7 @@ struct vfsmount *clone_private_mount(const struct path *path)
 		if (!anon_ns_root(old_mnt))
 			return ERR_PTR(-EINVAL);
 
-		if (!check_for_nsfs_mounts(old_mnt))
+		if (!check_for_nsfs_mounts(old_mnt, current->nsproxy->mnt_ns))
 			return ERR_PTR(-EINVAL);
 	}
 
@@ -2564,12 +2571,15 @@ int count_mounts(struct mnt_namespace *ns, struct mount *mnt)
 enum mnt_tree_flags_t {
 	MNT_TREE_BENEATH = BIT(0),
 	MNT_TREE_PROPAGATION = BIT(1),
+	MNT_TREE_MNTNS = BIT(2),
+	MNT_TREE_MNTNS_INIT = BIT(3),
 };
 
 /**
  * attach_recursive_mnt - attach a source mount tree
  * @source_mnt: mount tree to be attached
  * @dest:	the context for mounting at the place where the tree should go
+ * @move_mntns:	whether @source_mnt is attached via MOVE_MOUNT_T_MNTNS
  *
  *  NOTE: in the table below explains the semantics when a source mount
  *  of a given type is attached to a destination mount of a given type.
@@ -2632,7 +2642,8 @@ enum mnt_tree_flags_t {
  *         Otherwise a negative error code is returned.
  */
 static int attach_recursive_mnt(struct mount *source_mnt,
-				const struct pinned_mountpoint *dest)
+				const struct pinned_mountpoint *dest,
+				bool move_mntns)
 {
 	struct mount *dest_mnt = dest->parent;
 	struct mountpoint *dest_mp = dest->mp;
@@ -2641,6 +2652,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	struct user_namespace *user_ns = ns->user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
+	struct mnt_namespace *src_ns;
 	struct mount *child, *p;
 	struct mount *top;
 	struct hlist_node *n;
@@ -2662,6 +2674,9 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		user_ns = current->nsproxy->mnt_ns->user_ns;
 	else
 		user_ns = ns->user_ns;
+	src_ns = moving ? NULL : source_mnt->mnt_ns;
+	if (move_mntns && src_ns)
+		user_ns = src_ns->user_ns;
 
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
@@ -2728,8 +2743,12 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		struct mount *q;
 		hlist_del_init(&child->mnt_hash);
 		/* Notice when we are propagating across user namespaces */
-		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
+		if (child->mnt_parent->mnt_ns->user_ns != user_ns) {
 			lock_mnt_tree(child);
+			if ((move_mntns || is_anon_ns(ns)) &&
+			    list_empty(&child->mnt_expire))
+				child->mnt.mnt_flags |= MNT_LOCKED;
+		}
 		q = __lookup_mnt(&child->mnt_parent->mnt,
 				 child->mnt_mountpoint);
 		commit_tree(child);
@@ -2937,7 +2956,7 @@ static int graft_tree(struct mount *mnt, const struct pinned_mountpoint *mp)
 	      d_is_dir(mnt->mnt.mnt_root))
 		return -ENOTDIR;
 
-	return attach_recursive_mnt(mnt, mp);
+	return attach_recursive_mnt(mnt, mp, false);
 }
 
 static int may_change_propagation(const struct mount *m)
@@ -3131,7 +3150,7 @@ static int do_loopback(const struct path *path, const char *old_name,
 		return PTR_ERR(mnt);
 
 	/* the copy may carry mount namespace files from below the source */
-	if (recurse && !check_for_nsfs_mounts(mnt))
+	if (recurse && !check_for_nsfs_mounts(mnt, current->nsproxy->mnt_ns))
 		err = -EINVAL;
 	else
 		err = graft_tree(mnt, &mp);
@@ -3776,9 +3795,11 @@ static inline bool may_use_mount(struct mount *mnt)
 
 static int do_move_mount(const struct path *old_path,
 			 const struct path *new_path,
-			 enum mnt_tree_flags_t flags)
+			 enum mnt_tree_flags_t flags,
+			 struct mnt_namespace *target_mnt_ns)
 {
 	struct mount *old = real_mount(old_path->mnt);
+	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
@@ -3792,7 +3813,29 @@ static int do_move_mount(const struct path *old_path,
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
-	if (check_mnt(old)) {
+	if (flags & MNT_TREE_MNTNS) {
+		u64 seq;
+
+		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns ||
+		    mp.parent->mnt_ns != target_mnt_ns)
+			return -EINVAL;
+		seq = old->mnt_ns->seq_origin;
+		if (seq && seq != target_mnt_ns->ns.ns_id &&
+		    seq != current->nsproxy->mnt_ns->ns.ns_id)
+			return -EINVAL;
+		if (flags & MNT_TREE_MNTNS_INIT) {
+			if (mp.parent != target_mnt_ns->root)
+				return -EBUSY;
+		} else if (mp.mp->m_dentry == mp.parent->mnt.mnt_root) {
+			const struct mount *m = mp.parent;
+
+			while (m != target_mnt_ns->root && mnt_has_parent(m) &&
+			       m->mnt_mountpoint == m->mnt_parent->mnt.mnt_root)
+				m = m->mnt_parent;
+			if (m == target_mnt_ns->root)
+				return beneath ? -EINVAL : -EBUSY;
+		}
+	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
 		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
@@ -3840,12 +3883,14 @@ static int do_move_mount(const struct path *old_path,
 	 */
 	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old))
 		return -EINVAL;
-	if (!check_for_nsfs_mounts(old))
+	dest_mnt_ns = is_anon_ns(mp.parent->mnt_ns) ?
+		      current->nsproxy->mnt_ns : mp.parent->mnt_ns;
+	if (!check_for_nsfs_mounts(old, dest_mnt_ns))
 		return -ELOOP;
 	if (mount_is_ancestor(old, mp.parent))
 		return -ELOOP;
 
-	return attach_recursive_mnt(old, &mp);
+	return attach_recursive_mnt(old, &mp, flags & MNT_TREE_MNTNS);
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -3860,7 +3905,7 @@ static int do_move_mount_old(const struct path *path, const char *old_name)
 	if (err)
 		return err;
 
-	return do_move_mount(&old_path, path, 0);
+	return do_move_mount(&old_path, path, 0, NULL);
 }
 
 /*
@@ -4725,7 +4770,8 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 
 static inline int vfs_move_mount(const struct path *from_path,
 				 const struct path *to_path,
-				 enum mnt_tree_flags_t mflags)
+				 enum mnt_tree_flags_t mflags,
+				 struct mnt_namespace *target_mnt_ns)
 {
 	int ret;
 
@@ -4736,7 +4782,123 @@ static inline int vfs_move_mount(const struct path *from_path,
 	if (mflags & MNT_TREE_PROPAGATION)
 		return do_set_group(from_path, to_path);
 
-	return do_move_mount(from_path, to_path, mflags);
+	return do_move_mount(from_path, to_path, mflags, target_mnt_ns);
+}
+
+static int lookup_move_mount_from(int from_dfd,
+				  const char __user *from_pathname,
+				  unsigned int flags, struct path *from_path)
+{
+	unsigned int uflags = 0;
+	unsigned int lflags = 0;
+
+	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
+		uflags = AT_EMPTY_PATH;
+
+	CLASS(filename_maybe_null, from_name)(from_pathname, uflags);
+	if (!from_name && from_dfd >= 0) {
+		CLASS(fd_raw, f_from)(from_dfd);
+		if (fd_empty(f_from))
+			return -EBADF;
+
+		*from_path = fd_file(f_from)->f_path;
+		path_get(from_path);
+		return 0;
+	}
+
+	if (flags & MOVE_MOUNT_F_SYMLINKS)
+		lflags |= LOOKUP_FOLLOW;
+	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)
+		lflags |= LOOKUP_AUTOMOUNT;
+	return filename_lookup(from_dfd, from_name, lflags, from_path, NULL);
+}
+
+/**
+ * DOC: MOVE_MOUNT_T_MNTNS
+ *
+ * ``MOVE_MOUNT_T_MNTNS`` installs detached anonymous mount trees into a target
+ * mount namespace ``nsfs`` file descriptor supplied as ``to_dfd``:
+ *
+ * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
+ *    ``nullfs`` root of an empty mount namespace at most once.
+ *
+ * 2. Relative ``to_pathname`` values resolve beneath the live root of the
+ *    target mount namespace.
+ *
+ * Capability is checked against ``CAP_SYS_ADMIN`` in the target mount
+ * namespace's owning user namespace, and source trees crossing user namespace
+ * boundaries are locked with ``MNT_LOCKED`` and locked mount flags.
+ */
+static int move_mount_mntns(int from_dfd, const char __user *from_pathname,
+			    int to_dfd, const char __user *to_pathname,
+			    unsigned int flags, enum mnt_tree_flags_t mflags)
+{
+	struct path from_path __free(path_put) = {};
+	struct path to_path __free(path_put) = {};
+	struct mnt_namespace *target_mnt_ns;
+	unsigned int lflags;
+	struct ns_common *ns;
+	bool is_root;
+	int ret;
+
+	CLASS(filename_maybe_null, to_name)(to_pathname, AT_EMPTY_PATH);
+	if (IS_ERR(to_name))
+		return PTR_ERR(to_name);
+	if (!to_name)
+		return -EINVAL;
+
+	CLASS(fd, f_mntns)(to_dfd);
+	if (fd_empty(f_mntns))
+		return -EBADF;
+	if (!proc_ns_file(fd_file(f_mntns)))
+		return -EINVAL;
+
+	ns = get_proc_ns(file_inode(fd_file(f_mntns)));
+	if (ns->ns_type != CLONE_NEWNS)
+		return -EINVAL;
+
+	target_mnt_ns = to_mnt_ns(ns);
+	if (is_anon_ns(target_mnt_ns))
+		return -EINVAL;
+	if (!ns_capable(target_mnt_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	is_root = to_name->name[0] == '/' && to_name->name[1] == '\0';
+	if (is_root) {
+		if (flags & MOVE_MOUNT_BENEATH)
+			return -EINVAL;
+
+		to_path.mnt = mntget(&target_mnt_ns->root->mnt);
+		to_path.dentry = dget(target_mnt_ns->root->mnt.mnt_root);
+		mflags |= MNT_TREE_MNTNS_INIT;
+	} else {
+		struct path mntns_root __free(path_put) = {};
+
+		if (to_name->name[0] == '/')
+			return -EINVAL;
+
+		ret = mnt_ns_get_root(target_mnt_ns, &mntns_root);
+		if (ret)
+			return ret;
+
+		lflags = LOOKUP_IN_ROOT;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
+		ret = filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
+				      &mntns_root);
+		if (ret)
+			return ret;
+	}
+
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
+	if (ret)
+		return ret;
+
+	return vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_MNTNS,
+			      target_mnt_ns);
 }
 
 /*
@@ -4758,7 +4920,7 @@ SYSCALL_DEFINE5(move_mount,
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
 
-	if (!may_mount())
+	if (!(flags & MOVE_MOUNT_T_MNTNS) && !may_mount())
 		return -EPERM;
 
 	if (flags & ~MOVE_MOUNT__MASK)
@@ -4771,6 +4933,13 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
 
+	if (unlikely(flags & MOVE_MOUNT_T_MNTNS)) {
+		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
+			return -EINVAL;
+		return move_mount_mntns(from_dfd, from_pathname,
+					to_dfd, to_pathname, flags, mflags);
+	}
+
 	uflags = 0;
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
@@ -4794,29 +4963,12 @@ SYSCALL_DEFINE5(move_mount,
 			return ret;
 	}
 
-	uflags = 0;
-	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
-		uflags = AT_EMPTY_PATH;
-
-	CLASS(filename_maybe_null,from_name)(from_pathname, uflags);
-	if (!from_name && from_dfd >= 0) {
-		CLASS(fd_raw, f_from)(from_dfd);
-		if (fd_empty(f_from))
-			return -EBADF;
-
-		return vfs_move_mount(&fd_file(f_from)->f_path, &to_path, mflags);
-	}
-
-	lflags = 0;
-	if (flags & MOVE_MOUNT_F_SYMLINKS)
-		lflags |= LOOKUP_FOLLOW;
-	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)
-		lflags |= LOOKUP_AUTOMOUNT;
-	ret = filename_lookup(from_dfd, from_name, lflags, &from_path, NULL);
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
 	if (ret)
 		return ret;
 
-	return vfs_move_mount(&from_path, &to_path, mflags);
+	return vfs_move_mount(&from_path, &to_path, mflags, NULL);
 }
 
 /*
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index ac865edac517..7d413418426a 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -75,9 +75,10 @@
 #define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
 #define MOVE_MOUNT_T_AUTOMOUNTS		0x00000020 /* Follow automounts on to path */
 #define MOVE_MOUNT_T_EMPTY_PATH		0x00000040 /* Empty to path permitted */
+#define MOVE_MOUNT_T_MNTNS		0x00000080 /* Resolve to_dfd as mntns fd */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x00000377
+#define MOVE_MOUNT__MASK		0x000003f7
 
 /*
  * fsopen() flags.
-- 
2.47.3

