From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: [RFC v6 04/40] vfs: Make the inode passed to inode_change_ok non-const
Date: Tue,  4 Aug 2015 13:53:02 +0200
Message-ID: <1438689218-6921-5-git-send-email-agruenba@redhat.com>
References: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438689218-6921-1-git-send-email-agruenba@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, linux-cifs@vger.kernel.org, linux-security-module@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
List-Id: linux-api@vger.kernel.org

We will need to call iop->permission and iop->get_acl from
inode_change_ok() for additional permission checks, and both take a
non-const inode.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/attr.c          | 2 +-
 include/linux/fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 6530ced..328be71 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -28,7 +28,7 @@
  * Should be called as the first thing in ->setattr implementations,
  * possibly after taking additional locks.
  */
-int inode_change_ok(const struct inode *inode, struct iattr *attr)
+int inode_change_ok(struct inode *inode, struct iattr *attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index abf5b0e..aae46e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2873,7 +2873,7 @@ extern int buffer_migrate_page(struct address_space *,
 #define buffer_migrate_page NULL
 #endif
 
-extern int inode_change_ok(const struct inode *, struct iattr *);
+extern int inode_change_ok(struct inode *, struct iattr *);
 extern int inode_newsize_ok(const struct inode *, loff_t offset);
 extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
-- 
2.5.0
