From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Mon, 19 Jan 2015 09:54:58 +0100
Message-ID: <CACRpkdZ4CekD2xeJYM+UUtuGuwS2uB++XprSueWnshEVk=79Fw@mail.gmail.com>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
	<20150116111108.GG30960@localhost>
	<a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
	<CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <CAAVeFu+K0W96mi0=QR8JGSe9BpH2nC5WV_9qbSvm6LJGA8gc7Q@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Alexandre Courbot <gnurou@gmail.com>
Cc: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>, Johan Hovold <johan@kernel.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 19, 2015 at 5:20 AM, Alexandre Courbot <gnurou@gmail.com> w=
rote:
> On Sat, Jan 17, 2015 at 1:49 AM, S=C3=B6ren Brinkmann <soren.brinkman=
n@xilinx.com> wrote:
>> On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:

>>> Implementing proper wakeup support for unclaimed GPIOs would take s=
ome
>>> work (if at all desired), but that is not a reason to be adding cus=
tom
>>> implementations that violates the kernel's power policies and new A=
BIs
>>> that would need to be maintained forever.
(...)
>>> Meanwhile you can (should) use gpio-keys if you need to wake your s=
ystem
>>> on gpio events.
>>
>> We had that discussion and I don't think GPIO keys is the right solu=
tion
>> for every use-case.
>
> Sorry, it has been a while - can you remind us of why?

There are such cases. Of course keys should be handled by GPIO-keys
and these will trigger the right wakeup events in such cases.

This is for more esoteric cases: we cannot have a kernel module for
everything people want to do with GPIOs, and the use case I accept
is GPIOs used in automatic control etc, think factory lines or doors.
We can't have a "door" driver or "punch arm" or "fire alarm" driver
in the kernel. Those are userspace things.

Still such embedded systems need to be able to go to idle and
sleep to conerve power, and then they need to put wakeups on
these GPIOs.

So it is a feature userspace needs, though as with much of the
sysfs ABI it is very often abused for things like keys and LEDs which
is an abomination but we can't do much about it :(

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
