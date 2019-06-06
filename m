From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/10] security: Override creds in __fput() with last
 fputter's creds [ver #3]
Date: Thu, 06 Jun 2019 10:42:10 +0100
Message-ID: <155981413016.17513.10540579988392555403.stgit@warthog.procyon.org.uk>
References: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155981411940.17513.7137844619951358374.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>Casey Schaufler <casey@schaufler-ca.com>, dhowells@redhat.com, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

So that the LSM can see the credentials of the last process to do an fput()
on a file object when the file object is being dismantled, do the following
steps:

 (1) Cache the current credentials in file->f_fput_cred at the point the
     file object's reference count reaches zero.

 (2) In __fput(), use override_creds() to apply those credentials to the
     dismantling process.  This is necessary so that if we're dismantling a
     unix socket that has semi-passed fds still in it, their fputs will
     pick up the same credentials if they're reduced to zero at that point.

     Note that it's probably not strictly necessary to take an extra ref on
     the creds here (which override_creds() does).

 (3) Destroy the fput creds in file_free_rcu().

This additionally makes the creds available to:

	fsnotify
	eventpoll
	file locking
	->fasync, ->release file ops
	superblock destruction
	mountpoint destruction

This allows various notifications about object cleanups/destructions to
carry appropriate credentials for the LSM to approve/disapprove them based
on the process that caused them, even if indirectly.

Note that this means that someone looking at /proc/<pid>/fd/<n> may end up
being inadvertently noted as the subject of a cleanup message if the
process they're looking at croaks whilst they're looking at it.

Further, kernel services like nfsd and cachefiles may be seen as the
fputter and may not have a system credential.  In cachefiles's case, it may
appear that cachefilesd caused the notification.

Suggested-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>
---

 fs/file_table.c    |   12 ++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 13 insertions(+)

diff --git a/fs/file_table.c b/fs/file_table.c
index 3f9c1b452c1d..9bf2be45b7f9 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -46,6 +46,7 @@ static void file_free_rcu(struct rcu_head *head)
 	struct file *f = container_of(head, struct file, f_u.fu_rcuhead);
 
 	put_cred(f->f_cred);
+	put_cred(f->f_fput_cred);
 	kmem_cache_free(filp_cachep, f);
 }
 
@@ -252,6 +253,7 @@ struct file *alloc_file_clone(struct file *base, int flags,
  */
 static void __fput(struct file *file)
 {
+	const struct cred *saved_cred;
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
 	struct inode *inode = file->f_inode;
@@ -262,6 +264,12 @@ static void __fput(struct file *file)
 
 	might_sleep();
 
+	/* Set the creds of whoever triggered the last fput for the LSM.  Note
+	 * that this has to be made available to further fputs, say on fds
+	 * trapped in a unix socket.
+	 */
+	saved_cred = override_creds(file->f_fput_cred);
+
 	fsnotify_close(file);
 	/*
 	 * The function eventpoll_release() should be the first called
@@ -293,6 +301,8 @@ static void __fput(struct file *file)
 	if (unlikely(mode & FMODE_NEED_UNMOUNT))
 		dissolve_on_fput(mnt);
 	mntput(mnt);
+
+	revert_creds(saved_cred);
 out:
 	file_free(file);
 }
@@ -334,6 +344,7 @@ void fput_many(struct file *file, unsigned int refs)
 	if (atomic_long_sub_and_test(refs, &file->f_count)) {
 		struct task_struct *task = current;
 
+		file->f_fput_cred = get_current_cred();
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
 			init_task_work(&file->f_u.fu_rcuhead, ____fput);
 			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
@@ -368,6 +379,7 @@ void __fput_sync(struct file *file)
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
 		BUG_ON(!(task->flags & PF_KTHREAD));
+		file->f_fput_cred = get_current_cred();
 		__fput(file);
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f1c74596cd77..db05738b1951 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -943,6 +943,7 @@ struct file {
 	loff_t			f_pos;
 	struct fown_struct	f_owner;
 	const struct cred	*f_cred;
+	const struct cred	*f_fput_cred;	/* Who did the last fput() (for LSM) */
 	struct file_ra_state	f_ra;
 
 	u64			f_version;
