From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
Date: Wed, 4 Aug 2010 18:32:21 +0300
Message-ID: <20100804153221.GA29109@shutemov.name>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1280926108-24668-1-git-send-email-virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Cc: lkml-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jon Hunter <jon-hunter-l0cyMroinI0@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Avi Kivity <avi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, John Kacur <jkacur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 04, 2010 at 03:48:28PM +0300, Alexander Shishkin wrote:
> Certain userspace applications (like "clock" desktop applets or ntpd) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.
> 
> This patch implements a notification interface via eventfd mechanism. Proccess
> wishing to be notified about time changes should create an eventfd and echo
> its file descriptor to /sys/kernel/time_notify. After that, any calls to
> settimeofday()/stime()/adjtimex() made by other processes will be signalled
> to this eventfd. Credits for suggesting the eventfd mechanism for this
> purpose go te Kirill Shutemov.
> 
> So far, this implementation can only filter out notifications caused by
> time change calls made by the process that wrote the eventfd descriptor to
> sysfs, but not its children which (might) have inherited the eventfd. It
> is so far not clear to me whether this is bad and more confusing than
> excluding such children as well.

I think it's a bad idea to filter notifications. Let's leave it for
userspace. Userspace always can check eventfd counter and understand who
touch time based on its own activity.

> Similar mechanism can also be used for signalling other (all?) system calls
> made by certain (all?) processes without resorting to ptrace (which won't
> help if you don't know what processes you'd like to look after), given
> proper permission checks etc.
> 
> Signed-off-by: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
> CC: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> CC: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Jon Hunter <jon-hunter-l0cyMroinI0@public.gmane.org>
> CC: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
> CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Avi Kivity <avi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> CC: John Kacur <jkacur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  include/linux/time.h |    7 ++
>  init/Kconfig         |    7 ++
>  kernel/Makefile      |    1 +
>  kernel/time.c        |   11 +++-
>  kernel/time_notify.c |  158 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 182 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/time_notify.c
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index ea3559f..9fca62b 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -237,6 +237,13 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
>  	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
>  	a->tv_nsec = ns;
>  }
> +
> +#ifdef CONFIG_TIME_NOTIFY
> +void time_notify_all(void);
> +#else
> +#define time_notify_all() do {} while (0)
> +#endif
> +
>  #endif /* __KERNEL__ */
>  
>  #define NFDBITS			__NFDBITS
> diff --git a/init/Kconfig b/init/Kconfig
> index 5cff9a9..f7271f8 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -976,6 +976,13 @@ config PERF_USE_VMALLOC
>  	help
>  	  See tools/perf/design.txt for details
>  
> +config TIME_NOTIFY
> +	bool
> +	depends on EVENTFD
> +	help
> +	  Enable time change notification events to userspace via
> +	  eventfd.
> +

Do we really need config option? I think better just use
CONFIG_EVENTFD.

linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org added to CC list.

-- 
 Kirill A. Shutemov
