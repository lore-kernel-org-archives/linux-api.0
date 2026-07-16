Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3CE331A53;
	Thu, 16 Jul 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212645; cv=pass; b=apWCk0TnJBN8rXm5hMP0PEMVfQV7j+ECyWpfKgjIw/5byC72t19oHEKndLPHlMFtGc9ittl4IO16gw+PBjltyIxoMZ1L/Im0zSrDyvNmJdzRg+iUqiYzAxattTQzVDlOlFCTiwcLwL8yDco6rq8s/LYk8NL8aiz78Egy9pwTXh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212645; c=relaxed/simple;
	bh=PaCQmZ4YdrnwmEcVzCtXTS/TGX2sRBCYcaXFih9Td2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcJz6bneHcNKPXZJccAWnvfIYgVoBx/nCeQ8c+k1zBywfDO+rOV3xDrqNch5XQY3auvnu2yj9/8Qcc565C7qR3pQbIuEQgZ+bgcOMvsoO4B5OJR/ATBNW+DptG4PG6j0Jhbi4+Lfu+aiJZyczlGMbwtN2pb9flVpotLPHU89iYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=eJeO+eF4; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="eJeO+eF4"
ARC-Seal: i=1; a=rsa-sha256; t=1784212413; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j7mSAosRI9wV7TUnNqWq1BzuAf5bXMD6hPBcH2myQKWjCPo30Vc4xJIweaKlhr8i/kRxzr/hkm4I0KRL8zPeSZfTsLk3TRLzehqDyfQtTqPzPs3lXLHaCCbZ6THloKb+Kz8OXRSR4TFar0F+P8iGcdOpdv8ZDfVBlqrx0e8xs2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212413; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6tx3RL7Dpcom2Gtiv6HpK7TldWXCZEPMErda2T+l8Rw=; 
	b=D8RC/Zs/WkdAf3m91cI24PmxOBAKoOEdkM87hMycfQ0ckwq0LLAmp1WKiXniZ9YxBXv8I/1olWoS/FxDTg16OhZExFLGrG28RiDxnqgpoSaTb3jrz7IxtriocYGwhxJ8ZRU/M25BqD7nCWY4xVZtIMtiVbq42SnvAa9uJHEJScM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212413;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6tx3RL7Dpcom2Gtiv6HpK7TldWXCZEPMErda2T+l8Rw=;
	b=eJeO+eF4JoGGJJXCrB9CubM79/Z2MgT9xXlK9WvBTMUbK0M6i0+8FEfFE6jj3hFD
	hUc5sXT1jqrNDmZ0MeYXJw6Ay7rjNNzUThNhUE3Am92zK+dGTVQYSjv3rg2DDIm1o4Q
	6o1y37rGO/MwgKOzwSVjVZioiAqMQt1ZECsUcK2Q=
Received: by mx.zohomail.com with SMTPS id 1784212410836431.9517470736415;
	Thu, 16 Jul 2026 07:33:30 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 08/24] pidfs: attach pids to future pidfd files
Date: Thu, 16 Jul 2026 22:31:34 +0800
Message-ID: <0f824d157ae7d9767badfa2294f195fc71329324.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Associate a future pidfs inode with a preallocated struct pid and reuse
the future dentry as the canonical stashed dentry. Preserve the
reserved inode identity when the pid is registered.

Keep attachment reversible until a task owns the pid so copy_process()
failure can return the future file to its taskless state. File-handle
lookup requires both the stash and an attached task before accepting an
unpublished pid, preventing failed allocations from being reopened
through stale state.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfs.c            | 89 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/pidfs.h |  2 +
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 28464fe274c9e..36ee4f210f73f 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -115,6 +115,7 @@ struct pidfs_future_file {
 	void *data;
 	const struct pidfs_future_file_ops *ops;
 	struct pidfs_attr *attr;
+	struct pid *pid;
 	u64 ino;
 };
 
@@ -238,7 +239,8 @@ int pidfs_add_pid(struct pid *pid)
 {
 	int ret;
 
-	pid->ino = pidfs_alloc_ino();
+	if (!pid->ino)
+		pid->ino = pidfs_alloc_ino();
 	ret = rhashtable_insert_fast(&pidfs_ino_ht, &pid->pidfs_hash,
 				     pidfs_ino_ht_params);
 	if (unlikely(ret))
@@ -987,9 +989,18 @@ static struct pid *pidfs_ino_get_pid(u64 ino)
 	if (!pid)
 		return NULL;
 	attr = READ_ONCE(pid->attr);
-	if (IS_ERR_OR_NULL(attr))
+	if (IS_ERR(attr))
+		return NULL;
+	/*
+	 * A task can become visible before its future pidfd is published. Let
+	 * ->open() wait across that window, but never expose a dentry for a
+	 * caller-supplied pid when copy_process() has failed. That failure path
+	 * clears the stash before freeing the pid allocation.
+	 */
+	if (!attr && (!READ_ONCE(pid->stashed) ||
+		      !pid_has_task(pid, PIDTYPE_PID)))
 		return NULL;
-	if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
+	if (attr && test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
 		return NULL;
 	/* Within our pid namespace hierarchy? */
 	if (pid_vnr(pid) == 0)
@@ -1025,7 +1036,8 @@ static struct dentry *pidfs_fh_to_dentry(struct super_block *sb,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	VFS_WARN_ON_ONCE(!pid->attr);
+	VFS_WARN_ON_ONCE(!pid->attr &&
+			 !pidfs_future_file(d_inode(path.dentry)));
 
 	mntput(path.mnt);
 	return path.dentry;
@@ -1103,6 +1115,10 @@ static int pidfs_init_inode(struct inode *inode, void *data)
 static bool pidfs_inode_data_matches(const struct inode *inode,
 				     const void *data)
 {
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+
+	if (future)
+		return READ_ONCE(future->pid) == data;
 	return pidfs_inode_pid(inode) == data;
 }
 
@@ -1266,6 +1282,10 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
 				PIDFD_AUTOKILL) != 5);
 	BUILD_BUG_ON(PIDFD_EMPTY & VALID_OPEN_FLAGS);
 
+	ret = pidfs_register_pid(pid);
+	if (ret)
+		return ERR_PTR(ret);
+
 	ret = path_from_stashed(&pid->stashed, pidfs_mnt, get_pid(pid), &path);
 	if (ret < 0)
 		return ERR_PTR(ret);
@@ -1369,6 +1389,67 @@ u64 pidfs_future_file_ino(const struct file *file)
 	return future ? future->ino : 0;
 }
 
+/**
+ * pidfs_future_file_set_pid - associate a preallocated pid with a future file
+ * @file: future pidfs file
+ * @pid: preallocated pid whose pidfs inode number matches @file
+ *
+ * This stashes the future dentry in @pid before copy_process() publishes the
+ * task. No pid reference is transferred. On a later creation failure the
+ * producer must call pidfs_future_file_clear_pid() before freeing @pid.
+ *
+ * Return: Zero on success or a negative error code.
+ */
+int pidfs_future_file_set_pid(struct file *file, struct pid *pid)
+{
+	struct inode *inode = file_inode(file);
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *stashed;
+
+	if (!future || !future->ops->get_pid || future->pid ||
+	    pid->ino != future->ino)
+		return -EBADF;
+
+	WRITE_ONCE(future->pid, pid);
+	dentry->d_fsdata = &pid->stashed;
+	stashed = stash_dentry(&pid->stashed, dentry);
+	if (stashed != dentry) {
+		dput(stashed);
+		pidfs_future_file_clear_pid(file, pid);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+/**
+ * pidfs_future_file_clear_pid - undo an unpublished future-pid association
+ * @file: future pidfs file
+ * @pid: pid previously associated with @file
+ *
+ * This may be called only after pidfs_future_file_set_pid() and before
+ * pidfs_future_file_publish_pid(). It removes the stashed dentry so the
+ * producer can free @pid after a task-creation failure.
+ *
+ * The producer must clear the association before attaching @pid to a task.
+ * File-handle lookup treats an attached pid as a publication-in-progress
+ * guarantee, so clearing the association later would violate that contract.
+ */
+void pidfs_future_file_clear_pid(struct file *file, struct pid *pid)
+{
+	struct inode *inode = file_inode(file);
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+	struct dentry *dentry = file->f_path.dentry;
+
+	if (WARN_ON_ONCE(!future || READ_ONCE(future->pid) != pid))
+		return;
+
+	WARN_ON_ONCE(cmpxchg(&pid->stashed, dentry, NULL) != dentry);
+	dentry->d_fsdata = NULL;
+	WARN_ON_ONCE(pid->attr);
+	WRITE_ONCE(future->pid, NULL);
+}
+
 void __init pidfs_init(void)
 {
 	if (rhashtable_init(&pidfs_ino_ht, &pidfs_ino_ht_params))
diff --git a/include/linux/pidfs.h b/include/linux/pidfs.h
index 6b7fbc54ab388..828e96f769ba1 100644
--- a/include/linux/pidfs.h
+++ b/include/linux/pidfs.h
@@ -28,6 +28,8 @@ struct file *pidfs_alloc_future_file(const char *name, void *data,
 void *pidfs_future_file_data(const struct file *file,
 			     const struct pidfs_future_file_ops *ops);
 u64 pidfs_future_file_ino(const struct file *file);
+int pidfs_future_file_set_pid(struct file *file, struct pid *pid);
+void pidfs_future_file_clear_pid(struct file *file, struct pid *pid);
 void __init pidfs_init(void);
 void pidfs_prepare_pid(struct pid *pid);
 int pidfs_add_pid(struct pid *pid);
-- 
2.52.0

