From: Christian Brauner <christian@brauner.io>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Wed, 28 Nov 2018 22:36:49 +1300
Message-ID: <67B157B9-80B0-4862-87F4-F03DECBD58CC@brauner.io>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr> <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com> <20181115153008.GC2171@altlinux.org> <CAK8P3a38zcMikOiaHXrKbc3URL6-6kETk=1F-Bx7LywPyRh=yg@mail.gmail.com> <87d0qrooj3.fsf@oldenburg.str.redhat.com> <CAK8P3a3pVS3_70PQ+SeiSZtqXFcb5HON0QGRypWfu=cfLPgN=w@mail.gmail.com> <87r2f5h7kk.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-97620-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87r2f5h7kk.fsf@oldenburg.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On November 28, 2018 10:31:23 PM GMT+13:00, Florian Weimer <fweimer@redhat=
=2Ecom> wrote:
>* Arnd Bergmann:
>
>> On Mon, Nov 26, 2018 at 4:18 PM Florian Weimer <fweimer@redhat=2Ecom>
>wrote:
>>>
>>> * Arnd Bergmann:
>>>
>>> > On Thu, Nov 15, 2018 at 7:30 AM Dmitry V=2E Levin <ldv@altlinux=2Eor=
g>
>wrote:
>>> >> On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
>>> >> > On Thu, Nov 15, 2018 at 6:05 AM Dmitry V=2E Levin wrote:
>>> >> > > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD
>wrote:
>>> >>
>>> >> 1=2E strace needs a race-free invocation of wait4(2) or waitid(2)
>>> >> with a different signal mask, this cannot be achieved without
>>> >> an extended version of syscall, similar to pselect6(2) extension
>>> >> over select(2) and ppoll(2) extension over poll(2)=2E
>>> >>
>>> >> Signal mask specification in linux requires two parameters:
>>> >> "const sigset_t *sigmask" and "size_t sigsetsize"=2E
>>> >> Creating pwait6(2) as an extension of wait4(2) with two arguments
>>> >> is straightforward=2E
>>> >> Creating pwaitid(2) as an extension of waitid(2) that already has
>5
>>> >> arguments would require an indirection similar to pselect6(2)=2E
>>> >
>>> > Getting back to this point: you could also do the same thing with
>>> > the CLONE_FD approach from Josh Triplett[1] or Casey Dahlin's
>>> > older waitfd() syscall, correct?
>>>
>>> A descriptor-based solution would not be useful to glibc because
>>> applications assume that glibc does not (persistently) open any file
>>> descriptors behind t heir back=2E
>>
>> Right, makes sense=2E What about a temporary file descriptor as
>discussed
>> in the recent procfd() mail thread then? Would that work?

The intention has always been to start a
file descriptor process API off of that=2E
If we land my procfd_signal() patchset we are in good shape for procfd_wai=
t(), imho=2E

>>
>> /* for illustration, needs error handling and more features */
>> int pwait(pid_t id, siginfo_t *infop)
>> {
>>       char waitfd_file[MAX_PROCFD_LEN];
>>       struct pollfd pfd[1] =3D { {=2Eevents =3D POLLIN }};
>>
>>       snprintf(waitfd_file, MAX_PROCFD_LEN, "/proc/%d/wait", pid);
>>       pfd=2Efd =3D open(waitfd_file,  O_RDONLY);
>>       ppoll(&pfd, 1, NULL, sigmask);
>>       read(fd, infop, sizeof(*infop));
>>       close(fd);
>>
>>      return 0;
>> }
>
>Together with an officiall supported way that allows us that the
>process
>denoted by the PID is still the same that it was, it could work, I
>think=2E
>
>It would also nice to have the ability to launch processes without
>making them visible to wait, and trigger SIGCHLD signals, but noticing
>process exit seems like a tricky matter under these circumstances=2E
>
>Thanks,
>Florian
