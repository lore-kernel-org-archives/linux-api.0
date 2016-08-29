From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH v2 6/8] pipe: fix limit checking in alloc_pipe_info()
Date: Mon, 29 Aug 2016 12:21:45 +1200
Message-ID: <8ff3e9f9-23f6-510c-644f-8e70cd1c0bd9@gmail.com>
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

The limit checking in alloc_pipe_info() (used by pipe(2) and when
opening a FIFO) has the following problems:

(1) When checking capacity required for the new pipe, the checks against
    the limit in /proc/sys/fs/pipe-user-pages-{soft,hard} are made
    against existing consumption, and exclude the memory required for
    the new pipe capacity. As a consequence: (1) the memory allocation
    throttling provided by the soft limit does not kick in quite as
    early as it should, and (2) the user can overrun the hard limit.

(2) As currently implemented, accounting and checking against the limits
    is done as follows:

    (a) Test whether the user has exceeded the limit.
    (b) Make new pipe buffer allocation.
    (c) Account new allocation against the limits.

    This is racey. Multiple processes may pass point (a) simultaneously,
    and then allocate pipe buffers that are accounted for only in step
    (c).  The race means that the user's pipe buffer allocation could be
    pushed over the limit (by an arbitrary amount, depending on how
    unlucky we were in the race). [Thanks to Vegard Nossum for spotting
    this point, which I had missed.]

This patch addresses the above problems as follows:

* Alter the checks against limits to include the memory required for the
  new pipe.
* Re-order the accounting step so that it precedes the buffer allocation.
  If the accounting step determines that a limit has been reached, revert
  the accounting and cause the operation to fail.

Patch history:

v2
   * Rework accounting checks to ensure that user cant get past
     too_many_pipe_buffers_soft() before the accounting is done.
     [Thanks to Vegard Nossum]

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
 fs/pipe.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 256fc5a..41a580a 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -632,24 +632,30 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	if (pipe == NULL)
 		goto out_free_uid;
 
-	if (!too_many_pipe_buffers_hard(user)) {
-		if (too_many_pipe_buffers_soft(user))
-			pipe_bufs = 1;
-		pipe->bufs = kcalloc(pipe_bufs,
-				     sizeof(struct pipe_buffer),
-				     GFP_KERNEL_ACCOUNT);
+	account_pipe_buffers(user, 0, pipe_bufs);
+
+	if (too_many_pipe_buffers_soft(user)) {
+		account_pipe_buffers(user, pipe_bufs, 1);
+		pipe_bufs = 1;
 	}
 
+	if (too_many_pipe_buffers_hard(user))
+		goto out_revert_acct;
+
+	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
+			     GFP_KERNEL_ACCOUNT);
+
 	if (pipe->bufs) {
 		init_waitqueue_head(&pipe->wait);
 		pipe->r_counter = pipe->w_counter = 1;
 		pipe->buffers = pipe_bufs;
 		pipe->user = user;
-		account_pipe_buffers(user, 0, pipe_bufs);
 		mutex_init(&pipe->mutex);
 		return pipe;
 	}
 
+out_revert_acct:
+	account_pipe_buffers(user, pipe_bufs, 0);
 	kfree(pipe);
 out_free_uid:
 	free_uid(user);
-- 
2.5.5
