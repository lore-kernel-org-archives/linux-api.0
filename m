From: Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Sun, 10 Mar 2019 14:37:00 -0700
Message-ID: <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic> <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic> <20190305181808.GH8256@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305181808.GH8256@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 5, 2019 at 11:04 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Mar 05, 2019 at 07:11:38PM +0100, Borislav Petkov wrote:
> > I guess you could Cc arch maintainers with the a.out-core.h removal
> > patch to see if anyone screams.
>
> And they're like two for which we need confirmation:
>
> $ git ls-files | grep a.out-core.h
> arch/alpha/include/asm/a.out-core.h
> arch/m68k/include/asm/a.out-core.h
> arch/um/include/asm/a.out-core.h
> arch/x86/include/asm/a.out-core.h
>
> um and x86 are clear.
>
> Adding alpha and m68k MLs to Cc.

I'm not aware of a reason to keep a.out support on alpha.
