From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Fri, 23 Nov 2018 14:34:26 +0100
Message-ID: <87efbbvrx9.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <877ehjx447.fsf@oldenburg.str.redhat.com>
        <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
        <875zx2vhpd.fsf@oldenburg.str.redhat.com>
        <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Daniel Colascione:

> On Mon, Nov 12, 2018 at 12:11 AM, Florian Weimer <fweimer@redhat.com> wrote:
>> * Daniel Colascione:
>>
>>> If the kernel provides a system call, libc should provide a C wrapper
>>> for it, even if in the opinion of the libc maintainers, that system
>>> call is flawed.
>>
>> It's not that simple, I think.  What about bdflush?  socketcall?
>> getxpid?  osf_gettimeofday?  set_robust_list?
>
> What about them? Mentioning that these system calls exist is not in
> itself an argument.

But socketcall does not exist on all architectures.  Neither does
getpid, it's called getxpid on some architectures.

>> There are quite a few irregularities
>
> So?

I think it would be a poor approach to expose application developers to
these portability issues.  We need to abstract over these differences at
a certain layer, and applications are too late.

>> and some editorial discretion appears to be unavoidable.
>
> That's an assertion, not an argument, and I strongly disagree. *Why*
> do you think "editorial discretion" is unavoidable?

We do not want application authors to write code which uses socketcall,
however it is the right system call for the BSD sockets API if you need
compatibility back to Linux 2.6.32 and before.  If we application
authors seitched to socketall, applications would not be portable (at
the source level) to new architectures which do not have socketcall.

We do not want to force application authors to call osf_gettimeofday
instead of gettimeofday on Alpha.

We do not want to encourage library authors to call set_robust_list
because doing so would break robust mutex support in any libc.

>> Even if we were to provide perfectly consistent system call wrappers
>> under separate names, we'd still expose different calling conventions
>> for things like off_t to applications, which would make using some of
>> the system calls quite difficult and surprisingly non-portable.
>
> We can learn something from how Windows does things. On that system,
> what we think of as "libc" is actually two parts. (More, actually, but
> I'm simplifying.) At the lowest level, you have the semi-documented
> ntdll.dll, which contains raw system call wrappers and arcane
> kernel-userland glue. On top of ntdll live the "real" libc
> (msvcrt.dll, kernel32.dll, etc.) that provide conventional
> application-level glue. The tight integration between ntdll.dll and
> the kernel allows Windows to do very impressive things.

> We should adopt a similar approach.

Most kernel developers claim that a stable userspace ABI is desirable.
With your proposal, we need to maintain three stable ABI layers instead
of two, without actually adding any functionality.  That doesn't seem to
be a good way of using developer resources.

Thanks,
Florian
