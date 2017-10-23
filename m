From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 05/25] fs: add ->s_master_keys to struct
 super_block
Date: Mon, 23 Oct 2017 14:40:38 -0700
Message-ID: <20171023214058.128121-6-ebiggers3@gmail.com>
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

Add an ->s_master_keys keyring to 'struct super_block' for holding
encryption keys which have been added to the filesystem.  This keyring
will be populated using a new fscrypt ioctl.

This is needed for several reasons, including:

- To solve the visibility problems of having filesystem encryption keys
  stored in process-subscribed keyrings, while the VFS state of the
  filesystem is actually global.

- To implement a proper API for removing keys, which among other things
  will require maintaining the list of inodes that are using each master
  key so that we can evict the inodes when the key is removed.

- To allow caching a crypto transform for each master key so that we
  don't have to repeatedly allocate one over and over.

See later patches for full details, including why it wouldn't be enough
to add the concept of a "global keyring" to the keyrings API instead.

->s_master_keys will only be allocated when someone tries to add a key
for the first time.  Otherwise it will stay NULL.

Note that this could go in the filesystem-specific superblocks instead.
However, we already have three filesystems using fs/crypto/, so it's
useful to have it in the VFS.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/super.c         | 3 +++
 include/linux/fs.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 166c4ee0d0ed..161a9d05aa9f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -168,6 +168,9 @@ static void destroy_super(struct super_block *s)
 	WARN_ON(!list_empty(&s->s_mounts));
 	put_user_ns(s->s_user_ns);
 	kfree(s->s_subtype);
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	key_put(s->s_master_keys);
+#endif
 	call_rcu(&s->rcu, destroy_super_rcu);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3efd5ded21c9..8cfb0877d32c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1440,6 +1440,10 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	struct key		*s_master_keys; /* master crypto keys in use */
+#endif
 } __randomize_layout;
 
 /* Helper functions so that in most cases filesystems will
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
