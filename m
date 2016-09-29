From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH v2 0/8] pipe: fix limit handling
Date: Thu, 29 Sep 2016 13:56:32 +0200
Message-ID: <ffa397fa-b83b-d1bc-e31f-d9a8da0f0b71@oracle.com>
References: <89e4d1b0-39b9-0262-5cd5-229766962c56@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <89e4d1b0-39b9-0262-5cd5-229766962c56@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/29/2016 02:20 AM, Michael Kerrisk (man-pages) wrote:
> When changing a pipe's capacity with fcntl(F_SETPIPE_SZ), various
> limits defined by /proc/sys/fs/pipe-* files are checked to see
> if unprivileged users are exceeding limits on memory consumption.
>
> While documenting and testing the operation of these limits I noticed
> that, as currently implemented, these checks have a number of problems:
>
> (1) When increasing the pipe capacity, the checks against the limits
>     in /proc/sys/fs/pipe-user-pages-{soft,hard} are made against
>     existing consumption, and exclude the memory required for the
>     increased pipe capacity. The new increase in pipe capacity can then
>     push the total memory used by the user for pipes (possibly far) over
>     a limit. This can also trigger the problem described next.
>
> (2) The limit checks are performed even when the new pipe capacity
>     is less than the existing pipe capacity. This can lead to problems
>     if a user sets a large pipe capacity, and then the limits are
>     lowered, with the result that the user will no longer be able to
>     decrease the pipe capacity.
>
> (3) As currently implemented, accounting and checking against the
>     limits is done as follows:
>
>     (a) Test whether the user has exceeded the limit.
>     (b) Make new pipe buffer allocation.
>     (c) Account new allocation against the limits.
>
>     This is racey. Multiple processes may pass point (a) simultaneously,
>     and then allocate pipe buffers that are accounted for only in step
>     (c).  The race means that the user's pipe buffer allocation could be
>     pushed over the limit (by an arbitrary amount, depending on how
>     unlucky we were in the race). [Thanks to Vegard Nossum for spotting
>     this point, which I had missed.]
>
> This patch series addresses these three problems.
>
> Patch history:
>
> v1  This patch series is an improvement on a smaller series I sent
>     earlier to fix the user limit handling for pipes. I've made many
>     changes after feedback from Vegard Nossum, including the addition
>     of a fix for point (3) above.
>
> v2  Changes are noted in individual patches.
>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Vegard Nossum <vegard.nossum@oracle.com>
> Cc: socketpair@gmail.com
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-api@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> Michael Kerrisk (8):
>   pipe: relocate round_pipe_size() above pipe_set_size()
>   pipe: move limit checking logic into pipe_set_size()
>   pipe: refactor argument for account_pipe_buffers()
>   pipe: fix limit checking in pipe_set_size()
>   pipe: simplify logic in alloc_pipe_info()
>   pipe: fix limit checking in alloc_pipe_info()
>   pipe: make account_pipe_buffers() return a value, and use it
>   pipe: cap initial pipe capacity according to pipe-max-size limit
>
>  fs/pipe.c | 166 ++++++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 96 insertions(+), 70 deletions(-)
>

It seems I only have stylistic comments left for this, so FWIW

Reviewed-by: Vegard Nossum <vegard.nossum@oracle.com>


Vegard
