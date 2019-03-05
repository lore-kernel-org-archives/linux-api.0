From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Tue, 5 Mar 2019 09:58:28 -0800
Message-ID: <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com> <20190305173134.GE8256@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305173134.GE8256@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 5, 2019 at 9:31 AM Borislav Petkov <bp@alien8.de> wrote:
>
> So how do you wanna handle this?
>
> I guess the easiest would be if you apply your patch directly now and
> add the a.out phase-out strategy we're going for in its commit message
> so that people are aware of what we're doing.

Yup, I'll just do that. I'll fix up my patch to be more complete (ie
the a.out-core.h removal Jann pointed out).

I'll talk about removing a.out support entirely in the commit message.
I'd be ok for that to be a total removal, but maybe there are some
architectures that still have that as a "main" format?

Or I could just apply your patch after removing the core-dumping. Comments?

               Linus
