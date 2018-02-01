From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Thu, 1 Feb 2018 15:59:21 -0600
Message-ID: <CANk1AXS6xa8FTBTk5Q2PWcijb1Uuy=XFAFFin-R2dU2y-iruvw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com> <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev> <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev> <CANk1AXRdU6usqtsCUjjSC8Fk2SS8iKn+Ow4PvCiRpSBAcDwWjw@mail.gmail.com>
 <20171206053015.GA19023@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206053015.GA19023@hao-dev>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>, "mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 5, 2017 at 11:30 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Dec 05, 2017 at 11:00:22AM -0600, Alan Tull wrote:
>> On Mon, Dec 4, 2017 at 9:33 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > On Mon, Dec 04, 2017 at 01:46:59PM -0600, Alan Tull wrote:
>> >> On Mon, Nov 27, 2017 at 9:15 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >> > On Mon, Nov 27, 2017 at 10:28:04AM +0000, David Laight wrote:
>> >> >> From: Wu Hao
>> >> >> > Sent: 27 November 2017 06:42
>> >> >> > From: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> >> >> >
>> >> >> > The Intel FPGA device appears as a PCIe device on the system. This patch
>> >> >> > implements the basic framework of the driver for Intel PCIe device which
>> >> >> > is located between CPU and Accelerated Function Units (AFUs), and has
>> >> >> > the Device Feature List (DFL) implemented in its MMIO space.
>> >> >>
>> >> >> This ought to have a better name than 'Intel FPGA'.
>> >> >> An fpga can be used for all sorts of things, this looks like
>> >> >> a very specific architecture using a common VHDL environment to
>> >> >> allow certain types of user VHDL be accessed over PCIe.
>> >> >
>> >> > Hi David
>> >> >
>> >> > This patch adds a pcie device driver for Intel FPGA devices which implements
>> >> > the DFL, e.g Intel Server Platform with In-package FPGA and Intel FPGA PCIe
>> >> > Acceleration Cards. They are pcie devices, and all have DFL implemented in
>> >> > the MMIO space, so we would like to use one kernel driver to handle them.
>> >> >
>> >> > With this full patchset, it just provides user the interfaces to configure
>> >> > and access the FPGA accelerators on Intel DFL based FPGA devices. For sure,
>> >> > users can develop and build their own logics via tools provided by Intel,
>> >> > program them to accelerators on these Intel FPGA devices, and access them
>> >> > for their workloads.
>> >>
>> >> I don't see anything Intel specific here.  This could all be named dfl-*
>> >
>> > The maybe some device specific things, e.g Intel FPGA devices supported by this
>> > driver always have FME DFL at the beginning on the BAR0 for PF device.

I'm thinking that another user could add their PCI id's and a static
FPGA image that has a DFL in the right place for this to work for
them.

>> >
>> > But I think this should be the right direction for better code reuse, it could
>> > save efforts for other vendors who want to use DFL and follow the same way.

I appreciate your understanding here.

>> >
>> > Thanks for the comments. I will rename this driver in the next version.
>>
>> Thanks!
>>
>> Regarding file names, it seems like the files added to drivers/fpga
>> could be uniformly named dfl-*.[ch].  Some are fpga-dfl-*.[ch] while
>> other are currently dfl-*.[ch] currently.
>
> Sure, will have all related drivers files renamed to dfl-*.[ch].

Actually, I'll reverse that a bit.  The enumeration code, including
the pcie part is all sufficiently general to run on anything that has
a DFL struct located in the right place.  But individual feature
drivers (currently only the fme-mgr) will be vendor specific and could
be named intel-*.

Alan
