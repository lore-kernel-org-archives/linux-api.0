From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 07 Nov 2019 13:10:53 +0100
Message-ID: <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
	<0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106747-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com> (Christian
	Brauner's message of "Thu, 07 Nov 2019 13:05:16 +0100")
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Elichai Turkel <elichai.turkel@gmail.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> [+Cc Florian, glibc]
>
> On November 7, 2019 12:17:50 PM GMT+01:00, Elichai Turkel <elichai.turkel=
@gmail.com> wrote:
>>Hi,
>>I'm working on a library that calls syscalls directly to the kernel.
>>`make hedears_install` is a great command to auto generate the UAPI
>>headers that are needed to call the kernel.
>>
>>But the headers are still missing a bunch of defines for flags and
>>structs.
>>
>>I wanted to know if patches to move more things from `./include/linux`
>>to `./include/uapi/linux` are welcome (obviously only
>>typedefs/defines/structs that are required for the syscalls)
>>
>>I think the UAPI is really close to getting a complete set of things
>>needed to communicate with the syscalls, but still not quite there. I
>>would like to push patches whenever I see missing things that my
>>library needs (that way it will be incrementally and by usage only).

The kernel uses some POSIX names with POSIX-incompatible definitions,
e.g. struct msghdr.  Some libcs prioritize POSIX conformance over kernel
conformance and implement userspace translation for mismatch types.
When building against such libcs, it becomes difficult to use UAPI and
libc headers in a single translation unit.  (It is already difficult
today in some cases.)

I don't know a good solution here.  Not using POSIX names in UAPI
headers is one option.  Previously, we have tried to use preprocessor
macros to coordinate definitions, but did not work well in practice
(only few conflicts were ever resolved).  It does not help at all when
the definitions are incompatible.

Thanks,
Florian
