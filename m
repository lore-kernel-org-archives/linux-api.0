From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 15:10:24 -0800
Message-ID: <CAKOZueuM=3pxuXaJU4v571daWFCTJ1LYO-ApD6MrD7313RNYfQ@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com>
 <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
 <87lg5ym7qi.fsf@oldenburg.str.redhat.com> <CAKOZues2bQo1y_1ynxFMHGTvtTjABsqVpKJt5MYMdZBq6-ikHA@mail.gmail.com>
 <alpine.DEB.2.21.1811122236240.18130@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811122236240.18130@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Florian Weimer <fweimer@redhat.com>, Zack Weinberg <zackw@panix.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 12, 2018 at 2:51 PM, Joseph Myers <joseph@codesourcery.com> wrote:
> I see no obvious reason why a kernel-provided
> library, with all the problems that entails, should need to be involved,
> rather than putting new APIs either in libc

I initially wanted to put the APIs in libc. I still do. But that's
proving to be impractical, for the reasons we're discussing on this
thread.

> or in a completely separate
> libsignal

A separate library can't prevent some use of sigaction elsewhere in
the program stomping on its handler. One of the key aspects of the
registered-handler design is that registered handlers get to run
*before* the legacy process-wide handler. The only non-hacky way to do
that is to put the signal handler registration logic in the same logic
component that houses the legacy signal registration machinery.

> (I can imagine *other* parts of the toolchain being involved, if e.g. you
> want to have a good way of checking "is the address of the instruction
> causing this signal in this library?" that works with static as well as
> dynamic linking - for dynamic linking, I expect something could be done
> using libc_nonshared and __dso_handle to identify code in the library
> calling some registering function.  And indeed there might also be new
> kernel interfaces that help improve signal handling.)

Again: you're blocking a practical solution for the sake of some
elegant theoretical implementation that will never arrive, and so the
world remains in a poor state indefinitely. Incremental improvement is
good. Nothing about the registered signal handler approach precludes
this sort of enhancement in the future. The same goes for the system
call metadata database you've described: nice-to-have; shouldn't block
simpler and more immediately practical work.

> In the absence of consensus for adding such a new API for signals to
> glibc, it's unlikely one would get consensus for glibc to depend on some
> other library providing such an API either.

glibc would continue using an unsupported legacy system call
interfaces in lieu of a supported low-level interface library?
