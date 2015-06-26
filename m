From: Gioh Kim <gioh.kim@lge.com>
Subject: [RFCv2 2/5] fs/anon_inodes: get a new inode
Date: Fri, 26 Jun 2015 18:58:27 +0900
Message-ID: <1435312710-15108-3-git-send-email-gioh.kim@lge.com>
References: <1435312710-15108-1-git-send-email-gioh.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1435312710-15108-1-git-send-email-gioh.kim@lge.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, viro@zeniv.linux.org.uk, mst@redhat.com, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, Gioh Kim <gioh.kim@lge.com>
List-Id: linux-api@vger.kernel.org

A inode is necessary for some drivers that needs special address_space
and address_space_operation for page migration. Each drivers can create
inode with the anon_inodefs.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 fs/anon_inodes.c            | 6 ++++++
 include/linux/anon_inodes.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 80ef38c..1d51f96 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -162,6 +162,12 @@ err_put_unused_fd:
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
+struct inode *anon_inode_new(void)
+{
+	return alloc_anon_inode(anon_inode_mnt->mnt_sb);
+}
+EXPORT_SYMBOL_GPL(anon_inode_new);
+
 static int __init anon_inode_init(void)
 {
 	anon_inode_mnt = kern_mount(&anon_inode_fs_type);
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index 8013a45..ddbd67f 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -15,6 +15,7 @@ struct file *anon_inode_getfile(const char *name,
 				void *priv, int flags);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags);
+struct inode *anon_inode_new(void);
 
 #endif /* _LINUX_ANON_INODES_H */
 
-- 
1.9.1
