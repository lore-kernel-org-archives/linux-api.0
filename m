From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Thu, 7 Dec 2017 11:47:49 +0800
Message-ID: <20171207034749.GA23924@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com>
 <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev>
 <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev>
 <391be54799604c1fb3d7b80c7ad6d111@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <391be54799604c1fb3d7b80c7ad6d111-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 06, 2017 at 09:34:14AM +0000, David Laight wrote:
> From: Wu Hao
> > Sent: 05 December 2017 03:34
> ...
> > > I don't see anything Intel specific here.  This could all be named dfl-*
> > 
> > The maybe some device specific things, e.g Intel FPGA devices supported by this
> > driver always have FME DFL at the beginning on the BAR0 for PF device.
> 
> Since when has that been a method for specifying what the card does?
> You need to allocate a PCI-id for your DFL accelerator.

This driver only supports Intel FPGA devices (see PCI Device Ids table
in this patch) as mentioned above now, per my current understanding, if
other vendors follow the same hardware design on using DFL for their PCIe
based devices, then it's possible for them to fully reuse this code,
otherwise they need to develop new drivers for their own designs or extend
this driver in some ways (it depends on actual hardware implementation).

Thanks
Hao

> 
> 	David
