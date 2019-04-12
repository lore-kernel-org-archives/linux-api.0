From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Fri, 12 Apr 2019 09:50:41 +0200
Message-ID: <87lg0fbr1q.fsf@oldenburg2.str.redhat.com>
References: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
	<284e9c76-2411-b8f4-c4bc-c25c60c04cf7@linaro.org>
	<87imvker6t.fsf@oldenburg2.str.redhat.com>
	<db468a0f-4a7b-d251-601f-428885275d08@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-101350-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <db468a0f-4a7b-d251-601f-428885275d08@linaro.org> (Adhemerval
	Zanella's message of "Thu, 11 Apr 2019 09:53:30 -0300")
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: libc-alpha@sourceware.org, hpa@zytor.com, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

* Adhemerval Zanella:

> On 11/04/2019 08:07, Florian Weimer wrote:
>> * Adhemerval Zanella:
>>=20
>>> This allows us to adjust the baud rates to non-standard values using te=
rmios
>>> interfaces without to resorting to add new headers and use a different =
API
>>> (ioctl).
>>=20
>> How much symbol versioning will be required for this change?
>
> I think all interfaces that have termios as input for sparc and mips=20
> (tcgetattr, tcsetattr, cfmakeraw, cfgetispeed, cfgetospeed, cfsetispeed,
> cfsetospeed, cfsetspeed).
>
> Alpha will also need to use termios1 for pre-4.20 kernels.

So only new symbol versions there?  Hmm.

>>> As Peter Anvin has indicated, he create a POC [1] with the aforemention=
ed
>>> new interfaces.  It has not been rebased against master, more specially=
 against
>>> my termios refactor to simplify the multiple architecture header defini=
tions,
>>> but I intend to use as a base.
>>=20
>> Reference [1] is still missing. 8-(
>
> Oops... it is https://git.zytor.com/users/hpa/glibc/termbaud.git/log/?h=
=3Dwip.termbaud

This doesn't really illuminate things.  =E2=80=9CDrop explicit baud setting
interfaces in favor of cfenc|decspeed()=E2=80=9D removes the new symbol ver=
sion
for the cf* functions.

My gut feeling is that it's safer to add new interfaces, based on the
actual kernel/userspace interface, rather than trying to fix up existing
interfaces with symbol versioning.  The main reason is that code
involving serial interfaces is difficult to test, so it will take years
until we find the last application broken by the glibc interface bump.

I don't feel strongly about this.  This came out of a request for
enabling TCGETS2 support downstream.  If I can't fix this upstream, I
will just reject that request.

Thanks,
Florian
