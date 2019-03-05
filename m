From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Tue, 5 Mar 2019 19:18:08 +0100
Message-ID: <20190305181808.GH8256@zn.tnic>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic>
 <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop>
 <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic>
 <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190305181138.GG8256@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha@vger.kernel.org, linux-m68k@lists.linux-m68k.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 05, 2019 at 07:11:38PM +0100, Borislav Petkov wrote:
> I guess you could Cc arch maintainers with the a.out-core.h removal
> patch to see if anyone screams.

And they're like two for which we need confirmation:

$ git ls-files | grep a.out-core.h
arch/alpha/include/asm/a.out-core.h
arch/m68k/include/asm/a.out-core.h
arch/um/include/asm/a.out-core.h
arch/x86/include/asm/a.out-core.h

um and x86 are clear.

Adding alpha and m68k MLs to Cc.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
