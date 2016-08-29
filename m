From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH v2 5/8] pipe: simplify logic in alloc_pipe_info()
Date: Mon, 29 Aug 2016 12:21:39 +1200
Message-ID: <aef030c1-0257-98a9-4988-186efa48530c@gmail.com>
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

Replace an 'if' block that covers most of the code in this function
with a 'goto'. This makes the code a little simpler to read, and also
simplifies the next patch (fix limit checking in alloc_pipe_info())

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
 fs/pipe.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index f45a173..256fc5a 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -625,33 +625,34 @@ static bool too_many_pipe_buffers_hard(struct user_struct *user)
 struct pipe_inode_info *alloc_pipe_info(void)
 {
 	struct pipe_inode_info *pipe;
+	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
+	struct user_struct *user = get_current_user();
 
 	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
-	if (pipe) {
-		unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
-		struct user_struct *user = get_current_user();
-
-		if (!too_many_pipe_buffers_hard(user)) {
-			if (too_many_pipe_buffers_soft(user))
-				pipe_bufs = 1;
-			pipe->bufs = kcalloc(pipe_bufs,
-					     sizeof(struct pipe_buffer),
-					     GFP_KERNEL_ACCOUNT);
-		}
+	if (pipe == NULL)
+		goto out_free_uid;
+
+	if (!too_many_pipe_buffers_hard(user)) {
+		if (too_many_pipe_buffers_soft(user))
+			pipe_bufs = 1;
+		pipe->bufs = kcalloc(pipe_bufs,
+				     sizeof(struct pipe_buffer),
+				     GFP_KERNEL_ACCOUNT);
+	}
 
-		if (pipe->bufs) {
-			init_waitqueue_head(&pipe->wait);
-			pipe->r_counter = pipe->w_counter = 1;
-			pipe->buffers = pipe_bufs;
-			pipe->user = user;
-			account_pipe_buffers(user, 0, pipe_bufs);
-			mutex_init(&pipe->mutex);
-			return pipe;
-		}
-		free_uid(user);
-		kfree(pipe);
+	if (pipe->bufs) {
+		init_waitqueue_head(&pipe->wait);
+		pipe->r_counter = pipe->w_counter = 1;
+		pipe->buffers = pipe_bufs;
+		pipe->user = user;
+		account_pipe_buffers(user, 0, pipe_bufs);
+		mutex_init(&pipe->mutex);
+		return pipe;
 	}
 
+	kfree(pipe);
+out_free_uid:
+	free_uid(user);
 	return NULL;
 }
 
-- 
2.5.5
