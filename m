Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030584;
	b=JGVE41G65t/zMBbcU+MLFAHpTGGxjjHLKbSgn1Byvq5jS64jg80RZsUvblAA0NM4OH7H
	 GbkIf2YdM8ZuMnjwmVuZUfcmSpxcsoq+wyzIBxyeNmYALjO4Pq2FIpE8wkLXjbiwC/YGh
	 xRv4T7kSe7FKok8Z5DUJ311cAfLIUGe/4EkAtLcb732LTTjK2xS8Rb7ANRz/8HftxOSHC
	 E/iUk3GmZ5KROvjU6UnoAYH0Ft09XGgKNZ/8UncHhTGXs134hPo6lvnqiA+y4q51btZT8
	 ONmdFKPUB6R2pWcHNLtVUwfyUgnt64IHsOJiDL+pSrG1HqiLIFrfo3xTUkIpFpXX9Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Yw8Jtdyg9RvoWPd6s19IYtQvfj32qAY8qIbAaQ5b7a4=;
	b=E/CV3ZZkyAbsLGBO8ZhTAYa6ZdQkMI0wRdk3erye5mZW+6aU8GbM+jHdt3K4v94wmSm7
	 iO5BSmUz4mmgb/DOmkAOTH/XC24n/jM7fwBOaeGL1XcjEu7UOgxQtPu7daead/i3cu5kN
	 Emut5kJpQJrrlRXPAska29I3ob4aW0Eu2Jz39l7H6t3u0xVbDyqGqMpgvKf8toinzt86W
	 qQm94XdDlYM/gFwy3GckhLbpkox20fkLcJ0ymvzNbAU2WrpGgki2W3F9XxtRb1xWgOsvh
	 +WI+7C9OoQYWUjPp5kV8+fVpXRk3Qpl7gmiJBZOerQCg+CF4x0VXxCSdDumW2ICo77A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0DiFgqu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BB996606E7C9;
	Wed, 18 Nov 2026 19:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k0DiFgqu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C6DF71F000C8;
	Wed, 18 Nov 2026 19:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030584;
	bh=Yw8Jtdyg9RvoWPd6s19IYtQvfj32qAY8qIbAaQ5b7a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0DiFgquNB/PYhAsGk9nQv8pW1iKEIJFEE9zomwU03QVL0wEJdsO4tBfucWZbz9Yf
	 uFBF/KU3OmcXqXKTxPvwJENl8JEQOFUSdNanbtaF/aHeMUI9qryLI1dHF12vlB4ztv
	 6g0nQCeyUTuZIlJbwWTblulN2K82cfJYQY9fjr4ZzenChOu64AN0KnVLx8ofyJ1t65
	 SHjIuq7zjAnKxqKhPYJ1kx4QDPrwVtLb/dU7K5jgfndGtRJF0AP76N9EmlJ0LhFH1A
	 nwAD230VFjYOAw8k9gvq8GmaQK3myMpGkv8PyHbS/RkaWSKwNp0D/fcHVP9lW043MX
	 mc+J3H9YON0lg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 09/13] fs: Support MOVE_MOUNT_T_MNTNS in move_mount()
Date: Wed, 18 Nov 2026 21:35:35 +0200
Message-ID: <20261118193539.240065-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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
most once, while relative target paths attach anonymous mounts beneath
the live mount namespace root and reject root-mount aliases.

Check CAP_SYS_ADMIN in the target mount namespace's owning user
namespace instead of caller may_mount(), check nsfs mount loops against
the destination mount namespace, and lock moved mount trees inside
attach_recursive_mnt() when crossing user namespace boundaries.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 194 +++++++++++++++++++++++++++++++------
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 168 insertions(+), 29 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a6c0a31e275a..2bd973a490d3 100644
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
 
@@ -2564,6 +2571,8 @@ int count_mounts(struct mnt_namespace *ns, struct mount *mnt)
 enum mnt_tree_flags_t {
 	MNT_TREE_BENEATH = BIT(0),
 	MNT_TREE_PROPAGATION = BIT(1),
+	MNT_TREE_MNTNS = BIT(2),
+	MNT_TREE_MNTNS_INIT = BIT(3),
 };
 
 /**
@@ -2639,6 +2648,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	HLIST_HEAD(tree_list);
 	struct mnt_namespace *ns = dest_mnt->mnt_ns;
 	struct user_namespace *user_ns = ns->user_ns;
+	struct user_namespace *source_user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
 	struct mount *child, *p;
@@ -2662,6 +2672,8 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		user_ns = current->nsproxy->mnt_ns->user_ns;
 	else
 		user_ns = ns->user_ns;
+	source_user_ns = (!moving && source_mnt->mnt_ns) ?
+			 source_mnt->mnt_ns->user_ns : user_ns;
 
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
@@ -2730,6 +2742,12 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
 			lock_mnt_tree(child);
+		if (!is_anon_ns(child->mnt_parent->mnt_ns) &&
+		    child->mnt_parent->mnt_ns->user_ns != source_user_ns) {
+			lock_mnt_tree(child);
+			if (list_empty(&child->mnt_expire))
+				child->mnt.mnt_flags |= MNT_LOCKED;
+		}
 		q = __lookup_mnt(&child->mnt_parent->mnt,
 				 child->mnt_mountpoint);
 		commit_tree(child);
@@ -3131,7 +3149,7 @@ static int do_loopback(const struct path *path, const char *old_name,
 		return PTR_ERR(mnt);
 
 	/* the copy may carry mount namespace files from below the source */
-	if (recurse && !check_for_nsfs_mounts(mnt))
+	if (recurse && !check_for_nsfs_mounts(mnt, current->nsproxy->mnt_ns))
 		err = -EINVAL;
 	else
 		err = graft_tree(mnt, &mp);
@@ -3779,6 +3797,7 @@ static int do_move_mount(const struct path *old_path,
 			 enum mnt_tree_flags_t flags)
 {
 	struct mount *old = real_mount(old_path->mnt);
+	struct mnt_namespace *target_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
@@ -3792,7 +3811,13 @@ static int do_move_mount(const struct path *old_path,
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
-	if (check_mnt(old)) {
+	if (flags & MNT_TREE_MNTNS) {
+		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns)
+			return -EINVAL;
+		if ((flags & MNT_TREE_MNTNS_INIT) &&
+		    mp.parent != real_mount(new_path->mnt))
+			return -EBUSY;
+	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
 		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
@@ -3840,7 +3865,9 @@ static int do_move_mount(const struct path *old_path,
 	 */
 	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old))
 		return -EINVAL;
-	if (!check_for_nsfs_mounts(old))
+	target_mnt_ns = is_anon_ns(mp.parent->mnt_ns) ?
+			current->nsproxy->mnt_ns : mp.parent->mnt_ns;
+	if (!check_for_nsfs_mounts(old, target_mnt_ns))
 		return -ELOOP;
 	if (mount_is_ancestor(old, mp.parent))
 		return -ELOOP;
@@ -4751,6 +4778,127 @@ static inline int vfs_move_mount(const struct path *from_path,
 	return do_move_mount(from_path, to_path, mflags);
 }
 
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
+		lflags = 0;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
+		ret = filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
+				      &mntns_root);
+		if (ret)
+			return ret;
+		if (real_mount(to_path.mnt)->mnt_ns != target_mnt_ns ||
+		    to_path.mnt == &target_mnt_ns->root->mnt)
+			return -EINVAL;
+		if (real_mount(to_path.mnt)->mnt_parent == target_mnt_ns->root &&
+		    to_path.dentry == to_path.mnt->mnt_root)
+			return (flags & MOVE_MOUNT_BENEATH) ? -EINVAL : -EBUSY;
+	}
+
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
+	if (ret)
+		return ret;
+
+	return vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_MNTNS);
+}
+
 /*
  * Move a mount from one place to another.  In combination with
  * fsopen()/fsmount() this is used to install a new mount and in combination
@@ -4770,7 +4918,7 @@ SYSCALL_DEFINE5(move_mount,
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
 
-	if (!may_mount())
+	if (!(flags & MOVE_MOUNT_T_MNTNS) && !may_mount())
 		return -EPERM;
 
 	if (flags & ~MOVE_MOUNT__MASK)
@@ -4783,6 +4931,13 @@ SYSCALL_DEFINE5(move_mount,
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
@@ -4806,25 +4961,8 @@ SYSCALL_DEFINE5(move_mount,
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
 
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index cb55cfcfc92e..7fa93de08ceb 100644
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

