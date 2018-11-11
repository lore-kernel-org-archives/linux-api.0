From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 06:22:59 -0800
Message-ID: <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877ehjx447.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 3:09 AM, Florian Weimer <fweimer@redhat.com> wrote:
> We had a patch for the membarrier system call, but the kernel developers
> could not tell us what the system call does in therms of the C/C++
> memory model
[snip]
> A lot of the new system calls lack clear specifications or are just
> somewhat misdesigned.  For example, pkey_alloc
[snip]
> getrandom still causes boot delays
[snip]
> For copy_file_range, we still have debates whether the system call (and
> the glibc emulation) should preserve holes or not,
[snip]

These objections illustrate my point. glibc development is not the
proper forum for raising post-hoc objections to system call design.
Withholding wrappers will not un-ship these system calls. Applications
are already using them, via syscall(2). Developers and users would be
better served by providing access to the system as it is, with
appropriate documentation caveats, than by holding out for some
alternate and more ideal set of system calls that may or may not
appear in the future. This resistance to exposing the capabilities of
the system as they are, even in flawed and warty form, is what I meant
by "misplaced idealism" in my previous message. If the kernel provides
a system call, libc should provide a C wrapper for it, even if in the
opinion of the libc maintainers, that system call is flawed.

I agree with the proposals mentioned above to split system interface
responsibility, having glibc handle higher-level concerns like stdio
while punting system call wrappers and other low-level facilities to a
kernel-provided userspace library that can move faster and more
explicitly conform to the Linux kernel's userspace ABI.
