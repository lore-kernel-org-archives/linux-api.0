From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 17/23] y2038: time: avoid timespec usage in
 settimeofday()
Date: Wed, 13 Nov 2019 22:53:17 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911132250010.2507@nanos.tec.linutronix.de>
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-8-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191108211323.1806194-8-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 8 Nov 2019, Arnd Bergmann wrote:
> -SYSCALL_DEFINE2(settimeofday, struct timeval __user *, tv,
> +SYSCALL_DEFINE2(settimeofday, struct __kernel_old_timeval __user *, tv,
>  		struct timezone __user *, tz)
>  {
>  	struct timespec64 new_ts;
> -	struct timeval user_tv;
>  	struct timezone new_tz;
>  
>  	if (tv) {
> -		if (copy_from_user(&user_tv, tv, sizeof(*tv)))
> +		if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
> +		    get_user(new_ts.tv_nsec, &tv->tv_usec))
>  			return -EFAULT;

How is that supposed to be correct on a 32bit kernel?

>  
> -		if (!timeval_valid(&user_tv))
> +		if (tv->tv_usec > USEC_PER_SEC)
>  			return -EINVAL;

That's incomplete:

static inline bool timeval_valid(const struct timeval *tv)
{
        /* Dates before 1970 are bogus */
        if (tv->tv_sec < 0)
                return false;

	/* Can't have more microseconds then a second */
        if (tv->tv_usec < 0 || tv->tv_usec >= USEC_PER_SEC)
                return false;

        return true;
}


>  
> -		new_ts.tv_sec = user_tv.tv_sec;
> -		new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
> +		new_ts.tv_nsec *= NSEC_PER_USEC;
>  	}
>  	if (tz) {
>  		if (copy_from_user(&new_tz, tz, sizeof(*tz)))
> @@ -245,18 +244,17 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, struct old_timeval32 __user *, tv,
>  		       struct timezone __user *, tz)
>  {
>  	struct timespec64 new_ts;
> -	struct timeval user_tv;
>  	struct timezone new_tz;
>  
>  	if (tv) {
> -		if (compat_get_timeval(&user_tv, tv))
> +		if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
> +		    get_user(new_ts.tv_nsec, &tv->tv_usec))
>  			return -EFAULT;
>  
> -		if (!timeval_valid(&user_tv))
> +		if (new_ts.tv_nsec > USEC_PER_SEC)
>  			return -EINVAL;

Ditto.

Thanks,

	tglx
