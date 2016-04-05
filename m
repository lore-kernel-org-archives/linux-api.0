From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/8] uuid: convert users to generic UUID API
Date: Tue, 05 Apr 2016 14:07:27 +0300
Message-ID: <1459854447.12843.13.camel@linux.intel.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20160404164020.9a3529e6e247aac6ec114fff@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404164020.9a3529e6e247aac6ec114fff-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2016-04-04 at 16:40 -0700, Andrew Morton wrote:
> On Mon,=C2=A0=C2=A04 Apr 2016 16:30:02 +0300 Andy Shevchenko <andriy.=
shevchenko
> @linux.intel.com> wrote:
>=20
> >=20
> > There are few functions here and there along with type definitions
> > that provide
> > UUID API. This series consolidates everything under one hood and
> > converts
> > current users.
> Well.=C2=A0=C2=A0It converts two current users.
>=20
> There are many references to "uuid" in the tree.=C2=A0=C2=A0How many =
sites
> could
> potentially benefit from this change?

The big chunk is ACPI [1] though Rafael pointed out to some type
dereferencing he didn't get [2]. (By the way there is already use of
such in ACPI code from 2010: drivers/acpi/apei/ghes.c). That's why I
postponed that change.

[1]=C2=A0http://www.spinics.net/lists/linux-acpi/msg63811.html
[2]=C2=A0http://www.spinics.net/lists/linux-acpi/msg63854.html

>=20
> >=20
> > This has been tested for a while internally, however it doesn't
> > mean we covered
> > all possible cases (especially accuracy of UUID constants after
> > conversion).
> > So, please test this as much as you can and provide your tag. We
> > appreciate the
> > effort.
> I'm not sure who this series was aimed at but I saw "lib" and grabbed
> it.=C2=A0=C2=A0I'll await Matt's ack.

Yes, this is lib/ stuff, I hope the rest would provide Ack.

--=20
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
