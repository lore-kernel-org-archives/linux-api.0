From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC ebeam PATCH 2/2] input: misc: New USB eBeam input driver
Date: Mon, 20 Jul 2015 16:09:05 -0700
Message-ID: <20150720230905.GA15528@dtor-ws>
References: <1437426199-29866-1-git-send-email-yann.cantin@laposte.net>
 <1437426199-29866-3-git-send-email-yann.cantin@laposte.net>
 <20150720215956.GA21796@kroah.com>
 <20150720222640.GD30252@dtor-ws>
 <20150720224033.GA23884@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150720224033.GA23884@kroah.com>
Sender: linux-input-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yann Cantin <yann.cantin@laposte.net>, linux-input@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jkosina@suse.cz
List-Id: linux-api@vger.kernel.org

On Mon, Jul 20, 2015 at 03:40:33PM -0700, Greg KH wrote:
> On Mon, Jul 20, 2015 at 03:26:40PM -0700, Dmitry Torokhov wrote:
> > On Mon, Jul 20, 2015 at 02:59:56PM -0700, Greg KH wrote:
> > > On Mon, Jul 20, 2015 at 11:03:19PM +0200, Yann Cantin wrote:
> > > > Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> > > 
> > > > +
> > > > +	/* sysfs setup */
> > > > +	err = sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
> > > 
> > > Ick, you just added the sysfs files to the USB device, not your input
> > > device, are you sure you tested this?
> > > 
> > > And there should be a race-free way to add an attribute group to an
> > > input device, as this is, you are adding them to the device _after_ it
> > > is created, so userspace will not see them at creation time, causing a
> > > race.
> > 
> > No, there are no driver-specific attributed on input devices themselves,
> > they belong to the actual hardware devices. The input devices only
> > export standard attributes applicable to every and all input devices
> > in the system.
> 
> Then the Documentation in this patch better be fixed up, as it points to
> the input device as having these sysfs files :)
> 
> But as these are input device attributes, and not USB device interface
> attributes, putting them on the USB interface doesn't make much sense,
> and as I pointed out, is racy.  Why can't input devices have
> driver-specific attributes?  Why does input devices add their own
> attributes sometimes (like in psmouse, which does so in a racy way) yet
> this driver shouldn't do that?
> 
> Hm, nevermind about psmouse, that happens on the parent device too it
> seems (a serio device), not the input device, so it is "consistent", but
> not something I really like...

I think it is historical as quite often they (attributes) affect the
hardware itself, not behavior of input interface. And so they were
always placed on hardware level, not input device level.

Anyway, I do not think you are going to win your war on sysfs attributes
created post-device creation. We just need to recognize that there are
attributes that are created by the driver when it is bound to the
device. Maybe we need to revisit the idea about emitting special uevent
when driver is fully bound to a device and interested userspace can
start using it.

Thanks.

-- 
Dmitry
