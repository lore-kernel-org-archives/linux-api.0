From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v8 01/16] scripts: link-vmlinux: Don't pass page offset
 to kallsyms if XIP Kernel
Date: Fri, 22 May 2015 22:20:35 +0200
Message-ID: <555F8F93.7000705@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <1431158038-3813-2-git-send-email-mcoquelin.stm32@gmail.com> <CALszF6B0=dgSDfLFwDi9YmEzrrNVuYbUnqMu5DmDhhy--emtpw@mail.gmail.com> <555D12F8.4000403@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NGubmuQWF8p0L662mvgUTwp27eogPw0JI"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555D12F8.4000403-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>
Cc: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Linux-Arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Geert Uytterhoeven <geert@linu>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NGubmuQWF8p0L662mvgUTwp27eogPw0JI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 21.05.2015 um 01:04 schrieb Andreas F=E4rber:
> Hi,
>=20
> Am 18.05.2015 um 13:47 schrieb Maxime Coquelin:
>> 2015-05-09 9:53 GMT+02:00 Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:=

>>> When Kernel is executed in place from ROM, the symbol addresses can b=
e
>>> lower than the page offset.
>>>
>>> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
[...]
> Back then on STM32F4 I debugged that disabling KALLSYMS works around it=
=2E
>=20
> Now on a different XIP target I have confirmed this patch to help show =
a
> stacktrace (my clk driver was missing some CLK_DIVIDER_ALLOW_ZEROs) ...=

> although my earlyprintk serial output still gets stuck further down the=

> stacktrace - probably unrelated.

FTR confirming my suspicion: insufficient power supply. ;)

Andreas

> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at drivers/clk/clk-divider.c:126
> divider_recalc_rate+0x2b/0x44()
> [    0.000000] SYS: Zero divisor and CLK_DIVIDER_ALLOW_ZERO not set
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
> 4.1.0-rc4-next-20150519+ #23
> [    0.000000] Hardware name: XMC4000 (Device Tree Support)
> [    0.000000] [<0800bd5d>] (unwind_backtrace) from [<0800b0cb>]
> (show_stack+0xb/0xc)
> [    0.000000] [<0800b0cb>] (show_stack) from [<0800e0a5>]
> (warn_slowpath_common+0x55/0x78)
> [    0.000000] [<0800e0a5>] (warn_slowpath_common) from [<0800e103>]
> (warn_slowpath_fmt+0x1b/0x24)
> [    0.000000] [<0800e103>] (warn_slowpath_fmt) from [<080942e3>] (divi=
de
>=20
> But this is definitely an improvement for ARMv7-M debugging,
>=20
> Tested-by: Andreas F=E4rber <afaerber-l3A5Bk7waGM@public.gmane.org>

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton; HRB=

21284 (AG N=FCrnberg)


--NGubmuQWF8p0L662mvgUTwp27eogPw0JI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVX4+TAAoJEPou0S0+fgE/61oQAIIlc6qJ4pWt3nX9Yckg+uqF
1BjibhteOVF5/dJIm1lPJTNrwJahTjjiV3Wk0j9bYV8i8UDRwHieOsqJx9adstM/
VSM/fAQr1ex3Fzx6II5q16bKIZ6vHQwrcgDEIK+W32Q5pmEyCa03wF5zalEln6e/
8mOgK/GaVIDy6KQUlzY+s+6yGY4HeYuzvp/b/NtXUJqOUv0KpFKLvjfhNX4TTUcy
W2uGBwnbwmPGBvkMlbm6jHcd04kpjmNr4zP1e4VW4cLaiP4KZ8psbP27raTWfO9V
sBaQuxcD1GrvJIamFHmXo4A0xMZzwYPpPjWtSY6QI8Vcgo5PU6KRMDXpNWClKFAw
0sQ7/Ic/1NNTFM2PcVbrfMEurpgXB+y+8ukrcK9Uc/aRdX1NVowD8ceKGvAiAV7W
QcRbzd0K+IcpJdR9loe2MOJLX4nZxNTKYhm3Gqb2XXjCXKDyr18/3hoba5ZktxEE
7Y7WZLIbT8j2G9w7OBP+xHhGC71Jl723VHirS1oUoZJ7jidd1UfRTissm9/hE/4a
HV7CKO2HqHBUm4FAripxEKDv4j5ucMgPAXE/F5k3UjiC4hQGFMVE1PSmgCQpHTyr
wEpZxGXWvEzY9prjOCEZoaQJ2GnNyRcD+TIYjzT1QdwCneQfwOlW/G3e1lDRp7CM
G8xXS3KNZkfwX4R7bNoG
=blWh
-----END PGP SIGNATURE-----

--NGubmuQWF8p0L662mvgUTwp27eogPw0JI--
