From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 01/22] docs: fpga: add a document for Intel FPGA driver overview
Date: Mon, 17 Jul 2017 15:14:29 -0500
Message-ID: <CANk1AXTLhbczboA=wCYGUhnJyyYfvmUqUpk490sk34eh-MU5Ew@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-2-git-send-email-hao.wu@intel.com> <CANk1AXTDVVRG05H9kwZujFYGGS=AjQ2cdfrBm=bRNz9S7p6R6w@mail.gmail.com>
 <20170713042520.GC28569@hao-dev> <20170714235914.GA17169@eluebber-mac02.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170714235914.GA17169@eluebber-mac02.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luebbers, Enno" <enno.luebbers@intel.com>
Cc: Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 14, 2017 at 6:59 PM, Luebbers, Enno <enno.luebbers@intel.com> wrote:
> On Thu, Jul 13, 2017 at 12:25:20PM +0800, Wu Hao wrote:
>> On Wed, Jul 12, 2017 at 09:51:32AM -0500, Alan Tull wrote:
>> > On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu@intel.com> wrote:
>> >
>> > Hi Hao,
>> >
>> > > Add a document for Intel FPGA driver overview.
>> > >
>> > > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
>> > > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
>> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
>> > > ----
>> > > v2: added FME fpga-mgr/bridge/region platform driver to driver organization.
>> > >     updated open discussion per current implementation.
>> > >     fixed some typos.
>> > > ---
>> > >  Documentation/fpga/intel-fpga.txt | 256 ++++++++++++++++++++++++++++++++++++++
>> > >  1 file changed, 256 insertions(+)
>> > >  create mode 100644 Documentation/fpga/intel-fpga.txt
>> > >
>> > > diff --git a/Documentation/fpga/intel-fpga.txt b/Documentation/fpga/intel-fpga.txt
>> > > new file mode 100644
>> > > index 0000000..4a29470
>> > > --- /dev/null
>> > > +++ b/Documentation/fpga/intel-fpga.txt
>> > > @@ -0,0 +1,256 @@
>> > > +===============================================================================
>> > > +                    Intel FPGA driver Overview
>> > > +-------------------------------------------------------------------------------
>> > > +                Enno Luebbers <enno.luebbers@intel.com>
>> > > +                Xiao Guangrong <guangrong.xiao@linux.intel.com>
>> > > +                Wu Hao <hao.wu@intel.com>
>> > > +
>> > > +The Intel FPGA driver provides interfaces for userspace applications to
>> > > +configure, enumerate, open, and access FPGA accelerators on platforms equipped
>> > > +with Intel(R) FPGA PCIe based solutions and enables system level management
>> > > +functions such as FPGA reconfiguration, power management, and virtualization.
>> > > +
>> > > +HW Architecture
>> > > +===============
>> > > +From the OS's point of view, the FPGA hardware appears as a regular PCIe device.
>> > > +The FPGA device memory is organized using a predefined data structure (Device
>> > > +Feature List). Features supported by the particular FPGA device are exposed
>> > > +through these data structures, as illustrated below:
>> > > +
>> > > +  +-------------------------------+  +-------------+
>> > > +  |              PF               |  |     VF      |
>> > > +  +-------------------------------+  +-------------+
>> > > +      ^            ^         ^              ^
>> > > +      |            |         |              |
>> > > ++-----|------------|---------|--------------|-------+
>> > > +|     |            |         |              |       |
>> > > +|  +-----+     +-------+ +-------+      +-------+   |
>> > > +|  | FME |     | Port0 | | Port1 |      | Port2 |   |
>> > > +|  +-----+     +-------+ +-------+      +-------+   |
>> > > +|                  ^         ^              ^       |
>> > > +|                  |         |              |       |
>> > > +|              +-------+ +------+       +-------+   |
>> > > +|              |  AFU  | |  AFU |       |  AFU  |   |
>> > > +|              +-------+ +------+       +-------+   |
>> > > +|                                                   |
>> > > +|                 FPGA PCIe Device                  |
>> > > ++---------------------------------------------------+
>> > > +
>> > > +The driver supports PCIe SR-IOV to create virtual functions (VFs) which can be
>> > > +used to assign individual accelerators to virtual machines.
>> > > +
>> > > +FME (FPGA Management Engine)
>> > > +============================
>> > > +The FPGA Management Engine performs power and thermal management, error
>> > > +reporting, reconfiguration, performance reporting, and other infrastructure
>> > > +functions. Each FPGA has one FME, which is always accessed through the physical
>> > > +function (PF).
>> > > +
>> > > +User-space applications can acquire exclusive access to the FME using open(),
>> > > +and release it using close().
>> > > +
>> > > +The following functions are exposed through ioctls:
>> > > +
>> > > +       Get driver API version (FPGA_GET_API_VERSION)
>> > > +       Check for extensions (FPGA_CHECK_EXTENSION)
>> > > +       Assign port to PF (FPGA_FME_PORT_ASSIGN)
>> > > +       Release port from PF (FPGA_FME_PORT_RELEASE)
>> > > +       Program bitstream (FPGA_FME_PORT_PR)
>> > > +
>> >
>> > I was hoping the API mailing list might have an opinion about this,
>> > but I think adding ioctls to the kernel is discouraged.  Could these
>> > be sysfs?
>>
>> Hi Alan,
>>
>> As you see below, we have defined a lot of sysfs interface for device
>> info, attributes and simple control operations. But for some actions
>> which requires complex inputs/outputs parameters (e.g a struct with
>> multiple items) with userspace, ioctls are used. I feel in such cases,
>> ioctls seem more suitable than sysfs.
>>
>
> Also, we're thinking that some operations require that you first "acquire
> ownership" of the respective device, which I believe maps more easily to
> open() and ioctls than sysfs.
>
> Thanks
> - Enno

Yes, sysfs doesn't implement open/close so there's no clean way to
have one thing in userspace that owns the interface.  It's a shame.

Alan
