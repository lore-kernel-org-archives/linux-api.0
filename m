From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH v10 0/2] crypto: AF_ALG: add AEAD and RNG support
Date: Wed, 14 Jan 2015 12:26:32 -0500
Message-ID: <20150114172632.GB24512@localhost.localdomain>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de>
 <20150114094631.GB15294@localhost.localdomain>
 <20150114110011.GA18099@gondor.apana.org.au>
 <5006702.rWOQQ5L1VO@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5006702.rWOQQ5L1VO-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 14, 2015 at 04:31:44PM +0100, Stephan Mueller wrote:
> Am Mittwoch, 14. Januar 2015, 22:00:11 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Jan 14, 2015 at 04:46:31AM -0500, Neil Horman wrote:
> > > On Wed, Jan 14, 2015 at 04:52:29AM +0100, Stephan Mueller wrote:
> > > > Hi,
> > > > 
> > > > This patch set adds AEAD and RNG support to the AF_ALG interface
> > > > exported by the kernel crypto API. By extending AF_ALG with AEAD and RNG
> > > > support, all cipher types the kernel crypto API allows access to are
> > > > now accessible from userspace.
> > > > 
> > > >  crypto/Kconfig      |   9 +
> > > >  crypto/Makefile     |   1 +
> > > >  crypto/algif_aead.c | 680
> > > >  ++++++++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed,
> > > >  690 insertions(+)
> > > >  create mode 100644 crypto/algif_aead.c
> > > 
> > > Where are the RNG bits?
> > 
> > They've already been merged.
> 
> Please also see my change log for v7:
> ...
> * RNG: patch dropped as it was applied
> ...
> 
> To ensure consistency, I did not change the intro part of my description.
Ah, thanks for the clarification
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

> 
> > 
> > Cheers,
> 
> 
> -- 
> Ciao
> Stephan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
