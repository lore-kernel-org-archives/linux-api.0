From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH v2 7/8] pipe: make account_pipe_buffers() return a value, and
 use it
Date: Mon, 29 Aug 2016 12:21:51 +1200
Message-ID: <93e5f193-1e5e-3e1f-3a20-eae79b7e1310@gmail.com>
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

This is an optional patch, to provide a small performance
improvement.  Alter account_pipe_buffers() so that it returns the
new value in user->pipe_bufs. This means that we can refactor
too_many_pipe_buffers_soft() and too_many_pipe_buffers_hard() to
avoid the costs of repeated use of atomic_long_read() to get the
value user->pipe_bufs.

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
 fs/pipe.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 41a580a..741560b 100644
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
+static bool too_many_pipe_buffers_soft(unsigned long user_bufs)
 {
-	return pipe_user_pages_soft &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_soft;
+	return pipe_user_pages_soft && user_bufs >= pipe_user_pages_soft;
 }
 
-static bool too_many_pipe_buffers_hard(struct user_struct *user)
+static bool too_many_pipe_buffers_hard(unsigned long user_bufs)
 {
-	return pipe_user_pages_hard &&
-	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_hard;
+	return pipe_user_pages_hard && user_bufs >= pipe_user_pages_hard;
 }
 
 struct pipe_inode_info *alloc_pipe_info(void)
@@ -627,19 +625,20 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	struct pipe_inode_info *pipe;
 	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
 	struct user_struct *user = get_current_user();
+	unsigned long user_bufs;
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	account_pipe_buffers(user, 0, pipe_bufs);
+	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
-	if (too_many_pipe_buffers_soft(user)) {
-		account_pipe_buffers(user, pipe_bufs, 1);
+	if (too_many_pipe_buffers_soft(user_bufs)) {
+		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
 		pipe_bufs = 1;
 	}
 
-	if (too_many_pipe_buffers_hard(user))
+	if (too_many_pipe_buffers_hard(user_bufs))
 		goto out_revert_acct;
 
 	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
@@ -655,7 +654,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	}
 
 out_revert_acct:
-	account_pipe_buffers(user, pipe_bufs, 0);
+	(void) account_pipe_buffers(user, pipe_bufs, 0);
 	kfree(pipe);
 out_free_uid:
 	free_uid(user);
@@ -666,7 +665,7 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 {
 	int i;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, 0);
+	(void) account_pipe_buffers(pipe->user, pipe->buffers, 0);
 	free_uid(pipe->user);
 	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
@@ -1037,6 +1036,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 {
 	struct pipe_buffer *bufs;
 	unsigned int size, nr_pages;
+	unsigned long user_bufs;
 	long ret = 0;
 
 	size = round_pipe_size(arg);
@@ -1056,11 +1056,11 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 			size > pipe_max_size && !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
-	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
+	user_bufs = account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
 
 	if (nr_pages > pipe->buffers &&
-			(too_many_pipe_buffers_hard(pipe->user) ||
-			 too_many_pipe_buffers_soft(pipe->user)) &&
+			(too_many_pipe_buffers_hard(user_bufs) ||
+			 too_many_pipe_buffers_soft(user_bufs)) &&
 			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
 		ret = -EPERM;
 		goto out_revert_acct;
@@ -1112,7 +1112,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 	return nr_pages * PAGE_SIZE;
 
 out_revert_acct:
-	account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
+	(void) account_pipe_buffers(pipe->user, nr_pages, pipe->buffers);
 	return ret;
 }
 
-- 
2.5.5
