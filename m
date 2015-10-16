From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 11/48] vfs: Add get_richacl and set_richacl inode
	operations
Date: Fri, 16 Oct 2015 17:17:49 +0200
Message-ID: <1445008706-15115-12-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

These operations are similar to the get_acl and set_acl operations for
POSIX ACLs.  The distinction between access and default ACLs doesn't exist
for richacls.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/fs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3c22c92..08fde42 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1662,6 +1662,7 @@ struct inode_operations {
 	const char * (*follow_link) (struct dentry *, void **);
 	int (*permission) (struct inode *, int);
 	struct posix_acl * (*get_acl)(struct inode *, int);
+	struct richacl * (*get_richacl)(struct inode *);
 
 	int (*readlink) (struct dentry *, char __user *,int);
 	void (*put_link) (struct inode *, void *);
@@ -1691,6 +1692,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	int (*set_richacl)(struct inode *, struct richacl *);
 
 	/* WARNING: probably going away soon, do not use! */
 } ____cacheline_aligned;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
