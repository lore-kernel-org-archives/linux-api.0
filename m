From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] vfs: abort dedupe loop if fatal signals are pending
Date: Fri, 22 Jan 2016 16:58:28 -0800
Message-ID: <20160123005828.GB5496@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

If the program running dedupe receives a fatal signal during the
dedupe loop, we should bail out to avoid tying up the system.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 fs/read_write.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index aaaad52..aab334e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1617,6 +1617,9 @@ next_file:
 		mnt_drop_write_file(dst_file);
 next_loop:
 		fdput(dst_fd);
+
+		if (fatal_signal_pending(current))
+			goto out;
 	}
 
 out:
