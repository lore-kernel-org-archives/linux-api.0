From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/10] nfsd: use RWF_SYNC
Date: Tue, 29 Mar 2016 19:37:34 +0200
Message-ID: <1459273054-13478-11-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/nfsd/vfs.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d40010e..6fbd81e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -935,8 +935,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	int			stable = *stablep;
 	int			use_wgather;
 	loff_t			pos = offset;
-	loff_t			end = LLONG_MAX;
 	unsigned int		pflags = current->flags;
+	int			flags = 0;
 
 	if (test_bit(RQ_LOCAL, &rqstp->rq_flags))
 		/*
@@ -955,9 +955,12 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	if (!EX_ISSYNC(exp))
 		stable = 0;
 
+	if (stable && !use_wgather)
+		flags |= RWF_SYNC;
+
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
-	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos, 0);
+	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos, flags);
 	set_fs(oldfs);
 	if (host_err < 0)
 		goto out_nfserr;
@@ -965,15 +968,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	nfsdstats.io_write += host_err;
 	fsnotify_modify(file);
 
-	if (stable) {
-		if (use_wgather) {
-			host_err = wait_for_concurrent_writes(file);
-		} else {
-			if (*cnt)
-				end = offset + *cnt - 1;
-			host_err = vfs_fsync_range(file, offset, end, 0);
-		}
-	}
+	if (stable && use_wgather)
+		host_err = wait_for_concurrent_writes(file);
 
 out_nfserr:
 	dprintk("nfsd: write complete host_err=%d\n", host_err);
-- 
2.1.4
