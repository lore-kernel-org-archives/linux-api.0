From: Kevin Easton <kevin@guarana.org>
Subject: Re: Can we drop upstream Linux x32 support?
Date: Thu, 13 Dec 2018 12:12:13 +0000
Message-ID: <20181213121213.GA28833@ip-172-31-15-78>
References: <CALCETrXoRAibsbWa9nfbDrt0iEuebMnCMhSFg-d9W-J2g8mDjw@mail.gmail.com>
 <70bb54b2-8ed3-b5ee-c02d-6ef66c4f27eb@physik.fu-berlin.de>
 <20181213050313.GA21201@ip-172-31-15-78>
 <CAFLxGvy2sMW1nyMpxGN7xHPdUea713g89MdE3EcUNHJDCvZ3jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvy2sMW1nyMpxGN7xHPdUea713g89MdE3EcUNHJDCvZ3jA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: glaubitz@physik.fu-berlin.de, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, fweimer@redhat.com, Mike Frysinger <vapier@gentoo.org>, "H.J. Lu" <hjl.tools@gmail.com>, dalias@libc.org, x32@buildd.debian.org, Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 13, 2018 at 10:05:14AM +0100, Richard Weinberger wrote:
> On Thu, Dec 13, 2018 at 6:03 AM Kevin Easton <kevin@guarana.org> wrote:
> >
> > On Tue, Dec 11, 2018 at 11:29:14AM +0100, John Paul Adrian Glaubitz wrote:
> > ...
> > > I can't say anything about the syscall interface. However, what I do know
> > > is that the weird combination of a 32-bit userland with a 64-bit kernel
> > > interface is sometimes causing issues. For example, application code usually
> > > expects things like time_t to be 32-bit on a 32-bit system. However, this
> > > isn't the case for x32 which is why code fails to build.
> >
> > OpenBSD and NetBSD both have 64-bit time_t on 32-bit systems and have
> > had for four or five years at this point.
> 
> They can also do flag-day changes and break existing applications, Linux not.

Sure, but the point is that most widely-used software has probably by
now come in to contact with systems where time_t is bigger than long.

    - Kevin
