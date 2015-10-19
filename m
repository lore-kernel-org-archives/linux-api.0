From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 1/5] MPI: fix off by one in mpi_read_raw_from_sgl
Date: Mon, 19 Oct 2015 16:25:29 -0700
Message-ID: <56257BE9.7000303@intel.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
 <3192672.E3TvJmsW94@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <3192672.E3TvJmsW94@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/18/2015 03:45 AM, Stephan Mueller wrote:
> The patch fixes the analysis of the input data which contains an off
> by one.
> 
> The issue is visible when the SGL contains one byte per SG entry.
> The code for checking for zero bytes does not operate on the data byte.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  lib/mpi/mpicoder.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index c20ef27..c7e0a70 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -446,8 +446,11 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int len)
>  		const u8 *buff = sg_virt(sg);
>  		int len = sg->length;
>  
> -		while (len-- && !*buff++)
> +		while (len && !*buff) {
>  			lzeros++;
> +			len--;
> +			buff++;
> +		}
>  
>  		if (len && *buff)
>  			break;

ACK. Thanks for testing this Stephan.
