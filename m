From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH 14/17] fpga: dfl: fme: add thermal management support
Date: Wed, 3 Apr 2019 11:09:09 -0700
Message-ID: <20190403180909.GD5752@archbook>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-15-git-send-email-hao.wu@intel.com>
 <20190402145925.GA15773@archbook>
 <20190403163147.GA28570@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190403163147.GA28570@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, atull@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>, Russ Weight <russell.h.weight@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Hao,

On Thu, Apr 04, 2019 at 12:31:47AM +0800, Wu Hao wrote:
> On Tue, Apr 02, 2019 at 07:59:25AM -0700, Moritz Fischer wrote:
> > Hi Wu,
> > 
> > On Mon, Mar 25, 2019 at 11:07:41AM +0800, Wu Hao wrote:
> > > This patch adds support to thermal management private feature for DFL
> > > FPGA Management Engine (FME). As thermal throttling is handled by
> > > hardware automatically per pre-defined thresholds, this private
> > > feature driver only provides read-only sysfs interfaces for user
> > > to read temperature, thresholds, threshold policy and other info.
> > > 
> > > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > > Signed-off-by: Russ Weight <russell.h.weight@intel.com>
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-platform-dfl-fme |  56 +++++++
> > >  drivers/fpga/dfl-fme-main.c                      | 202 +++++++++++++++++++++++
> > >  2 files changed, 258 insertions(+)
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > index b8327e9..d3aeb88 100644
> > > --- a/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > +++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > @@ -44,3 +44,59 @@ Description:	Read-only. It returns socket_id to indicate which socket
> > >  		this FPGA belongs to, only valid for integrated solution.
> > >  		User only needs this information, in case standard numa node
> > >  		can't provide correct information.
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/temperature
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. It returns temperature (in Celsius) of this FPGA
> > > +		device.
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. Read this file to get the temperature threshold1
> > > +		(in Celsius).
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold2
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. Read this file to get the temperature threshold2
> > > +		(in Celsius).
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/trip_threshold
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. It returns trip threshold (in Celsius), once FPGA
> > > +		temperature reaches trip threshold, it triggers a fatal event
> > > +		to board management controller (BMC) to shutdown FPGA.
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1_status
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. It returns 1 if temperature reaches threshold1,
> > > +		otherwise 0. Once temperature reaches threshold1, hardware
> > > +		will automatically enter throttling state (AP1 - 50%
> > > +		or AP2 - 90% throttling, see 'threshold1_policy').
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold2_status
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. It returns 1 if temperature reaches threshold2,
> > > +		otherwise 0. Once temperature reaches threshold2, hardware
> > > +		will automatically enter the deepest throttling state (AP6
> > > +		- 100% throttling).
> > > +
> > > +What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1_policy
> > > +Date:		March 2019
> > > +KernelVersion:  5.2
> > > +Contact:	Wu Hao <hao.wu@intel.com>
> > > +Description:	Read-only. Read this file to get the policy of temperature
> > > +		threshold1. It only supports two value (policy):
> > > +		    0 - AP2 state (90% throttling)
> > > +		    1 - AP1 state (50% throttling)
> > 
> > These look like they could directly map to the linux thermal framework,
> > any reason you can't use the thermal framework?
> > 
> > The trip stuff literally maps 1:1 to what a thermal driver does, I think
> > that's something you'd wanna consider.
> > 
> 
> Hi Moritz,
> 
> Thanks a lot for the suggestion, actually I feel that the trip points in thermal
> zone are used to indicate cooling actions required for thermal software either
> in kernel or userspace. But in this case, such FPGA hardware handles cooling
> automatically (yes, driver only expose Read-only sysfs for information), so
> software doesn't need to take care of this at all. For this purpose, it seems
> that we don't have to put these thresholds as trip points. And per my
> understanding, if people use such FPGA device, then they may need to know
> what's the current hardware throttling behavior, e.g. 50% vs 90%. These
> information can't be provided by standard thermal zone sysfs, so anyway user
> needs these sysfs interfaces to know it. But it seems that we still could
> create a thermal zone without trip points, it could help if user wants to
> connect some external cooling devices via userspace thermal daemon, they can
> define whatever trip points they like to activate the external cooling 
> device. I will consider this further more and come up with a new patch in
> v2 patchset.

Generally speaking extending an existing framework with the
functionality you want is preferable over rolling 100% your own.

So please look into this.

Thanks,
Moritz
