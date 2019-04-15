From: hpa@zytor.com
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Mon, 15 Apr 2019 08:53:02 -0700
Message-ID: <A278227C-039B-49F4-B80D-650B785AE225@zytor.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com> <284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org> <87imvker6t.fsf@oldenburg2.str.redhat.com> <db468a0f-4a7b-d251-601f-428885275d08@linaro.org> <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-101392-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>, Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On April 12, 2019 12:50:41 AM PDT, Florian Weimer <fweimer@redhat=2Ecom> wr=
ote:
>* Adhemerval Zanella:
>
>> On 11/04/2019 08:07, Florian Weimer wrote:
>>> * Adhemerval Zanella:
>>>=20
>>>> This allows us to adjust the baud rates to non-standard values
>using termios
>>>> interfaces without to resorting to add new headers and use a
>different API
>>>> (ioctl)=2E
>>>=20
>>> How much symbol versioning will be required for this change?
>>
>> I think all interfaces that have termios as input for sparc and mips=20
>> (tcgetattr, tcsetattr, cfmakeraw, cfgetispeed, cfgetospeed,
>cfsetispeed,
>> cfsetospeed, cfsetspeed)=2E
>>
>> Alpha will also need to use termios1 for pre-4=2E20 kernels=2E
>
>So only new symbol versions there?  Hmm=2E
>
>>>> As Peter Anvin has indicated, he create a POC [1] with the
>aforementioned
>>>> new interfaces=2E  It has not been rebased against master, more
>specially against
>>>> my termios refactor to simplify the multiple architecture header
>definitions,
>>>> but I intend to use as a base=2E
>>>=20
>>> Reference [1] is still missing=2E 8-(
>>
>> Oops=2E=2E=2E it is
>https://git=2Ezytor=2Ecom/users/hpa/glibc/termbaud=2Egit/log/?h=3Dwip=2Et=
ermbaud
>
>This doesn't really illuminate things=2E  =E2=80=9CDrop explicit baud set=
ting
>interfaces in favor of cfenc|decspeed()=E2=80=9D removes the new symbol v=
ersion
>for the cf* functions=2E
>
>My gut feeling is that it's safer to add new interfaces, based on the
>actual kernel/userspace interface, rather than trying to fix up
>existing
>interfaces with symbol versioning=2E  The main reason is that code
>involving serial interfaces is difficult to test, so it will take years
>until we find the last application broken by the glibc interface bump=2E
>
>I don't feel strongly about this=2E  This came out of a request for
>enabling TCGETS2 support downstream=2E  If I can't fix this upstream, I
>will just reject that request=2E
>
>Thanks,
>Florian

New interfaces are only necessary for the handful of architectures that do=
n't have the speed fields *and* to space to put them in=2E=20

Using symbol versioning doesn't really help much since the real problem is=
 that struct termios can be passed around in userspace, and the interfaces =
between user space libraries don't have any versioning=2E However, my POC c=
ode deals with that too by only seeing BOTHER when necessary, so if the str=
ucture is extended garbage in the extra fields will be ignored unless new b=
aud rates are in use=2E

My POC code deals with Alpha as well by falling back to the old interfaces=
 if necessary and possible, otherwise return error=2E

Exporting termios2 to user space feels a bit odd at this stage as it would=
 only be usable as a fallback on old glibc=2E Call it kernel_termios2 at le=
ast=2E ioctls using struct termios *must* be changed to kernel_termios anyw=
ay!
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
