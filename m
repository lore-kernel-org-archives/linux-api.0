From: Daniel Colascione <dancol@google.com>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Wed, 28 Nov 2018 10:50:44 -0800
Message-ID: <CAKOZueuvs88BusE-MT4Eyc8xJjm5d3YZ=PUMJnKndfHmOeLpRg@mail.gmail.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org> <CAK8P3a38zcMikOiaHXrKbc3URL6-6kETk=1F-Bx7LywPyRh=yg@mail.gmail.com>
 <87d0qrooj3.fsf@oldenburg.str.redhat.com> <CAK8P3a3pVS3_70PQ+SeiSZtqXFcb5HON0QGRypWfu=cfLPgN=w@mail.gmail.com>
 <87r2f5h7kk.fsf@oldenburg.str.redhat.com> <67B157B9-80B0-4862-87F4-F03DECBD58CC@brauner.io>
 <87efb5h74j.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-97650-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87efb5h74j.fsf@oldenburg.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, GNU C Library <libc-alpha@sourceware.org>, Arnd Bergmann <arnd@arndb.de>, "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 28, 2018 at 1:41 AM, Florian Weimer <fweimer@redhat.com> wrote:
> * Christian Brauner:
>
>> The intention has always been to start a
>> file descriptor process API off of that.
>> If we land my procfd_signal() patchset we are in good shape for
>> procfd_wait(), imho.
>
> How does this interact with SIGCHLD and the wait system call (or any
> wait function without an explicitly specified PID)?

It doesn't, but let's take one step at a time. procfd_signal() is a
good first step. Once procfd_signal() and procfd_wait() exist, and
managing processes with FDs in general no longer seems odd, we can add
a clone() option that 1) avoid wiring a new subprocess up to the
legacy PID-based process-management API, and 2) returns one of these
fancy new FDs that works with procfd_signal and procfd_wait. (How we
do that without /proc mounted is an open question, but solvable in a
few options.)

> I understand that I have somewhat conflicting requirements, but in terms
> of relative priorities, launching a process without spurious signals and
> wait notifications would probably offer the larger benefit.

I also want a non-process-wide subprocess API. A clean FD-based API is
how you get it--- it's not an either-or situation. Considering that we
want to use FDs for general-purpose process management in the future,
it'd be not only a waste of time, but actually counterproductive, to
design a non-FD-based API for this non-process-wide sub-process use
case.
