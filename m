From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [RFC PATCH 07/10] pipe: Conditionalise wakeup in pipe_read() [ver
 #2]
Date: Sun, 3 Nov 2019 14:04:23 +0300
Message-ID: <f8810057-d92a-bcd2-c703-0a947336ce8d@yandex-team.ru>
References: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru>
 <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186189069.3995.10292601951655075484.stgit@warthog.procyon.org.uk>
 <3165.1572539884@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3165.1572539884@warthog.procyon.org.uk>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 31/10/2019 19.38, David Howells wrote:
> Okay, attached is a change that might give you what you want.  I tried my
> pipe-bench program (see cover note) with perf.  The output of the program with
> the patch applied was:
> 
> -       pipe                  305127298     36262221772       302185181         7887690
> 
> The output of perf with the patch applied:
> 
>          239,943.92 msec task-clock                #    1.997 CPUs utilized
>              17,728      context-switches          #   73.884 M/sec
>                 124      cpu-migrations            #    0.517 M/sec
>               9,330      page-faults               #   38.884 M/sec
>     885,107,207,365      cycles                    # 3688822.793 GHz
>   1,386,873,499,490      instructions              #    1.57  insn per cycle
>     311,037,372,339      branches                  # 1296296921.931 M/sec
>          33,467,827      branch-misses             #    0.01% of all branches
> 
> And without:
> 
>          239,891.87 msec task-clock                #    1.997 CPUs utilized
>              22,187      context-switches          #   92.488 M/sec
>                 133      cpu-migrations            #    0.554 M/sec
>               9,334      page-faults               #   38.909 M/sec
>     884,906,976,128      cycles                    # 3688787.725 GHz
>   1,391,986,932,265      instructions              #    1.57  insn per cycle
>     311,394,686,857      branches                  # 1298067400.849 M/sec
>          30,242,823      branch-misses             #    0.01% of all branches
> 
> So it did make something like a 20% reduction in context switches.

Ok. Looks promising. Depending on workload reduction might be much bigger.

I suppose buffer resize (grow) makes wakeup unconditionally. Should be ok.

> 
> David
> ---
> diff --git a/fs/pipe.c b/fs/pipe.c
> index e3d5f7a39123..5167921edd73 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -276,7 +276,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   	size_t total_len = iov_iter_count(to);
>   	struct file *filp = iocb->ki_filp;
>   	struct pipe_inode_info *pipe = filp->private_data;
> -	int do_wakeup;
> +	int do_wakeup, wake;
>   	ssize_t ret;
> 
>   	/* Null read succeeds. */
> @@ -329,11 +329,12 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   				tail++;
>   				pipe->tail = tail;
>   				do_wakeup = 1;
> -				if (head - (tail - 1) == pipe->max_usage)
> +				wake = head - (tail - 1) == pipe->max_usage / 2;
> +				if (wake)
>   					wake_up_interruptible_sync_poll_locked(
>   						&pipe->wait, EPOLLOUT | EPOLLWRNORM);
>   				spin_unlock_irq(&pipe->wait.lock);
> -				if (head - (tail - 1) == pipe->max_usage)
> +				if (wake)
>   					kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>   			}
>   			total_len -= chars;
> 
