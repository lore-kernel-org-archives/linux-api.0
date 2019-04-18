From: hpa@zytor.com
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Thu, 18 Apr 2019 07:46:39 -0700
Message-ID: <50A91072-AEEB-4A05-BF7C-41086B17A4F9@zytor.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com> <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org> <87imvker6t.fsf@oldenburg2.str.redhat.com> <db468a0f-4a7b-d251-601f-428885275d08@linaro.org> <87lg0fbr1q.fsf@oldenburg2.str.redhat.com> <A278227C-039B-49F4-B80D-650B785AE225@zytor.com> <bfe6744f-7326-0a06-e43c-9f88abce7032@linaro.org> <8f05dc10-02ea-327f-f984-98b91a0b195d@zytor.com> <4ae23f8e-c5e5-2d11-8508-82e5dd4c1e2b@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-101514-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <4ae23f8e-c5e5-2d11-8508-82e5dd4c1e2b@linaro.org>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>, Florian Weimer <fweimer@redhat.com>
Cc: libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On April 18, 2019 4:09:07 AM PDT, Adhemerval Zanella <adhemerval=2Ezanella@=
linaro=2Eorg> wrote:
>
>
>On 17/04/2019 19:04, H=2E Peter Anvin wrote:
>> On 4/15/19 10:22 AM, Adhemerval Zanella wrote:
>>>>
>>>> New interfaces are only necessary for the handful of architectures
>that don't have the speed fields *and* to space to put them in=2E=20
>>>
>>> Based on your WIP, it seems that both sparc and mips could be
>adapted=2E
>>> Do we still have glibc supported architecture that would require
>compat
>>> symbols?
>>>
>>>>
>>>> Using symbol versioning doesn't really help much since the real
>problem is that struct termios can be passed around in userspace, and
>the interfaces between user space libraries don't have any versioning=2E
>However, my POC code deals with that too by only seeing BOTHER when
>necessary, so if the structure is extended garbage in the extra fields
>will be ignored unless new baud rates are in use=2E
>>>
>>> Yeah, we discussed this earlier and if recall correctly it was not
>settled
>>> that all architectures would allow the use to extra space for the
>new
>>> fields=2E It seems the case, which makes the adaptation for termios2
>even easier=2E
>>>
>>> The question I have for kernel side is whether termios2 is fully
>compatible
>>> with termios, meaning that if there is conner cases we need to
>handle in
>>> userland=2E
>>>
>>=20
>> It depends on what you mean with "fully compatible=2E"
>>=20
>> Functionality-wise, the termios2 interfaces are a strict superset=2E
>There
>> is not, however, any guarantee that struct kernel_termios2 *contains*
>a
>> contiguous binary equivalent to struct kernel_termios (in fact, on
>most
>> architectures, it doesn't=2E)
>
>I mean that we can fully implement termios1 using termios2 by adjusting
>the termios struct in syscall wrappers=2E  If it is a superset I think it
>is fine=2E
>
>>=20
>>>>
>>>> My POC code deals with Alpha as well by falling back to the old
>interfaces if necessary and possible, otherwise return error=2E
>>>>
>>>> Exporting termios2 to user space feels a bit odd at this stage as
>it would only be usable as a fallback on old glibc=2E Call it
>kernel_termios2 at least=2E ioctls using struct termios *must* be changed
>to kernel_termios anyway!
>>>>
>>>
>>> I still prefer to avoid export it to userland and make it usable
>through
>>> default termios, as your wip does=2E  My understanding is new
>interfaces=20
>>> should be semantic equal to current one with the only deviation that
>>> non-standard baudrates will handled as its values=2E  The only issue I
>
>>> can foresee is if POSIX starts to export new bauds value=2E
>>>
>>=20
>> =2E=2E=2E which will be easy to handle: just define a Bxxxx constant wi=
th
>the
>> value equal to the baud rate=2E
>>=20
>> 	-hhpa
>
>Right=2E

termio, termios1 and termios2 are kernel ioctl interfaces =2E=2E=2E there =
are no wrappers; it is an ioctl=2E

The glibc termios is different from all of these, and already is a wrapper=
 around the kernel-provided ioctls=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
