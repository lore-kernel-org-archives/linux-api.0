From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 5/5] nfs: don't clear STATX_ATIME from result_mask
Date: Fri, 19 Oct 2018 14:20:49 +0200
Message-ID: <20181019122049.27121-5-mszeredi@redhat.com>
References: <20181019122049.27121-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019122049.27121-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>
List-Id: linux-api@vger.kernel.org

As per statx(2) man page only clear out flags that are unsupported by the
fs or have an unrepresentable value.  Atime is supported by NFS as long as
it's supported on the server.

So the STATX_ATIME flag should not be cleared in the result_mask if the
operation was requested on a MNT_NOATIME or MNT_NODIRATIME mount.

This patch doesn't change the revalidation algorithm in any way, just the
clearing of flags in stat->result_mask.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: 9ccee940bd5b ("Support statx() mask and query flags parameters")
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
---
 fs/nfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index b65aee481d13..34bb3e591709 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -811,7 +811,7 @@ int nfs_getattr(const struct path *path, struct kstat *stat,
 	if (!(request_mask & (STATX_MODE|STATX_NLINK|STATX_ATIME|STATX_CTIME|
 					STATX_MTIME|STATX_UID|STATX_GID|
 					STATX_SIZE|STATX_BLOCKS)))
-		goto out_no_revalidate;
+		goto out_no_update;
 
 	/* Check whether the cached attributes are stale */
 	do_update |= force_sync || nfs_attribute_cache_expired(inode);
@@ -833,9 +833,6 @@ int nfs_getattr(const struct path *path, struct kstat *stat,
 			goto out;
 	} else
 		nfs_readdirplus_parent_cache_hit(path->dentry);
-out_no_revalidate:
-	/* Only return attributes that were revalidated. */
-	stat->result_mask &= request_mask;
 out_no_update:
 	generic_fillattr(inode, stat);
 	stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
-- 
2.14.3
