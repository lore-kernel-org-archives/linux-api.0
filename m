From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 14/24] fpga: dfl: fme: add partial reconfiguration sub
 feature support
Date: Mon, 12 Mar 2018 13:53:57 -0500
Message-ID: <CANk1AXSwV+gZ-6cYdfNAzLiQx5Hu2po6NUrhFJ_zX-C6GRae5Q@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-15-git-send-email-hao.wu@intel.com> <CANk1AXRT6Rd6kjxT9Q_=3T0zNfzLGmdxOzY=pyX0VKMYReh-0Q@mail.gmail.com>
 <alpine.DEB.2.20.1803111251190.11747@mgerlach-VirtualBox> <20180312042939.GA19068@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180312042939.GA19068@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Matthew Gerlach <matthew.gerlach@linux.intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 11, 2018 at 11:29 PM, Wu Hao <hao.wu@intel.com> wrote:
> On Sun, Mar 11, 2018 at 01:09:31PM -0700, matthew.gerlach@linux.intel.com wrote:
>>

>> Hi Hao,
>>
>> I do think we should consider different hw implementations with this code
>> because it does look like most of it is generic.  Specifically, I think
>> we should consider DFH based fpga images that have been shipped already,
>> and I think we need to consider new hardware implementations as well.
>> Full disclosure, I am particularly interested in porting to a new hw
>> implementation for partial reconfiguration.

Hi Matthew,

The manager may not be the only thing that has to change for a new
implementation, i.e. will your 'port' be able to work with this
patchset?  In the current implementation, the port is part of the dfl
enumeration code (dfl.c and dfl.h) rather than being part of the
bridge for some reason.  We discussed the possibility of putting the
port enable/disable code into the bridge driver [1], but that didn't
seem feasible at least last December.  I still would feel more
confident if port were part of the bridge instead of part of dfl.

Alan

[1] https://lkml.org/lkml/2017/12/21/62
