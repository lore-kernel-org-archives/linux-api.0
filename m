From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 4/5] statx: don't clear STATX_ATIME on SB_RDONLY
Date: Fri, 19 Oct 2018 14:20:48 +0200
Message-ID: <20181019122049.27121-4-mszeredi@redhat.com>
References: <20181019122049.27121-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

IS_NOATIME(inode) is defined as __IS_FLG(inode, SB_RDONLY|SB_NOATIME), so
generic_fillattr() will clear STATX_ATIME from the result_mask if the super
block is marked read only.

This was probably not the intention, so fix to only clear STATX_ATIME if
the fs doesn't support atime at all.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/stat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index 8d297a279991..b46583df70d4 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -46,7 +46,8 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->blksize = i_blocksize(inode);
 	stat->blocks = inode->i_blocks;
 
-	if (IS_NOATIME(inode))
+	/* SB_NOATIME means filesystem supplies dummy atime value */
+	if (inode->i_sb->s_flags & SB_NOATIME)
 		stat->result_mask &= ~STATX_ATIME;
 	if (IS_AUTOMOUNT(inode))
 		stat->attributes |= STATX_ATTR_AUTOMOUNT;
-- 
2.14.3
