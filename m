From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v8 17/20] ext4: wire up new fscrypt ioctls
Date: Mon,  5 Aug 2019 09:25:18 -0700
Message-ID: <20190805162521.90882-18-ebiggers@kernel.org>
References: <20190805162521.90882-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190805162521.90882-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Satya Tangirala <satyat@google.com>, Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

The key removal ioctls also required making ext4_drop_inode() call
fscrypt_drop_inode().

For more details see Documentation/filesystems/fscrypt.rst and the
fscrypt patches that added the implementation of these ioctls.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ioctl.c | 30 ++++++++++++++++++++++++++++++
 fs/ext4/super.c |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 442f7ef873fc36..fe5a4b13f939a2 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1115,6 +1115,31 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_get_policy_ex(filp, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_add_key(filp, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_remove_key(filp, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_remove_key_all_users(filp,
+							  (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		if (!ext4_has_feature_encrypt(sb))
+			return -EOPNOTSUPP;
+		return fscrypt_ioctl_get_key_status(filp, (void __user *)arg);
+
 	case EXT4_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
@@ -1231,6 +1256,11 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 	case EXT4_IOC_SHUTDOWN:
 	case FS_IOC_GETFSMAP:
 		break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4079605d437ae7..757819139b8f70 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1107,6 +1107,9 @@ static int ext4_drop_inode(struct inode *inode)
 {
 	int drop = generic_drop_inode(inode);
 
+	if (!drop)
+		drop = fscrypt_drop_inode(inode);
+
 	trace_ext4_drop_inode(inode, drop);
 	return drop;
 }
-- 
2.22.0.770.g0f2c4a37fd-goog
