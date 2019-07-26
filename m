From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v7 15/16] ubifs: wire up new fscrypt ioctls
Date: Fri, 26 Jul 2019 15:41:40 -0700
Message-ID: <20190726224141.14044-16-ebiggers@kernel.org>
References: <20190726224141.14044-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190726224141.14044-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up the new ioctls for adding and removing fscrypt keys to/from the
filesystem, and the new ioctl for retrieving v2 encryption policies.

FS_IOC_REMOVE_ENCRYPTION_KEY also required making UBIFS use
fscrypt_drop_inode().

For more details see Documentation/filesystems/fscrypt.rst and the
fscrypt patches that added the implementation of these ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/ioctl.c | 16 ++++++++++++++++
 fs/ubifs/super.c | 11 +++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 034ad14710d14..a0dbf58780409 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -185,6 +185,18 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_GET_ENCRYPTION_POLICY:
 		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
 
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (const void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -202,6 +214,10 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case FS_IOC_SET_ENCRYPTION_POLICY:
 	case FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 2c0803b0ac3aa..3ad6620f14fb8 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -318,6 +318,16 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return err;
 }
 
+static int ubifs_drop_inode(struct inode *inode)
+{
+	int drop = generic_drop_inode(inode);
+
+	if (!drop)
+		drop = fscrypt_drop_inode(inode);
+
+	return drop;
+}
+
 static void ubifs_evict_inode(struct inode *inode)
 {
 	int err;
@@ -1990,6 +2000,7 @@ const struct super_operations ubifs_super_operations = {
 	.free_inode    = ubifs_free_inode,
 	.put_super     = ubifs_put_super,
 	.write_inode   = ubifs_write_inode,
+	.drop_inode    = ubifs_drop_inode,
 	.evict_inode   = ubifs_evict_inode,
 	.statfs        = ubifs_statfs,
 	.dirty_inode   = ubifs_dirty_inode,
-- 
2.22.0
