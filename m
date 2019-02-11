From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH v2 09/20] fs/inode.c: rename and export
 dispose_list()
Date: Mon, 11 Feb 2019 09:27:27 -0800
Message-ID: <20190211172738.4633-10-ebiggers@kernel.org>
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

When a filesystem encryption key is removed, we need all files which had
been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
again.  This is most easily done by evicting the inodes.  This can
currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
that is overkill and not usable by non-root users.  In preparation for
allowing fs/crypto/ to evict just the needed inodes, make dispose_list()
non-static.  For clarity also rename it to evict_inode_list().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/inode.c         | 18 +++++++++---------
 include/linux/fs.h |  1 +
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 037df483c9af..10147197c1de 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -574,13 +574,13 @@ static void evict(struct inode *inode)
 }
 
 /*
- * dispose_list - dispose of the contents of a local list
- * @head: the head of the list to free
+ * evict_inode_list - evict each inode in a local list of inodes
+ * @head: the head of the list
  *
- * Dispose-list gets a local list with local inodes in it, so it doesn't
+ * This gets a local list with local inodes in it, so it doesn't
  * need to worry about list corruption and SMP locks.
  */
-static void dispose_list(struct list_head *head)
+void evict_inode_list(struct list_head *head)
 {
 	while (!list_empty(head)) {
 		struct inode *inode;
@@ -632,13 +632,13 @@ void evict_inodes(struct super_block *sb)
 		if (need_resched()) {
 			spin_unlock(&sb->s_inode_list_lock);
 			cond_resched();
-			dispose_list(&dispose);
+			evict_inode_list(&dispose);
 			goto again;
 		}
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-	dispose_list(&dispose);
+	evict_inode_list(&dispose);
 }
 EXPORT_SYMBOL_GPL(evict_inodes);
 
@@ -683,7 +683,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-	dispose_list(&dispose);
+	evict_inode_list(&dispose);
 
 	return busy;
 }
@@ -770,7 +770,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
  * Walk the superblock inode LRU for freeable inodes and attempt to free them.
  * This is called from the superblock shrinker function with a number of inodes
  * to trim from the LRU. Inodes to be freed are moved to a temporary list and
- * then are freed outside inode_lock by dispose_list().
+ * then are freed outside inode_lock by evict_inode_list().
  */
 long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 {
@@ -779,7 +779,7 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
 				     inode_lru_isolate, &freeable);
-	dispose_list(&freeable);
+	evict_inode_list(&freeable);
 	return freed;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 326cbb044596..ce18ece60da4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2987,6 +2987,7 @@ extern void discard_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
 extern void inode_lru_list_del(struct inode *inode);
+extern void evict_inode_list(struct list_head *head);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-- 
2.20.1
