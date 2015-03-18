From: Bastien Nocera <hadess@hadess.net>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit
 accelerometer
Date: Wed, 18 Mar 2015 19:05:34 +0100
Message-ID: <1426701934.6764.10.camel@hadess.net>
References: <1426694157-10866-1-git-send-email-martink@posteo.de>
		 <2231139.ojeyer6qnI@ws-stein> <5509AAE5.1000503@posteo.de>
	 <1426697978.6764.8.camel@hadess.net> <5509BDA0.9000806@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <5509BDA0.9000806@posteo.de>
Sender: linux-input-owner@vger.kernel.org
To: Martin Kepplinger <martink@posteo.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martin.kepplinger@theobroma-systems.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-18 at 19:02 +0100, Martin Kepplinger wrote:
> Am 2015-03-18 um 17:59 schrieb Bastien Nocera:
> > On Wed, 2015-03-18 at 17:42 +0100, Martin Kepplinger wrote:
> > > 
> > <snip>
> > > It could have gone to drivers/iio/accel if it would use an iio  
> > > interface, which would make more sense, you are right, but I 
> > > simply  don't have the time to merge it in to iio.
> > > 
> > > It doesn't use an input interface either but I don't see a good  
> > > place for an accelerometer that uses sysfs only.
> > > 
> > > It works well, is a relatively recent chip and a clean dirver. 
> > > But  this is all I can provide.
> > 
> > As a person who works on the user-space interaction of those with  
> > desktops [1]: Urgh.
> > 
> > I already have 3 (probably 4) types of accelerometers to contend 
> > with,  I'm not fond of adding yet another type.
> > 
> > Is there any way to get this hardware working outside the SoCs 
> > it's  designed for (say, a device with I2C like a Raspberry Pi), 
> > so that a  kind soul could handle getting this using the right 
> > interfaces?
> > 
> 
> It works on basically any SoC and is in no way limited in this 
> regard. Sure, userspace has to expicitely support it and I hear you. 
> Using the iio interface would make more sense. I can only say I'd 
> love to have the time to move this driver over. I'm very sorry.

How can we get the hardware for somebody to use on their own 
laptops/embedded boards to implement this driver?
