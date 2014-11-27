From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 16:36:52 +0100
Message-ID: <7773522.25QE5ibXJZ@wuerfel>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com> <3400511.2SONqVcoEr@wuerfel> <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>, Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>
List-Id: linux-api@vger.kernel.org

On Thursday 27 November 2014 23:23:17 Lyra Zhang wrote:
> 
> Yes, I saw this way in other serial drivers.
> But, if then, there are two questions for me:
> 1. Why did some serial drivers need an UN_SHARED irq?

A lot of drivers were written before we had shared IRQs, or
were copied from old drivers, or are for hardware that uses
edge-triggered interrupts instead of level-triggered interrupts.

Only level-triggered interrupts can be shared.

> 2. How can we choose a right way?

It never hurts to implement a shared interrupt handler. Only
if you have no way to find out whether the device triggered
the interrupt or not you have to leave out IRQF_SHARED, and then
you won't be able to return IRQ_NONE.

	Arnd
