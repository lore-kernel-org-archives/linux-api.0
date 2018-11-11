From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 12:46:35 +0100
Message-ID: <87zhufvntw.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <20181111081725.GA30248@1wt.eu>
        <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
        <20181111111143.GB4189@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111111143.GB4189@1wt.eu> (Willy Tarreau's message of "Sun,
        11 Nov 2018 12:11:43 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Willy Tarreau:

> I think the issue is a bit more complex :
>   - linux doesn't support a single libc
>   - glibc doesn't support a single OS
>
> In practice we all know (believe?) that both statements above are
> true but in practice 99% of the time there's a 1:1 relation between
> these two components.

Eh.  Most Linux systems do not run glibc at all (and use cryptography
and other tricks to prevent users from installing it).

> What we'd really need would be to have the libc
> interface as part of the operating system itself. I'm perfectly fine
> with glibc providing all the "high-level" stuff like strcpy(), FILE*
> operations etc, and all this probably is mostly system-independent.

That's a bit messy, unfortunately.

The kernel does not know about TCB layout, so a lot of low-level
threading aspects are defined by userspace.

The kernel does not know about POSIX cancellation.  Directly calling
system calls breaks support for that.

A lot of multi-threaded applications assume that most high-level
functionality remains usable even after fork in a multi-threaded
process.  (This is increasingly a problem today with all those direct
calls to clone.)  Unfortunately, this introduces rather tricky
low-level/high-level cross-subsystem issues, too.

> But the system interface could possibly be handled easier in the
> system itself, which would also provide a smoother adoption of new
> syscalls and API updates. It would also limit the hassle required to
> provide new syscalls, as if you start to have to contribute to two
> projects at once for a single syscall, it becomes really painful.

Sure, the duplication is unfortunate.

Several glibc contributors deeply care about standards compliance for
header files.  The kernel developers care not, and the result is that we
copy definitions and declarations from the kernel header files, creating
additional problems.

We also want to use old kernel headers to compile glibc and still
implement features which are only defined by newer (upstream) kernels,
so that leads to more duplication.

Thanks,
Florian
