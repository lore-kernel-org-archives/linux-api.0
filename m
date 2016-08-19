From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] pipe: check limits only when increasing pipe capacity
Date: Fri, 19 Aug 2016 17:07:26 +1200
Message-ID: <88c159a1-0d4f-c776-90b1-5532b7fd4616@gmail.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c85cff-7fee-cded-386a-e1d518573dda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andrew,

thanks for picking up this patch series in -mm. Please drop it.
After discussions with Vegard, I have something better now.

Cheers,

Michael

On 08/16/2016 11:10 PM, Michael Kerrisk (man-pages) wrote:
> When changing a pipe's capacity with fcntl(F_SETPIPE_SZ), various
> limits defined by /proc/sys/fs/pipe-* files are checked to see
> if unprivileged users are exceeding limits on memory consumption.
> 
> While documenting and testing the operation of these limits I noticed
> that, as currently implemented, these checks can lead to cases where
> a user can increase a pipe's capacity and is then unable to decrease
> the capacity. The origin of the problem is two-fold:
> 
> (1) When increasing the pipe capacity, the checks against the limits
>     in /proc/sys/fs/pipe-user-pages-{soft,hard} are made against
>     existing consumption, and exclude the memory required for the
>     increased pipe capacity. The new increase in pipe capacity
>     can then push the total memory used by the user for pipes
>     (possibly far) over a limit.
> 
> (2) The limit checks are performed even when the new pipe capacity
>     is less than the existing pipe capacity. This can lead to
>     problems if a user sets a large pipe capacity, and then the
>     limits are lowered, with the result that the user will no
>     longer be able to decrease the pipe capacity.
> 
> The simple solution given by this patch is to perform the checks
> only when the pipe capacity is being increased. The patch does not
> address the broken check in (1), which allows a user to (one-time)
> set a pipe capacity that pushes the user's consumption over the user
> pipe limits. A change to fix that check is proposed in a subsequent
> patch. I've separated the two fixes because the second fix is a
> little more complex, and could possibly (though unlikely) break
> existing user-space. The current patch implements the simple fix
> that carries little risk and seems obviously correct: allowing an
> unprivileged user always to decrease a pipe's capacity.
> 
> The program below can be used to demonstrate the problem, and the
> effect of the fix. The program takes one or more command-line
> arguments. The first argument specifies the number of pipes
> that the program should create. The remaining arguments are,
> alternately, pipe capacities that should be set using
> fcntl(F_SETPIPE_SZ), and sleep intervals (in seconds) between
> the fcntl() operations. (The sleep intervals allow the possibility
> to change the limits between fcntl() operations.)
> 
> Running this program on an unpatched kernel, we first set some limits:
> 
>     # getconf PAGESIZE
>     4096
>     # echo 0 > /proc/sys/fs/pipe-user-pages-soft
>     # echo 1000000000 > /proc/sys/fs/pipe-max-size
>     # echo 10000 > /proc/sys/fs/pipe-user-pages-hard    # 40.96 MB
> 
> Now perform two fcntl(F_SETPIPE_SZ) operations on a single pipe,
> first setting a pipe capacity (10MB), sleeping for a few seconds,
> during which time the hard limit is lowered, and then set pipe
> capacity to a smaller amount (5MB):
> 
>     # sudo -u mtk ./test_F_SETPIPE_SZ 1 10000000 15 5000000 &
>     [1] 748
>     #     Loop 1: set pipe capacity to 10000000 bytes
>             F_SETPIPE_SZ returned 16777216
>             Sleeping 15 seconds
> 
>     # echo 1000 > /proc/sys/fs/pipe-user-pages-hard      # 4.096 MB
> 
>     #     Loop 2: set pipe capacity to 5000000 bytes
>             Loop 2, pipe 0: F_SETPIPE_SZ failed: fcntl: Operation not permitted
> 
> In this case, the user should be able to lower the limit.
> 
> With a kernel that has the patch below, the second fcntl() 
> succeeds:
> 
>     # echo 0 > /proc/sys/fs/pipe-user-pages-soft
>     # echo 1000000000 > /proc/sys/fs/pipe-max-size
>     # echo 10000 > /proc/sys/fs/pipe-user-pages-hard
>     # sudo -u mtk ./test_F_SETPIPE_SZ 1 10000000 15 5000000 &
>     [1] 3215
>     #     Loop 1: set pipe capacity to 10000000 bytes
>             F_SETPIPE_SZ returned 16777216
>             Sleeping 15 seconds
> 
>     # echo 1000 > /proc/sys/fs/pipe-user-pages-hard
> 
>     #     Loop 2: set pipe capacity to 5000000 bytes
>             F_SETPIPE_SZ returned 8388608
> 
> 8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---
> 
> /* test_F_SETPIPE_SZ.c
> 
>    (C) 2016, Michael Kerrisk; licensed under GNU GPL version 2 or later
> 
>    Test operation of fcntl(F_SETPIPE_SZ) for setting pipe capacity
>    and interactions with limits defined by /proc/sys/fs/pipe-* files.
> */
> 
> int
> main(int argc, char *argv[])
> {
>     int (*pfd)[2];
>     int npipes;
>     int pcap, rcap;
>     int j, p, s, stime, loop;
> 
>     if (argc < 2) {
>         fprintf(stderr, "Usage: %s num-pipes "
>                 "[pipe-capacity sleep-time]...\n", argv[0]);
>         exit(EXIT_FAILURE);
>     }
> 
>     npipes = atoi(argv[1]);
> 
>     pfd = calloc(npipes, sizeof (int [2]));
>     if (pfd == NULL) {
>         perror("calloc");
>         exit(EXIT_FAILURE);
>     }
> 
>     for (j = 0; j < npipes; j++) {
>         if (pipe(pfd[j]) == -1) {
>             fprintf(stderr, "Loop %d: pipe() failed: ", j);
>             perror("pipe");
>             exit(EXIT_FAILURE);
>         }
>     }
> 
>     for (j = 2; j < argc; j += 2 ) {
>         loop = j / 2;
>         pcap = atoi(argv[j]);
>         printf("    Loop %d: set pipe capacity to %d bytes\n", loop, pcap);
> 
>         for (p = 0; p < npipes; p++) {
>             s = fcntl(pfd[p][0], F_SETPIPE_SZ, pcap);
>             if (s == -1) {
>                 fprintf(stderr, "        Loop %d, pipe %d: F_SETPIPE_SZ "
>                         "failed: ", loop, p);
>                 perror("fcntl");
>                 exit(EXIT_FAILURE);
>             }
> 
>             if (p == 0) {
>                 printf("        F_SETPIPE_SZ returned %d\n", s);
>                 rcap = s;
>             } else {
>                 if (s != rcap) {
>                     fprintf(stderr, "        Loop %d, pipe %d: F_SETPIPE_SZ "
>                             "unexpected return: %d\n", loop, p, s);
>                     exit(EXIT_FAILURE);
>                 }
>             }
> 
>             stime = (j + 1 < argc) ? atoi(argv[j + 1]) : 0;
>             if (stime > 0) {
>                 printf("        Sleeping %d seconds\n", stime);
>                 sleep(stime);
>             }
>         }
>     }
> 
>     exit(EXIT_SUCCESS);
> }
> 
> 8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---
> 
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/pipe.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 4ebe6b2..a98ebca 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1122,14 +1122,23 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>  		if (!nr_pages)
>  			goto out;
>  
> -		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
> -			ret = -EPERM;
> -			goto out;
> -		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> -			    too_many_pipe_buffers_soft(pipe->user)) &&
> -		           !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
> -			ret = -EPERM;
> -			goto out;
> +		/*
> +		 * If trying to increase the pipe capacity, check that an
> +		 * unprivileged user is not trying to exceed various limits.
> +		 * (Decreasing the pipe capacity is always permitted, even
> +		 * if the user is currently over a limit.)
> +		 */
> +		if (nr_pages > pipe->buffers) {
> +			if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
> +				ret = -EPERM;
> +				goto out;
> +			} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> +				too_many_pipe_buffers_soft(pipe->user)) &&
> +				!capable(CAP_SYS_RESOURCE) &&
> +				!capable(CAP_SYS_ADMIN)) {
> +				ret = -EPERM;
> +				goto out;
> +			}
>  		}
>  		ret = pipe_set_size(pipe, nr_pages);
>  		break;
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
