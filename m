From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 01/16] scripts: link-vmlinux: Don't pass page offset to
 kallsyms if XIP Kernel
Date: Thu, 21 May 2015 09:42:32 +0200
Message-ID: <CALszF6AdNfYRhcLdc252peOcPOnzAXOKQydNcvgVdT26btAA6Q@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-2-git-send-email-mcoquelin.stm32@gmail.com>
	<CALszF6B0=dgSDfLFwDi9YmEzrrNVuYbUnqMu5DmDhhy--emtpw@mail.gmail.com>
	<555D12F8.4000403@suse.de>
	<555D6FBD.3020202@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <555D6FBD.3020202@suse.cz>
Sender: linux-arch-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.cz>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefan Agner <stefan@agner.ch>, Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail>
List-Id: linux-api@vger.kernel.org

2015-05-21 7:40 GMT+02:00 Michal Marek <mmarek@suse.cz>:
> Dne 21.5.2015 v 07:04 Andreas F=C3=A4rber napsal(a):
>> Am 18.05.2015 um 13:47 schrieb Maxime Coquelin:
>> But this is definitely an improvement for ARMv7-M debugging,
>>
>> Tested-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>
>>> [Hi Michal, ...] could you consider
>>> taking it for v4.2?
>
> I applied it to kbuild.git#kbuild now.

Thanks!
Maxime
