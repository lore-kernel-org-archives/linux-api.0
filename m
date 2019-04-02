From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH 01/17] fpga: dfl-fme-mgr: fix FME_PR_INTFC_ID register
 address.
Date: Tue, 2 Apr 2019 12:38:45 +0800
Message-ID: <20190402043845.GA24012@hao-dev>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-2-git-send-email-hao.wu@intel.com>
 <20190401195447.GA1910@archbook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190401195447.GA1910@archbook>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: atull@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 01, 2019 at 12:54:47PM -0700, Moritz Fischer wrote:
> Hi Wu,
> 
> On Mon, Mar 25, 2019 at 11:07:28AM +0800, Wu Hao wrote:
> > FME_PR_INTFC_ID is used as compat_id for fpga manager and region,
> > but high 64 bits and low 64 bits of the compat_id are swapped by
> > mistake. This patch fixes this problem by fixing register address.
> > 
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ---
> >  drivers/fpga/dfl-fme-mgr.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/fpga/dfl-fme-mgr.c b/drivers/fpga/dfl-fme-mgr.c
> > index 76f3770..b3f7eee 100644
> > --- a/drivers/fpga/dfl-fme-mgr.c
> > +++ b/drivers/fpga/dfl-fme-mgr.c
> > @@ -30,8 +30,8 @@
> >  #define FME_PR_STS		0x10
> >  #define FME_PR_DATA		0x18
> >  #define FME_PR_ERR		0x20
> > -#define FME_PR_INTFC_ID_H	0xA8
> > -#define FME_PR_INTFC_ID_L	0xB0
> > +#define FME_PR_INTFC_ID_L	0xA8
> > +#define FME_PR_INTFC_ID_H	0xB0
> 
> Does this handle endianess correct?

Hi Moritz,

This is just a bug fixing for wrong offsets given to these 2 registers
according to spec. I think this is not endianess related, and per my
understanding we don't need more code on endianess handling as that
should be done inside the readq function already. :)

Thanks
Hao
