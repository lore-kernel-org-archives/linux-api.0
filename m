From: Stepan Golosunov <stepan@golosunov.pp.ru>
Subject: Re: [PATCH v3 4/5] pselect6: use __kernel_timespec
Date: Tue, 18 Sep 2018 00:34:39 +0400
Message-ID: <20180917203438.maary2eo64dbuhw2@sghpc.golosunov.pp.ru>
References: <20180917010458.23159-1-deepa.kernel@gmail.com>
 <20180917010458.23159-5-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180917010458.23159-5-deepa.kernel@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-aio@kvack.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 16, 2018 at 06:04:57PM -0700, Deepa Dinamani wrote:
>  static long do_compat_pselect(int n, compat_ulong_t __user *inp,
>  	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
> -	struct old_timespec32 __user *tsp, compat_sigset_t __user *sigmask,
> -	compat_size_t sigsetsize)
> +	void __user *tsp, compat_sigset_t __user *sigmask,
> +	compat_size_t sigsetsize, enum poll_time_type type)
>  {
>  	sigset_t ksigmask, sigsaved;
>  	struct timespec64 ts, end_time, *to = NULL;
>  	int ret;
>  
>  	if (tsp) {
> -		if (get_old_timespec32(&ts, tsp))
> -			return -EFAULT;
> +		switch (type) {
> +		case PT_OLD_TIMESPEC:
> +			if (get_old_timespec32(&ts, tsp))
> +				return -EFAULT;
> +			break;
> +		case PT_TIMESPEC:
> +			if (get_old_timespec32(&ts, tsp))
> +				return -EFAULT;
> +			break;
> +		default:
> +			BUG();
> +		}

One of the two get_old_timespec32 calls here should be
get_timespec64.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
