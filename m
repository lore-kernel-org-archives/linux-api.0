From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 25/25] fscrypt: document the new ioctls and
 policy version
Date: Mon, 23 Oct 2017 14:40:58 -0700
Message-ID: <20171023214058.128121-26-ebiggers3@gmail.com>
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

Update the fscrypt documentation file to catch up to all the latest
changes, including the new ioctls to manage master encryption keys in
the filesystem-level keyring, the support for v2 encryption policies,
and the new key derivation function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 565 ++++++++++++++++++++++++++++------
 1 file changed, 472 insertions(+), 93 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index f12956f3f1f8..f2d0ff2269f3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -72,6 +72,9 @@ Online attacks
 fscrypt (and storage encryption in general) can only provide limited
 protection, if any at all, against online attacks.  In detail:
 
+Side-channel attacks
+~~~~~~~~~~~~~~~~~~~~
+
 fscrypt is only resistant to side-channel attacks, such as timing or
 electromagnetic attacks, to the extent that the underlying Linux
 Cryptographic API algorithms are.  If a vulnerable algorithm is used,
@@ -80,29 +83,86 @@ attacker to mount a side channel attack against the online system.
 Side channel attacks may also be mounted against applications
 consuming decrypted data.
 
-After an encryption key has been provided, fscrypt is not designed to
-hide the plaintext file contents or filenames from other users on the
-same system, regardless of the visibility of the keyring key.
-Instead, existing access control mechanisms such as file mode bits,
-POSIX ACLs, LSMs, or mount namespaces should be used for this purpose.
-Also note that as long as the encryption keys are *anywhere* in
-memory, an online attacker can necessarily compromise them by mounting
-a physical attack or by exploiting any kernel security vulnerability
-which provides an arbitrary memory read primitive.
-
-While it is ostensibly possible to "evict" keys from the system,
-recently accessed encrypted files will remain accessible at least
-until the filesystem is unmounted or the VFS caches are dropped, e.g.
-using ``echo 2 > /proc/sys/vm/drop_caches``.  Even after that, if the
-RAM is compromised before being powered off, it will likely still be
-possible to recover portions of the plaintext file contents, if not
-some of the encryption keys as well.  (Since Linux v4.12, all
-in-kernel keys related to fscrypt are sanitized before being freed.
-However, userspace would need to do its part as well.)
-
-Currently, fscrypt does not prevent a user from maliciously providing
-an incorrect key for another user's existing encrypted files.  A
-protection against this is planned.
+Unauthorized file access
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+After an encryption key has been added, fscrypt does not hide the
+plaintext file contents or filenames from other users on the same
+system.  Instead, existing access control mechanisms such as file mode
+bits, POSIX ACLs, LSMs, or namespaces should be used for this purpose.
+
+(For the reasoning behind this, understand that while the key is
+added, the confidentiality of the data, from the perspective of the
+system itself, is *not* protected by the mathematical properties of
+encryption but rather only by the correctness of the kernel.
+Therefore, any encryption-specific access control checks would merely
+be enforced by kernel *code* and therefore would be largely redundant
+with the wide variety of access control mechanisms already available.)
+
+Kernel compromise
+~~~~~~~~~~~~~~~~~
+
+An attacker who compromises the system enough to read from arbitrary
+memory, e.g. by mounting a physical attack or by exploiting a kernel
+security vulnerability, can compromise all encryption keys that are
+currently in use.
+
+However, fscrypt does allow an encryption key to be removed from the
+kernel, which may protect it from later compromise.
+
+In more detail, the FS_IOC_REMOVE_ENCRYPTION_KEY ioctl will wipe a
+master encryption key from kernel memory.  Moreover, it will try to
+evict all cached inodes which had been "unlocked" using the key,
+thereby wiping their derived encryption keys and making them once
+again appear "locked", i.e. in ciphertext or encrypted form.
+
+However, FS_IOC_REMOVE_ENCRYPTION_KEY has some limitations:
+
+- Derived keys for in-use files will *not* be removed or wiped.
+  Therefore, for maximum effect, userspace should close the relevant
+  encrypted files and directories before removing a master key, as
+  well as kill any processes whose working directory is in an affected
+  encrypted directory.
+
+- The kernel cannot magically wipe copies of the master key(s) that
+  userspace might have as well.  Therefore, userspace must wipe all
+  copies of the master key(s) it makes as well.  Naturally, the same
+  also applies to all higher levels in the key hierarchy, e.g. to all
+  key(s) that are used to wrap or derive the fscrypt master keys.
+  Userspace should also follow other security precautions such as
+  mlock()ing memory containing keys to prevent it from being swapped
+  out.
+
+- In general, decrypted contents and filenames in the kernel VFS
+  caches are freed but not wiped.  Therefore, portions thereof may be
+  recoverable from freed memory, even after the corresponding key(s)
+  were wiped.  To partially solve this, you may enable page poisoning
+  by enabling CONFIG_PAGE_POISONING in your kernel config and adding
+  page_poison=1 to your kernel command line.  However, that has a
+  performance cost.
+
+- Secret keys might still exist in CPU registers, in crypto
+  accelerator hardware (if used by the crypto API to provide any of
+  the algorithms), or in other places not explicitly considered here.
+
+Limitations of v1 policies
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The original encryption policy version (which we call "v1") had some
+weaknesses with respect to online attacks:
+
+- There was no verification that the provided master key was correct.
+  Therefore, malicious users could associate the wrong key with
+  encrypted files, even files to which they had only read-only access.
+
+- A compromise of any file's derived encryption key also compromised
+  the master key it was derived from.
+
+- Non-root users could not securely remove encryption keys.
+
+All the above problems are fixed with v2 encryption policies
+(:c:type:`fscrypt_policy_v2`).  For this reason, it's recommended to
+use v2 encryption policies for all new encrypted directories.
 
 Key hierarchy
 =============
@@ -167,19 +227,27 @@ master keys or to support rotating master keys.  Instead, the master
 keys may be wrapped in userspace, e.g. as done by the `fscrypt
 <https://github.com/google/fscrypt>`_ tool.
 
-The current KDF encrypts the master key using the 16-byte nonce as an
-AES-128-ECB key.  The output is used as the derived key.  If the
-output is longer than needed, then it is truncated to the needed
-length.  Truncation is the norm for directories and symlinks, since
-those use the CTS-CBC encryption mode which requires a key half as
-long as that required by the XTS encryption mode.
-
-Note: this KDF meets the primary security requirement, which is to
-produce unique derived keys that preserve the entropy of the master
-key, assuming that the master key is already a good pseudorandom key.
-However, it is nonstandard and has some problems such as being
-reversible, so it is generally considered to be a mistake!  It may be
-replaced with HKDF or another more standard KDF in the future.
+A different KDF is used depending on the encryption policy version:
+
+For v1 encryption policies, the KDF is somewhat ad-hoc: we encrypt the
+master key with AES-128-ECB using the file's 16-byte nonce as the AES
+key, and the resulting ciphertext is used as the derived key.  If the
+master key is longer than the derived key, then only the needed prefix
+of the ciphertext is used.  Truncation is the norm for directories and
+symlinks, since those use the CTS-CBC encryption mode which requires a
+key half as long as that required by the XTS encryption mode.
+
+For v2 encryption policies, the KDF is HKDF-SHA512.  HKDF is preferred
+to the AES-based KDF because HKDF is standardized and has a number of
+desirable properties such as being nonreversible and evenly
+distributing the entropy from the master key.  To derive a file's
+encryption key using HKDF, the master key is used as the "input key
+material", a fixed value is used as the "salt", and the file's 16-byte
+nonce prefixed with a context byte is used as the
+"application-specific information string".  (A fixed salt is used
+because there is no random salt available on a per-master-key basis,
+and the master keys should already be good pseudorandom keys that are
+long enough to make dictionary attacks infeasible.)
 
 Encryption modes and usage
 ==========================
@@ -249,21 +317,38 @@ Setting an encryption policy
 The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
 empty directory or verifies that a directory or regular file already
 has the specified encryption policy.  It takes in a pointer to a
-:c:type:`struct fscrypt_policy`, defined as follows::
-
-    #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
+:c:type:`struct fscrypt_policy_v1` or a :c:type:`struct
+fscrypt_policy_v2`, defined as follows::
 
-    struct fscrypt_policy {
+    #define FSCRYPT_POLICY_VERSION_LEGACY   0
+    #define FSCRYPT_KEY_DESCRIPTOR_SIZE     8
+    struct fscrypt_policy_v1 {
             __u8 version;
             __u8 contents_encryption_mode;
             __u8 filenames_encryption_mode;
             __u8 flags;
             __u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
     };
+    #define fscrypt_policy  fscrypt_policy_v1
+
+    #define FSCRYPT_POLICY_VERSION_2        2
+    #define FSCRYPT_KEY_IDENTIFIER_SIZE     16
+    struct fscrypt_policy_v2 {
+            __u8 version;
+            __u8 contents_encryption_mode;
+            __u8 filenames_encryption_mode;
+            __u8 flags;
+            __u8 reserved[4];
+            __u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+    };
 
 This structure must be initialized as follows:
 
-- ``version`` must be 0.
+- ``version`` must be FSCRYPT_POLICY_VERSION_LEGACY (0) if the struct
+  is :c:type:`fscrypt_policy_v1` or FSCRYPT_POLICY_VERSION_2 (2) if
+  the struct is :c:type:`fscrypt_policy_v2`.  (Note: we refer to the
+  legacy policy version as "v1", though its version number was really
+  0.)  For new encrypted directories, use v2 policies.
 
 - ``contents_encryption_mode`` and ``filenames_encryption_mode`` must
   be set to constants from ``<linux/fs.h>`` which identify the
@@ -276,15 +361,25 @@ This structure must be initialized as follows:
   identifies the amount of NUL-padding to use when encrypting
   filenames.  If unsure, use FSCRYPT_POLICY_FLAGS_PAD_32 (0x3).
 
-- ``master_key_descriptor`` specifies how to find the master key in
-  the keyring; see `Adding keys`_.  It is up to userspace to choose a
-  unique ``master_key_descriptor`` for each master key.  The e4crypt
-  and fscrypt tools use the first 8 bytes of
+- For v2 encryption policies, ``reserved`` must be zeroed.
+
+- For v1 encryption policies, ``master_key_descriptor`` specifies how
+  to find the master key in a keyring; see `Adding keys`_.  It is up
+  to userspace to choose a unique ``master_key_descriptor`` for each
+  master key.  The e4crypt and fscrypt tools use the first 8 bytes of
   ``SHA-512(SHA-512(master_key))``, but this particular scheme is not
   required.  Also, the master key need not be in the keyring yet when
   FS_IOC_SET_ENCRYPTION_POLICY is executed.  However, it must be added
   before any files can be created in the encrypted directory.
 
+  For v2 encryption policies, ``master_key_descriptor`` has been
+  replaced with ``master_key_identifier``, which is longer and cannot
+  be arbitrarily chosen.  Instead, the key must first be added using
+  FS_IOC_ADD_ENCRYPTION_KEY, as described in `Adding keys`_.  Then,
+  the ``key_spec.identifier`` the kernel returned in the
+  :c:type:`struct fscrypt_add_key_args` must be used as the
+  ``master_key_identifier`` in the ``struct fscrypt_policy_v2``.
+
 If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
 verifies that the file is an empty directory.  If so, the specified
 encryption policy is assigned to the directory, turning it into an
@@ -300,6 +395,15 @@ policy exactly matches the actual one.  If they match, then the ioctl
 returns 0.  Otherwise, it fails with EEXIST.  This works on both
 regular files and directories, including nonempty directories.
 
+When a v2 encryption policy is assigned to a directory, it is also
+required that either the specified key has been added by the current
+user, or the caller has CAP_FOWNER in the initial user namespace.
+(This is needed to prevent a user from encrypting their data with
+another user's key.)  The key must remain added while
+FS_IOC_SET_ENCRYPTION_POLICY is executing.  However, if the new
+encrypted directory does not need to be accessed immediately, then the
+key can be removed right away afterwards.
+
 Note that the ext4 filesystem does not allow the root directory to be
 encrypted, even if it is empty.  Users who want to encrypt an entire
 filesystem with one key should consider using dm-crypt instead.
@@ -312,7 +416,9 @@ FS_IOC_SET_ENCRYPTION_POLICY can fail with the following errors:
 - ``EEXIST``: the file is already encrypted with an encryption policy
   different from the one specified
 - ``EINVAL``: an invalid encryption policy was specified (invalid
-  version, mode(s), or flags)
+  version, mode(s), or flags; or reserved bits were set)
+- ``ENOKEY``: a v2 encryption policy was specified, but the key with
+  the specified ``master_key_identifier`` has not been added
 - ``ENOTDIR``: the file is unencrypted and is a regular file, not a
   directory
 - ``ENOTEMPTY``: the file is unencrypted and is a nonempty directory
@@ -331,25 +437,82 @@ FS_IOC_SET_ENCRYPTION_POLICY can fail with the following errors:
 Getting an encryption policy
 ----------------------------
 
-The FS_IOC_GET_ENCRYPTION_POLICY ioctl retrieves the :c:type:`struct
-fscrypt_policy`, if any, for a directory or regular file.  See above
-for the struct definition.  No additional permissions are required
-beyond the ability to open the file.
+Two ioctls are available to get a file's encryption policy:
+
+- FS_IOC_GET_ENCRYPTION_POLICY_EX
+- FS_IOC_GET_ENCRYPTION_POLICY
+
+The extended (_EX) version of the ioctl is more general and is
+recommended to use when possible.  However, on older kernels only the
+original ioctl is available.  Applications should try the extended
+version, and if it fails with ENOTTY fall back to the original
+version.
+
+Preferred method
+~~~~~~~~~~~~~~~~
+
+The FS_IOC_GET_ENCRYPTION_POLICY_EX ioctl retrieves the encryption
+policy, if any, for a directory or regular file.  No additional
+permissions are required beyond the ability to open the file.  It
+takes in a pointer to a buffer formatted as a :c:type:`struct
+fscrypt_get_policy_ex_args`, defined as follows::
+
+    struct fscrypt_get_policy_ex_args {
+            __u64 size;
+            union {
+                    __u8 version;
+                    struct fscrypt_policy_v1 v1;
+                    struct fscrypt_policy_v2 v2;
+            } policy;
+    };
+
+The caller must initialize ``size`` to the size of the buffer in
+bytes, including both the ``size`` field and the space available for
+the policy struct.  It is recommended to use ``sizeof(struct
+fscrypt_get_policy_ex_args)``.
+
+On successful return, ``size`` is set to the actual number of bytes
+returned, including both the ``size`` field and the actual size of the
+returned policy struct.  In addition, the ``version`` field should be
+used to determine the actual policy version returned.  Note that the
+version code for the "v1" policy is actually 0
+(FSCRYPT_POLICY_VERSION_LEGACY).
 
-FS_IOC_GET_ENCRYPTION_POLICY can fail with the following errors:
+FS_IOC_GET_ENCRYPTION_POLICY_EX can fail with the following errors:
 
 - ``EINVAL``: the file is encrypted, but it uses an unrecognized
-  encryption context format
+  encryption policy version; or, an invalid ``size`` was provided
 - ``ENODATA``: the file is not encrypted
-- ``ENOTTY``: this type of filesystem does not implement encryption
+- ``ENOTTY``: this type of filesystem does not implement encryption,
+  or this kernel is too old to support FS_IOC_GET_ENCRYPTION_POLICY_EX
+  (try FS_IOC_GET_ENCRYPTION_POLICY instead)
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
   support for this filesystem
+- ``EOVERFLOW``: the file is encrypted and uses a recognized
+  encryption policy version, but the policy struct does not fit into
+  the provided buffer
 
 Note: if you only need to know whether a file is encrypted or not, on
 most filesystems it is also possible to use the FS_IOC_GETFLAGS ioctl
 and check for FS_ENCRYPT_FL, or to use the statx() system call and
 check for STATX_ATTR_ENCRYPTED in stx_attributes.
 
+Legacy method
+~~~~~~~~~~~~~
+
+The FS_IOC_GET_ENCRYPTION_POLICY ioctl can also retrieve the
+encryption policy, if any, for a directory or regular file.  However,
+unlike the extended version (FS_IOC_GET_ENCRYPTION_POLICY_EX),
+FS_IOC_GET_ENCRYPTION_POLICY only supports the original policy
+version.  It takes in a pointer directly to a :c:type:`struct
+fscrypt_policy_v1` rather than a :c:type:`struct
+fscrypt_get_policy_ex_args`.
+
+The error codes for FS_IOC_GET_ENCRYPTION_POLICY are the same as those
+for FS_IOC_GET_ENCRYPTION_POLICY_EX, except that
+FS_IOC_GET_ENCRYPTION_POLICY also returns ``EINVAL`` if the file is
+encrypted using a newer encryption policy version.
+
 Getting the per-filesystem salt
 -------------------------------
 
@@ -365,8 +528,97 @@ generate and manage any needed salt(s) in userspace.
 Adding keys
 -----------
 
-To provide a master key, userspace must add it to an appropriate
-keyring using the add_key() system call (see:
+Preferred method
+~~~~~~~~~~~~~~~~
+
+The FS_IOC_ADD_ENCRYPTION_KEY ioctl adds a master encryption key to
+the filesystem, making all files on the filesystem which were
+encrypted using that key appear "unlocked", i.e. in plaintext form.
+It takes in a pointer to a :c:type:`struct fscrypt_add_key_args`,
+defined as follows::
+
+    struct fscrypt_add_key_args {
+            __u32 raw_size;
+            __u32 reserved1;
+            __u64 reserved2[2];
+            struct fscrypt_key_specifier key_spec;
+            __u8 raw[];
+    };
+
+    struct fscrypt_key_specifier {
+            __u32 type;
+    #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR        1
+    #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER        2
+            __u32 reserved;
+            union {
+                    __u8 max_specifier[32];
+                    __u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
+                    __u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+            };
+    };
+
+:c:type:`struct fscrypt_add_key_args` must be initialized as follows:
+
+- ``raw_size`` must be the size of the ``raw`` key provided, in bytes.
+
+- If the key is being added for use by v1 encryption policies, then
+  ``key_spec.type`` must contain FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR, and
+  ``key_spec.descriptor`` must contain the descriptor of the key being
+  added, corresponding to the value in the ``master_key_descriptor``
+  field of :c:type:`struct fscrypt_policy_v1`.  To add this type of
+  key, the calling process must have the CAP_SYS_ADMIN capability in
+  the initial user namespace.
+
+  Alternatively, if the key is being added for use by v2 encryption
+  policies, then ``key_spec.type`` must contain
+  FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER, and ``key_spec.identifier`` is an
+  *output* field which the kernel fills in with a cryptographic hash
+  of the key.  To add this type of key, the calling process does not
+  need any privileges.  However, the number of keys that can be added
+  is limited by the user's quota for the keyrings service (see
+  ``Documentation/security/keys/core.rst``).
+
+- ``raw`` is a variable-length field which must contain the actual
+  key, ``raw_size`` bytes long.
+
+- All reserved fields must be zeroed.
+
+FS_IOC_ADD_ENCRYPTION_KEY can fail with the following errors:
+
+- ``EACCES``: FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR was specified, but the
+  caller does not have the CAP_SYS_ADMIN capability in the initial
+  user namespace
+- ``EDQUOT``: the key quota for this user would be exceeded by adding
+  the key
+- ``EINVAL``: invalid key size or key specifier type, or reserved bits
+  were set
+- ``ENOTTY``: this type of filesystem does not implement encryption
+- ``EOPNOTSUPP``: the kernel was not configured with encryption
+  support for this filesystem, or the filesystem superblock has not
+  had encryption enabled on it
+
+Legacy method
+~~~~~~~~~~~~~
+
+For v1 encryption policies, a master encryption key can also be
+provided by adding it to a process-subscribed keyring, e.g. to a
+session keyring, or to a user keyring if the user keyring is linked
+into the session keyring.
+
+This method is deprecated (and not supported for v2 encryption
+policies) for several reasons.  First, it cannot be used in
+combination with FS_IOC_REMOVE_ENCRYPTION_KEY (see `Removing keys`_),
+so for removing a key a workaround such as keyctl_unlink() in
+combination with ``sync; echo 2 > /proc/sys/vm/drop_caches`` would
+have to be used.  Second, it doesn't match the fact that the
+locked/unlocked status of encrypted files (i.e. whether they appear to
+be in plaintext form or in ciphertext form) is global.  This mismatch
+has caused much confusion as well as real problems when processes
+running under different UIDs, such as a ``sudo`` command, need to
+access encrypted files.
+
+Nevertheless, to add a key to one of the process-subscribed keyrings,
+the add_key() system call can be used (see:
 ``Documentation/security/keys/core.rst``).  The key type must be
 "logon"; keys of this type are kept in kernel memory and cannot be
 read back by userspace.  The key description must be "fscrypt:"
@@ -391,26 +643,143 @@ with a filesystem-specific prefix such as "ext4:".  However, the
 filesystem-specific prefixes are deprecated and should not be used in
 new programs.
 
-There are several different types of keyrings in which encryption keys
-may be placed, such as a session keyring, a user session keyring, or a
-user keyring.  Each key must be placed in a keyring that is "attached"
-to all processes that might need to access files encrypted with it, in
-the sense that request_key() will find the key.  Generally, if only
-processes belonging to a specific user need to access a given
-encrypted directory and no session keyring has been installed, then
-that directory's key should be placed in that user's user session
-keyring or user keyring.  Otherwise, a session keyring should be
-installed if needed, and the key should be linked into that session
-keyring, or in a keyring linked into that session keyring.
-
-Note: introducing the complex visibility semantics of keyrings here
-was arguably a mistake --- especially given that by design, after any
-process successfully opens an encrypted file (thereby setting up the
-per-file key), possessing the keyring key is not actually required for
-any process to read/write the file until its in-memory inode is
-evicted.  In the future there probably should be a way to provide keys
-directly to the filesystem instead, which would make the intended
-semantics clearer.
+Removing keys
+-------------
+
+The FS_IOC_REMOVE_ENCRYPTION_KEY ioctl can be used to remove a master
+encryption key from the kernel, wiping the corresponding secrets from
+memory and causing any files which were "unlocked" with the key to
+appear "locked" again.  It takes in a pointer to a :c:type:`struct
+fscrypt_remove_key_args`, defined as follows::
+
+    struct fscrypt_remove_key_args {
+            __u32 flags;
+    #define FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS       0x00000001
+            __u32 reserved1;
+            __u64 reserved2[2];
+            struct fscrypt_key_specifier key_spec;
+    };
+
+This structure must be initialized as follows:
+
+- ``flags`` can contain the following flags:
+
+    - ``FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS`` specifies that the key
+      should be removed even if it has also been added by other users.
+      Specifying this flag requires the CAP_SYS_ADMIN capability in
+      the initial user namespace.
+
+- The key to remove is specified by ``key_spec``:
+
+    - To remove a key used by v1 encryption policies, set
+      ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR and fill
+      in ``key_spec.descriptor``.  To remove this type of key, the
+      calling process must have the CAP_SYS_ADMIN capability in the
+      initial user namespace.
+
+    - To remove a key used by v2 encryption policies, set
+      ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER and fill
+      in ``key_spec.identifier``.  To remove this type of key, no
+      privileges are needed.  However, users can only remove keys that
+      they added themselves, subject to privileged override with
+      FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS.
+
+- All reserved fields must be zeroed.
+
+FS_IOC_REMOVE_ENCRYPTION_KEY can fail with the following errors:
+
+- ``EACCES``: The FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR key specifier type
+  and/or the FSCRYPT_REMOVE_KEY_FLAG_ALL_USERS flag was specified, but
+  the caller does not have the CAP_SYS_ADMIN capability in the initial
+  user namespace
+- ``EBUSY``: the master key secret was wiped from memory, but some
+  files which were unlocked with it are still in use.  Such files
+  could not be locked, nor could their per-file keys be wiped from
+  memory.  The ioctl may be retried later to re-attempt locking the
+  remaining files.
+- ``EINVAL``: invalid flags or key specifier type, or reserved bits
+  were set
+- ``ENOKEY``: the key is not present or has already been removed
+- ``ENOTTY``: this type of filesystem does not implement encryption
+- ``EOPNOTSUPP``: the kernel was not configured with encryption
+  support for this filesystem, or the filesystem superblock has not
+  had encryption enabled on it
+- ``EUSERS``: the key cannot be removed because other users have added
+  it too
+
+Before using this ioctl, please read the `Kernel compromise`_ section
+for a discussion of the security goals and limitations of this ioctl.
+
+Getting key status
+------------------
+
+The FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl retrieves the status of a
+master encryption key.  It takes in a pointer to a :c:type:`struct
+fscrypt_get_key_status_args`, defined as follows::
+
+    struct fscrypt_get_key_status_args {
+            /* input */
+            __u64 reserved1[3];
+            struct fscrypt_key_specifier key_spec;
+
+            /* output */
+            __u32 status;
+    #define FSCRYPT_KEY_STATUS_ABSENT               1
+    #define FSCRYPT_KEY_STATUS_PRESENT              2
+    #define FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED 3
+            __u32 status_flags;
+    #define FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF   0x00000001
+            __u32 user_count;
+            __u32 reserved2;
+            __u64 reserved3[6];
+    };
+
+The caller must zero ``reserved1``, then fill in ``key_spec``:
+
+    - To get the status of a key for v1 encryption policies, set
+      ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR and fill
+      in ``key_spec.descriptor``.
+
+    - To get the status of a key for v2 encryption policies, set
+      ``key_spec.type`` to FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER and fill
+      in ``key_spec.identifier``.
+
+On success, 0 is returned and the kernel fills in the output fields:
+
+- ``status`` indicates whether the key is absent, present, or
+  incompletely removed.  Incompletely removed means that the master
+  secret has been removed, but some files are still in use; i.e.,
+  FS_IOC_REMOVE_ENCRYPTION_KEY returned EBUSY.
+
+- ``status_flags`` can contain the following flags:
+
+    - ``FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF`` indicates that the key
+      has added by the current user.  This is only set for keys
+      identified by ``identifier`` rather than by ``descriptor``.
+
+- ``user_count`` specifies the number of users who have added the key.
+  This is only set for keys identified by ``identifier`` rather than
+  by ``descriptor``.
+
+FS_IOC_GET_ENCRYPTION_KEY_STATUS can fail with the following errors:
+
+- ``EINVAL``: invalid key specifier type, or reserved bits were set
+- ``ENOTTY``: this type of filesystem does not implement encryption
+- ``EOPNOTSUPP``: the kernel was not configured with encryption
+  support for this filesystem, or the filesystem superblock has not
+  had encryption enabled on it
+
+Among other use cases, FS_IOC_GET_ENCRYPTION_KEY_STATUS might be
+useful for determining whether the key for a given encrypted directory
+needs to be added before prompting the user for the passphrase needed
+to derive the key.
+
+FS_IOC_GET_ENCRYPTION_KEY_STATUS can only get the status of keys in
+the filesystem-level keyring, i.e. the keyring managed by
+FS_IOC_ADD_ENCRYPTION_KEY and FS_IOC_REMOVE_ENCRYPTION_KEY.  It cannot
+get the status of a key that has only been added for use by v1
+encryption policies using the legacy mechanism involving
+process-subscribed keyrings.
 
 Access semantics
 ================
@@ -459,7 +828,7 @@ Without the key
 
 Some filesystem operations may be performed on encrypted regular
 files, directories, and symlinks even before their encryption key has
-been provided:
+been added, or after their encryption key has been removed:
 
 - File metadata may be read, e.g. using stat().
 
@@ -524,20 +893,20 @@ Encryption context
 ------------------
 
 An encryption policy is represented on-disk by a :c:type:`struct
-fscrypt_context`.  It is up to individual filesystems to decide where
-to store it, but normally it would be stored in a hidden extended
-attribute.  It should *not* be exposed by the xattr-related system
-calls such as getxattr() and setxattr() because of the special
-semantics of the encryption xattr.  (In particular, there would be
-much confusion if an encryption policy were to be added to or removed
-from anything other than an empty directory.)  The struct is defined
-as follows::
+fscrypt_context_v1` or a :c:type:`struct fscrypt_context_v2`.  It is
+up to individual filesystems to decide where to store it, but normally
+it would be stored in a hidden extended attribute.  It should *not* be
+exposed by the xattr-related system calls such as getxattr() and
+setxattr() because of the special semantics of the encryption xattr.
+(In particular, there would be much confusion if an encryption policy
+were to be added to or removed from anything other than an empty
+directory.)  These structs are defined as follows::
 
-    #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
     #define FS_KEY_DERIVATION_NONCE_SIZE 16
 
-    struct fscrypt_context {
-            u8 format;
+    #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
+    struct fscrypt_context_v1 {
+            u8 version;
             u8 contents_encryption_mode;
             u8 filenames_encryption_mode;
             u8 flags;
@@ -545,12 +914,22 @@ as follows::
             u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
     };
 
-Note that :c:type:`struct fscrypt_context` contains the same
-information as :c:type:`struct fscrypt_policy` (see `Setting an
-encryption policy`_), except that :c:type:`struct fscrypt_context`
-also contains a nonce.  The nonce is randomly generated by the kernel
-and is used to derive the inode's encryption key as described in
-`Per-file keys`_.
+    #define FSCRYPT_KEY_IDENTIFIER_SIZE  16
+    struct fscrypt_context_v2 {
+            u8 version;
+            u8 contents_encryption_mode;
+            u8 filenames_encryption_mode;
+            u8 flags;
+            u8 reserved[4];
+            u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+            u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+    };
+
+Note that the context structs contain the same information as the
+corresponding policy structs (see `Setting an encryption policy`_),
+except that the context structs also contain a nonce.  The nonce is
+randomly generated by the kernel and is used to derive the inode's
+encryption key as described in `Per-file keys`_.
 
 Data path changes
 -----------------
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
