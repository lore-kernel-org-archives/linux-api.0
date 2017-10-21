From: Nicolas Belouin <nicolas@belouin.fr>
Subject: [RFC PATCH 2/2] fs: add the possibility to use CAP_SYS_MOUNT to (u)mount a fs
Date: Sat, 21 Oct 2017 15:43:03 +0200
Message-ID: <20171021134303.20685-2-nicolas@belouin.fr>
References: <20171021134303.20685-1-nicolas@belouin.fr>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171021134303.20685-1-nicolas@belouin.fr>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Nicolas Belouin <nicolas@belouin.fr>
List-Id: linux-api@vger.kernel.org

Fulfill the purpose of CAP_SYS_MOUNT by adding it as a sufficient
capability to mount and unmount filesystems.

Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
---
 fs/cachefiles/daemon.c |  2 +-
 fs/ext4/ioctl.c        |  2 +-
 fs/namespace.c         |  3 ++-
 fs/super.c             | 14 +++++++++-----
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 1ee54ffd3a24..fc53bdeacc8a 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -91,7 +91,7 @@ static int cachefiles_daemon_open(struct inode *inode, struct file *file)
 	_enter("");
 
 	/* only the superuser may do this */
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_MOUNT))
 		return -EPERM;
 
 	/* the cachefiles device may only be open once at a time */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index afb66d4ab5cf..19d838e558e2 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -458,7 +458,7 @@ static int ext4_shutdown(struct super_block *sb, unsigned long arg)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	__u32 flags;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_MOUNT))
 		return -EPERM;
 
 	if (get_user(flags, (__u32 __user *)arg))
diff --git a/fs/namespace.c b/fs/namespace.c
index 3b601f115b6c..1eaa6a9f1631 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1661,7 +1661,8 @@ void __detach_mounts(struct dentry *dentry)
  */
 static inline bool may_mount(void)
 {
-	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN);
+	return ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN) ||
+	       ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_MOUNT);
 }
 
 static inline bool may_mandlock(void)
diff --git a/fs/super.c b/fs/super.c
index 166c4ee0d0ed..1d84d8b87216 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -474,7 +474,7 @@ struct super_block *sget_userns(struct file_system_type *type,
 
 	if (!(flags & (SB_KERNMOUNT|SB_SUBMOUNT)) &&
 	    !(type->fs_flags & FS_USERNS_MOUNT) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_MOUNT))
 		return ERR_PTR(-EPERM);
 retry:
 	spin_lock(&sb_lock);
@@ -551,7 +551,9 @@ struct super_block *sget(struct file_system_type *type,
 		user_ns = &init_user_ns;
 
 	/* Ensure the requestor has permissions over the target filesystem */
-	if (!(flags & (SB_KERNMOUNT|SB_SUBMOUNT)) && !ns_capable(user_ns, CAP_SYS_ADMIN))
+	if (!(flags & (SB_KERNMOUNT | SB_SUBMOUNT)) &&
+	    !ns_capable(user_ns, CAP_SYS_ADMIN) &&
+	    !ns_capable(user_ns, CAP_SYS_MOUNT))
 		return ERR_PTR(-EPERM);
 
 	return sget_userns(type, test, set, flags, user_ns, data);
@@ -1020,10 +1022,12 @@ struct dentry *mount_ns(struct file_system_type *fs_type,
 {
 	struct super_block *sb;
 
-	/* Don't allow mounting unless the caller has CAP_SYS_ADMIN
-	 * over the namespace.
+	/* Don't allow mounting unless the caller has CAP_SYS_ADMIN (deprecated)
+	 * or CAP_SYS_MOUNT over the namespace.
 	 */
-	if (!(flags & SB_KERNMOUNT) && !ns_capable(user_ns, CAP_SYS_ADMIN))
+	if (!(flags & SB_KERNMOUNT) &&
+	    !ns_capable(user_ns, CAP_SYS_ADMIN) &&
+	    !ns_capable(user_ns, CAP_SYS_MOUNT))
 		return ERR_PTR(-EPERM);
 
 	sb = sget_userns(fs_type, ns_test_super, ns_set_super, flags,
-- 
2.14.2
