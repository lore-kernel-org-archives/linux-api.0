From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 13/25] f2fs crypto: wire up new ioctls for managing encryption keys
Date: Mon, 23 Oct 2017 14:40:46 -0700
Message-ID: <20171023214058.128121-14-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20171023214058.128121-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, keyrings@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Ryo Hashimoto <hashimoto@chromium.org>, Sarthak Kukreti <sarthakkukreti@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 517e112c8a9a..0296a9594fe7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2651,6 +2651,12 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_get_encryption_policy(filp, arg);
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 		return f2fs_ioc_get_encryption_pwsalt(filp, arg);
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(filp, (void __user *)arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(filp, (const void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(filp, (void __user *)arg);
 	case F2FS_IOC_GARBAGE_COLLECT:
 		return f2fs_ioc_gc(filp, arg);
 	case F2FS_IOC_GARBAGE_COLLECT_RANGE:
@@ -2731,6 +2737,9 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 	case F2FS_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
 	case F2FS_IOC_GARBAGE_COLLECT:
 	case F2FS_IOC_GARBAGE_COLLECT_RANGE:
 	case F2FS_IOC_WRITE_CHECKPOINT:
-- 
2.15.0.rc0.271.g36b669edcc-goog
