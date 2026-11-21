Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219765;
	b=n3yj65OnD9HoN0iHzcdKCANJWQsA9FwHsDjG2m8U7gGvmyxhw35wNptVtdRn/f/ZXq47
	 7TprF66+fU6R4/T4E5vIIqG9G8wLZco03kRv3yL+hx9fbgwv/FlUZdRv0cqMS4xEqMFXQ
	 Ry63Q46FX4vIgEv6A7yCyS/PF8c1jjYNNxAPeXHjPy9R9AEoyv+pT+TX2HYW3oPGyDH1t
	 sxtfBbXAoncvfd0tIaQfwNdFF7Mtu91lG25M21ofObthdw3a2gQJkQn/unaHs2wG2voX1
	 evhProOPIQRMPo/rRzhNdWe8vK+siMks9n8hhkzYYYp8LMGf5QBA7Ci0/wwxjCIioxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+f1eU7ac3P35v22m7Eb/vGvj0V/F0nbMpLFasj8SJb4=;
	b=36tK1N+KSFTvsdeXHER5ogfh51Pm9Pja1EtO+Q0vgdntz+MBukZeXs3k444MXMKdv9CQ
	 6yG5oPvxaoqzDc+PwvZyGGHVaP0EC3MQhO2h9+PDzFwHBVxQ/KTpUIqxBMosKUndE+W5f
	 nRVO7B0I44MYjsF8N0PdFOdA9Y608WPktx1mdYR8UAcAeKDHnep12a5DUokC+20LrJEQ+
	 PpHlrl9O0xix7ov3IpZkFlcV4ugBseJWKmGmvRf/zrl+MUYr3OuKoqdS//TEiFk2yrTMb
	 y80LGb4/JmETmmqY5YaEvaSzg1UAHJiFQPJrtHi88bSSTGih/h50ljP9rwSZj/9kc4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GBIWfWUk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D6AEF606A680;
	Sat, 21 Nov 2026 00:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GBIWfWUk
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3BFAB1F000EF;
	Sat, 21 Nov 2026 00:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219764;
	bh=+f1eU7ac3P35v22m7Eb/vGvj0V/F0nbMpLFasj8SJb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBIWfWUkM4x2QWdqaZHh0KG+xlwuw31r3M2RMQCC1zF5lWkxilX1M+EdZ4AMV37l2
	 crd1fBHHEfPb0+oeX89AtDuK04a/mCGWlRRciJUQ6LrQhSD82XQBUXnmrEgIqHFBSX
	 wYBORTPFXfKS+DIKk3D88UHznulZsBKAyDwgY2DSkOHCHz906RXy9gsaccDllUPaNV
	 F4mEy7cUxfceopPhoOejcjXPNF89DBnySzI9Y0nTqRLqi/N2Tt1CMJf2ozZoKCOZkD
	 upQN+sTfti47xk0zHY+WPJ1krc0XI8YlGWj3luxO67eTQma3aVyvgTPfG3t77+iUrf
	 HTAETQ2E0VLkw==
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
Subject: [RFC PATCH v5 07/25] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
Date: Sat, 21 Nov 2026 02:08:26 +0200
Message-ID: <20261121000844.1863324-8-jarkko@kernel.org>
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

Unprivileged container managers cannot use open_tree(OPEN_TREE_CLONE) in
the host mount namespace because it requires may_mount() against the
caller's current mount namespace rather than the destination namespace.

Add MOVE_MOUNT_CLONE for use with MOVE_MOUNT_T_MNTNS so move_mount() can
recursively loopback-clone a path from the caller's mount namespace
directly into the target mount namespace file descriptor. Authorize the
operation against CAP_SYS_ADMIN in target_mnt_ns->user_ns, apply
CL_SLAVE | CL_COPY_UNBINDABLE when crossing user namespace boundaries,
and lock cross-user-namespace cloned subtrees with MNT_LOCKED inside
attach_recursive_mnt().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 106 +++++++++++++++++++++++++++----------
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 80 insertions(+), 29 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index b65f1fdd9281..1e7d776c0966 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2573,13 +2573,15 @@ enum mnt_tree_flags_t {
 	MNT_TREE_PROPAGATION = BIT(1),
 	MNT_TREE_MNTNS = BIT(2),
 	MNT_TREE_MNTNS_INIT = BIT(3),
+	MNT_TREE_CLONE = BIT(4),
 };
 
 /**
  * attach_recursive_mnt - attach a source mount tree
  * @source_mnt: mount tree to be attached
  * @dest:	the context for mounting at the place where the tree should go
- * @move_mntns:	whether @source_mnt is attached via MOVE_MOUNT_T_MNTNS
+ * @src_user_ns: owning user namespace of @source_mnt for MOVE_MOUNT_T_MNTNS,
+ *               or NULL
  *
  *  NOTE: in the table below explains the semantics when a source mount
  *  of a given type is attached to a destination mount of a given type.
@@ -2643,7 +2645,7 @@ enum mnt_tree_flags_t {
  */
 static int attach_recursive_mnt(struct mount *source_mnt,
 				const struct pinned_mountpoint *dest,
-				bool move_mntns)
+				struct user_namespace *src_user_ns)
 {
 	struct mount *dest_mnt = dest->parent;
 	struct mountpoint *dest_mp = dest->mp;
@@ -2652,7 +2654,6 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	struct user_namespace *user_ns = ns->user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
-	struct mnt_namespace *src_ns;
 	struct mount *child, *p;
 	struct mount *top;
 	struct hlist_node *n;
@@ -2670,13 +2671,12 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	 * the attaching task's mount namespace is authoritative, not
 	 * the creator of the detached tree.
 	 */
-	if (is_anon_ns(ns))
+	if (src_user_ns)
+		user_ns = src_user_ns;
+	else if (is_anon_ns(ns))
 		user_ns = current->nsproxy->mnt_ns->user_ns;
 	else
 		user_ns = ns->user_ns;
-	src_ns = moving ? NULL : source_mnt->mnt_ns;
-	if (move_mntns && src_ns)
-		user_ns = src_ns->user_ns;
 
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
@@ -2745,7 +2745,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns) {
 			lock_mnt_tree(child);
-			if ((move_mntns || is_anon_ns(ns)) &&
+			if ((src_user_ns || is_anon_ns(ns)) &&
 			    list_empty(&child->mnt_expire))
 				child->mnt.mnt_flags |= MNT_LOCKED;
 		}
@@ -2956,7 +2956,7 @@ static int graft_tree(struct mount *mnt, const struct pinned_mountpoint *mp)
 	      d_is_dir(mnt->mnt.mnt_root))
 		return -ENOTDIR;
 
-	return attach_recursive_mnt(mnt, mp, false);
+	return attach_recursive_mnt(mnt, mp, NULL);
 }
 
 static int may_change_propagation(const struct mount *m)
@@ -3799,29 +3799,27 @@ static int do_move_mount(const struct path *old_path,
 			 struct mnt_namespace *target_mnt_ns)
 {
 	struct mount *old = real_mount(old_path->mnt);
+	struct user_namespace *src_user_ns = NULL;
+	struct mount *cloned = NULL;
 	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
-	if (!path_mounted(old_path))
+	if (!(flags & MNT_TREE_CLONE) && !path_mounted(old_path))
 		return -EINVAL;
 
 	if (d_is_dir(new_path->dentry) != d_is_dir(old_path->dentry))
 		return -EINVAL;
 
+	if ((flags & MNT_TREE_CLONE) && mnt_ns_loop(old_path->dentry))
+		return -EINVAL;
+
 	LOCK_MOUNT_MAYBE_BENEATH(mp, new_path, beneath);
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
 	if (flags & MNT_TREE_MNTNS) {
-		u64 seq;
-
-		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns ||
-		    mp.parent->mnt_ns != target_mnt_ns)
-			return -EINVAL;
-		seq = old->mnt_ns->seq_origin;
-		if (seq && seq != target_mnt_ns->ns.ns_id &&
-		    seq != current->nsproxy->mnt_ns->ns.ns_id)
+		if (mp.parent->mnt_ns != target_mnt_ns)
 			return -EINVAL;
 		if (flags & MNT_TREE_MNTNS_INIT) {
 			if (mp.parent != target_mnt_ns->root)
@@ -3835,6 +3833,35 @@ static int do_move_mount(const struct path *old_path,
 			if (m == target_mnt_ns->root)
 				return beneath ? -EINVAL : -EBUSY;
 		}
+		if (flags & MNT_TREE_CLONE) {
+			unsigned int copy_flags;
+
+			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns)
+				return -EINVAL;
+			src_user_ns = old->mnt_ns->user_ns;
+			copy_flags = (target_mnt_ns->user_ns != src_user_ns) ?
+				     (CL_SLAVE | CL_COPY_UNBINDABLE) :
+				     CL_COPY_MNT_NS_FILE;
+			cloned = __do_loopback(old_path, true, copy_flags);
+			if (IS_ERR(cloned))
+				return PTR_ERR(cloned);
+			old = cloned;
+			if (d_is_symlink(old->mnt.mnt_root)) {
+				err = -EINVAL;
+				goto out_cloned;
+			}
+		} else {
+			u64 seq;
+
+			if (!anon_ns_root(old) ||
+			    old->mnt_ns == mp.parent->mnt_ns)
+				return -EINVAL;
+			seq = old->mnt_ns->seq_origin;
+			if (seq && seq != target_mnt_ns->ns.ns_id &&
+			    seq != current->nsproxy->mnt_ns->ns.ns_id)
+				return -EINVAL;
+			src_user_ns = old->mnt_ns->user_ns;
+		}
 	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
@@ -3874,23 +3901,36 @@ static int do_move_mount(const struct path *old_path,
 			over = mp.parent->overmount;
 		err = can_move_mount_beneath(old, over, &mp);
 		if (err)
-			return err;
+			goto out_cloned;
 	}
 
 	/*
 	 * Don't move a mount tree containing unbindable mounts to a destination
 	 * mount which is shared.
 	 */
-	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old))
-		return -EINVAL;
+	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old)) {
+		err = -EINVAL;
+		goto out_cloned;
+	}
 	dest_mnt_ns = is_anon_ns(mp.parent->mnt_ns) ?
 		      current->nsproxy->mnt_ns : mp.parent->mnt_ns;
-	if (!check_for_nsfs_mounts(old, dest_mnt_ns))
-		return -ELOOP;
-	if (mount_is_ancestor(old, mp.parent))
-		return -ELOOP;
+	if (!check_for_nsfs_mounts(old, dest_mnt_ns)) {
+		err = -ELOOP;
+		goto out_cloned;
+	}
+	if (mount_is_ancestor(old, mp.parent)) {
+		err = -ELOOP;
+		goto out_cloned;
+	}
 
-	return attach_recursive_mnt(old, &mp, flags & MNT_TREE_MNTNS);
+	err = attach_recursive_mnt(old, &mp, src_user_ns);
+out_cloned:
+	if (err && cloned) {
+		lock_mount_hash();
+		umount_tree(cloned, UMOUNT_SYNC);
+		unlock_mount_hash();
+	}
+	return err;
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -4816,8 +4856,8 @@ static int lookup_move_mount_from(int from_dfd,
 /**
  * DOC: MOVE_MOUNT_T_MNTNS
  *
- * ``MOVE_MOUNT_T_MNTNS`` installs detached anonymous mount trees into a target
- * mount namespace ``nsfs`` file descriptor supplied as ``to_dfd``:
+ * ``MOVE_MOUNT_T_MNTNS`` installs mount trees into a target mount namespace
+ * ``nsfs`` file descriptor supplied as ``to_dfd``:
  *
  * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
  *    ``nullfs`` root of an empty mount namespace at most once.
@@ -4825,6 +4865,11 @@ static int lookup_move_mount_from(int from_dfd,
  * 2. Relative ``to_pathname`` values resolve beneath the live root of the
  *    target mount namespace.
  *
+ * 3. Combining ``MOVE_MOUNT_CLONE`` with ``MOVE_MOUNT_T_MNTNS`` recursively
+ *    loopback-clones ``from_pathname`` from the caller's mount namespace into
+ *    ``to_dfd`` without requiring ``OPEN_TREE_CLONE`` or ``may_mount()`` in
+ *    the caller's own mount namespace.
+ *
  * Capability is checked against ``CAP_SYS_ADMIN`` in the target mount
  * namespace's owning user namespace, and source trees crossing user namespace
  * boundaries are locked with ``MNT_LOCKED`` and locked mount flags.
@@ -4926,12 +4971,17 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & ~MOVE_MOUNT__MASK)
 		return -EINVAL;
 
+	if ((flags & MOVE_MOUNT_CLONE) && !(flags & MOVE_MOUNT_T_MNTNS))
+		return -EINVAL;
+
 	if ((flags & (MOVE_MOUNT_BENEATH | MOVE_MOUNT_SET_GROUP)) ==
 	    (MOVE_MOUNT_BENEATH | MOVE_MOUNT_SET_GROUP))
 		return -EINVAL;
 
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
+	if (flags & MOVE_MOUNT_CLONE)
+		mflags |= MNT_TREE_CLONE;
 
 	if (unlikely(flags & MOVE_MOUNT_T_MNTNS)) {
 		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index 7d413418426a..cb4f7175db02 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -78,7 +78,8 @@
 #define MOVE_MOUNT_T_MNTNS		0x00000080 /* Resolve to_dfd as mntns fd */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x000003f7
+#define MOVE_MOUNT_CLONE		0x00000400 /* Recursively clone from path */
+#define MOVE_MOUNT__MASK		0x000007f7
 
 /*
  * fsopen() flags.
-- 
2.47.3

