From: Richard Weinberger <richard@nod.at>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Fri, 14 Dec 2018 16:17:59 +0100
Message-ID: <3143388.E8mgBzaflP@blindfold>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com> <CAFLxGvy2sMW1nyMpxGN7xHPdUea713g89MdE3EcUNHJDCvZ3jA@mail.gmail.com> <d54d7ea7c558474583dfed0d26f05ccd@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d54d7ea7c558474583dfed0d26f05ccd@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: 'Richard Weinberger' <richard.weinberger@gmail.com>, "kevin@guarana.org" <kevin@guarana.org>, "glaubitz@physik.fu-berlin.de" <glaubitz@physik.fu-berlin.de>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, "fweimer@redhat.com" <fweimer@redhat.com>, Mike Frysinger <vapier@gentoo.org>, "H.J. Lu" <hjl.tools@gmail.com>, "dalias@libc.org" <dalias@libc.org>, "x32@buildd.debian.org" <x32@buildd.debian.org>, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@li>
List-Id: linux-api@vger.kernel.org

Am Freitag, 14. Dezember 2018, 15:38:53 CET schrieb David Laight:
> From: Richard Weinberger
> > Sent: 13 December 2018 09:05
> > On Thu, Dec 13, 2018 at 6:03 AM Kevin Easton <kevin@guarana.org> wrote:
> > >
> > > On Tue, Dec 11, 2018 at 11:29:14AM +0100, John Paul Adrian Glaubitz wrote:
> > > ...
> > > > I can't say anything about the syscall interface. However, what I do know
> > > > is that the weird combination of a 32-bit userland with a 64-bit kernel
> > > > interface is sometimes causing issues. For example, application code usually
> > > > expects things like time_t to be 32-bit on a 32-bit system. However, this
> > > > isn't the case for x32 which is why code fails to build.
> > >
> > > OpenBSD and NetBSD both have 64-bit time_t on 32-bit systems and have
> > > had for four or five years at this point.
> > 
> > They can also do flag-day changes and break existing applications, Linux not.
> 
> Not true at all.
> The binary compatibility in NetBSD is probably better than that in Linux
> and goes back a long way.
> 
> For the time_t changes new system calls numbers were assigned where needed.
> The system headers and libc were updated so that recompiled code would
> use the new system calls.
> 
> The only real advantage that NetBSD has is that its libc (and standard
> utilities) are released with the kernel making it much easier to get
> applications to use the new features.
> 
> This was also done a very long time ago when file offsets were extended
> to 64 bits.
> 
> Some of the system calls have quite a few 'compatibility' versions.
> As well as the ones for emulations of other operating systems.
> It has been possible to run copies of firefox compiled for Linux
> under NetBSD.

I stand corrected, I was under the impression that NetBSD went the same
path as OpenBSD did. Thanks for pointing this out.

Thanks,
//richard
