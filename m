From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 17:50:14 -0800
Message-ID: <CAK8P3a38zcMikOiaHXrKbc3URL6-6kETk=1F-Bx7LywPyRh=yg@mail.gmail.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97327-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20181115153008.GC2171@altlinux.org>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 15, 2018 at 7:30 AM Dmitry V. Levin <ldv@altlinux.org> wrote:
> On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
> > On Thu, Nov 15, 2018 at 6:05 AM Dmitry V. Levin wrote:
> > > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
>
> 1. strace needs a race-free invocation of wait4(2) or waitid(2)
> with a different signal mask, this cannot be achieved without
> an extended version of syscall, similar to pselect6(2) extension
> over select(2) and ppoll(2) extension over poll(2).
>
> Signal mask specification in linux requires two parameters:
> "const sigset_t *sigmask" and "size_t sigsetsize".
> Creating pwait6(2) as an extension of wait4(2) with two arguments
> is straightforward.
> Creating pwaitid(2) as an extension of waitid(2) that already has 5
> arguments would require an indirection similar to pselect6(2).

Getting back to this point: you could also do the same thing with
the CLONE_FD approach from Josh Triplett[1] or Casey Dahlin's
older waitfd() syscall, correct?

Neither of them got merged, bu t we could revisit the ideas if they
make it easier to solve your problem by calling ppoll().

        Arnd

[1] https://lwn.net/Articles/638613/
[2] https://lore.kernel.org/lkml/49639EB8.40204@redhat.com/
