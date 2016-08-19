From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] pipe: move limit checking logic into pipe_set_size()
Date: Fri, 19 Aug 2016 17:25:21 +1200
Message-ID: <c41e6935-82b0-0669-dea8-9d5c4358794e@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <67ce15aa-cf43-0c89-d079-2d966177c56d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is a preparatory patch for following work. Move the F_SETPIPE_SZ
limit-checking logic from pipe_fcntl() into pipe_set_size().
This simplifies the code a little, and allows for reworking
required in later patches.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
 fs/pipe.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 7d7c21e..4b98fd0 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1026,9 +1026,24 @@ static inline unsigned int round_pipe_size(unsigned int size)
  * Allocate a new array of pipe buffers and copy the info over. Returns the
  * pipe size if successful, or return -ERROR on error.
  */
-static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
+static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 {
 	struct pipe_buffer *bufs;
+	unsigned int size, nr_pages;
+
+	size = round_pipe_size(arg);
+	nr_pages = size >> PAGE_SHIFT;
+
+	if (!nr_pages)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size)
+		return -EPERM;
+
+	if ((too_many_pipe_buffers_hard(pipe->user) ||
+			too_many_pipe_buffers_soft(pipe->user)) &&
+			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
 	/*
 	 * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
@@ -1112,28 +1127,9 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 	__pipe_lock(pipe);
 
 	switch (cmd) {
-	case F_SETPIPE_SZ: {
-		unsigned int size, nr_pages;
-
-		size = round_pipe_size(arg);
-		nr_pages = size >> PAGE_SHIFT;
-
-		ret = -EINVAL;
-		if (!nr_pages)
-			goto out;
-
-		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
-			ret = -EPERM;
-			goto out;
-		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
-			    too_many_pipe_buffers_soft(pipe->user)) &&
-		           !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
-			ret = -EPERM;
-			goto out;
-		}
-		ret = pipe_set_size(pipe, nr_pages);
+	case F_SETPIPE_SZ:
+		ret = pipe_set_size(pipe, arg);
 		break;
-		}
 	case F_GETPIPE_SZ:
 		ret = pipe->buffers * PAGE_SIZE;
 		break;
@@ -1142,7 +1138,6 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-out:
 	__pipe_unlock(pipe);
 	return ret;
 }
-- 
2.5.5
