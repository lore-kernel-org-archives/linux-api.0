From: john stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Mon, 08 Nov 2010 15:37:03 -0800
Message-ID: <1289259423.21487.7.camel@localhost.localdomain>
References: <cover.1288897198.git.richard.cochran@omicron.at>
	 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2010-11-04 at 20:28 +0100, Richard Cochran wrote: 
> This patch lets the clock_gettime system call use dynamic clock devices.
> 
> Signed-off-by: Richard Cochran <richard.cochran-3mrvs1K0uXizZXS1Dc/lvw@public.gmane.org>
> ---
>  include/linux/clockdevice.h  |    9 ++++++
>  include/linux/posix-timers.h |   21 ++++++++++++++-
>  include/linux/time.h         |    2 +
>  kernel/posix-timers.c        |    4 +-
>  kernel/time/clockdevice.c    |   58 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 91 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/clockdevice.h b/include/linux/clockdevice.h
> index a8f9359..ae258ac 100644
> --- a/include/linux/clockdevice.h
> +++ b/include/linux/clockdevice.h
> @@ -94,4 +94,13 @@ void destroy_clock_device(struct clock_device *clk);
>   */
>  void *clock_device_private(struct file *fp);
> 
> +/**
> + * clockid_to_clock_device() - obtain clock device pointer from a clock id
> + * @id: user space clock id
> + *
> + * Returns a pointer to the clock device, or NULL if the id is not a
> + * dynamic clock id.
> + */
> +struct clock_device *clockid_to_clock_device(clockid_t id);
> +
>  #endif
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index 3e23844..70f40e6 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -17,10 +17,22 @@ struct cpu_timer_list {
>  	int firing;
>  };
> 
> +/* Bit fields within a clockid:
> + *
> + * The most significant 29 bits hold either a pid or a file descriptor.
> + *
> + * Bit 2 indicates whether a cpu clock refers to a thread or a process.
> + *
> + * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
> + *
> + * A clockid is invalid if bits 2, 1, and 0 all set (see also CLOCK_INVALID
> + * in include/linux/time.h)
> + */

> #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))

So I think we may want to add some additional comments here.
Specifically around the limits both new and existing that are created
around the interactions between clockid_t, pid_t and now the clock_fd.

Specifically, pid_t is already limited by futex to 29 bits (I believe,
please correct me if I'm wrong). MAKE_PROCESS_CPUCLOCK macro below seems
to also utilize this 29 bit pid limit assumption as well (via pid<<3),
however it may actually require pid to be below 28 (since CLOCK_DISPATCH
assumes cpu clockids are negative).

Anyway, this seems like it should be a bit more explicit.


> #define CPUCLOCK_PERTHREAD(clock) \
>  	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
> -#define CPUCLOCK_PID_MASK	7
> +
>  #define CPUCLOCK_PERTHREAD_MASK	4
>  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
>  #define CPUCLOCK_CLOCK_MASK	3
> @@ -28,12 +40,17 @@ struct cpu_timer_list {
>  #define CPUCLOCK_VIRT		1
>  #define CPUCLOCK_SCHED		2
>  #define CPUCLOCK_MAX		3
> +#define CLOCKFD			CPUCLOCK_MAX
> +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> 
>  #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
>  	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
>  #define MAKE_THREAD_CPUCLOCK(tid, clock) \
>  	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)
> 
> +#define FD_TO_CLOCKID(fd)  ((clockid_t) (fd << 3) | CLOCKFD)
> +#define CLOCKID_TO_FD(clk) (((unsigned int) clk) >> 3)

So similarly here, we need to be explicit in making sure that the max fd
value is small enough to fit without dropping bits if we shift it up by
three (trying to quickly review open I don't see any explicit limit,
other then NR_OPEN_DEFAULT, but that's BIT_PER_LONG, which won't fit in
the int returned by open on 64bit systems).


> +SYSCALL_DEFINE2(clock_gettime,
> +		const clockid_t, id, struct timespec __user *, user_ts)
> +{
> +	struct timespec ts;
> +	struct clock_device *clk;
> +	int err;
> +
> +	clk = clockid_to_clock_device(id);
> +	if (!clk)
> +		return posix_clock_gettime(id, user_ts);
> +
> +	mutex_lock(&clk->mux);
> +
> +	if (clk->zombie)
> +		err = -ENODEV;
> +	else if (!clk->ops->clock_gettime)
> +		err = -EOPNOTSUPP;
> +	else
> +		err = clk->ops->clock_gettime(clk->priv, &ts);
> +
> +	if (!err && copy_to_user(user_ts, &ts, sizeof(ts)))
> +		err = -EFAULT;
> +
> +	mutex_unlock(&clk->mux);
> +	return err;
> +}


So sort of minor nit here, but is there a reason the clockfd
implementation is primary here and the standard posix implementation
gets pushed off into its own function rather then doing something like:

clk = clockid_to_clock_device(id)
if(clk)
	return clockdev_clock_gettime(clk, user_ts);
[existing sys_clock_gettime()] 

As you implemented it, it seems to expect the clockdevice method to be
the most frequent use case, where as its likely to be the inverse. So
folks looking into the more common CLOCK_REALTIME calls have to traverse
more code then the likely more rare clockfd cases.

Also, in my mind, it would seem more in-line with the existing code to
integrate the conditional into CLOCK_DISPATCH. Not that CLOCK_DISPATCH
is pretty, but it avoids making your changes look tacked on in front of
everything.

thanks
-john
