From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] io_uring: use __kernel_timespec in timeout ABI
Date: Tue, 1 Oct 2019 17:49:43 +0200
Message-ID: <CAK8P3a3AAFXNmpQwuirzM+jgEQGj9tMC_5oaSs4CfiEVGmTkZg@mail.gmail.com>
References: <20190930202055.1748710-1-arnd@arndb.de> <8d5d34da-e1f0-1ab5-461e-f3145e52c48a@kernel.dk>
 <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <623e1d27-d3b1-3241-bfd4-eb94ce70da14@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Stefan_B=C3=BChler?= <source@stbuehler.de>, Hannes Reinecke <hare@suse.com>, Jackie Liu <liuyun01@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>, Hristo Venev <hristo@venev.name>, linux-block <linux-block@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 1, 2019 at 5:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/1/19 8:09 AM, Jens Axboe wrote:
> > On 9/30/19 2:20 PM, Arnd Bergmann wrote:
> >> All system calls use struct __kernel_timespec instead of the old struct
> >> timespec, but this one was just added with the old-style ABI. Change it
> >> now to enforce the use of __kernel_timespec, avoiding ABI confusion and
> >> the need for compat handlers on 32-bit architectures.
> >>
> >> Any user space caller will have to use __kernel_timespec now, but this
> >> is unambiguous and works for any C library regardless of the time_t
> >> definition. A nicer way to specify the timeout would have been a less
> >> ambiguous 64-bit nanosecond value, but I suppose it's too late now to
> >> change that as this would impact both 32-bit and 64-bit users.
> >
> > Thanks for catching that, Arnd. Applied.
>
> On second thought - since there appears to be no good 64-bit timespec
> available to userspace, the alternative here is including on in liburing.

What's wrong with using __kernel_timespec? Just the name?
I suppose liburing could add a macro to give it a different name
for its users.

> That seems kinda crappy in terms of API, so why not just use a 64-bit nsec
> value as you suggest? There's on released kernel with this feature yet, so
> there's nothing stopping us from just changing the API to be based on
> a single 64-bit nanosecond timeout.

Certainly fine with me.

> +       timeout = READ_ONCE(sqe->addr);
>         hrtimer_init(&req->timeout.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>         req->timeout.timer.function = io_timeout_fn;
> -       hrtimer_start(&req->timeout.timer, timespec_to_ktime(ts),
> +       hrtimer_start(&req->timeout.timer, ns_to_ktime(timeout),

It seems a little odd to use the 'addr' field as something that's not
an address,
and I'm not sure I understand the logic behind when you use a READ_ONCE()
as opposed to simply accessing the sqe the way it is done a few lines
earlier.

The time handling definitely looks good to me.

       Arnd
