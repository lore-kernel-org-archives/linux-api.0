From: Joe Richey <joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fscrypt: Remove __packed from fscrypt_policy
Date: Tue,  4 Apr 2017 15:40:40 -0700
Message-ID: <20170404224040.63624-1-joerichey94@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This commit removes __packed from fscrypt_policy as it does not contain
any implicit padding and does not refer to an on-disk structure. Even
though this is a change to a UAPI file, no users will be broken as the
structure doesn't change.

Change-Id: I6075696cee284c3bd4aefa3e9e2dae735602c583
Signed-off-by: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
