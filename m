From: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ARM: cacheflush: disallow pending signals during cacheflush
Date: Thu, 13 Nov 2014 17:39:00 +0000
Message-ID: <CAFEAcA_dSxRgkvuJW6aHdSv88NkXXHBMAzjyJMTRbW3mXAV3Sg@mail.gmail.com>
References: <1415863793-6219-1-git-send-email-chanho.min@lge.com> <20141113112633.GE13350@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141113112633.GE13350-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Chanho Min <chanho.min-Hm3cg6mZ9cc@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Jon Medhurst <tixy-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taras Kondratiuk <taras.kondratiuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gunho Lee <gunho.lee-Hm3cg6mZ9cc@public.gmane.org>, HyoJun Im <hyojun.im-Hm3cg6mZ9cc@public.gmane.org>, Jongsung Kim <neidhard.kim-Hm3cg6mZ9cc@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 13 November 2014 11:26, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> Whilst I don't think this is the correct solution, I agree that there's
> a potential issue here. We could change the restart return value to
> -ERESTARTNOINTR instead, but I can imagine something like a periodic
> SIGALRM which could prevent a large cacheflush from ever completing.
> Do we actually care about making forward progress in such a scenario?
>
> It is interesting to note that this change has been in mainline since
> May last year without any reported issues. That could be down to a number
> of reasons:
>
>   (1) People are using old kernels on ARM
>
>   (2) Code doesn't check the return value from the cacheflush system call,
>       because it historically always returned 0

...and the documentation comment in the source code didn't say
anything about the syscall having a return value; it only
described the input parameters. I would actually be surprised
if any userspace caller of this syscall checked its return value
(the libgcc cacheflush function used by gcc's clear_cache builtin
doesn't, to pick one popularly used example).

>   (3) People are getting lucky with timing, as this is likely difficult
>       to hit

    (4) The resulting misbehaviour ("my JIT crashes occasionally and
        non-reproducibly at some point possibly some while after the
        cacheflush call") will be extremely hard to track back
        to this kernel change

> This leaves me with the following questions:
>
>   - Has this change been shown to break anything in practice?
>   - Can we change the internal return value to -ERESTARTNOINTR?
>   - What do we do about kernels that *do* return -EINTR? (>=3.12?)

My suggestion would be "treat this as a bugfix, put it into
stable kernels in the usual way (and assume distros will pick
it up if appropriate)".

>   - Can we get a manpage put together to describe this mess?

That would be nice :-)

-- PMM
