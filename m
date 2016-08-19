From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH 8/8] pipe: cap initial pipe capacity according to
 pipe-max-size limit
Date: Fri, 19 Aug 2016 17:26:02 +1200
Message-ID: <28a33f0f-2380-87d3-3ff9-ab8735fef488@gmail.com>
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

This is an patch that provides behavior that is more consistent,
and probably less surprising to users. I consider the change
optional, and welcome opinions about whether it should be applied.

By default, pipes are created with a capacity of 64 kiB.  However,
/proc/sys/fs/pipe-max-size may be set smaller than this value.  In
this scenario, an unprivileged user could thus create a pipe whose
initial capacity exceeds the limit. Therefore, it seems logical to
cap the initial pipe capacity according to the value of
pipe-max-size.

The test program shown earlier in this patch series can be used to
demonstrate the effect of the change brought about with this
patch:

    # cat /proc/sys/fs/pipe-max-size
    1048576
    # sudo -u mtk ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 65536
    # echo 10000 > /proc/sys/fs/pipe-max-size
    # cat /proc/sys/fs/pipe-max-size
    16384
    # sudo -u mtk ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 16384
    # ./test_F_SETPIPE_SZ 1
    Initial pipe capacity: 65536

The last two executions of 'test_F_SETPIPE_SZ' show that pipe-max-size
caps the initial allocation for a new pipe for unprivileged users, but
not for privileged users.

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
 fs/pipe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index ada1777..caced8b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -631,6 +631,9 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	if (pipe == NULL)
 		goto out_free_uid;
 
+	if (!capable(CAP_SYS_RESOURCE) && pipe_bufs * PAGE_SIZE > pipe_max_size)
+		pipe_bufs = pipe_max_size >> PAGE_SHIFT;
+
 	if (too_many_pipe_buffers_soft(atomic_long_read(&user->pipe_bufs)))
 		pipe_bufs = 1;
 
-- 
2.5.5
