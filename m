From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 22:51:03 +0000
Message-ID: <alpine.DEB.2.21.1811122236240.18130@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com> <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
 <87lg5ym7qi.fsf@oldenburg.str.redhat.com> <CAKOZues2bQo1y_1ynxFMHGTvtTjABsqVpKJt5MYMdZBq6-ikHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZues2bQo1y_1ynxFMHGTvtTjABsqVpKJt5MYMdZBq6-ikHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, Zack Weinberg <zackw@panix.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, 12 Nov 2018, Daniel Colascione wrote:

> The two features *are* unrelated. The design I've proposed works
> equally well for synchronous and asynchronous signals, and limiting it

Whatever the design, I see no obvious reason why a kernel-provided 
library, with all the problems that entails, should need to be involved, 
rather than putting new APIs either in libc or in a completely separate 
libsignal for libraries wanting to use such a system for cooperative 
signal use.

(I can imagine *other* parts of the toolchain being involved, if e.g. you 
want to have a good way of checking "is the address of the instruction 
causing this signal in this library?" that works with static as well as 
dynamic linking - for dynamic linking, I expect something could be done 
using libc_nonshared and __dso_handle to identify code in the library 
calling some registering function.  And indeed there might also be new 
kernel interfaces that help improve signal handling.)

In the absence of consensus for adding such a new API for signals to 
glibc, it's unlikely one would get consensus for glibc to depend on some 
other library providing such an API either.  But you can always write a 
library (which I think would most naturally be a completely separate 
libsignal, not part of the kernel source tree) and seek to persuade 
libraries they should be using it rather than interfering with global 
state by registering normal signal handlers directly.

-- 
Joseph S. Myers
joseph@codesourcery.com
