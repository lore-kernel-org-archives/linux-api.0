From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Tue, 3 Jun 2014 12:12:27 +0200
Message-ID: <CAHO5Pa3F2MjfTtfNxa8LbnkeeU8=YJ+9tDqxZpw7Gz59E-4AUg@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
 <CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
 <CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
 <CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com>
 <CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ@mail.gmail.com> <CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWLNFJbwaYKkjBi7XPLBQ2=gEGmW=G==+_9jcrLPW+JdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Kees, thank you for CCing linux-api]

On Tue, Jun 3, 2014 at 1:08 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Jun 2, 2014 at 4:05 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:

>> I'd like to hear from other folks on this (akpm?). My instinct is to
>> continue using prctl since that is already where mediation for seccomp
>> happens. I don't see why prctl vs a new syscall makes a difference
>> here, frankly.
>
> Aesthetics?  There's a tendency for people to get annoyed at big
> multiplexed APIs, and your patches will be doubly multiplexed.

prctl() is already a Franken-interface that provides a mass of
different, mostly completely unrelated, functionality. So, I wonder if
it would be better not to make the situation worse. Furthermore, the
very fact that the existing prctl seccomp API is being extended and
multiplexed suggests that other extensions might be desirable further
down the line, which also hints that a separate syscall would be a
good idea. (Or do we have to wait until the prctl seccomp API is
extended one more time, before we realize that a new system call would
have been a good idea...)

> TBH, I care more about the atomicity thing than about the actual form
> of the API.

User-space does not necessarily thank you for that perspective, Andy
;-). The atomicity thing is presumably fixable, regardless of the API.
On the other hand, APIs are things that kernel developers design once
and forget about, and user-space has to live with forever.

Cheers,

Michael
