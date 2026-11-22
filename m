Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376186;
	b=wmA3VIcBckCuCHj4fOJOoQwYhruyYCv3WWGk7BkJ/z4lXqBw70b251k0yAVWVnxrzYIg
	 ROg7x/TPfAb4yELUdPuctC04T9tPml1yfYjoR7aMr/r8HuofMZd8cOw2bgd9z/5a+AbHg
	 cTFdTaoR92kpUwE/UVb/eGTcbdhQNllpdeaozfOI9wu6eTgHnGzHNyVELrB/P6jKEISZA
	 a1hETkQgHVLWCIZvonJs1WPocKRatpDZNoY98UiGXv4HwbyrOcn0YoAkSLYaHYhBwPXf2
	 AdMxVJJPSv9hMb+M38q1s1F74y0p2MXiogetPgdpQGo2zGFbhewrxbxURDl9gkc9a7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0eNIDEAoRmujXA6Ky0SIP9NpYpxjc1cr18CdGUMXyVQ=;
	b=Q3WJYxetxwILlyd0jg1IvqvVLAhcTrPHjIOhp0LjBp/0GK/IY7nygdw6r/aD2aTOy0HX
	 94hj5za9jPWLbLnAk8Y9EAljIeIaxdxxtaep47E97+H4xC8tW1SGMuHPdzwLKvndOXaUv
	 NU0eecIK0vRhRw8lcLgn2uVdF6JbIKqaiYV66Jk0FdmWGFftkfbwrTuBU6RE0dd00iRmA
	 +2KORYl9fESdxFqX+Yd341mopxpkDpo5+kdr8TDKyM8h7gJ0y/9RLyIdH6oqKdOy4Cj+u
	 iahst2HXJwcC0h1Z/z4qcfkCqtf1Csk9vW8NVh44VybDf+sUxERGJVhFIFyLOsHBGoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLFFyAyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B74F0606A336;
	Sun, 22 Nov 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLFFyAyi
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A05D51F000D8;
	Sun, 22 Nov 2026 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376186;
	bh=0eNIDEAoRmujXA6Ky0SIP9NpYpxjc1cr18CdGUMXyVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLFFyAyiMhK9+SAYJuBfJZEQtt1h6fQt9grxzJAP4rpI7obSf62cNKQZAYTyL0HB9
	 WnZKPuysbmFsbZdrAi0HCcEiJTOHTn9/3diENvg9DThAEXCv9O0YxoJPZTOxR/rFzA
	 JgPHvjFAV+em3yt5633CMfEMJp2ZDdsjP0EGo5+FIuwrnoqIxGM7iNlM0FXfBLWsai
	 GIk7KAamRhim5UvhKQJcs00/KagMUt8t3KJei22Llu3GK0UvsD/ojToL/meIiw3s/S
	 NLcrLcfad3jY5fLiLZRUaibhLbHQLck+9QX8PepsyP25w6vInK+Pb2C9ylTrIPVqDP
	 XCeD8oj9N9j+A==
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
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: [RFC PATCH v7 07/26] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
Date: Sun, 22 Nov 2026 21:35:20 +0200
Message-ID: <20261122193539.3334213-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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
index 93dd11da7e73..b2c89ad2393e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2573,6 +2573,7 @@ enum mnt_tree_flags_t {
 	MNT_TREE_PROPAGATION = BIT(1),
 	MNT_TREE_MNTNS = BIT(2),
 	MNT_TREE_MNTNS_INIT = BIT(3),
+	MNT_TREE_CLONE = BIT(4),
 };
 
 /**
@@ -3805,31 +3806,28 @@ static int do_move_mount(const struct path *old_path,
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
@@ -3842,6 +3840,36 @@ static int do_move_mount(const struct path *old_path,
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
@@ -3881,23 +3909,36 @@ static int do_move_mount(const struct path *old_path,
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
@@ -4823,8 +4864,8 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4832,6 +4873,11 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4933,12 +4979,17 @@ SYSCALL_DEFINE5(move_mount,
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

