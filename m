From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [v11,1/4] drivers: jtag: Add JTAG core driver
Date: Tue, 14 Nov 2017 11:19:16 +0000
Message-ID: <20171114111916.GO12318@n2100.armlinux.org.uk>
References: <1509724449-26221-2-git-send-email-oleksandrs@mellanox.com>
 <8760aoz78q.fsf@bilbrey.org>
 <DB6PR0501MB219753AC43515148F39CC2D0B1280@DB6PR0501MB2197.eurprd05.prod.outlook.com>
 <20171114111046.GA23820@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114111046.GA23820-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org" <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, 'Chip Bilbrey' <chip-Gz1Ta9Qd61ZAfugRpC6u6w@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org" <mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org" <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org" <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 12:10:46PM +0100, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> On Tue, Nov 14, 2017 at 10:34:49AM +0000, Oleksandr Shamray wrote:
> > Greg, what you can suggest about it. May be better to add again single-open()-per-device lock with right locking way like:
> > 
> > >if (mutex_lock_interruptible(&jtag->open_lock)) {
> 
> You would stall an open?  Why not just return saying you can't do that?

Greg, I think you need to look at the code again.

>From the snippet in the email, this lock is not held while the device is
open, as you apparently think it is.  It's a short-term lock that is
held to ensure atomic access to the jtag->opened member, so that two
concurrent opens are unable to operate lock-step, resulting in
jtag->opened becoming 2.

The open function snippet in the email drops the lock as soon as it has
incremented jtag->opened, or encounters an error.

It seems entirely sensible, rather than using an atomic_t counter, as
it means that other openers are held off until the current opener has
either succeeded in opening the device or failed to open it.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
