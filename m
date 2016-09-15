From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: fix return type of ioctl_file_dedupe_range
Date: Wed, 14 Sep 2016 20:20:00 -0700
Message-ID: <20160915032000.GA9309@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

All the VFS functions in the dedupe ioctl path return int status, so
the ioctl handler ought to as well.

Found by Coverity, CID 1350952.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 0f56deb..26aba09 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -568,7 +568,7 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
-static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
+static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
 {
 	struct file_dedupe_range __user *argp = arg;
 	struct file_dedupe_range *same = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
