From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v14 10/22] posix_acl: Unexport acl_by_type and make it static
Date: Thu,  5 Nov 2015 12:39:28 +0100
Message-ID: <1446723580-3747-11-git-send-email-agruenba@redhat.com>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>
List-Id: linux-api@vger.kernel.org

acl_by_type(inode, type) returns a pointer to either inode->i_acl or
inode->i_default_acl depending on type.  This is useful in
fs/posix_acl.c, but should never have been visible outside that file.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/posix_acl.c            | 3 +--
 include/linux/posix_acl.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 4fb17de..aacfb58 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -21,7 +21,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 
-struct posix_acl **acl_by_type(struct inode *inode, int type)
+static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
 	switch (type) {
 	case ACL_TYPE_ACCESS:
@@ -32,7 +32,6 @@ struct posix_acl **acl_by_type(struct inode *inode, int type)
 		BUG();
 	}
 }
-EXPORT_SYMBOL(acl_by_type);
 
 struct posix_acl *get_cached_acl(struct inode *inode, int type)
 {
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 3e96a6a..5b5a80c 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -99,7 +99,6 @@ extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 extern int simple_set_acl(struct inode *, struct posix_acl *, int);
 extern int simple_acl_create(struct inode *, struct inode *);
 
-struct posix_acl **acl_by_type(struct inode *inode, int type);
 struct posix_acl *get_cached_acl(struct inode *inode, int type);
 struct posix_acl *get_cached_acl_rcu(struct inode *inode, int type);
 void set_cached_acl(struct inode *inode, int type, struct posix_acl *acl);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
