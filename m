From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 15/21] fpga: dfl: add fpga bridge platform driver for
 FME
Date: Thu, 1 Feb 2018 13:15:43 +0800
Message-ID: <20180201051543.GC10273@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-16-git-send-email-hao.wu@intel.com>
 <CANk1AXS-ioW2svMS3QwrQCF5TiHp_nwaongC=d2Z2MfT8BEMMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXS-ioW2svMS3QwrQCF5TiHp_nwaongC=d2Z2MfT8BEMMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 31, 2018 at 09:16:58AM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> One fix below.  Besides that, please add my ack.
> 
> > This patch adds fpga bridge platform driver for FPGA Management Engine.
> > It implements the enable_set call back for fpga bridge.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> 
> Acked-by: Alan Tull <atull@kernel.org>
> 
> > diff --git a/drivers/fpga/fpga-dfl-fme-br.c b/drivers/fpga/fpga-dfl-fme-br.c
> > new file mode 100644
> > index 0000000..db2603b
> > --- /dev/null
> > +++ b/drivers/fpga/fpga-dfl-fme-br.c
> > @@ -0,0 +1,87 @@
> > +/*
> > + * FPGA Bridge Driver for FPGA Management Engine (FME)
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Wu Hao <hao.wu@intel.com>
> > + *   Joseph Grecco <joe.grecco@intel.com>
> > + *   Enno Luebbers <enno.luebbers@intel.com>
> > + *   Tim Whisonant <tim.whisonant@intel.com>
> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > + *   Henry Mitchel <henry.mitchel@intel.com>
> > + *
> > + * This work is licensed under the terms of the GNU GPL version 2.
> 
> If we're using the SPDX, then please get rid of the above line.
> 
> > + * SPDX-License-Identifier: GPL-2.0
> > + */
> 
> The SPDX line should be the first line of the file with a // (for .c
> files), please see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/license-rules.rst
> 
> Same thing for other files.

Thanks for the review.

Sure, will fix this for all driver files in the next version.

Thanks
Hao

> 
> Alan
