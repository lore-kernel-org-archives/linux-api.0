From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 15/25] fscrypt: add UAPI definitions to
 get/set v2 encryption policies
Date: Mon, 23 Oct 2017 14:40:48 -0700
Message-ID: <20171023214058.128121-16-ebiggers3@gmail.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20171023214058.128121-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Ryo Hashimoto <hashimoto@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>, linux-api@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, Michael Halcrow <mhalcrow@google.com>, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, fscrypt policies and xattrs identify the master key by
master_key_descriptor, which is an arbitrary 8-byte value used to form
the description of the keyring key.  However, there is no verification
that the key descriptor in any way corresponds with the key payload.
Since ->i_crypt_info by necessity gets set up on a "first come, first
serve" basis, this flaw allows a process with only read-only access to
an encrypted file or directory to provide the wrong key, causing the
file contents or directory listing to be corrupted.  This is a bug with
security implications which must be fixed.

To fix this bug without simply locking down adding keys to root, we must
replace master_key_descriptor with a cryptographic hash of the key.  We
name the replacement master_key_identifier and make it 16 bytes long,
which should provide enough collision resistance, and more importantly
preimage resistance, without bloating the size of the encryption xattr
too much.

This will be both an on-disk format and API change, since we'll need to
define new versions of both the fscrypt_context and fscrypt_policy.
This patch begins this process by defining the UAPI changes to manage v2
policies.  (Note: we jump to version 2 even though the previous policy
version number was 0 because the fscrypt_context was actually already
using version 1, not version 0.  It would be really confusing to have
them always be 1 off from each other.)

The existing FS_IOC_SET_ENCRYPTION_POLICY will be used to set a v2
policy, as the kernel will be able to examine the 'version' field.

However, a new ioctl FS_IOC_GET_ENCRYPTION_POLICY_EX is needed to get a
v2 policy, since the returned struct needs to be larger.  This ioctl
includes a size field as input, so that it can be used for both v1 and
v2 policies as well as any new policy versions that may get added in the
future.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/uapi/linux/fscrypt.h | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9da153df238a..065060b20a34 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -7,7 +7,6 @@
  * File system encryption support
  */
 /* Policy provided via an ioctl on the topmost directory */
-#define FSCRYPT_KEY_DESCRIPTOR_SIZE	8
 
 /* Encryption policy flags */
 #define FSCRYPT_POLICY_FLAGS_PAD_4	0x00
@@ -26,13 +25,22 @@
 #define FSCRYPT_MODE_AES_128_CBC	5
 #define FSCRYPT_MODE_AES_128_CTS	6
 
-struct fscrypt_policy {
+/*
+ * Legacy policy version; no key verification (potentially insecure).
+ * For new encrypted directories, use fscrypt_policy_v2 instead.
+ *
+ * Careful: the .version field for this is actually 0, not 1.
+ */
+#define FSCRYPT_POLICY_VERSION_LEGACY	0
+#define FSCRYPT_KEY_DESCRIPTOR_SIZE	8
+struct fscrypt_policy_v1 {
 	__u8 version;
 	__u8 contents_encryption_mode;
 	__u8 filenames_encryption_mode;
 	__u8 flags;
 	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 };
+#define fscrypt_policy	fscrypt_policy_v1
 
 /*
  * Process-subscribed "logon" key description prefix and payload format.
@@ -47,6 +55,30 @@ struct fscrypt_key {
 	__u32 size;
 };
 
+/*
+ * New policy version with HKDF and key verification (recommended).
+ */
+#define FSCRYPT_POLICY_VERSION_2	2
+#define FSCRYPT_KEY_IDENTIFIER_SIZE	16
+struct fscrypt_policy_v2 {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 reserved[4];
+	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+};
+
+/* Struct passed to FS_IOC_GET_ENCRYPTION_POLICY_EX */
+struct fscrypt_get_policy_ex_args {
+	__u64 size; /* input/output */
+	union {
+		__u8 version;
+		struct fscrypt_policy_v1 v1;
+		struct fscrypt_policy_v2 v2;
+	} policy; /* output */
+};
+
 struct fscrypt_key_specifier {
 	__u32 type;
 #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
@@ -91,6 +123,7 @@ struct fscrypt_get_key_status_args {
 #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR( 'f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW( 'f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY	_IOW( 'f', 21, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_POLICY_EX	_IOWR('f', 21, __u8[9]) /* size + version */
 #define FS_IOC_ADD_ENCRYPTION_KEY	_IOWR('f', 22, struct fscrypt_add_key_args)
 #define FS_IOC_REMOVE_ENCRYPTION_KEY	_IOR( 'f', 23, struct fscrypt_remove_key_args)
 #define FS_IOC_GET_ENCRYPTION_KEY_STATUS _IOWR('f',24, struct fscrypt_get_key_status_args)
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
