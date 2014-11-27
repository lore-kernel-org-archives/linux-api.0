From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Thu, 27 Nov 2014 15:34:15 +0000
Message-ID: <20141127153415.3c2817b5@lxorguk.ukuu.org.uk>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
	<CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
	<3400511.2SONqVcoEr@wuerfel>
	<CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAfSe-uWvn4MX-+GKuvvd=G2MTfLDCFeLRoUGWp7vvc81wfu0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Murali Karicheri <m-karicheri2@ti.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, Jonathan Corbet <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>, Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>, "andrew@lunn.ch" <andrew@lu>
List-Id: linux-api@vger.kernel.org

> Yes, I saw this way in other serial drivers.
> But, if then, there are two questions for me:
> 1. Why did some serial drivers need an UN_SHARED irq?
> 2. How can we choose a right way?

If your hardware can support sharing an IRQ then shared is the right way
- along with the test Arnd suggested. Some hardware lacks the needed
facilities to handle shared interrupt.


Alan
