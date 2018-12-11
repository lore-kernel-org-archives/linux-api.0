From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Tue, 11 Dec 2018 15:22:43 -0800
Message-ID: <CALCETrWgpAX7FV23zHmid83SsgnwFMKD4a_-xSEgB6v0kJR5sA@mail.gmail.com>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <CAHk-=wi_Kp=3XmGDdzmadzFSPFvuL+aAJ6ZPAR=o4z=KwYT2vw@mail.gmail.com> <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.BSM.4.64L.1812112150480.21176@herc.mirbsd.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tg@mirbsd.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Florian Weimer <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>, Rich Felker <dalias@libc.org>, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 11, 2018 at 2:14 PM Thorsten Glaser <tg@mirbsd.de> wrote:
>
> Note: please keep me in Cc because I am not subscribed.
>
> Linus Torvalds dixit:
>
> >I'm not opposed to trying to sunset the support, but let's see who compl=
ains..
>
> I will hereby complain.
>
> I=E2=80=99m using Debian/x32 on my main desktop at work, and do
> occasionally help out with porting issues. It=E2=80=99s a good
> way to make more out of 64-bit machines without going
> all 64 bit; it=E2=80=99s also helped me find bugs in software.
> It=E2=80=99s a nice architectural idea, and a way forward for
> things that are constricted to 32 bits while opening
> up stuff like 64-bit time_t without taking up half the
> available CPU registers (while more than doubling the
> number of the available CPU registers, too).

Thanks for responding!

I suppose the question is: are you enough of a user to justify the
continued maintenance effort.

>
> I was also considering investing a nontrivial amount of
> work into porting klibc to x32, since hpa does not wish
> to do it himself. Thankfully I have only done a bit yet.
>
> Furthermore, x32 was the first of the many *64ilp32
> architectures; I know I=E2=80=99ve seen amd64ilp32 and at least
> one other I don=E2=80=99t recall. It will have prototyped many
> of the problems users of these will run in, and I=E2=80=99d prefer
> to keep it (completely selfish because I don=E2=80=99t wish to
> have to crossgrade a whole system yet again).

it kind of seems like arm64's lesson is "don't do it like x32".

There's some effort going on right now to make it possible to add
syscalls without having to muck with every single architecture.  I
don't really want x32 to derail that effort.  I suppose we could say
that x32 stays but that it simply gets no new syscalls, but that seems
a bit lame.  Unfortunately, on x86, x32 really is a third ABI that is
not compatible in a structure-memory-layout sense with the other two.
What happens if someone adds a struct like:

struct nasty_on_x32 {
  __kernel_long_t a;
  void * __user b;
};

On x86_64, that's two 8-byte fields.  On x86_32, it's two four-byte
fields.  On x32, it's an 8-byte field and a 4-byte field.  Now what?

I'm sure we could have some magic gcc plugin or other nifty tool that gives=
 us:

copy_from_user(struct struct_name, kernel_ptr, user_ptr);

where it automatically generates code for all possible ABIs to copy
over the struct and dispatches dynamically based on the current
syscall ABI, but I have trouble imagining anyone volunteering to
actually do this work.  Instead we get ad hoc fixes for each syscall,
along the lines of preadv64v2(), which get done when somebody notices
a problem.

Linus, any advice here?

--Andy
