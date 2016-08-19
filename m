From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] pipe: fix limit handling
Date: Fri, 19 Aug 2016 17:25:01 +1200
Message-ID: <d366cc2f-3d67-ec72-feb5-c7d757d17b7f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[This patch series is an improvement on a smaller series I sent
earlier to fix the user limit handling for pipes. I've made
many changes after feedback from Vegard Nossum, including
the addition of a fix for point (3) below.]

When changing a pipe's capacity with fcntl(F_SETPIPE_SZ), various
limits defined by /proc/sys/fs/pipe-* files are checked to see
if unprivileged users are exceeding limits on memory consumption.

While documenting and testing the operation of these limits I noticed
that, as currently implemented, these checks have a number of problems:

(1) When increasing the pipe capacity, the checks against the limits
    in /proc/sys/fs/pipe-user-pages-{soft,hard} are made against
    existing consumption, and exclude the memory required for the
    increased pipe capacity. The new increase in pipe capacity
    can then push the total memory used by the user for pipes
    (possibly far) over a limit. This can also trigger the problem
    described next.

(2) The limit checks are performed even when the new pipe capacity
    is less than the existing pipe capacity. This can lead to
    problems if a user sets a large pipe capacity, and then the
    limits are lowered, with the result that the user will no
    longer be able to decrease the pipe capacity.

(3) As currently implemented, accounting and checking against the limits
    is done as follows:

    (a) Test whether the user has exceeded the limit.
    (b) Make new pipe buffer allocation.
    (c) Account new allocation against the limits.

    This is racey. Multiple processes may pass point (a) simultaneously,
    and then allocate pipe buffers that are accounted for only in step (c).
    The race means that the user's pipe buffer allocation could be pushed
    over the limit (by an arbitrary amount, depending on how unlucky we
    were in the race). [Thanks to Vegard Nossum for spotting this point,
    which I had missed.]

This patch series addresses these three problems.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Michael Kerrisk (8):
  pipe: relocate round_pipe_size() above pipe_set_size()
  pipe: move limit checking logic into pipe_set_size()
  pipe: refactor argument for account_pipe_buffers()
  pipe: fix limit checking in pipe_set_size()
  pipe: simplify logic in alloc_pipe_info()
  pipe: fix limit checking in alloc_pipe_info()
  pipe: make account_pipe_buffers() return a value, and use it
  pipe: cap initial pipe capacity according to pipe-max-size limit

 fs/pipe.c | 164 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 94 insertions(+), 70 deletions(-)

-- 
2.5.5

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
