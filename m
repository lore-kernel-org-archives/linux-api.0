From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 15/24] fpga: dfl-fme-pr: add compat_id support for
 dfl-fme-region platform device.
Date: Thu, 1 Mar 2018 13:49:35 +0800
Message-ID: <20180301054935.GA8999@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-16-git-send-email-hao.wu@intel.com>
 <CANk1AXR9473+QqjF=R2JqqJGPB_XH9k+2qDhh68hN=5Fq4E7uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXR9473+QqjF=R2JqqJGPB_XH9k+2qDhh68hN=5Fq4E7uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 28, 2018 at 05:06:57PM -0600, Alan Tull wrote:
> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> > This patch adds compat_id support when driver creates the platform
> > device for dfl-fme-region. It allows dfl-fme-region platform driver
> > to create fpga-region with correct compat_id.
> >
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ---
> >  drivers/fpga/dfl-fme-pr.c | 20 ++++++++++++++++++++
> >  drivers/fpga/dfl-fme-pr.h |  3 +++
> >  2 files changed, 23 insertions(+)
> >
> > diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
> > index 526e90b..c17170b 100644
> > --- a/drivers/fpga/dfl-fme-pr.c
> > +++ b/drivers/fpga/dfl-fme-pr.c
> > @@ -314,6 +314,25 @@ static void fpga_fme_destroy_bridges(struct feature_platform_data *pdata)
> >  }
> >
> >  /**
> > + * fpga_fme_get_region_compat_id - read region compat_id from hardware
> > + *
> > + * @dev: fme device.
> > + */
> > +static struct fpga_region_compat_id
> > +fpga_fme_get_region_compat_id(struct device *dev)
> > +{
> > +       struct fpga_region_compat_id compat_id;
> > +       void __iomem *fme_pr;
> > +
> > +       fme_pr = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_PR_MGMT);
> > +
> > +       compat_id.id_l = readq(fme_pr + FME_PR_INTFC_ID_L);
> > +       compat_id.id_h = readq(fme_pr + FME_PR_INTFC_ID_H);
> 
> I tried building for 32 bit ARM and ran into readq and writeq not
> being defined.  v2 had proper '#indef readq/writeq', so looks like we
> need that after all.

Sorry, it's missing a header file for dfl-fme-pr.h, as some files don't include
dfl.h at this version. That header file has definitions for readq/writeq.

+#include <linux/io-64-nonatomic-lo-hi.h>

will fix it.

Thanks
Hao

> Alan
