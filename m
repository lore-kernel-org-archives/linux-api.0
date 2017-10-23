From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 23/25] f2fs crypto: wire up FS_IOC_GET_ENCRYPTION_POLICY_EX
Date: Mon, 23 Oct 2017 14:40:56 -0700
Message-ID: <20171023214058.128121-24-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20171023214058.128121-1-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, keyrings@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Ryo Hashimoto <hashimoto@chromium.org>, Sarthak Kukreti <sarthakkukreti@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

FS_IOC_GET_ENCRYPTION_POLICY_EX allows filesystem encryption users to
retrieve the encryption policy for files and directories that use a v2
encryption policy.  Unlike the original FS_IOC_GET_ENCRYPTION_POLICY,
FS_IOC_GET_ENCRYPTION_POLICY_EX is also extensible to new versions of
the policy struct that may be added in the future.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0296a9594fe7..68b6ba732f25 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1887,11 +1887,6 @@ static int f2fs_ioc_set_encryption_policy(struct file *filp, unsigned long arg)
 	return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 }
 
-static int f2fs_ioc_get_encryption_policy(struct file *filp, unsigned long arg)
-{
-	return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
-}
-
 static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -2647,10 +2642,12 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_fitrim(filp, arg);
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 		return f2fs_ioc_set_encryption_policy(filp, arg);
-	case F2FS_IOC_GET_ENCRYPTION_POLICY:
-		return f2fs_ioc_get_encryption_policy(filp, arg);
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 		return f2fs_ioc_get_encryption_pwsalt(filp, arg);
+	case F2FS_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(filp, (void __user *)arg);
 	case FS_IOC_ADD_ENCRYPTION_KEY:
 		return fscrypt_ioctl_add_key(filp, (void __user *)arg);
 	case FS_IOC_REMOVE_ENCRYPTION_KEY:
@@ -2737,6 +2734,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 	case F2FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
 	case FS_IOC_ADD_ENCRYPTION_KEY:
 	case FS_IOC_REMOVE_ENCRYPTION_KEY:
 	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
-- 
2.15.0.rc0.271.g36b669edcc-goog
