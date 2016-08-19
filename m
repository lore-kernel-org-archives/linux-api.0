From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH 7/8] pipe: make account_pipe_buffers() return a value, and use
 it
Date: Fri, 19 Aug 2016 17:25:54 +1200
Message-ID: <676aa52b-c4fc-3bf1-8051-39deca8bf0ab@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum@oracle.com>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an optional patch, to provide a small performance improvement.
Alter account_pipe_buffers() so that it returns the new value in
user->pipe_bufs. This means that we can refactor too_many_pipe_buffers_soft()
and too_many_pipe_buffers_hard() to avoid the costs of repeated use of
atomic_long_read() to get the value user->pipe_bufs.

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
 fs/pipe.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 705d79f..ada1777 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -604,22 +604,20 @@ pipe_fasync(int fd, struct file *filp, int on)
 	return retval;
 }
 
-static void account_pipe_buffers(struct user_struct *user,
+static unsigned long account_pipe_buffers(struct user_struct *user,
                                  unsigned long old, unsigned long new)
 {
-	atomic_long_add(new - old, &user->pipe_bufs);
+	return atomic_long_add_return(new - old, &user->pipe_bufs);
 }
 
-static bool too_many_pipe_buffers_soft(struct user_struct *user)
+static bool too_many_pipe_buffers_soft(unsigned long num_bufs)
 {
-	return pipe_user_pages_soft &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_soft;
+	return pipe_user_pages_soft && num_bufs >= pipe_user_pages_soft;
 }
 
-static bool too_many_pipe_buffers_hard(struct user_struct *user)
+static bool too_many_pipe_buffers_hard(unsigned long num_bufs)
 {
-	return pipe_user_pages_hard &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_hard;
+	return pipe_user_pages_hard && num_bufs >= pipe_user_pages_hard;
 }
 
 struct pipe_inode_info *alloc_pipe_info(void)
@@ -627,17 +625,18 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	struct pipe_inode_info *pipe;
 	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
 	struct user_struct *user = get_current_user();
+	unsigned long num_bufs;
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	if (too_many_pipe_buffers_soft(user))
+	if (too_many_pipe_buffers_soft(atomic_long_read(&user->pipe_bufs)))
 		pipe_bufs = 1;
 
-	account_pipe_buffers(user, 0, pipe_bufs);
+	num_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
-	if (too_many_pipe_buffers_hard(user))
+	if (too_many_pipe_buffers_hard(num_bufs))
 		goto out_revert_acct;
 
 	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
@@ -653,7 +652,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	}
 
 out_revert_acct:
-	account_pipe_buffers(user, pipe_bufs, 0);
+	(void) account_pipe_buffers(user, pipe_bufs, 0);
 	kfree(pipe);
 out_free_uid:
 	free_uid(user);
@@ -664,7 +663,7 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 {
 	int i;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, 0);
+	(void) account_pipe_buffers(pipe->user, pipe->buffers, 0);
 	free_uid(pipe->user);
 	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
@@ -1035,6 +1034,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 {
 	struct pipe_buffer *bufs;
 	unsigned int size, nr_pages;
+	unsigned long num_bufs;
 	long ret = 0;
 
 	size = round_pipe_size(arg);
@@ -1043,7 +1043,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	if (!nr_pages)
 		return -EINVAL;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
+	num_bufs = account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
 
 	/*
 	 * If trying to increase the pipe capacity, check that an
@@ -1055,8 +1055,8 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
 			ret = -EPERM;
 			goto out_revert_acct;
-		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
-				too_many_pipe_buffers_soft(pipe->user)) &&
+		} else if ((too_many_pipe_buffers_hard(num_bufs) ||
+				too_many_pipe_buffers_soft(num_bufs)) &&
 				!capable(CAP_SYS_RESOURCE) &&
 				!capable(CAP_SYS_ADMIN)) {
 			ret = -EPERM;
@@ -1110,7 +1110,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	return nr_pages * PAGE_SIZE;
 
 out_revert_acct:
-	account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
+	(void) account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
 	return ret;
 }
 
-- 
2.5.5
