From: Eric Biggers <ebiggers@kernel.org>
Subject: [RFC PATCH v2 08/20] fs/inode.c: export
 inode_lru_list_del()
Date: Mon, 11 Feb 2019 09:27:26 -0800
Message-ID: <20190211172738.4633-9-ebiggers@kernel.org>
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
that is overkill and not usable by non-root users.

In preparation for allowing fs/crypto/ to evict just the needed inodes,
make inode_lru_list_del() non-static.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/inode.c         | 4 +---
 include/linux/fs.h | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0cd47fe0dbe5..037df483c9af 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -426,10 +426,8 @@ void inode_add_lru(struct inode *inode)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 70d929ac89f9..326cbb044596 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2986,6 +2986,7 @@ extern void unlock_new_inode(struct inode *);
 extern void discard_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
+extern void inode_lru_list_del(struct inode *inode);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-- 
2.20.1
