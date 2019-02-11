From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH v2 04/20] fs: add ->s_master_keys to struct
 super_block
Date: Mon, 11 Feb 2019 09:27:22 -0800
Message-ID: <20190211172738.4633-5-ebiggers@kernel.org>
References: <20190211172738.4633-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190211172738.4633-1-ebiggers@kernel.org>
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

Add an ->s_master_keys keyring to 'struct super_block'.  New fscrypt
ioctls will allow adding and removing encryption keys from this keyring.
This will enable solving multiple interrelated problems with how fscrypt
keys are provided and managed currently, including:

- Making the key status (which is currently per-process) match the
  filesystem-level status of which encrypted files are "unlocked".

- Supporting a proper API to remove encryption keys, "locking" the
  corresponding encrypted files.

- Caching an HMAC transform for each master key, allowing the use of
  HKDF while still retaining good performance.

- Preventing denial of service via keyctl_invalidate().

Similar to the existing ->s_cop, the keyring is added to the VFS-level
superblock struct rather than separately to the ext4, f2fs, and ubifs
superblock structs so that it can be used by the shared code in
fs/crypto/.  To minimize overhead, the keyring will only be allocated if
userspace actually adds a key; otherwise will stay NULL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/super.c         | 3 +++
 include/linux/fs.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 48e25eba8465..7ca05dda905c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -291,6 +291,9 @@ static void __put_super(struct super_block *s)
 		security_sb_free(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
+#ifdef CONFIG_FS_ENCRYPTION
+		key_put(s->s_master_keys);
+#endif
 		call_rcu(&s->rcu, destroy_super_rcu);
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ba7889bb9ef6..70d929ac89f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1405,6 +1405,7 @@ struct super_block {
 	const struct xattr_handler **s_xattr;
 #ifdef CONFIG_FS_ENCRYPTION
 	const struct fscrypt_operations	*s_cop;
+	struct key		*s_master_keys; /* master crypto keys in use */
 #endif
 	struct hlist_bl_head	s_roots;	/* alternate root dentries for NFS */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-- 
2.20.1
