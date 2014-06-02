From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Mon, 2 Jun 2014 16:08:30 -0700
Message-ID: <CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
 <CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
 <CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
 <CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com> <CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 2, 2014 at 4:05 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Mon, Jun 2, 2014 at 2:17 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Mon, Jun 2, 2014 at 1:06 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>> On Mon, Jun 2, 2014 at 12:59 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> On Mon, Jun 2, 2014 at 12:47 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>>>> Hi Andrew,
>>>>>
>>>>> Would you be willing to carry this series? Andy Lutomirski appears
>>>>> happy with it now. (Thanks again for all the feedback Andy!) If so, it
>>>>> has a relatively small merge conflict with the bpf changes living in
>>>>> net-next. Would you prefer I rebase against net-next, let sfr handle
>>>>> it, get carried in net-next, or some other option?
>>>>
>>>> Well, I'm still not entirely convinced that we want to have this much
>>>> multiplexing in a prctl, and I'm still a bit unconvinced that the code
>>>
>>> I don't want to get caught without interface argument flexibility
>>> again, so that's why the prctl interface is being set up that way.
>>
>> I was thinking that a syscall might be a lot prettier.  It may pay to
>> cc linux-api, too.
>>
>> I'll offer you a deal: if you try to come up with a nice, clean
>> syscall, I'll try to write a fast(er) path for x86_64 to reduce
>> overhead.  I bet I can save 90-100ns per syscall. :)
>
> Now added to the Cc.
>
> Which path do you mean to improve? Neither the prctl nor a syscall for
> this would need to be fast at all.

Non-seccomp-related syscalls when seccomp is enabled.

>
> I don't want to go in circles on this. I've been there before on my
> VFS link hardening series, and my module restriction series. I would
> like consensus from more than just one person. :)

I can't offer you anyone else's review, unfortunately :-/

>
> I'd like to hear from other folks on this (akpm?). My instinct is to
> continue using prctl since that is already where mediation for seccomp
> happens. I don't see why prctl vs a new syscall makes a difference
> here, frankly.

Aesthetics?  There's a tendency for people to get annoyed at big
multiplexed APIs, and your patches will be doubly multiplexed.

TBH, I care more about the atomicity thing than about the actual form
of the API.

--Andy

>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
