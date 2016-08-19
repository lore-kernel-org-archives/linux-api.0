From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH 3/8] pipe: refactor argument for account_pipe_buffers()
Date: Fri, 19 Aug 2016 17:25:29 +1200
Message-ID: <54fd7601-9199-f070-d26d-614c224ebe0c@gmail.com>
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

This is a preparatory patch for following work. account_pipe_buffers()
performs accounting in the 'user_struct'. There is no need to pass
a pointer to a 'pipe_inode_info' struct (which is then dereferenced
to obtain a pointer to the 'user' field). Instead, pass a pointer
directly to the 'user_struct'. This change is needed in preparation
for subsequent patches (and the resulting code is a little more logical).

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
 fs/pipe.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 4b98fd0..37b7f5e 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -604,10 +604,10 @@ pipe_fasync(int fd, struct file *filp, int on)
 	return retval;
 }
 
-static void account_pipe_buffers(struct pipe_inode_info *pipe,
+static void account_pipe_buffers(struct user_struct *user,
                                  unsigned long old, unsigned long new)
 {
-	atomic_long_add(new - old, &pipe->user->pipe_bufs);
+	atomic_long_add(new - old, &user->pipe_bufs);
 }
 
 static bool too_many_pipe_buffers_soft(struct user_struct *user)
@@ -644,7 +644,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
 			pipe->r_counter = pipe->w_counter = 1;
 			pipe->buffers = pipe_bufs;
 			pipe->user = user;
-			account_pipe_buffers(pipe, 0, pipe_bufs);
+			account_pipe_buffers(user, 0, pipe_bufs);
 			mutex_init(&pipe->mutex);
 			return pipe;
 		}
@@ -659,7 +659,7 @@ void free_pipe_info(struct pipe_inode_info *pipe)
 {
 	int i;
 
-	account_pipe_buffers(pipe, pipe->buffers, 0);
+	account_pipe_buffers(pipe->user, pipe->buffers, 0);
 	free_uid(pipe->user);
 	for (i = 0; i < pipe->buffers; i++) {
 		struct pipe_buffer *buf = pipe->bufs + i;
@@ -1080,7 +1080,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
 			memcpy(bufs + head, pipe->bufs, tail * sizeof(struct pipe_buffer));
 	}
 
-	account_pipe_buffers(pipe, pipe->buffers, nr_pages);
+	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
 	pipe->curbuf = 0;
 	kfree(pipe->bufs);
 	pipe->bufs = bufs;
-- 
2.5.5
