From: Elichai Turkel <elichai.turkel@gmail.com>
Subject: Re: Missing size_t declaration in UAPI
Date: Sat, 9 Nov 2019 14:15:30 +0200
Message-ID: <CALN7hCKXbU_oXH_AfQ5Y204Faucc2UrwPASdgAHWoss8jgMgTA@mail.gmail.com>
References: <CALN7hCJRe1uL6pd+VwgzDt=5giMVjvX+YpF28f5qbLOVCZf4GQ@mail.gmail.com>
 <04EB5627-FD42-4397-995B-FDF051CFCFB5@brauner.io> <CALN7hC+YmHGpniNKBiD03cBnTyO+cqXhrVvE7SdtgEb7GkG-LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106863-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALN7hC+YmHGpniNKBiD03cBnTyO+cqXhrVvE7SdtgEb7GkG-LQ@mail.gmail.com>
To: Christian Brauner <christian@brauner.io>
Cc: linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

After further reading into `nolibc.h` I think not all of it should be
in UAPI (specifically the syscalls wrappers don't).
I think it should be split and both the ASM declarations and the
types(i.e. size_t) should be in UAPI

On Sat, Nov 9, 2019 at 1:52 PM Elichai Turkel <elichai.turkel@gmail.com> wr=
ote:
>
> Hi,
> I'm proposing to move `linux/tools/include/nolibc/nolibc.h` to the
> UAPI interface.
> It would then be included in `linux/types.h`
> Would love feedback before I work on a patch.
>
> Thanks.
> Elichai.
>
> On Fri, Nov 8, 2019 at 11:43 PM Christian Brauner <christian@brauner.io> =
wrote:
> >
> > On November 8, 2019 10:25:09 PM GMT+01:00, Elichai Turkel <elichai.turk=
el@gmail.com> wrote:
> >>
> >> Hi,
> >> Currently compiling the following program fails:
> >> ```
> >> #include "linux/signal.h"
> >> void main(void){}
> >> ```
> >> Because of `./asm/signal.h:127:2: error: unknown type name =E2=80=98si=
ze_t=E2=80=99`.
> >>
> >> I tried patching with `#include <stddef.h>` but there's a local file
> >> with the same name overriding the include.
> >>
> >> How can this be fixed? the `drm` headers seems to work with `uint_*`.
> >>
> >> Right now the `linux/signal.h` header isn't usable without wrapping it
> >> with another header to include/define size_t.
> >>
> >> Thanks,
> >> Elichai.
> >
> >
> > I think it might make sense to always cc the libc mailing list too for =
these things.
>
>
>
> --
> PGP: 5607C93B5F86650C



--=20
PGP: 5607C93B5F86650C
