Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957286;
	b=RzkYbPFuEVoWHSOFdBUehfntz82Wkksw6352QxbypodhXH0IKryS/9pxC/hO97Bw3eyl
	 BqHXon6IK2xWkpvz4sPneYrVcnnRaySTRndN/so0piqxv9cXplvk8YfjAStQnt5IeTWvP
	 gmGoktqZpSByQuI6T9vavpJb94YWdzaz7qRUMA2THJomIhNS+UFBv9ow2QCaPT+OLPsqL
	 mZPGtaTW4slygZYM06tly3RkSA85bgPAxmXKWy6dV0+KnBdXECOWzU4Q1b4xl8VqMVJdx
	 oBlkTIZ8Sqbj9Ts+3Y06d/utQT0L+ZHFLBf0UXQ92rTWL2pP91QNsUPI4Ac27XlmEDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6n34UB4IGYmqbxIeyu3C92WUyY/otUHn2KouidPimtk=;
	b=PBgac1QWaHbrMatvEYWH5zSSqEjSqtFVK2foPEPBIC9kEJ4cr9tTXnwHYH5xP9SiXBZU
	 5wc4bmJBZKyZuy79pVaAVBOakOm1y7zDV7JZv9rOeXKBy3SfUNWv435RjA8YfquSUTOwy
	 bKFIs+Q5mP/4ZaIpeHQlPV4oEz3fAk5gYS6R9u9+ILPQ5nF55wCzKtCtbCkCliXhpczT5
	 NPNC/G61HtnEJGv8bHK0F8HimuMeH5JW3xEyWZmhAWq453s+XG7DSArB45HdklsCCKGJC
	 xpnRERp0j/AuS9GYAV+GCDXB//8hYCz8OBAKQs82FjxricfQOh/0NzTA7MsV/fCcFdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nv82ikRn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 05EA3606A88A;
	Tue, 17 Nov 2026 23:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nv82ikRn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE2621F00923;
	Tue, 17 Nov 2026 23:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957285;
	bh=6n34UB4IGYmqbxIeyu3C92WUyY/otUHn2KouidPimtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nv82ikRni3pWvdz/v3Vdo+m1Anuew84FJcPoalRIkbDhe6E5zey3rFphBih5HmEi1
	 Jdj85W4jMNmUEEYeQvn10vCL9w84rrIIQWOvHio86WhASVJSe7JhRk/BhZoA2caOMn
	 BcQCQ1kOtz3EfRvr5RBUjeT8YZUorLG1SwZ24dQylM7CUrkAohYxDY1kC6mLaVAIpE
	 njZnDZ9/qWUlt4Ax/p64lqw9yFXGnqjVuiOMmxjXfoqa8EuMKYBfUAzEHntS7aYcqC
	 3KEhBzC1vPDiFvp4mnnuTvw6gT7uuc39cnywJh8Ozpp8k+cLCTOr5c8ebROGPJKW67
	 NkI6qRuasf7jA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 09/13] fs: Support installing rootns mount trees via move_mount()
Date: Wed, 18 Nov 2026 01:13:48 +0200
Message-ID: <20261117231352.3816603-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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

A newly created rootns starts with an empty nullfs-rooted mount
namespace, and move_mount() only resolves target paths against the
caller's own filesystem view.

Add MOVE_MOUNT_T_ROOTNS_ROOT to populate a rootns mount tree through its
file descriptor before or after entry. Installing "/" attaches a
detached anonymous mount tree onto the nullfs root of the rootns mount
namespace once and transitions the rootns to ROOTNS_READY; relative
target paths attach anonymous mounts underneath the installed rootns
root while verifying the destination mount namespace.

Allocate fsmount() anonymous namespaces in fc->user_ns, check target
user namespace CAP_SYS_ADMIN for MOVE_MOUNT_T_ROOTNS_ROOT instead of
caller may_mount(), and lock moved mount trees when crossing user
namespace boundaries.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 178 ++++++++++++++++++++++++++++++++-----
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 157 insertions(+), 24 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..f8c96e4d13ee 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -34,6 +34,7 @@
 #include <linux/mnt_idmapping.h>
 #include <linux/pidfs.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -2564,6 +2565,8 @@ int count_mounts(struct mnt_namespace *ns, struct mount *mnt)
 enum mnt_tree_flags_t {
 	MNT_TREE_BENEATH = BIT(0),
 	MNT_TREE_PROPAGATION = BIT(1),
+	MNT_TREE_ROOTNS = BIT(2),
+	MNT_TREE_ROOTNS_INIT = BIT(3),
 };
 
 /**
@@ -3781,6 +3784,7 @@ static int do_move_mount(const struct path *old_path,
 	struct mount *old = real_mount(old_path->mnt);
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
+	bool lock_tree;
 
 	if (!path_mounted(old_path))
 		return -EINVAL;
@@ -3792,7 +3796,13 @@ static int do_move_mount(const struct path *old_path,
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
-	if (check_mnt(old)) {
+	if (flags & MNT_TREE_ROOTNS) {
+		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns)
+			return -EINVAL;
+		if ((flags & MNT_TREE_ROOTNS_INIT) &&
+		    mp.parent != real_mount(new_path->mnt))
+			return -EBUSY;
+	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
 		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
@@ -3845,7 +3855,16 @@ static int do_move_mount(const struct path *old_path,
 	if (mount_is_ancestor(old, mp.parent))
 		return -ELOOP;
 
-	return attach_recursive_mnt(old, &mp);
+	lock_tree = (flags & MNT_TREE_ROOTNS) &&
+		    old->mnt_ns->user_ns != mp.parent->mnt_ns->user_ns;
+	err = attach_recursive_mnt(old, &mp);
+	if (!err && lock_tree) {
+		scoped_guard(mount_writer) {
+			lock_mnt_tree(old);
+			old->mnt.mnt_flags |= MNT_LOCKED;
+		}
+	}
+	return err;
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -4699,7 +4718,7 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(fc->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
 	mnt = real_mount(new_path.mnt);
@@ -4739,6 +4758,129 @@ static inline int vfs_move_mount(const struct path *from_path,
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
+ * DOC: MOVE_MOUNT_T_ROOTNS_ROOT
+ *
+ * ``MOVE_MOUNT_T_ROOTNS_ROOT`` installs detached anonymous mount trees into a
+ * target ``rootns`` control fd supplied as ``to_dfd``:
+ *
+ * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
+ *    ``nullfs`` root of the ``rootns`` mount namespace at most once and
+ *    transitions the ``rootns`` to ``ROOTNS_READY``.
+ *
+ * 2. Relative ``to_pathname`` values resolve beneath the installed ``rootns``
+ *    root inside the ``rootns`` mount namespace.
+ *
+ * Capability is checked against ``CAP_SYS_ADMIN`` in the target ``rootns``
+ * user namespace, and source trees crossing user namespace boundaries are
+ * locked with ``MNT_LOCKED`` and locked mount flags.
+ */
+static int move_mount_rootns(int from_dfd, const char __user *from_pathname,
+			     int to_dfd, const char __user *to_pathname,
+			     unsigned int flags, enum mnt_tree_flags_t mflags)
+{
+	struct path from_path __free(path_put) = {};
+	struct path to_path __free(path_put) = {};
+	struct mnt_namespace *rootns_mnt_ns;
+	unsigned int lflags;
+	struct rootns *rootns;
+	bool is_root;
+	int ret;
+
+	CLASS(filename_maybe_null, to_name)(to_pathname, AT_EMPTY_PATH);
+	if (IS_ERR(to_name))
+		return PTR_ERR(to_name);
+	if (!to_name)
+		return -EINVAL;
+
+	CLASS(fd, f_rootns)(to_dfd);
+	if (fd_empty(f_rootns))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f_rootns)))
+		return -EINVAL;
+
+	rootns = fd_file(f_rootns)->private_data;
+	if (!ns_capable(rootns->cred->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	rootns_mnt_ns = rootns->ns->mnt_ns;
+	is_root = to_name->name[0] == '/' && to_name->name[1] == '\0';
+	if (is_root) {
+		if (flags & MOVE_MOUNT_BENEATH)
+			return -EINVAL;
+		if (READ_ONCE(rootns->state) != ROOTNS_EMPTY)
+			return -EBUSY;
+
+		to_path.mnt = mntget(&rootns_mnt_ns->root->mnt);
+		to_path.dentry = dget(rootns_mnt_ns->root->mnt.mnt_root);
+		mflags |= MNT_TREE_ROOTNS_INIT;
+	} else {
+		if (to_name->name[0] == '/')
+			return -EINVAL;
+
+		scoped_guard(spinlock, &rootns->lock) {
+			if (rootns->state == ROOTNS_EMPTY)
+				return -ENOENT;
+		}
+
+		lflags = 0;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
+		ret = filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
+				      &rootns->root);
+		if (ret)
+			return ret;
+		if (real_mount(to_path.mnt)->mnt_ns != rootns_mnt_ns)
+			return -EINVAL;
+	}
+
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
+	if (ret)
+		return ret;
+
+	ret = vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_ROOTNS);
+	if (!ret && is_root) {
+		scoped_guard(spinlock, &rootns->lock) {
+			path_get(&from_path);
+			rootns->root = from_path;
+			WRITE_ONCE(rootns->state, ROOTNS_READY);
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Move a mount from one place to another.  In combination with
  * fsopen()/fsmount() this is used to install a new mount and in combination
@@ -4758,7 +4900,7 @@ SYSCALL_DEFINE5(move_mount,
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
 
-	if (!may_mount())
+	if (!(flags & MOVE_MOUNT_T_ROOTNS_ROOT) && !may_mount())
 		return -EPERM;
 
 	if (flags & ~MOVE_MOUNT__MASK)
@@ -4771,6 +4913,13 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
 
+	if (unlikely(flags & MOVE_MOUNT_T_ROOTNS_ROOT)) {
+		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
+			return -EINVAL;
+		return move_mount_rootns(from_dfd, from_pathname,
+					 to_dfd, to_pathname, flags, mflags);
+	}
+
 	uflags = 0;
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
@@ -4794,25 +4943,8 @@ SYSCALL_DEFINE5(move_mount,
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
index cb55cfcfc92e..7224a43af51d 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -75,9 +75,10 @@
 #define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
 #define MOVE_MOUNT_T_AUTOMOUNTS		0x00000020 /* Follow automounts on to path */
 #define MOVE_MOUNT_T_EMPTY_PATH		0x00000040 /* Empty to path permitted */
+#define MOVE_MOUNT_T_ROOTNS_ROOT	0x00000080 /* Set as rootns root */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x00000377
+#define MOVE_MOUNT__MASK		0x000003f7
 
 /*
  * fsopen() flags.
-- 
2.47.3

