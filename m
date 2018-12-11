From: Rich Felker <dalias@libc.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 18:38:05 -0500
Message-ID: <20181211233805.GO23599@brightrain.aerifal.cx>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com>
 <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
 <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: tg@mirbsd.de, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 11, 2018 at 03:22:43PM -0800, Andy Lutomirski wrote:
> On Tue, Dec 11, 2018 at 2:14 PM Thorsten Glaser <tg@mirbsd.de> wrote:
> > I was also considering investing a nontrivial amount of
> > work into porting klibc to x32, since hpa does not wish
> > to do it himself. Thankfully I have only done a bit yet.
> >
> > Furthermore, x32 was the first of the many *64ilp32
> > architectures; I know I’ve seen amd64ilp32 and at least
> > one other I don’t recall. It will have prototyped many
> > of the problems users of these will run in, and I’d prefer
> > to keep it (completely selfish because I don’t wish to
> > have to crossgrade a whole system yet again).
> 
> it kind of seems like arm64's lesson is "don't do it like x32".
> 
> There's some effort going on right now to make it possible to add
> syscalls without having to muck with every single architecture.  I
> don't really want x32 to derail that effort.  I suppose we could say
> that x32 stays but that it simply gets no new syscalls, but that seems
> a bit lame.  Unfortunately, on x86, x32 really is a third ABI that is
> not compatible in a structure-memory-layout sense with the other two.
> What happens if someone adds a struct like:
> 
> struct nasty_on_x32 {
>   __kernel_long_t a;
>   void * __user b;
> };
> 
> On x86_64, that's two 8-byte fields.  On x86_32, it's two four-byte
> fields.  On x32, it's an 8-byte field and a 4-byte field.  Now what?
> 
> I'm sure we could have some magic gcc plugin or other nifty tool that gives us:
> 
> copy_from_user(struct struct_name, kernel_ptr, user_ptr);
> 
> where it automatically generates code for all possible ABIs to copy
> over the struct and dispatches dynamically based on the current
> syscall ABI, but I have trouble imagining anyone volunteering to
> actually do this work.  Instead we get ad hoc fixes for each syscall,
> along the lines of preadv64v2(), which get done when somebody notices
> a problem.

For what it's worth, this is exactly what I plan to do if/when I ever
get to doing my kernel with multiple/universal userspace ABI support:
pure-data markup for the data structures (and syscall argument
arrangements) userspace is speaking, with generic marshalling code.
But I don't think it's easy to retrofit to Linux, and probably
wouldn't be welcome there.

Rich
