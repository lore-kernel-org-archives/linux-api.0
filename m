From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Tue, 5 Mar 2019 18:31:34 +0100
Message-ID: <20190305173134.GE8256@zn.tnic>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic>
 <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop>
 <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 05, 2019 at 08:22:21AM -0800, Linus Torvalds wrote:
> Because I think all the known *bugs* we had were with the core dumping
> code, weren't they?

Well, I'm aware of only this one I fixed but who knows what else has
bitrotten out there through the years...

> Removing it looks trivial. Untested patch attached.
> 
> Then I'd be much happier with your "let's deprecate a.out entirely" as
> a second patch, because I think it's a unrelated issue and much more
> likely to have somebody pipe up and say "hey, I have this sequence
> that generates executables dynamically, and I use a.out because it's
> much simpler than ELF, and now it's broken". Or something.

Hohumm, yap, it all makes sense to me. That's definitely the safer
approach without us having to revert patches later.

So how do you wanna handle this?

I guess the easiest would be if you apply your patch directly now and
add the a.out phase-out strategy we're going for in its commit message
so that people are aware of what we're doing.

This will allow for other arch maintainers to delete
arch/*/include/asm/a.out-core.h, Jann mentions in the other mail, after
-rc1 is cut.

And then I'll carry any other patches through the tip tree ontop of -rc1
too.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
