From: hpa@zytor.com
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Thu, 15 Nov 2018 07:37:58 -0800
Message-ID: <68E78315-66C9-4CEE-B6A0-61485AFB314A@zytor.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr> <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com> <20181115153008.GC2171@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-97262-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20181115153008.GC2171@altlinux.org>
To: "Dmitry V. Levin" <ldv@altlinux.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On November 15, 2018 7:30:11 AM PST, "Dmitry V=2E Levin" <ldv@altlinux=2Eor=
g> wrote:
>On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
>> On Thu, Nov 15, 2018 at 6:05 AM Dmitry V=2E Levin wrote:
>> > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
>[=2E=2E=2E]
>> > > https://sourceware=2Eorg/glibc/wiki/Y2038ProofnessDesign?rev=3D146
>> > Is there any rationale for marking wait4 as an obsolete API?
>>=20
>> In the *kernel* syscall API, wait4(2) is obsoleted by waitid(2),
>which is
>> a strict superset of its functionality=2E
>>=20
>> In the libc API, this is different, as wait4() does not have a
>replacement
>> that is exposed to user space directly=2E I expect glibc to implement
>> wait4() on top of the kernel's waitid()=2E
>>=20
>> There has not been a final decision on which variant of waitid() that
>would
>> be=2E The easiest option would be to not change it at all: new
>architectures
>> (rv32, csky, nanomips/p32, =2E=2E=2E) would keep exposing the tradition=
al
>> waitid() in Linux, with its 32-bit time_t based rusage structure, but
>drop the
>> wait4()=2E glibc then has to convert between the kernel's rusage and
>the
>> user space rusage indefinitely=2E
>>=20
>> Alternatively, we can create a new version like waitid2() that uses
>> 64-bit time_t in some form, either the exact same rusage that we
>> use on 64-bit architectures and x32, or using a new set of arguments
>> to include further improvements=2E
>
>In strace, we have two use cases that require an extended version
>of wait4(2) or waitid(2) syscall=2E  From your response I understand that
>you'd recommend extending waitid(2) rather than wait4(2), is it
>correct?
>
>These two use cases were mentioned in my talk yesterday at LPC 2018,
>here is a brief summary=2E
>
>1=2E strace needs a race-free invocation of wait4(2) or waitid(2)
>with a different signal mask, this cannot be achieved without
>an extended version of syscall, similar to pselect6(2) extension
>over select(2) and ppoll(2) extension over poll(2)=2E
>
>Signal mask specification in linux requires two parameters:
>"const sigset_t *sigmask" and "size_t sigsetsize"=2E
>Creating pwait6(2) as an extension of wait4(2) with two arguments
>is straightforward=2E
>Creating pwaitid(2) as an extension of waitid(2) that already has 5
>arguments would require an indirection similar to pselect6(2)=2E
>
>2=2E The time precision provided by struct rusage returned by wait4(2)
>and
>waitid(2) is too low for syscall time counting (strace -c) nowadays,
>this
>can be observing by running in a row a simple command like "strace -c
>pwd"=2E
>
>The fix is to return a more appropriate structure than struct rusage
>by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
>struct timeval is replaced with struct timespec or even struct
>timespec64=2E

Arnd: w=2Er=2Et=2E our previous discussion, this would seem to justify goi=
ng to timespec(64) for these kind of cases=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
