Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310327;
	b=VV9LIddo73FC4hwbDgUDostZ54yKvleWvr1fENJQGu7F42YSYIR8ytYNOr70HF8tTjrN
	 3zsZ8NCI9RUc3Q8cmo/g9MR74r8qD2hLH1b5W8elXQpv0mMv74uHaU6GgogIiKIwp+eAX
	 M+A6k6XiZYmcbeWCt8NNmiwsgEtNuaabIogDF3PkLcmt4FjYLKUO/eLC83scB02wCS4WW
	 ntrJAopBdBMoWbfwTdjbQAmXw2p83mVd5GGahr9arxUDU2wpi5RSuqFGcDvoWNKmSIVmA
	 5bxOjssF5eZeKNalDqiXcdJ6WXV6qP+dAAO4rorWlqlujfKx40WdvEdoiAlFzn5XPpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Mm/aE/uZ/LZ5IsRqL1/fzIJ4sZW+7y9KuMcaDkHtn6s=;
	b=jtTV8+Bu48U95n2YdXuPNMhGa79497d1ytjWeKSzLAoAlf7V8fiuWVl1o8HPYlc2tpqK
	 /9m2RCWX911I/Pv1EDxyGyvKhEMTpy+/SYMz7hkE/g1xFQdjr8Vpp5I+ezC9lDlc6NUDS
	 hBhoqtWwZJWVjjFy3jG+8xTWPAKrmgG+YzgydgkKS/25nU2LLP8xAE5CUMco6Jxbji9R6
	 TN9EExuigV2X725Nm0RJjT0hoCIbgLTItG4m7Y6K0cBTW2faJn6uPXR0bbhQqN4ZT79Ep
	 voApfVXX+O20JA7Pgk6s0w2Jj0rh71jI2sdjW+XMEEz0+7KfuSrr2RSR04pO55JoMuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJ2IQo+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 27831606A331;
	Sun, 22 Nov 2026 01:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJ2IQo+F
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 248D51F000C6;
	Sun, 22 Nov 2026 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310326;
	bh=Mm/aE/uZ/LZ5IsRqL1/fzIJ4sZW+7y9KuMcaDkHtn6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ2IQo+FLk/KN7nUomepZzEekGrM+qWpWwiuS10TP7U+kio3WgFFa/vcj53OtaNxE
	 qQdz/1WFpDD+iA45IuwGsn00pCoBSlETxHq/jwHp7AJSAfmMatUJDV+sYEyCWCHnOV
	 rylvdRIl+mLHxYG2XpduRYf+0Ic8UwtIGTdBUVBauMBwpOHbmZQWUwslfYQRiAAVY+
	 LC5v7MQxx/A1wDUfWuGVh+ejaQ9rQ2B4fR5LVDSZ88XJNwzP18Tr082jk6rsAhpzHF
	 Y42A+5xUh99xkKBLVgts0kWweMgM+8A1O37ABVBPGDbCrafYIotBh8DlwVUPY019ni
	 x5CAGcaA9r1eg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 07/26] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
Date: Sun, 22 Nov 2026 03:17:50 +0200
Message-ID: <20261122011809.2667684-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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
 fs/namespace.c             | 91 +++++++++++++++++++++++++++++---------
 include/uapi/linux/mount.h |  3 +-
 2 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e21dd876dde3..57b4e8755fe9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2573,6 +2573,7 @@ enum mnt_tree_flags_t {
 	MNT_TREE_PROPAGATION = BIT(1),
 	MNT_TREE_MNTNS = BIT(2),
 	MNT_TREE_MNTNS_INIT = BIT(3),
+	MNT_TREE_CLONE = BIT(4),
 };
 
 /**
@@ -3803,31 +3804,28 @@ static int do_move_mount(const struct path *old_path,
 {
 	struct mount *old = real_mount(old_path->mnt);
 	struct user_namespace *src_user_ns = NULL;
+	struct mount *cloned = NULL;
 	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
-	if (!path_mounted(old_path))
+	if (!(flags & MNT_TREE_CLONE) && !path_mounted(old_path))
 		return -EINVAL;
 
 	if (d_is_dir(new_path->dentry) != d_is_dir(old_path->dentry))
 		return -EINVAL;
 
+	if ((flags & MNT_TREE_CLONE) &&
+	    mnt_ns_loop_target(old_path->dentry, target_mnt_ns))
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
-		src_user_ns = old->mnt_ns->user_ns;
 		if (flags & MNT_TREE_MNTNS_INIT) {
 			if (mp.parent != target_mnt_ns->root)
 				return -EBUSY;
@@ -3840,6 +3838,36 @@ static int do_move_mount(const struct path *old_path,
 			if (m == target_mnt_ns->root)
 				return beneath ? -EINVAL : -EBUSY;
 		}
+		if (flags & MNT_TREE_CLONE) {
+			unsigned int copy_flags;
+
+			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns ||
+			    (old->mnt.mnt_sb->s_flags & SB_NOUSER))
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
@@ -3879,23 +3907,36 @@ static int do_move_mount(const struct path *old_path,
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
 
-	return attach_recursive_mnt(old, &mp, src_user_ns);
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
@@ -4821,8 +4862,8 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4830,6 +4871,11 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4931,12 +4977,17 @@ SYSCALL_DEFINE5(move_mount,
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

