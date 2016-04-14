From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 00/10] Support for Cortex-M Prototyping System
Date: Thu, 14 Apr 2016 12:25:40 -0700
Message-ID: <20160414192540.GD20512@kroah.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
 <570F593D.6040809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570F593D.6040809@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: arnd@arndb.de, linux@arm.linux.org.uk, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com, mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 14, 2016 at 09:47:57AM +0100, Vladimir Murzin wrote:
> Hi,
> 
> On 01/04/16 15:02, Vladimir Murzin wrote:
> > Hi,
> > 
> > This patch series provides the basic support for running ucLinux on V2M-MPS2
> > platform.
> > 
> > With these patches applied ucLinux can be run on both HW and FVP models
> > with Cortex-M3/M4/M7 configurations.
> 
> Any objection to get it merged?
> 
> Sudeep Holla noticed that there is merge conflict against linux-next
> with PIC32 uart (Makefile and serial_core.h), so should I provide
> conflict resolution or do rebase on someone's branch?
> 
> Anyway, I'd be glad to know how it should be processed further?

I have no objection to the tty/serial changes, so if this all goes
through the arm-soc tree, that's fine with me.

thanks,

greg k-h
