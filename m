From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 12:09:28 +0100
Message-ID: <877ehjx447.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> (Michael
        Kerrisk's message of "Sun, 11 Nov 2018 07:55:30 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

> [adding in glibc folk for comment]
>
> On 11/10/18 7:52 PM, Daniel Colascione wrote:
>> Now that glibc is basically not adding any new system call wrappers,
>> how about publishing an "official" system call glue library as part of
>> the kernel distribution, along with the uapi headers? I don't think
>> it's reasonable to expect people to keep using syscall(__NR_XXX) for
>> all new functionality, especially as the system grows increasingly
>> sophisticated capabilities (like the new mount API, and hopefully the
>> new process API) outside the strictures of the POSIX process.
>
> As a quick glance at the glibc NEWS file shows, the above is not
> quite true:
>
> [[
> Version 2.28
> * The renameat2 function has been added...
> * The statx function has been added...
>
> Version 2.27
> * Support for memory protection keys was added.  The <sys/mman.h> header now
>   declares the functions pkey_alloc, pkey_free, pkey_mprotect...
> * The copy_file_range function was added.
>
> Version 2.26
> * New wrappers for the Linux-specific system calls preadv2 and pwritev2.
>
> Version 2.25
> * The getrandom [function] have been added.
> ]]
>
> I make that 11 system call wrappers added in the last 2 years.

And you missed mlock2 and memfd_create.

In some cases, we used system calls before the kernel had them (because
the kernel does not add system calls consistently across architectures).

On the other hand, this is only half of the story because distributions
do not backport system call wrappers, even those that backport kernel
implementations (or just rebase the kernel).  This is something that
could be fixed eventually, but it is realted to another problem:

We had a patch for the membarrier system call, but the kernel developers
could not tell us what the system call does in therms of the C/C++
memory model, and the kernel developers and our concurrency expert could
not agree on documentation.

A lot of the new system calls lack clear specifications or are just
somewhat misdesigned.  For example, pkey_alloc uses PKEY_DISABLE_WRITE
and PKEY_DISABLE_ACCESS flags (where the latter implies disabling both
read and write access), not something that matches the PROT_READ and
PROT_WRITE flags used by mmap/mprotect.  This caused problems when POWER
support for pkey_alloc was added, and we are still working on resolving
that.

getrandom still causes boot delays because the kernel somehow fails to
seed its internal pool before starting PID 1 even on mainstream hardware
which has plenty of (true) randomness sources available, leading to
indefinite blocking of getrandom.  It seems to me that people have
largely given up on fixing this in the upstream kernel.

For copy_file_range, we still have debates whether the system call (and
the glibc emulation) should preserve holes or not, and there a plans to
lift the cross-device restriction.

For renameat2, we already had a function in gnulib with the same name,
but which did not provide the atomic RENAME_NOREPLACE behavior for which
renameat2 was introduced.

These problems are relevant to the backporting question.  One relatively
low-cost way do backport straight wrappers would be to put them as
hidden functions into libc_nonshared.a.  But with these uncertainties,
this would be rather risky because fixing bugs of the wrappers would
then require relinking.

Thanks,
Florian
