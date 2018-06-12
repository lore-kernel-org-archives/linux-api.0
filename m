From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v6 12/29] fpga: add FPGA DFL PCIe device driver
Date: Wed, 13 Jun 2018 07:42:39 +0800
Message-ID: <20180612234239.GB8459@hao-dev>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
 <1528798243-2029-13-git-send-email-hao.wu@intel.com>
 <87a783f1-9db8-e56d-c4c4-1802c29c416a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a783f1-9db8-e56d-c4c4-1802c29c416a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 12, 2018 at 08:27:27AM -0700, Randy Dunlap wrote:
> Hi,
> 
> On 06/12/2018 03:10 AM, Wu Hao wrote:
> > From: Zhang Yi <yi.z.zhang@intel.com>
> > 
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index 4052532..5faab48 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -146,4 +146,19 @@ config FPGA_DFL
> >  	  Gate Array (FPGA) solutions which implement Device Feature List.
> >  	  It provides enumeration APIs, and feature device infrastructure.
> >  
> > +config FPGA_DFL_PCI
> > +	tristate "FPGA DFL PCIe Device Driver"
> > +	depends on PCI && FPGA_DFL
> > +	help
> > +	  Select this option to enable PCIe driver for PCIe based
> 
> 	                                               PCIe-based
> 
> > +	  Field-Programmable Gate Array (FPGA) solutions which implemented
> 
> 	                                                 which implement

Hi Randy

Thanks for the comments on these patches, I will fix them all in the next
version.

Hao

> 
> > +	  the Device Feature List (DFL). This driver provides interfaces
> > +	  for userspace applications to configure, enumerate, open and access
> > +	  FPGA accelerators on the FPGA DFL devices, enables system level
> > +	  management functions such as FPGA partial reconfiguration, power
> > +	  management, and virtualization with DFL framework and DFL feature
> > +	  device drivers.
> > +
> > +	  To compile this as a module, choose M here.
> > +
> >  endif # FPGA
> 
> 
> -- 
> ~Randy
