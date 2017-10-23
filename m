From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 07/25] fs/inode.c: export inode_lru_list_del()
Date: Mon, 23 Oct 2017 14:40:40 -0700
Message-ID: <20171023214058.128121-8-ebiggers3@gmail.com>
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

When a filesystem encryption key is removed, we need all files which had
been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
again.  This is most easily done by evicting the inodes.  This can
currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
that is overkill and not usable by non-root users.  In preparation for
allowing fs/crypto/ to evict just the needed inodes, export
inode_lru_list_del() to modules.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/inode.c         | 5 ++---
 include/linux/fs.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d1e35b53bb23..30ce98956801 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -420,13 +420,12 @@ void inode_add_lru(struct inode *inode)
 		inode_lru_list_add(inode);
 }
 
-
-static void inode_lru_list_del(struct inode *inode)
+void inode_lru_list_del(struct inode *inode)
 {
-
 	if (list_lru_del(&inode->i_sb->s_inode_lru, &inode->i_lru))
 		this_cpu_dec(nr_unused);
 }
+EXPORT_SYMBOL_GPL(inode_lru_list_del);
 
 /**
  * inode_sb_list_add - add inode to the superblock list of inodes
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8cfb0877d32c..2833ace2f01d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2879,6 +2879,7 @@ static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
 extern void unlock_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
+extern void inode_lru_list_del(struct inode *inode);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-- 
2.15.0.rc0.271.g36b669edcc-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
