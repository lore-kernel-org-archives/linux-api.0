From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Mon, 19 Oct 2015 09:32:30 +0800
Message-ID: <20151019013230.GA3156@gondor.apana.org.au>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1831785.BBs8Hj3CxY-Veo+UhszpQh6vwJ5+F2VIg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 18, 2015 at 12:44:00PM +0200, Stephan Mueller wrote:
> Hi,
> 
> This patch set adds the AF_ALG user space API to externalize the
> asymmetric cipher API recently added to the kernel crypto API.
> 
> The patch set is tested with the user space library of libkcapi [1].
> Use [1] test/test.sh for a full test run. The test covers the
> following scenarios:

Thanks Stephan.  But I would prefer to defer this til after we have
completed the conversion of current in-kernel users.  This is because
changing the kernel interface is easy while changing the user-space
interface is not.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
