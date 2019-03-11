From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Mon, 11 Mar 2019 12:02:33 +0100
Message-ID: <CAK8P3a2cc0QoG8=y343vXaVQHHayJKT_hSLRDPx-awRdB1MutA@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic> <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic> <20190305181808.GH8256@zn.tnic>
 <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com> <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 10, 2019 at 11:46 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Mar 10, 2019 at 2:37 PM Matt Turner <mattst88@gmail.com> wrote:
> >
> > I'm not aware of a reason to keep a.out support on alpha.
>
> Hmm. I was looking at removing a.out support entirely, but it's
> actually fairly incestuous on alpha.
>
> For example, arch/alpha/boot/tools/objstrip.c very much has some a.out
> support in it. Maybe it can just be removed entirely.
>
> There's also an a.out.h include in arch/alpha/kernel/binfmt_loader.c.
>
> Finally, note that CONFIG_OSF4_COMPAT also no longer makes sense
> without a.out support.
>
> So this attached patch does not compile on alpha, but it's been many
> many years since I had an alpha to test with, so I'm stuck.
>
> Matt, can you fill in the details and complete this patch?

I wonder if we could remove the osf time32 compat code as well,
this was one of the areas that kept causing problems with the y2038
rework. (I think it's all good now, but it's never been tested as far as I
can tell).

For some syscalls (e.g. brk, mmap, getxuid, ...) we definitely need to
keep the osf1 version, since it is the only supported ABI.

I just looked up some really old source trees and found that glibc-2.1
was the first release to use 64-bit time_t the way we do it today,
as implemented in [1], so all Debian and SuSE releases for alpha
had it, but any ELF binaries built on Red Hat Linux 4.x and 5.x
(released 1996 through 1998) or earlier would use 32-bit time_t
osf1 syscalls. Red Hat 2.x and 3.x were a.out based on alpha.

      Arnd

[1] https://repo.or.cz/glibc/history.git/commitdiff/64819b5c3a94e81e4
