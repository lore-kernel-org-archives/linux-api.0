From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Missing size_t declaration in UAPI
Date: Sat, 09 Nov 2019 13:27:30 +0100
Message-ID: <87d0e19qvh.fsf@mid.deneb.enyo.de>
References: <CALN7hCJRe1uL6pd+VwgzDt=5giMVjvX+YpF28f5qbLOVCZf4GQ@mail.gmail.com>
	<04EB5627-FD42-4397-995B-FDF051CFCFB5@brauner.io>
	<CALN7hC+YmHGpniNKBiD03cBnTyO+cqXhrVvE7SdtgEb7GkG-LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106864-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALN7hC+YmHGpniNKBiD03cBnTyO+cqXhrVvE7SdtgEb7GkG-LQ@mail.gmail.com>
	(Elichai Turkel's message of "Sat, 9 Nov 2019 13:52:11 +0200")
To: Elichai Turkel <elichai.turkel@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Elichai Turkel:

> I'm proposing to move `linux/tools/include/nolibc/nolibc.h` to the
> UAPI interface.
> It would then be included in `linux/types.h`
> Would love feedback before I work on a patch.

I do not think nolibc.h is a good starting point.  The header is
pretty much incompatible with everything, including multiple
translation units that include it, so including it from
<linux/types.h> will not work.

>>> Currently compiling the following program fails:
>>> ```
>>> #include "linux/signal.h"
>>> void main(void){}
>>> ```
>>> Because of `./asm/signal.h:127:2: error: unknown type name =E2=80=98siz=
e_t=E2=80=99`.
>>>
>>> I tried patching with `#include <stddef.h>` but there's a local file
>>> with the same name overriding the include.

<stddef.h> is expected to be provided by the compiler. It's probably
easier to fix your build environment.
