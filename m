Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF066423763;
	Thu, 16 Jul 2026 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212711; cv=pass; b=pXbdiZXFvPvua3hP4CN13hn10v2VB7i4EAtt9uMOmPATD1wDfEMSGhJTP4bdiZtDdsgFMXixupduvdHazalm0nluUp9ZViIyeg5FAonVbW9Ny4/kt7GiikoQUtNsFiwAI7dGnRgkkFLLuc2M5WLSmJeN2Iz/pxb3Fi+8wHzFQJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212711; c=relaxed/simple;
	bh=Jlnf/7KJHQfGIfh6PO7upfelW445vVJyUcSe9GjDh/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAJUKsnCw94pps5YAqLS6U2iSwQsSUdmmrm8B2qFWJme3QcZ/fBVW/KeakXZJ8rWFuu8maUH/hWmQWeAIFpZeQy8pZWa+cP/jQL4Nsau6/vWuIwmGy3yPTyc1dFYPBNf/Et60JaUw+nBMsPMY4WMq7nmuNlG8mJyyfVgkDeiwrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=QH3sbyQl; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="QH3sbyQl"
ARC-Seal: i=1; a=rsa-sha256; t=1784212433; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kf3Np9YMkVz7SmzAbmA9Ilnck/MJz74KOTXGRXf9LKGYKx1zBG/kwIc2qdKSN5b32JmHGtuuKezihLN6q0niulAVljKw50eijwtg44jtfkrK7EhXPb3+oS/9jUikszJf599BHIhsRpo8LL/8MSgaA5icFxtERmpU8m7xDnQF2V4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212433; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+uXJHS4PC2mihbQ3K+CCZilSeUWVhuHe8bqD8OWrn0Y=; 
	b=W4aGfZGuo7kaVt1subY6WFddzZJmE9j6QUC6E4WTAd/kY1PO17injV2MW54XSpf2U/RT4GYGhnQGJ2rcMv9KDPXXZGlvlp6x4RVL4OAsRy7srIBb+Lu90mCHRgccq1oEyy/3sDkiVORSYHWwKRguiBONT84f2EnUlnLimy+QmnA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212433;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+uXJHS4PC2mihbQ3K+CCZilSeUWVhuHe8bqD8OWrn0Y=;
	b=QH3sbyQlyiqO6uzo1R20HvNwz9QDXk8tU6MzpcPZproojaC0nhdwCjFc4klSjozV
	CIcbQAJfrrjYJ3YPRboIEUiFvMdwY4fI5+Guy3qZVSdvJT+mi2DiQ5VaYGktuB7mb7/
	Pt+KWSJRzECIQDmuDJAJPAmFWu1P9fbeXXzqCBHE=
Received: by mx.zohomail.com with SMTPS id 178421243027830.582287462494605;
	Thu, 16 Jul 2026 07:33:50 -0700 (PDT)
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
Subject: [RFC PATCH 10/24] pidfs: publish future pidfd files
Date: Thu, 16 Jul 2026 22:31:36 +0800
Message-ID: <ccc0ca829719466561e954865512335871d8fe9b.1784204592.git.me@linux.beauty>
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

Publish an attached future pidfd by transferring pidfs attributes and
forwarding process-exit wakeups to poll registrations made while the
file was taskless.

Make numeric pidfd opens and file-handle opens wait across the interval
between task visibility and producer publication. Internal PIDFD_STALE
callers remain nonblocking so task creation cannot wait on itself.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/pidfs.c            | 127 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/pidfs.h |   5 ++
 2 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 36ee4f210f73f..d62235e01b351 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -116,7 +116,10 @@ struct pidfs_future_file {
 	const struct pidfs_future_file_ops *ops;
 	struct pidfs_attr *attr;
 	struct pid *pid;
+	wait_queue_head_t wait_pidfd;
+	wait_queue_entry_t pid_wait;
 	u64 ino;
+	bool pid_wait_attached;
 };
 
 static struct pidfs_node *pidfs_inode_node(const struct inode *inode)
@@ -137,6 +140,12 @@ pidfs_future_file(const struct inode *inode)
 	return container_of(node, struct pidfs_future_file, node);
 }
 
+static bool pidfs_future_file_terminal(struct pidfs_future_file *future)
+{
+	return future && future->ops->is_terminal &&
+	       future->ops->is_terminal(future->data);
+}
+
 void *pidfs_future_file_data(const struct file *file,
 			     const struct pidfs_future_file_ops *ops)
 {
@@ -169,6 +178,21 @@ static struct pid *pidfs_inode_pid(const struct inode *inode)
 	return pid;
 }
 
+static int pidfs_wait_for_published_pid(struct inode *inode)
+{
+	struct pidfs_future_file *future = pidfs_future_file(inode);
+	int status = -ESRCH;
+	int ret;
+
+	if (!future)
+		return 0;
+
+	ret = wait_event_killable(future->wait_pidfd,
+				  (status = PTR_ERR_OR_ZERO(pidfs_inode_pid(inode))) !=
+				  -ESRCH || pidfs_future_file_terminal(future));
+	return ret ? ret : status;
+}
+
 #if BITS_PER_LONG == 32
 
 DEFINE_SPINLOCK(pidfs_ino_lock);
@@ -370,10 +394,22 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
  */
 static __poll_t pidfd_poll(struct file *file, struct poll_table_struct *pts)
 {
+	struct pidfs_future_file *future;
 	struct task_struct *task;
 	__poll_t poll_flags = 0;
-	struct pid *pid = pidfd_pid(file);
+	struct pid *pid;
 
+	future = pidfs_future_file(file_inode(file));
+	pid = pidfd_pid(file);
+	if (IS_ERR(pid) && PTR_ERR(pid) == -ESRCH && future) {
+		/* Close the publication race after registering the future wait. */
+		poll_wait(file, &future->wait_pidfd, pts);
+		pid = pidfd_pid(file);
+	}
+
+	if (IS_ERR(pid) && PTR_ERR(pid) == -ESRCH &&
+	    pidfs_future_file_terminal(future))
+		return EPOLLERR | EPOLLHUP;
 	if (IS_ERR(pid))
 		return PTR_ERR(pid) == -ESRCH ? 0 : EPOLLHUP;
 
@@ -927,6 +963,8 @@ static void pidfs_evict_inode(struct inode *inode)
 		return;
 
 	future = container_of(node, struct pidfs_future_file, node);
+	if (future->pid_wait_attached)
+		remove_wait_queue(&future->pid->wait_pidfd, &future->pid_wait);
 	if (future->ops->release)
 		future->ops->release(future->data);
 	if (future->attr)
@@ -934,6 +972,16 @@ static void pidfs_evict_inode(struct inode *inode)
 	kfree(future);
 }
 
+static int pidfs_future_pid_wake(wait_queue_entry_t *wait,
+				 unsigned int mode, int sync, void *key)
+{
+	struct pidfs_future_file *future;
+
+	future = container_of(wait, struct pidfs_future_file, pid_wait);
+	wake_up_all(&future->wait_pidfd);
+	return 0;
+}
+
 static const struct super_operations pidfs_sops = {
 	.drop_inode	= inode_just_drop,
 	.evict_inode	= pidfs_evict_inode,
@@ -1068,12 +1116,16 @@ static int pidfs_export_permission(struct handle_to_path_ctx *ctx,
 static struct file *pidfs_export_open(const struct path *path, unsigned int oflags)
 {
 	struct file *file;
+	int ret;
 
 	/*
 	 * Clear O_LARGEFILE as open_by_handle_at() forces it and raise
 	 * O_RDWR as pidfds always are.
 	 */
 	oflags &= ~O_LARGEFILE;
+	ret = pidfs_wait_for_published_pid(d_inode(path->dentry));
+	if (ret)
+		return ERR_PTR(ret);
 	file = dentry_open(path, oflags | O_RDWR, current_cred());
 	/* do_dentry_open() strips O_EXCL, which encodes PIDFD_THREAD. */
 	if (!IS_ERR(file))
@@ -1289,6 +1341,17 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
 	ret = path_from_stashed(&pid->stashed, pidfs_mnt, get_pid(pid), &path);
 	if (ret < 0)
 		return ERR_PTR(ret);
+	/*
+	 * A future dentry can be stashed before copy_process() makes its task
+	 * visible. Non-stale callers have already observed the task, so do not
+	 * return that inode until its producer has published the process state.
+	 * PIDFD_STALE is used by pre-task internal callers and must not wait here.
+	 */
+	if (!(flags & PIDFD_STALE)) {
+		ret = pidfs_wait_for_published_pid(d_inode(path.dentry));
+		if (ret)
+			return ERR_PTR(ret);
+	}
 
 	VFS_WARN_ON_ONCE(!pid->attr);
 
@@ -1317,7 +1380,8 @@ struct file *pidfs_alloc_file(struct pid *pid, unsigned int flags)
  * associate one preallocated pid with
  * pidfs_future_file_set_pid(), publish its pidfs metadata with
  * pidfs_future_file_publish_pid(), make @ops->get_pid() resolve that pid, and
- * finally wake waiters with pidfs_future_file_notify().
+ * finally wake waiters with pidfs_future_file_notify(). A producer that
+ * becomes terminal without publishing must also notify its waiters.
  *
  * A task associated with the future pid must not become runnable before
  * publication metadata and exit-wakeup forwarding are installed.
@@ -1378,6 +1442,7 @@ struct file *pidfs_alloc_future_file(const char *name, void *data,
 	future->data = data;
 	future->ops = ops;
 	future->ino = ino;
+	init_waitqueue_head(&future->wait_pidfd);
 	inode->i_private = &future->node;
 	return file;
 }
@@ -1422,6 +1487,60 @@ int pidfs_future_file_set_pid(struct file *file, struct pid *pid)
 	return 0;
 }
 
+/**
+ * pidfs_future_file_publish_pid - publish pidfs metadata for a future pid
+ * @file: future pidfs file
+ * @pid: pid previously associated with @file
+ *
+ * This transfers the future inode attributes to @pid and forwards pid exit
+ * wakeups. After it returns, the producer must publish the state used by
+ * @ops->get_pid() before calling pidfs_future_file_notify().
+ */
+void pidfs_future_file_publish_pid(struct file *file, struct pid *pid)
+{
+	struct pidfs_future_file *future = pidfs_future_file(file_inode(file));
+	struct pidfs_attr *unused = NULL;
+
+	if (WARN_ON_ONCE(!future || READ_ONCE(future->pid) != pid))
+		return;
+
+	scoped_guard(spinlock_irq, &pid->wait_pidfd.lock) {
+		if (WARN_ON_ONCE(pid->attr == PIDFS_PID_DEAD))
+			return;
+		if (!pid->attr) {
+			pid->attr = future->attr;
+			future->attr = NULL;
+		} else {
+			unused = future->attr;
+			future->attr = NULL;
+		}
+	}
+	if (unused)
+		kmem_cache_free(pidfs_attr_cachep, unused);
+
+	init_waitqueue_func_entry(&future->pid_wait, pidfs_future_pid_wake);
+	add_wait_queue(&pid->wait_pidfd, &future->pid_wait);
+	future->pid_wait_attached = true;
+}
+
+/**
+ * pidfs_future_file_notify - wake future-pidfd state waiters
+ * @file: future pidfs file
+ *
+ * For publication, the producer must call this only after @ops->get_pid() can
+ * return the live pid. The publication must use release ordering paired with
+ * the producer's acquire-side lookup. A taskless terminal producer may call
+ * this after making @ops->is_terminal() return true.
+ */
+void pidfs_future_file_notify(struct file *file)
+{
+	struct pidfs_future_file *future = pidfs_future_file(file_inode(file));
+
+	if (WARN_ON_ONCE(!future))
+		return;
+	wake_up_all(&future->wait_pidfd);
+}
+
 /**
  * pidfs_future_file_clear_pid - undo an unpublished future-pid association
  * @file: future pidfs file
@@ -1444,6 +1563,10 @@ void pidfs_future_file_clear_pid(struct file *file, struct pid *pid)
 	if (WARN_ON_ONCE(!future || READ_ONCE(future->pid) != pid))
 		return;
 
+	if (future->pid_wait_attached) {
+		remove_wait_queue(&pid->wait_pidfd, &future->pid_wait);
+		future->pid_wait_attached = false;
+	}
 	WARN_ON_ONCE(cmpxchg(&pid->stashed, dentry, NULL) != dentry);
 	dentry->d_fsdata = NULL;
 	WARN_ON_ONCE(pid->attr);
diff --git a/include/linux/pidfs.h b/include/linux/pidfs.h
index 828e96f769ba1..e4df7f7748487 100644
--- a/include/linux/pidfs.h
+++ b/include/linux/pidfs.h
@@ -13,11 +13,14 @@ struct pid;
  * @get_pid: Return the published, borrowed, non-NULL process identity, or an
  *	error pointer while the producer is still taskless. The producer must
  *	keep the returned pid alive for the future inode lifetime.
+ * @is_terminal: Return true when a taskless producer can no longer publish a
+ *	process. Optional; a producer without terminal failures may leave it NULL.
  * @release: Optionally release producer-owned data when the pidfs inode is
  *	evicted. If provided, this is called at most once.
  */
 struct pidfs_future_file_ops {
 	struct pid *(*get_pid)(void *data);
+	bool (*is_terminal)(void *data);
 	void (*release)(void *data);
 };
 
@@ -29,6 +32,8 @@ void *pidfs_future_file_data(const struct file *file,
 			     const struct pidfs_future_file_ops *ops);
 u64 pidfs_future_file_ino(const struct file *file);
 int pidfs_future_file_set_pid(struct file *file, struct pid *pid);
+void pidfs_future_file_publish_pid(struct file *file, struct pid *pid);
+void pidfs_future_file_notify(struct file *file);
 void pidfs_future_file_clear_pid(struct file *file, struct pid *pid);
 void __init pidfs_init(void);
 void pidfs_prepare_pid(struct pid *pid);
-- 
2.52.0

