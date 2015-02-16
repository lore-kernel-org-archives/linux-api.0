From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v3 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Mon, 16 Feb 2015 16:12:06 +0800
Message-ID: <20150216081119.GA9964@cpc-pc.redhat.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
 <20150215150011.0340686c@lwn.net>
 <20150216010224.GA32421@ad.nay.redhat.com>
 <DDB9C85B850785449757F9914A034FCB3BF41130@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF41130-4I1V4pQFGigSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd>
List-Id: linux-api@vger.kernel.org

Hi Seymour,

On Mon, 02/16 07:25, Seymour, Shane M wrote:
> I found the manual pages really confusing so I had a go at rewriting
> them - there were places in the manual page that didn't match the
> functionality provided by your code as well as I could tell).

Could you point which places don't match the code?

> 
> My apologies for a few formatting issues though. I still don't like
> parts of epoll_pwait1 but it's less confusing than it was.

Any other than the timespec question don't you like?

> 
> You are free to take some or all or none of the changes.
> 
> I did have a question I marked with **** below about what you
> describe and what your code does.
> 

<snip>

>        The timeout member specifies the minimum time that epoll_wait(2) will
>        block. The time spent waiting will be rounded up to the clock
>        granularity. Kernel scheduling delays mean that the blocking
>        interval may overrun by a small amount. Specifying a -1 for either
>        tv_sec or tv_nsec member of the struct timespec timeout will cause
>        causes epoll_pwait1(2) to block indefinitely. Specifying a timeout
>        equal to zero (both tv_sec or tv_nsec member of the struct timespec
>        timeout are zero) causes epoll_wait(2) to return immediately, even
>        if no events are available.
> 
> **** Are you really really sure about this for the -1 stuff? your code copies
> in the timespec and just passes it to timespec_to_ktime:
> 
> +	if (copy_from_user(&p, params, sizeof(p)))
> +		return -EFAULT;
> ...
> +	kt = timespec_to_ktime(p.timeout);
> 
> Compare that to something like the futex syscall which does this:
> 
> 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
> 			return -EFAULT;
> 		if (!timespec_valid(&ts))
> 			return -EINVAL;
> 
> 		t = timespec_to_ktime(ts);
> 
> If the timespec is not valid it returns -EINVAL back to user space. With your
> settings of tv_sec and/or tv_usec to -1 are you relying on a side effect of
> the conversion that could break your code in the future if in the unlikely
> event someone changes timespec_to_ktime() and should it be:
> 
> +	if (copy_from_user(&p, params, sizeof(p)))
> +		return -EFAULT;
> +       if ((p.timeout.tv_sec == -1) || (p.timeout.tv_nsec == -1)) {
> +  /* this is off the top of my head no idea if it will compile */
> +		p.timeout.tv_sec = KTIME_SEC_MAX;
> +		p.timeout.tv_nsec = 0;
> +	}
> +       if (!timespec_valid(&p.timeout))
> +       	return -EINVAL;
> ...
> +	kt = timespec_to_ktime(p.timeout);

OK. timespec_valid() is clear about this: negative tv_sec is invalid, so I
don't think accepting -1 from user is the right thing to do.

We cannot do pointer check as ppoll already because the structure is embedded
in epoll_wait_params.

Maybe it's best to use a flags bit (#define EPOLL_PWAIT1_BLOCK 1).  What do you
think?

Fam

<snip>
