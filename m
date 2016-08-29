From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH v2 2/8] pipe: move limit checking logic into pipe_set_size()
Date: Mon, 29 Aug 2016 12:21:05 +1200
Message-ID: <3701b2c5-2c52-2c3e-226d-29b9deb29b50@gmail.com>
References: <ef9ce203-6683-31b1-26dc-e0b823aba73e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ef9ce203-6683-31b1-26dc-e0b823aba73e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum@oracle.com>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is a preparatory patch for following work. Move the F_SETPIPE_SZ
limit-checking logic from pipe_fcntl() into pipe_set_size().  This
simplifies the code a little, and allows for reworking required in
a later patch that fixes the limit checking in pipe_set_size()

Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: socketpair@gmail.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
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
