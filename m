From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 14 Nov 2017 12:10:46 +0100
Message-ID: <20171114111046.GA23820@kroah.com>
References: <1509724449-26221-2-git-send-email-oleksandrs@mellanox.com>
 <8760aoz78q.fsf@bilbrey.org>
 <DB6PR0501MB219753AC43515148F39CC2D0B1280@DB6PR0501MB2197.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB6PR0501MB219753AC43515148F39CC2D0B1280@DB6PR0501MB2197.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: 'Chip Bilbrey' <chip@bilbrey.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, "joel@jms.id.au" <joel@jms.id.au>, "jiri@resnulli.us" <jiri@resnulli.us>, "tklauser@distanz.ch" <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "mec@shout.net" <mec@shout.net>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owner@lists.sourceforge.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 10:34:49AM +0000, Oleksandr Shamray wrote:
> > -----Original Message-----
> > From: Chip Bilbrey [mailto:chip@bilbrey.org]
> > Sent: Monday, November 6, 2017 12:33 AM
> > To: Oleksandr Shamray <oleksandrs@mellanox.com>
> > Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-
> > kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > devicetree@vger.kernel.org; openbmc@lists.ozlabs.org; joel@jms.id.au;
> > jiri@resnulli.us; tklauser@distanz.ch; linux-serial@vger.kernel.org;
> > mec@shout.net; Vadim Pasternak <vadimp@mellanox.com>; system-sw-low-
> > level <system-sw-low-level@mellanox.com>; robh+dt@kernel.org; openocd-
> > devel-owner@lists.sourceforge.net; linux-api@vger.kernel.org;
> > davem@davemloft.net; mchehab@kernel.org; Jiri Pirko <jiri@mellanox.com>
> > Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
> > 
> > 
> > Oleksandr Shamray writes:
> 
> [..]
> 
> > I notice the single-open()-per-device lock was dropped by request in an earlier
> > revision of your patches, but multiple processes trying to drive a single JTAG
> > master could wreak serious havoc if transactions get interleaved. Would
> > something like an added JTAG_LOCKCHAIN/UNLOCKCHAIN
> > ioctl() for exclusive client access be reasonable to prevent this?
> > 
> 
> Yes, it dropped by recommendation of Greg KH <gregkh@linuxfoundation.org>. 

I asked to drop it as you didn't even implement it to work correctly :)

> Greg, what you can suggest about it. May be better to add again single-open()-per-device lock with right locking way like:
> 
> >if (mutex_lock_interruptible(&jtag->open_lock)) {

You would stall an open?  Why not just return saying you can't do that?

Anyway, if you want to only have one access to the device at a time,
great, but do it in a way that works properly.

thanks,

greg k-h
