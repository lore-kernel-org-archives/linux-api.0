From: Joe Richey <joerichey94@gmail.com>
Subject: [PATCH v2] fscrypt: Remove __packed from fscrypt_policy
Date: Thu,  6 Apr 2017 16:14:28 -0700
Message-ID: <20170406231428.154187-1-joerichey94@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org, linux-api@vger.kernel.org, Richard Weinberger <richard.weinberger@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Michael Halcrow <mhalcrow@google.com>, Joe Richey <joerichey@google.com>
List-Id: linux-api@vger.kernel.org

From: Joe Richey <joerichey@google.com>

This commit removes __packed from fscrypt_policy as it does not contain
any implicit padding and does not refer to an on-disk structure. Even
though this is a change to a UAPI file, no users will be broken as the
structure doesn't change.

Signed-off-by: Joe Richey <joerichey@google.com>
---
 include/uapi/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 048a85e9f017..f6e1c54ac5e2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -279,7 +279,7 @@ struct fscrypt_policy {
 	__u8 filenames_encryption_mode;
 	__u8 flags;
 	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
-} __packed;
+};
 
 #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
-- 
2.12.2.715.g7642488e1d-goog
