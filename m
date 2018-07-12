From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 7/7] timex: change syscalls to use struct
 __kernel_timex
Date: Thu, 12 Jul 2018 01:29:56 -0700
Message-ID: <20180712082956.GD8802@infradead.org>
References: <20180707054247.19802-1-deepa.kernel@gmail.com>
 <20180707054247.19802-8-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180707054247.19802-8-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 06, 2018 at 10:42:47PM -0700, Deepa Dinamani wrote:
> struct timex is not y2038 safe.
> Switch all the syscall apis to use y2038 safe __kernel_timex.

So you switch existing syscalls to use a different structure.
If this actually happens to be safe it needs a big explanation
in the commit log.

> -#ifdef CONFIG_COMPAT
> -
>  COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>  		       struct compat_timex __user *, utp)
>  {
> @@ -1187,10 +1183,6 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>  	return err;
>  }
>  
> -#endif

And this unconditionally defines clock_adjtime, but doesn't actually
seem to add callers, which looks rather odd.  Same for other bits
in the patch.
