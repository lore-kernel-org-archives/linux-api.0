From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 12:42:40 +0000
Message-ID: <20181116124238.GT3505@e103592.cambridge.arm.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org>
 <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97308-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20181115153008.GC2171@altlinux.org>
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 15, 2018 at 06:30:11PM +0300, Dmitry V. Levin wrote:
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
> 
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
> 
> 2. The time precision provided by struct rusage returned by wait4(2) and
> waitid(2) is too low for syscall time counting (strace -c) nowadays, this
> can be observing by running in a row a simple command like "strace -c pwd".
> 
> The fix is to return a more appropriate structure than struct rusage
> by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
> struct timeval is replaced with struct timespec or even struct timespec64.

I didn't attend LPC so apologies if I'm missing some background here,
but:

The traditional way would be install a handler for SIGCHLD and
do a sigsuspend()/pselect()/ppoll().  Then when the suspend() returns,
you pump the status of any children with wait*(..., WNOHANG).

Does that not work for you for some reason?

Adding more and more "wait for some stuff" syscalls for every possible
definition of "some stuff" is a slippery slope... IMHO we have way too
many of those already.


One way to improve struct rusage would be to add a new wait flag (say,
WFANCY_RUSAGE) to the existing wait calls to indicate use of a different
struct in place of struct rusage.  It's not clear to me why a brand new
syscall is essential, though obviously that's an option.

Cheers
---Dave
