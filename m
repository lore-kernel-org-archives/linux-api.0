From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Thu, 15 Nov 2018 23:12:36 -0800
Message-ID: <CAK8P3a2a4F18e-Vqdb-iSmDzLQthaqU-ahC9H5wj1R1WFqA9jg@mail.gmail.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97299-glibc-alpha=m.gmane.org@sourceware.org>
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
>
> On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
> > On Thu, Nov 15, 2018 at 6:05 AM Dmitry V. Levin wrote:
> > > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
> [...]
> > > > https://sourceware.org/glibc/wiki/Y2038ProofnessDesign?rev=146
> > > Is there any rationale for marking wait4 as an obsolete API?
> >
> > In the *kernel* syscall API, wait4(2) is obsoleted by waitid(2), which is
> > a strict superset of its functionality.
> >
> > In the libc API, this is different, as wait4() does not have a replacement
> > that is exposed to user space directly. I expect glibc to implement
> > wait4() on top of the kernel's waitid().
> >
> > There has not been a final decision on which variant of waitid() that would
> > be. The easiest option would be to not change it at all: new architectures
> > (rv32, csky, nanomips/p32, ...) would keep exposing the traditional
> > waitid() in Linux, with its 32-bit time_t based rusage structure, but drop the
> > wait4(). glibc then has to convert between the kernel's rusage and the
> > user space rusage indefinitely.
> >
> > Alternatively, we can create a new version like waitid2() that uses
> > 64-bit time_t in some form, either the exact same rusage that we
> > use on 64-bit architectures and x32, or using a new set of arguments
> > to include further improvements.
>
> In strace, we have two use cases that require an extended version
> of wait4(2) or waitid(2) syscall.  From your response I understand that
> you'd recommend extending waitid(2) rather than wait4(2), is it correct?

Correct. It's already a superset, so a new waitid2(2) or wait5(2) should be
an extension of waitid(2) in order to provide backwards compatibility to the
other ones (along with wait() and waitpid()).

> These two use cases were mentioned in my talk yesterday at LPC 2018,
> here is a brief summary.
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

Right, that indirection is not ideal, but I suspect it's better
than the alternatives.

> 2. The time precision provided by struct rusage returned by wait4(2) and
> waitid(2) is too low for syscall time counting (strace -c) nowadays, this
> can be observing by running in a row a simple command like "strace -c pwd".
>
> The fix is to return a more appropriate structure than struct rusage
> by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
> struct timeval is replaced with struct timespec or even struct timespec64.

It definitely has to be a 64-bit based structure, the question is which one.
My preferred solution would be to interpret the timestamps as 'struct
__kernel_timespec', which has a 64-bit seconds and 64-bit nanoseconds.
I'd also use a structure that is the same between 32-bit and 64-bit
kernels here, using '__s64' members instead of '__kernel_long_t' or 'long'
for the rest. It is then up to the C library to convert it into whichever
structure they want to expose to user space for the normal wait4().

        Arnd
