From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 13:25:25 +0100
Message-ID: <87d0raqy8a.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <20181111081725.GA30248@1wt.eu>
        <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
        <20181111111143.GB4189@1wt.eu>
        <87zhufvntw.fsf@oldenburg.str.redhat.com>
        <20181111120910.GA4425@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111120910.GA4425@1wt.eu> (Willy Tarreau's message of "Sun,
        11 Nov 2018 13:09:10 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Willy Tarreau:

>> > What we'd really need would be to have the libc
>> > interface as part of the operating system itself. I'm perfectly fine
>> > with glibc providing all the "high-level" stuff like strcpy(), FILE*
>> > operations etc, and all this probably is mostly system-independent.
>> 
>> That's a bit messy, unfortunately.
>> 
>> The kernel does not know about TCB layout, so a lot of low-level
>> threading aspects are defined by userspace.
>> 
>> The kernel does not know about POSIX cancellation.  Directly calling
>> system calls breaks support for that.
>> 
>> A lot of multi-threaded applications assume that most high-level
>> functionality remains usable even after fork in a multi-threaded
>> process.  (This is increasingly a problem today with all those direct
>> calls to clone.)  Unfortunately, this introduces rather tricky
>> low-level/high-level cross-subsystem issues, too.
>
> But don't you think that moving a bit of this into the kernel
> repository could improve the situation ? The corner cases could then
> be detected when the feature is developed and be addressed either by
> adapting the kernel side of the syscall or even by changing the design
> before it's committed. Maybe a few extra syscalls are missing to
> retrieve some critial info that would make things more reliable or
> easier between userland and kernel, and that would become more obvious
> with all the relevant parts at the same place ?
>
>> > But the system interface could possibly be handled easier in the
>> > system itself, which would also provide a smoother adoption of new
>> > syscalls and API updates. It would also limit the hassle required to
>> > provide new syscalls, as if you start to have to contribute to two
>> > projects at once for a single syscall, it becomes really painful.
>> 
>> Sure, the duplication is unfortunate.
>> 
>> Several glibc contributors deeply care about standards compliance for
>> header files.
>
> For having suffered a lot from the libc-4 to libc-5 then libc-5 to glibc,
> I certainly can understand their concerns about standards compliance.

This is getting way off-topic, but:

The C standard does not care deeply about practical source code
compatibility.  Behavior of valid syntax generally remains unchanged.
However, each revision adds many macros to existing header files, so
practical source code compatibility tends to be problematic.  For glibc,
the current policy is to enable all optional features with _GNU_SOURCE,
so most projects receive the full dose of macros.  (Unrelated to
standards, even new system call wrappers are problematic for source code
compatibility).)

For ABI compatibility, there are only ad-hoc standards anyway, so it's
mostly about us being careful when making changes.

>> The kernel developers care not, and the result is that we
>> copy definitions and declarations from the kernel header files, creating
>> additional problems.
>
> Probably that these standard compatibility issues should be addressed at
> their root in the kernel header definitions in fact. Working around issues
> always leads to a stall at some point, and it encourages the process not
> to change.

In the past, we couldn't even get agreement about little things such as
__u64, so I'm not hopeful. 8-(

Thanks,
Florian
