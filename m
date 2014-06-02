From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Mon, 2 Jun 2014 16:05:29 -0700
Message-ID: <CAGXu5jKFte0ZvqU8RYcqjWDCoegWeu66gdwX83tiL8vprcvMgQ@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
	<CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
	<CALCETrV0ZEFipU0E64n5q44LiUV4j4Qqvnz0h_QAoddg+e7V3A@mail.gmail.com>
	<CAGXu5j+YRW_+W8Z9S9O84ep-uUc4wQQRbtSu6_s8o5J2HLPUYg@mail.gmail.com>
	<CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXB0zp8gwpWuxXs0bgB8sQhe6JLE46BOYw3OrBx7hQYVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, James Morris <james.l.morris@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "David S. Miller" <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 2, 2014 at 2:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jun 2, 2014 at 1:06 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Jun 2, 2014 at 12:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Mon, Jun 2, 2014 at 12:47 PM, Kees Cook <keescook@chromium.org> wrote:
>>>> Hi Andrew,
>>>>
>>>> Would you be willing to carry this series? Andy Lutomirski appears
>>>> happy with it now. (Thanks again for all the feedback Andy!) If so, it
>>>> has a relatively small merge conflict with the bpf changes living in
>>>> net-next. Would you prefer I rebase against net-next, let sfr handle
>>>> it, get carried in net-next, or some other option?
>>>
>>> Well, I'm still not entirely convinced that we want to have this much
>>> multiplexing in a prctl, and I'm still a bit unconvinced that the code
>>
>> I don't want to get caught without interface argument flexibility
>> again, so that's why the prctl interface is being set up that way.
>
> I was thinking that a syscall might be a lot prettier.  It may pay to
> cc linux-api, too.
>
> I'll offer you a deal: if you try to come up with a nice, clean
> syscall, I'll try to write a fast(er) path for x86_64 to reduce
> overhead.  I bet I can save 90-100ns per syscall. :)

Now added to the Cc.

Which path do you mean to improve? Neither the prctl nor a syscall for
this would need to be fast at all.

I don't want to go in circles on this. I've been there before on my
VFS link hardening series, and my module restriction series. I would
like consensus from more than just one person. :)

I'd like to hear from other folks on this (akpm?). My instinct is to
continue using prctl since that is already where mediation for seccomp
happens. I don't see why prctl vs a new syscall makes a difference
here, frankly.

-Kees

-- 
Kees Cook
Chrome OS Security
