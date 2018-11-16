From: hpa@zytor.com
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 10:48:01 -0800
Message-ID: <9D0F6AB6-3F09-449D-912A-87A6F2214E30@zytor.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr> <20181115140441.GA2171@altlinux.org> <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com> <20181115153008.GC2171@altlinux.org> <68E78315-66C9-4CEE-B6A0-61485AFB314A@zytor.com> <CAK8P3a2bGYt1Z50eQsBv2pu_zd649SB1MjX-iWcZ-YnJ+Bhj1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-97324-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAK8P3a2bGYt1Z50eQsBv2pu_zd649SB1MjX-iWcZ-YnJ+Bhj1Q@mail.gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, GNU C Library <libc-alpha@sourceware.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On November 15, 2018 11:14:21 PM PST, Arnd Bergmann <arnd@arndb=2Ede> wrote=
:
>On Thu, Nov 15, 2018 at 7:38 AM <hpa@zytor=2Ecom> wrote:
>> On November 15, 2018 7:30:11 AM PST, "Dmitry V=2E Levin"
><ldv@altlinux=2Eorg> wrote:
>> >On Thu, Nov 15, 2018 at 06:39:03AM -0800, Arnd Bergmann wrote:
>> >> On Thu, Nov 15, 2018 at 6:05 AM Dmitry V=2E Levin wrote:
>> >> > On Thu, Apr 20, 2017 at 03:20:51PM +0200, Albert ARIBAUD wrote:
>
>> >2=2E The time precision provided by struct rusage returned by wait4(2)
>> >and waitid(2) is too low for syscall time counting (strace -c)
>nowadays,
>> >this can be observing by running in a row a simple command like
>"strace -c
>> >pwd"=2E
>> >
>> >The fix is to return a more appropriate structure than struct rusage
>> >by the new pwait6(2)/pwaitid(2) syscall mentioned above, where
>> >struct timeval is replaced with struct timespec or even struct
>> >timespec64=2E
>>
>> Arnd: w=2Er=2Et=2E our previous discussion, this would seem to justify
>going to timespec(64) for these kind of cases=2E
>
>Ok, and I assume we want the same layout for getrusage(2) then, right?
>
>        Arnd

Note that now we have to add one system calls for 64-but platforms=2E Thus=
, the right way to do that is to add those new system calls (e=2Eg=2E waiti=
dns()), and *only* provide those for 32-bit Y2038=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
