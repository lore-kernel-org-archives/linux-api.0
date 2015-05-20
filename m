From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v8 01/16] scripts: link-vmlinux: Don't pass page offset
 to kallsyms if XIP Kernel
Date: Thu, 21 May 2015 01:04:24 +0200
Message-ID: <555D12F8.4000403@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <1431158038-3813-2-git-send-email-mcoquelin.stm32@gmail.com> <CALszF6B0=dgSDfLFwDi9YmEzrrNVuYbUnqMu5DmDhhy--emtpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8i5AvsSrkCnii38NUmGSkosWURaENrkw1"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALszF6B0=dgSDfLFwDi9YmEzrrNVuYbUnqMu5DmDhhy--emtpw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>, Stefan Agner <stefan@agner.ch>
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, =
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8i5AvsSrkCnii38NUmGSkosWURaENrkw1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

Am 18.05.2015 um 13:47 schrieb Maxime Coquelin:
> 2015-05-09 9:53 GMT+02:00 Maxime Coquelin <mcoquelin.stm32@gmail.com>:
>> When Kernel is executed in place from ROM, the symbol addresses can be=

>> lower than the page offset.
>>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>

This issue was reported by Stefan Agner in 2014 for the VF610 [1], not
sure if I asked already whether there should be a Reported-by line?
Stefan, have you had a chance to test this patch?

Back then on STM32F4 I debugged that disabling KALLSYMS works around it.

Now on a different XIP target I have confirmed this patch to help show a
stacktrace (my clk driver was missing some CLK_DIVIDER_ALLOW_ZEROs) ...
although my earlyprintk serial output still gets stuck further down the
stacktrace - probably unrelated.

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/clk/clk-divider.c:126
divider_recalc_rate+0x2b/0x44()
[    0.000000] SYS: Zero divisor and CLK_DIVIDER_ALLOW_ZERO not set
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
4.1.0-rc4-next-20150519+ #23
[    0.000000] Hardware name: XMC4000 (Device Tree Support)
[    0.000000] [<0800bd5d>] (unwind_backtrace) from [<0800b0cb>]
(show_stack+0xb/0xc)
[    0.000000] [<0800b0cb>] (show_stack) from [<0800e0a5>]
(warn_slowpath_common+0x55/0x78)
[    0.000000] [<0800e0a5>] (warn_slowpath_common) from [<0800e103>]
(warn_slowpath_fmt+0x1b/0x24)
[    0.000000] [<0800e103>] (warn_slowpath_fmt) from [<080942e3>] (divide=


But this is definitely an improvement for ARMv7-M debugging,

Tested-by: Andreas F=E4rber <afaerber@suse.de>

> [Hi Michal, ...] could you consider
> taking it for v4.2?

Regards,
Andreas

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/30729=
7.html

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton; HRB=

21284 (AG N=FCrnberg)


--8i5AvsSrkCnii38NUmGSkosWURaENrkw1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVXRL4AAoJEPou0S0+fgE/qVwP+gKrGKJSjtMU1IV/fW3HkQ4R
+97WglEInrDpipmUoWn2yAOC2iH6p2HFZ3xmJh5gWt7XbeGM4JTssDSQTd0DAoT4
CcneEURyEdrm7UiHxCyd2Di0o5Pk3AOo9eHh8ze6RUp3dQIRuUJ6Q3MS3MVLjvWq
OuPVUga4qY1V3Vxn2E/LF4lzzBGkP+vnZEwY0mTThQcBEnDDRDu4aB6l5YYFizt6
6DDThM7oaCfg1fhjbCDB0OCf1Yb7I++/+a082Oo0kWeXvggql4qQ+/ZIXdYuh+ug
1pQspEZUkiqBBzJV+zwsfKOdUbt63sUMUCpsHeuIlnn7BQ/dchgYkPprAmHNO3wb
3slezwePnZ28Fqt42eR169chNkA+7PUpahqaRYo7TRH6VGbcIZx9Tmd52bUIQvYb
Pl0hZwidO69ekSNkwb0ZhNPes7G6r3roCDmhjatqoEv2lOraSHt4+/arxORRf9hh
UzeYvKUX+Y4ll9O1K9/Ioew08jrDX17D4VWwnIVQ82Bc/NbNm0/BncII4PDnYkxT
v2s+l4/JTnyzhZV6mwq6zGiWvZJn2Vj/zZ2TK+L9icy8jPjs7kc6/60ce2W36Lnn
NAyQS8vuerCa0br6I+5vFksQmeLp4Nik5aGqjOsoe9qx8vxr62VSc+F4J+GQ+t2D
mvSYJQ4+euwyofu1dQuw
=Fdus
-----END PGP SIGNATURE-----

--8i5AvsSrkCnii38NUmGSkosWURaENrkw1--
