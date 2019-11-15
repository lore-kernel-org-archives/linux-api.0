From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 17/23] y2038: time: avoid timespec usage in settimeofday()
Date: Fri, 15 Nov 2019 14:50:42 +0100
Message-ID: <CAK8P3a0KOVG7STctuPW9gzhCo_yR6uM82LohoQML8CcwQF68Xw@mail.gmail.com>
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-8-arnd@arndb.de>
 <20191114230127.GA3580@ryzen.lan> <CAK8P3a3jn8GcedX=HaTFiPY+fyHPoyVUnpcX19nMZqmuUA1RzA@mail.gmail.com>
 <73a56955-552a-3a95-a410-3064401913f7@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <73a56955-552a-3a95-a410-3064401913f7@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Abel Vesa <abelvesa@linux.com>, y2038 Mailman List <y2038@lists.linaro.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 15, 2019 at 11:27 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On 15/11/2019 08.58, Arnd Bergmann wrote:
> > On Fri, Nov 15, 2019 at 12:01 AM Abel Vesa <abelvesa@linux.com> wrote:
> >>
> > --- a/kernel/time/time.c
> > +++ b/kernel/time/time.c
> > @@ -207,7 +207,7 @@ SYSCALL_DEFINE2(settimeofday, struct
> > __kernel_old_timeval __user *, tv,
> >                     get_user(new_ts.tv_nsec, &tv->tv_usec))
> >                         return -EFAULT;
> >
> > -               if (tv->tv_usec > USEC_PER_SEC)
> > +               if (new_ts->tv_usec > USEC_PER_SEC)
> >                         return -EINVAL;
>
> Hopefully not :)

No, I misquoted from a fix that I had temporarily applied, not the
version in linux-next.

>
> >                 new_ts.tv_nsec *= NSEC_PER_USEC;
>
> So the actual patch in next-20191115 does
>
> -               if (copy_from_user(&user_tv, tv, sizeof(*tv)))
> +               if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
> +                   get_user(new_ts.tv_nsec, &tv->tv_usec))
>                         return -EFAULT;
>
> -               if (!timeval_valid(&user_tv))
> +               if (new_ts.tv_nsec > USEC_PER_SEC)
>                         return -EINVAL;
>
> -               new_ts.tv_sec = user_tv.tv_sec;
> -               new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
> +               new_ts.tv_nsec *= NSEC_PER_USEC;
>
> But removing the "user value is < 0" check, relying on the timespec
> value being rejected later, is wrong

You are right of course, so many ways to get this one line wrong...
Pushed more more update to the branch now.

Thanks for the careful review!

        Arnd
