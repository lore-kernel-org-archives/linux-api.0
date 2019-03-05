From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Tue, 5 Mar 2019 17:30:13 +0100
Message-ID: <CAG48ez0=AWipDy+aDBtxwEs6h8AmiBnfoU7GMi=_yW3sS14MNQ@mail.gmail.com>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
 <20190305091904.GB8256@zn.tnic> <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop> <20190305145717.GD8256@zn.tnic> <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 5, 2019 at 5:22 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 5, 2019 at 6:59 AM Borislav Petkov <bp@alien8.de> wrote:
> > We can at least deprecate it on x86...
>
> I'd prefer to try to deprecate a.out core dumping first.. That's the
> part that is actually broken, no?
>
> In fact, I'd be happy to deprecate a.out entirely, but if somebody
> _does_ complain, I'd like to be able to bring it back without the core
> dumping.
>
> Because I think the likeliihood that anybody cares about a.out core
> dumps is basically zero. While the likelihood that we have some odd
> old binary that is still a.out is slightly above zero.
>
> So I'd be much happier with this if it was a two-stage thing where we
> just delete a.out core dumping entirely first, and then deprecate even
> running a.out binaries separately.
>
> Because I think all the known *bugs* we had were with the core dumping
> code, weren't they?
>
> Removing it looks trivial. Untested patch attached.

We might want to also delete the then-unused aout_dump_thread()
implementations from the various arch trees. We probably want to
delete arch/*/include/asm/a.out-core.h, since that seems to be the
only thing these headers do, and the only thing that uses them is
fs/binfmt_aout.c?
