From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 14 Nov 2017 12:31:44 +0100
Message-ID: <20171114113144.GA25234@kroah.com>
References: <1509724449-26221-2-git-send-email-oleksandrs@mellanox.com>
 <8760aoz78q.fsf@bilbrey.org>
 <DB6PR0501MB219753AC43515148F39CC2D0B1280@DB6PR0501MB2197.eurprd05.prod.outlook.com>
 <20171114111046.GA23820@kroah.com>
 <20171114111916.GO12318@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114111916.GO12318-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org" <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, 'Chip Bilbrey' <chip-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org" <mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org" <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org" <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 11:19:16AM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 14, 2017 at 12:10:46PM +0100, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> > On Tue, Nov 14, 2017 at 10:34:49AM +0000, Oleksandr Shamray wrote:
> > > Greg, what you can suggest about it. May be better to add again single-open()-per-device lock with right locking way like:
> > > 
> > > >if (mutex_lock_interruptible(&jtag->open_lock)) {
> > 
> > You would stall an open?  Why not just return saying you can't do that?
> 
> Greg, I think you need to look at the code again.

Heh, sorry, I probably got it wrong.  I'll be glad to review it in a
real patch when needed, but not in the middle of the merge window :)

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
