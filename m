From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 15/24] fpga: dfl-fme-pr: add compat_id support for
 dfl-fme-region platform device.
Date: Thu, 1 Mar 2018 23:55:06 +0800
Message-ID: <20180301155506.GA13141@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-16-git-send-email-hao.wu@intel.com>
 <CANk1AXR9473+QqjF=R2JqqJGPB_XH9k+2qDhh68hN=5Fq4E7uw@mail.gmail.com>
 <20180301054935.GA8999@hao-dev>
 <CANk1AXRp_oKnLemFS4C7MgJwyFsjOUxgbYN0=S5wdSiUP9iM0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRp_oKnLemFS4C7MgJwyFsjOUxgbYN0=S5wdSiUP9iM0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 01, 2018 at 09:59:16AM -0600, Alan Tull wrote:
> On Wed, Feb 28, 2018 at 11:49 PM, Wu Hao <hao.wu@intel.com> wrote:
> > On Wed, Feb 28, 2018 at 05:06:57PM -0600, Alan Tull wrote:
> >> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> >> > +
> >> > +       compat_id.id_l = readq(fme_pr + FME_PR_INTFC_ID_L);
> >> > +       compat_id.id_h = readq(fme_pr + FME_PR_INTFC_ID_H);
> >>
> >> I tried building for 32 bit ARM and ran into readq and writeq not
> >> being defined.  v2 had proper '#indef readq/writeq', so looks like we
> >> need that after all.
> >
> > Sorry, it's missing a header file for dfl-fme-pr.h, as some files don't include
> > dfl.h at this version. That header file has definitions for readq/writeq.
> >
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> >
> > will fix it.
> 
> Hi Hao,
> 
> That sounds good.  I was able to build if I added it.  There are a
> couple issues in the enumeration code:
> 
> In file included from
> /home/atull/repos/linux-socfpga/include/linux/kernel.h:11:0,
>                  from /home/atull/repos/linux-socfpga/include/linux/list.h:9,
>                  from /home/atull/repos/linux-socfpga/include/linux/module.h:9,
>                  from /home/atull/repos/linux-socfpga/drivers/fpga/dfl.c:13:
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl.c: In function
> 'parse_feature_list':
> /home/atull/repos/linux-socfpga/include/linux/bitops.h:7:24: warning:
> left shift count >= width of type [-Wshift-count-overflow]
>  #define BIT(nr)   (1UL << (nr))
>                         ^
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl.h:73:19: note: in
> expansion of macro 'BIT'
>  #define DFH_EOL   BIT(40)   /* End of list */
>                    ^
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl.c:643:12: note: in
> expansion of macro 'DFH_EOL'
>    if ((v & DFH_EOL) || !ofst)
>             ^
> 
> and
> 
>   CC      drivers/fpga/dfl-fme-mgr.o
> In file included from
> /home/atull/repos/linux-socfpga/include/linux/kernel.h:11:0,
>                  from /home/atull/repos/linux-socfpga/include/linux/list.h:9,
>                  from
> /home/atull/repos/linux-socfpga/include/linux/kobject.h:19,
>                  from /home/atull/repos/linux-socfpga/include/linux/device.h:16,
>                  from
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl-fme-pr.c:20:
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl-fme-pr.c: In function
> 'pr_mgmt_init':
> /home/atull/repos/linux-socfpga/include/linux/bitops.h:7:24: warning:
> left shift count >= width of type [-Wshift-count-overflow]
>  #define BIT(nr)   (1UL << (nr))
>                         ^
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl.h:113:27: note: in
> expansion of macro 'BIT'
>  #define FME_PORT_OFST_IMP BIT(60)
>                            ^
> /home/atull/repos/linux-socfpga/drivers/fpga/dfl-fme-pr.c:449:23:
> note: in expansion of macro 'FME_PORT_OFST_IMP'
>    if (!(port_offset & FME_PORT_OFST_IMP))

Hi Alan

I think it needs to use BIT_ULL instead of BIT.
will fix them in the next version.

Thanks
Hao

>                        ^
> Alan
> 
> 
> >
> > Thanks
> > Hao
> >
> >> Alan
