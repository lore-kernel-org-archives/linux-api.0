From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early
 console
Date: Tue, 16 Feb 2016 16:12:56 +0000
Message-ID: <20160216161256.234a2be8@lxorguk.ukuu.org.uk>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>
	<CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
	<56C31F9F.10000@arm.com>
	<CAHp75Vf_4MgdWunQy5hBMH5GGei+OkktFPYY-ZprY0qOEnD=wA@mail.gmail.com>
	<56C32641.4020201@arm.com>
	<CAHp75VecjR3sBcGmRHFwZPwUjXhPwV-2z4hYYJ7Y+iCOxi8_EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VecjR3sBcGmRHFwZPwUjXhPwV-2z4hYYJ7Y+iCOxi8_EA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> > If you do insist to have a counter I'll add one, but if you are not
> > strong about it I'd prefer to leave it as is.  
> 
> I would wait for Peter Hurley, Alan, or other experienced guys to talk.

I would leave it. Some of the drivers have defensive code of this form,
but mostly because they can be hot unplugged and we don't want to spin
into oblivion because the user ejected a serial card adapter.

Alan
