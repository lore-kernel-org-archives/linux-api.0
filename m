From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: Simplfying copy_siginfo_to_user
Date: Mon, 31 Jul 2017 11:37:41 -0500
Message-ID: <87mv7k1s16.fsf@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
        <20170718140651.15973-7-ebiederm@xmission.com>
        <CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw@mail.gmail.com>
        <878tjlbqpt.fsf@xmission.com> <8760ek5ics.fsf_-_@xmission.com>
        <CA+55aFyH5W2doo9vxXta_-pXfNXqQ19d7z48k1hmfAot+aJvMw@mail.gmail.com>
        <20170725013756.GH2063@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170725013756.GH2063@ZenIV.linux.org.uk> (Al Viro's message of
        "Tue, 25 Jul 2017 02:37:57 +0100")
Sender: linux-arch-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

2> On Mon, Jul 24, 2017 at 10:43:34AM -0700, Linus Torvalds wrote:
>> On Sat, Jul 22, 2017 at 1:25 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>> > I played with some clever changes such as limiting the copy to 48 bytes,
>> > disabling the memset and the like but I could not get a strong enough
>> > signal to say that any one change removed the extra or a clear part of
>> > it 20ns.
>> 
>> What CPU did you use? Because the SMAP bit in particular matters.
>> 
>> The field-by-field copies are extremely slow on modern CPU's that
>> implement SMAP, unless you also use the special "unsafe_put_user()"
>> code (or the nasty old put_user_ex() code that some of the x86 signal
>> code uses).
>> 
>> So one of the advantages of just copy_to_user() ends up being visible
>> only on Broadwell+ (or whatever the SMAP cutoff is).
>
> Guys, could you take a look at vfs.git#work.siginfo?  I'd been pretty
> much buried lately (and probably will for several more weeks - long-distance
> moves *suck*), so that thing got stalled, but it might be worth a
> look.

There is some good stuff in there.  If you don't mind I am going to
cherry pick out your unification of struct siginfo and struct compat_siginfo.

> The code generated in copy_siginfo_to_user() in it looks reasonably good,
> we don't copy more than we need and all copying to userland is done
> by copy_to_user() - one call per call of copy_siginfo_to_user(), so
> SMAP crap is not an issue.

There is actually a core problem with doing things that way.  You rely
on having the siginfo union member stored in the high bits of si_code.

I have just fixed that in my tree and replaced using the high bits
with calling the function siginfo_layout.

It has been a significant problem storing the union member differently
in the kernel than in userspace.  It has allowed for some pretty
horrendous gaffs in the archictecures changing the meaning of SI_USER
when specific signals are delivered over.  It has also meant that ptrace
siginfo injection and tg_sigqueueinfo have been broken for some signals
almost since the interface was added.

Without any optimization and just changing the code to be copy_to_user
I am seeing a maybe 2% slowdown.  Given that no one has seemed to care
overly for the performance of signal delivery I suspect an almost
unmeasurable slowdown is a reasonable tradeoff for simpler code.

> The next thing I hope to do is converting compat side of that thing to
> the same; that got stalled.

All of that said your precise copying code appears reasonable and quite
nice so I may adopt it on the compat side.

> Al "Buried in boxes" Viro...

Eric "Also Buried in boxes" Biederman
