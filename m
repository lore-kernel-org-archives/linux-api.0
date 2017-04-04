From: Joe Richey <joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fscrypt: Move key structure and constants to uapi
Date: Tue,  4 Apr 2017 15:39:13 -0700
Message-ID: <20170404223913.62817-1-joerichey94@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This commit exposes the necessary constants and structures for a
userspace program to pass filesystem encryption keys into the keyring.
The fscrypt_key structure was already part of the kernel ABI, this
change just makes it so programs no longer have to redeclare these
structures (like e4crypt in e2fsprogs currently does).

Note that we do not expose the other FS_*_KEY_SIZE constants as they are
not necessary. Only XTS is supported for contents_encryption_mode, so
currently FS_MAX_KEY_SIZE bytes of key material must always be passed to
the kernel.

This commit also removes __packed from fscrypt_key as it does not
contain any implicit padding and does not refer to an on-disk structure.

Change-Id: Iafc7d0f2127a5521a4566e59f2ed1ffc1526a62b
Signed-off-by: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/crypto/fscrypt_private.h | 11 -----------
 include/uapi/linux/fs.h     | 13 +++++++++++++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e39696e64494..e08ca6d1ca0f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -22,10 +22,6 @@
 #define FS_AES_256_CBC_KEY_SIZE		32
 #define FS_AES_256_CTS_KEY_SIZE		32
 #define FS_AES_256_XTS_KEY_SIZE		64
-#define FS_MAX_KEY_SIZE			64
-
-#define FS_KEY_DESC_PREFIX		"fscrypt:"
-#define FS_KEY_DESC_PREFIX_SIZE		8
 
 #define FS_KEY_DERIVATION_NONCE_SIZE		16
 
@@ -51,13 +47,6 @@ struct fscrypt_context {
 
 #define FS_ENCRYPTION_CONTEXT_FORMAT_V1		1
 
-/* This is passed in from userspace into the kernel keyring */
-struct fscrypt_key {
-	u32 mode;
-	u8 raw[FS_MAX_KEY_SIZE];
-	u32 size;
-} __packed;
-
 /*
  * A pointer to this structure is stored in the file system's in-core
  * representation of an inode.
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 048a85e9f017..9691fda01245 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -285,6 +285,19 @@ struct fscrypt_policy {
 #define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
 
+/* Parameters for passing an encryption key into the kernel keyring */
+#define FS_KEY_DESC_PREFIX		"fscrypt:"
+#define FS_KEY_DESC_PREFIX_SIZE		8
+
+/* Structure that userspace passes to the kernel keyring */
+#define FS_MAX_KEY_SIZE			64
+
+struct fscrypt_key {
+	__u32 mode;
+	__u8 raw[FS_MAX_KEY_SIZE];
+	__u32 size;
+};
+
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
  *
-- 
2.12.2.715.g7642488e1d-goog
