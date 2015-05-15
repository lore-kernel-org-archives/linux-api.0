From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 13/19] y2038: add compat handling for sys_semtimedop
Date: Sat, 16 May 2015 00:46:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505160041370.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430929826-318934-14-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-14-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 6 May 2015, Arnd Bergmann wrote:
> +SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
> +		unsigned, nsops,
> +		const struct __kernel_timespec  __user *, timeout)
> +{
> +	unsigned long jiffies_left = 0;
> +
> +	if (timeout) {
> +		struct timespec64 _timeout;
> +		if (get_timespec64(&_timeout, timeout))

Moo. I had to look 3 times to get not confused by the extra
underscore. What's wrong with a proper variable name which is easy to
distinguish?

> +			return -EFAULT;

> +		if (_timeout.tv_sec < 0 || _timeout.tv_nsec < 0 ||
> +			_timeout.tv_nsec >= 1000000000L)
> +			return -EINVAL;

We have proper helper functions to validate time specs.

Thanks,

	tglx
