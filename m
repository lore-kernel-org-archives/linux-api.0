From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v3 08/21] fpga: add Intel FPGA DFL PCIe device
Date: Tue, 5 Dec 2017 11:00:22 -0600
Message-ID: <CANk1AXRdU6usqtsCUjjSC8Fk2SS8iKn+Ow4PvCiRpSBAcDwWjw@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-9-git-send-email-hao.wu@intel.com> <f5ae8e5edf88420e89cfbe754407b92e@AcuMS.aculab.com>
 <20171128031519.GA25705@hao-dev> <CANk1AXRBEcz5_j+v0oTAXfH10hrPbHGabdR8Pqt07exYxYgfCw@mail.gmail.com>
 <20171205033330.GA19730@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205033330.GA19730@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: David Laight <David.Laight@aculab.com>, "mdf@kernel.org" <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "luwei.kang@intel.com" <luwei.kang@intel.com>, "yi.z.zhang@intel.com" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 4, 2017 at 9:33 PM, Wu Hao <hao.wu@intel.com> wrote:
> On Mon, Dec 04, 2017 at 01:46:59PM -0600, Alan Tull wrote:
>> On Mon, Nov 27, 2017 at 9:15 PM, Wu Hao <hao.wu@intel.com> wrote:
>> > On Mon, Nov 27, 2017 at 10:28:04AM +0000, David Laight wrote:
>> >> From: Wu Hao
>> >> > Sent: 27 November 2017 06:42
>> >> > From: Zhang Yi <yi.z.zhang@intel.com>
>> >> >
>> >> > The Intel FPGA device appears as a PCIe device on the system. This patch
>> >> > implements the basic framework of the driver for Intel PCIe device which
>> >> > is located between CPU and Accelerated Function Units (AFUs), and has
>> >> > the Device Feature List (DFL) implemented in its MMIO space.
>> >>
>> >> This ought to have a better name than 'Intel FPGA'.
>> >> An fpga can be used for all sorts of things, this looks like
>> >> a very specific architecture using a common VHDL environment to
>> >> allow certain types of user VHDL be accessed over PCIe.
>> >
>> > Hi David
>> >
>> > This patch adds a pcie device driver for Intel FPGA devices which implements
>> > the DFL, e.g Intel Server Platform with In-package FPGA and Intel FPGA PCIe
>> > Acceleration Cards. They are pcie devices, and all have DFL implemented in
>> > the MMIO space, so we would like to use one kernel driver to handle them.
>> >
>> > With this full patchset, it just provides user the interfaces to configure
>> > and access the FPGA accelerators on Intel DFL based FPGA devices. For sure,
>> > users can develop and build their own logics via tools provided by Intel,
>> > program them to accelerators on these Intel FPGA devices, and access them
>> > for their workloads.
>>
>> I don't see anything Intel specific here.  This could all be named dfl-*
>
> The maybe some device specific things, e.g Intel FPGA devices supported by this
> driver always have FME DFL at the beginning on the BAR0 for PF device.
>
> But I think this should be the right direction for better code reuse, it could
> save efforts for other vendors who want to use DFL and follow the same way.
>
> Thanks for the comments. I will rename this driver in the next version.

Thanks!

Regarding file names, it seems like the files added to drivers/fpga
could be uniformly named dfl-*.[ch].  Some are fpga-dfl-*.[ch] while
other are currently dfl-*.[ch] currently.

Alan

>
> Hao
