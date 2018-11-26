From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Mon, 26 Nov 2018 18:15:12 +0100
Message-ID: <CAK8P3a3pVS3_70PQ+SeiSZtqXFcb5HON0QGRypWfu=cfLPgN=w@mail.gmail.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org> <CAK8P3a38zcMikOiaHXrKbc3URL6-6kETk=1F-Bx7LywPyRh=yg@mail.gmail.com>
 <87d0qrooj3.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97554-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87d0qrooj3.fsf@oldenburg.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 26, 2018 at 4:18 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Arnd Bergmann:
>
> > On Thu, Nov 15, 2018 at 7:30 AM Dmitry V. Levin <ldv@altlinux.org> wrote:
> >> On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
> >> > On Thu, Nov 15, 2018 at 6:05 AM Dmitry V. Levin wrote:
> >> > > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
> >>
> >> 1. strace needs a race-free invocation of wait4(2) or waitid(2)
> >> with a different signal mask, this cannot be achieved without
> >> an extended version of syscall, similar to pselect6(2) extension
> >> over select(2) and ppoll(2) extension over poll(2).
> >>
> >> Signal mask specification in linux requires two parameters:
> >> "const sigset_t *sigmask" and "size_t sigsetsize".
> >> Creating pwait6(2) as an extension of wait4(2) with two arguments
> >> is straightforward.
> >> Creating pwaitid(2) as an extension of waitid(2) that already has 5
> >> arguments would require an indirection similar to pselect6(2).
> >
> > Getting back to this point: you could also do the same thing with
> > the CLONE_FD approach from Josh Triplett[1] or Casey Dahlin's
> > older waitfd() syscall, correct?
>
> A descriptor-based solution would not be useful to glibc because
> applications assume that glibc does not (persistently) open any file
> descriptors behind t heir back.

Right, makes sense. What about a temporary file descriptor as discussed
in the recent procfd() mail thread then? Would that work?

/* for illustration, needs error handling and more features */
int pwait(pid_t id, siginfo_t *infop)
{
      char waitfd_file[MAX_PROCFD_LEN];
      struct pollfd pfd[1] = { {.events = POLLIN }};

      snprintf(waitfd_file, MAX_PROCFD_LEN, "/proc/%d/wait", pid);
      pfd.fd = open(waitfd_file,  O_RDONLY);
      ppoll(&pfd, 1, NULL, sigmask);
      read(fd, infop, sizeof(*infop));
      close(fd);

     return 0;
}

       Arnd
