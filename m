From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [RFC PATCH 07/10] pipe: Conditionalise wakeup in pipe_read() [ver
 #2]
Date: Sun, 27 Oct 2019 18:57:35 +0300
Message-ID: <fe167a90-1503-7ca2-4150-eeffd5cb1378@yandex-team.ru>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186189069.3995.10292601951655075484.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157186189069.3995.10292601951655075484.stgit@warthog.procyon.org.uk>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 23/10/2019 23.18, David Howells wrote:
> Only do a wakeup in pipe_read() if we made space in a completely full
> buffer.  The producer shouldn't be waiting on pipe->wait otherwise.

We could go further and wakeup writer only when at least half of buffer is empty.
This gives better batching and reduces rate of context switches.

https://lore.kernel.org/lkml/157219118016.7078.16223055699799396042.stgit@buzz/T/#u

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>   fs/pipe.c |   15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 1274305772fb..e3a8f10750c9 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -327,11 +327,13 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   				spin_lock_irq(&pipe->wait.lock);
>   				tail++;
>   				pipe_commit_read(pipe, tail);
> -				do_wakeup = 0;
> -				wake_up_interruptible_sync_poll_locked(
> -					&pipe->wait, EPOLLOUT | EPOLLWRNORM);
> +				do_wakeup = 1;
> +				if (head - (tail - 1) == pipe->max_usage)
> +					wake_up_interruptible_sync_poll_locked(
> +						&pipe->wait, EPOLLOUT | EPOLLWRNORM);
>   				spin_unlock_irq(&pipe->wait.lock);
> -				kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
> +				if (head - (tail - 1) == pipe->max_usage)
> +					kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
>   			}
>   			total_len -= chars;
>   			if (!total_len)
> @@ -360,11 +362,6 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>   				ret = -ERESTARTSYS;
>   			break;
>   		}
> -		if (do_wakeup) {
> -			wake_up_interruptible_sync_poll(&pipe->wait, EPOLLOUT | EPOLLWRNORM);
> - 			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
> -			do_wakeup = 0;
> -		}
>   		pipe_wait(pipe);
>   	}
>   	__pipe_unlock(pipe);
> 
> 
