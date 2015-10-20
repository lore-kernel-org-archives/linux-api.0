From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2 1/5] MPI: fix off by one in mpi_read_raw_from_sgl
Date: Tue, 20 Oct 2015 22:20:22 +0800
Message-ID: <20151020142022.GD7625@gondor.apana.org.au>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
 <3192672.E3TvJmsW94@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3192672.E3TvJmsW94-Veo+UhszpQh6vwJ5+F2VIg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 18, 2015 at 12:45:18PM +0200, Stephan Mueller wrote:
> The patch fixes the analysis of the input data which contains an off
> by one.
> 
> The issue is visible when the SGL contains one byte per SG entry.
> The code for checking for zero bytes does not operate on the data byte.
> 
> Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
