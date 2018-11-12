From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 23:26:58 +0000
Message-ID: <alpine.DEB.2.21.1811122313000.18130@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com> <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
 <87lg5ym7qi.fsf@oldenburg.str.redhat.com> <CAKOZues2bQo1y_1ynxFMHGTvtTjABsqVpKJt5MYMdZBq6-ikHA@mail.gmail.com> <alpine.DEB.2.21.1811122236240.18130@digraph.polyomino.org.uk> <CAKOZueuM=3pxuXaJU4v571daWFCTJ1LYO-ApD6MrD7313RNYfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuM=3pxuXaJU4v571daWFCTJ1LYO-ApD6MrD7313RNYfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, Zack Weinberg <zackw@panix.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, 12 Nov 2018, Daniel Colascione wrote:

> I initially wanted to put the APIs in libc. I still do. But that's
> proving to be impractical, for the reasons we're discussing on this
> thread.

Well, your proposed APIs didn't attract consensus among libc developers.

> > (I can imagine *other* parts of the toolchain being involved, if e.g. you
> > want to have a good way of checking "is the address of the instruction
> > causing this signal in this library?" that works with static as well as
> > dynamic linking - for dynamic linking, I expect something could be done
> > using libc_nonshared and __dso_handle to identify code in the library
> > calling some registering function.  And indeed there might also be new
> > kernel interfaces that help improve signal handling.)
> 
> Again: you're blocking a practical solution for the sake of some
> elegant theoretical implementation that will never arrive, and so the

I'm not - I'm observing various areas that might be open to improvements 
related to signal handling, not saying improvements in one area are a 
prerequisite to improvements in another.  I'm exploring the problem and 
solution space, and collectively exploring the problem and solution space 
is an important part of trying to work out where there might be useful 
future improvements related to the general issue of signal handling.

Exploring the problem and solution space can include coming to the 
conclusion that an idea that seems obvious is in fact a bad idea, or in 
fact orthogonal to other ideas that are independently useful - those 
things are still useful in yielding a better rationale for taking a given 
approach.

> > In the absence of consensus for adding such a new API for signals to
> > glibc, it's unlikely one would get consensus for glibc to depend on some
> > other library providing such an API either.
> 
> glibc would continue using an unsupported legacy system call
> interfaces in lieu of a supported low-level interface library?

The Linux kernel supports the interfaces that people actually use, on the 
principle of not breaking userspace, not the interfaces that someone would 
like to declare to be the supported ones.  We'd use the interfaces that 
seem suitable for use by glibc, and direct syscalls seem more suitable to 
me than any kernel-provided userspace library.

Naturally a library invented in the kernel on the basis of not liking what 
libc people are doing or not doing is unlikely to be suitable for use by 
libc (and use together with libc of anything in it that interferes with 
libc functionality such as sigaction might be explicitly discouraged by 
libc maintainers, just as e.g. direct use of clone can be discouraged) - 
whereas interfaces developed collaboratively with libc implementations and 
getting consensus from those users are more likely to be of use to libc 
implementations.

-- 
Joseph S. Myers
joseph@codesourcery.com
