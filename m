From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 07:17:01 -0800
Message-ID: <CAK8P3a2kDbzzdHdPNaU9LBdLbdFejLYzx+Ntt4s5F=7u+scHsg@mail.gmail.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org> <68E78315-66C9-4CEE-B6A0-61485AFB314A@zytor.com>
 <CAK8P3a2bGYt1Z50eQsBv2pu_zd649SB1MjX-iWcZ-YnJ+Bhj1Q@mail.gmail.com> <87sh01uxlh.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97315-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87sh01uxlh.fsf@oldenburg.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 16, 2018 at 2:27 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Arnd Bergmann:
>
> > On Thu, Nov 15, 2018 at 7:38 AM <hpa@zytor.com> wrote:
> >> On November 15, 2018 7:30:11 AM PST, "Dmitry V. Levin" <ldv@altlinux.org> wrote:
> >> >On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
> >> >> On Thu, Nov 15, 2018 at 6:05 AM Dmitry V. Levin wrote:
> >> >> > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
> >
> >> >2. The time precision provided by struct rusage returned by wait4(2)
> >> >and waitid(2) is too low for syscall time counting (strace -c) nowadays,
> >> >this can be observing by running in a row a simple command like "strace -c
> >> >pwd".
> >> >
> >> >The fix is to return a more appropriate structure than struct rusage
> >> >by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
> >> >struct timeval is replaced with struct timespec or even struct
> >> >timespec64.
> >>
> >> Arnd: w.r.t. our previous discussion, this would seem to justify going to timespec(64) for these kind of cases.
> >
> > Ok, and I assume we want the same layout for getrusage(2) then, right?
>
> Or introduce something that covers FreeBSD's wait6 functionality as well
> (resource usage by subprocesses of the subprocess).

Ok, so combining that with the request for a signal mask, we'd want
something like

int wait9(idtype_t idtype, id_t id, siginfo_t *infop, int options,
       /* waitid subset */
           int *status, struct rusage64 *self, struct rusage64
*children,  /* wait4, wait6, time64 */
           const sigset_t *sigmask, size_t sigsetsize);
       /* suggested by Dmitry */

which I think could over all use cases mentioned in this thread, but
already has nine arguments instead of the allowed six, so it can't
be the signature of the system call entry.

We can get that down to six arguments in the familiar ways:
- like Linux waitid, wait4-style status can be computed from infop
- like wait6, self and children can be in one pointer
- like io_pgetevents, sigmask and sigsetsize can be an indirect struct

int waitid6(idtype_t idtype, id_t id, siginfo_t *infop, int options,
          struct __wrusage64 *wrusage, struct __wait_sigset *sigset);

Alternatively, we could combine even more arguments into a single
structure if inputs, in various ways.

        Arnd
