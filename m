From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Tue, 28 Nov 2017 11:15:19 +0800
Message-ID: <20171128031519.GA25705@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com>
 <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f5ae8e5edf88420e89cfbe754407b92e-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: "atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 10:28:04AM +0000, David Laight wrote:
> From: Wu Hao
> > Sent: 27 November 2017 06:42
> > From: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > The Intel FPGA device appears as a PCIe device on the system. This patch
> > implements the basic framework of the driver for Intel PCIe device which
> > is located between CPU and Accelerated Function Units (AFUs), and has
> > the Device Feature List (DFL) implemented in its MMIO space.
> 
> This ought to have a better name than 'Intel FPGA'.
> An fpga can be used for all sorts of things, this looks like
> a very specific architecture using a common VHDL environment to
> allow certain types of user VHDL be accessed over PCIe.

Hi David

This patch adds a pcie device driver for Intel FPGA devices which implements
the DFL, e.g Intel Server Platform with In-package FPGA and Intel FPGA PCIe
Acceleration Cards. They are pcie devices, and all have DFL implemented in
the MMIO space, so we would like to use one kernel driver to handle them.

With this full patchset, it just provides user the interfaces to configure
and access the FPGA accelerators on Intel DFL based FPGA devices. For sure,
users can develop and build their own logics via tools provided by Intel,
program them to accelerators on these Intel FPGA devices, and access them
for their workloads.

Thanks
Hao
