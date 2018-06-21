From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/2] rusage: allow 64-bit times ru_utime/ru_stime
Date: Thu, 21 Jun 2018 17:49:15 +0200
Message-ID: <20180621154915.GA31947@gmail.com>
References: <20180420120605.1612248-1-arnd@arndb.de>
 <20180420120605.1612248-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180420120605.1612248-2-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Paul Eggert <eggert@cs.ucla.edu>, "Eric W . Biederman" <ebiederm@xmission.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Dominik Brodowski <linux@dominikbrodowski.net>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org


(belated reply)

* Arnd Bergmann <arnd@arndb.de> wrote:

> +int put_compat_rusage_time64(const struct __kernel_rusage *r,
> +			     struct compat_rusage_time64 __user *ru)
> +{
> +	struct compat_rusage_time64 r32;
> +	memset(&r32, 0, sizeof(r32));
> +	r32.ru_utime.tv_sec = r->ru_utime.tv_sec;
> +	r32.ru_utime.tv_usec = r->ru_utime.tv_usec;
> +	r32.ru_stime.tv_sec = r->ru_stime.tv_sec;
> +	r32.ru_stime.tv_usec = r->ru_stime.tv_usec;
> +	r32.ru_maxrss = r->ru_maxrss;
> +	r32.ru_ixrss = r->ru_ixrss;
> +	r32.ru_idrss = r->ru_idrss;
> +	r32.ru_isrss = r->ru_isrss;
> +	r32.ru_minflt = r->ru_minflt;
> +	r32.ru_majflt = r->ru_majflt;
> +	r32.ru_nswap = r->ru_nswap;
> +	r32.ru_inblock = r->ru_inblock;
> +	r32.ru_oublock = r->ru_oublock;
> +	r32.ru_msgsnd = r->ru_msgsnd;
> +	r32.ru_msgrcv = r->ru_msgrcv;
> +	r32.ru_nsignals = r->ru_nsignals;
> +	r32.ru_nvcsw = r->ru_nvcsw;
> +	r32.ru_nivcsw = r->ru_nivcsw;

Could you please vertically align the right side of the initialization as well? 
Much easier to check at a glance.

> +	user_access_begin();
> +	unsafe_put_user(signo, &infop->si_signo, Efault);
> +	unsafe_put_user(0, &infop->si_errno, Efault);
> +	unsafe_put_user(info.cause, &infop->si_code, Efault);
> +	unsafe_put_user(info.pid, &infop->si_pid, Efault);
> +	unsafe_put_user(info.uid, &infop->si_uid, Efault);
> +	unsafe_put_user(info.status, &infop->si_status, Efault);
> +	user_access_end();

This too would look nicer the following way:

> +	user_access_begin();
> +	unsafe_put_user(signo,		&infop->si_signo,	Efault);
> +	unsafe_put_user(0,		&infop->si_errno,	Efault);
> +	unsafe_put_user(info.cause,	&infop->si_code,	Efault);
> +	unsafe_put_user(info.pid,	&infop->si_pid,		Efault);
> +	unsafe_put_user(info.uid,	&infop->si_uid,		Efault);
> +	unsafe_put_user(info.status,	&infop->si_status,	Efault);
> +	user_access_end();

Which tabulated form made me notice the info.cause / si_code asymmetry - and a 
brief check of the source shows that it's correct. No way would I have noticed it 
in the jumbled up form above, so I think aligning such mass-initializations makes 
sense.

> +	memset(&r, 0, sizeof(r));
> +	r.ru_utime.tv_sec = rk->ru_utime.tv_sec;
> +	r.ru_utime.tv_usec = rk->ru_utime.tv_usec;
> +	r.ru_stime.tv_sec = rk->ru_stime.tv_sec;
> +	r.ru_stime.tv_usec = rk->ru_stime.tv_usec;
> +	r.ru_maxrss = rk->ru_maxrss;
> +	r.ru_ixrss = rk->ru_ixrss;
> +	r.ru_idrss = rk->ru_idrss;
> +	r.ru_isrss = rk->ru_isrss;
> +	r.ru_minflt = rk->ru_minflt;
> +	r.ru_majflt = rk->ru_majflt;
> +	r.ru_nswap = rk->ru_nswap;
> +	r.ru_inblock = rk->ru_inblock;
> +	r.ru_oublock = rk->ru_oublock;
> +	r.ru_msgsnd = rk->ru_msgsnd;
> +	r.ru_msgrcv = rk->ru_msgrcv;
> +	r.ru_nsignals = rk->ru_nsignals;
> +	r.ru_nvcsw = rk->ru_nvcsw;
> +	r.ru_nivcsw = rk->ru_nivcsw;

Ditto.

Thanks,

	Ingo
