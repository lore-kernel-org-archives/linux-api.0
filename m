From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RESEND v5 1/6] crypto: AF_ALG -- add sign/verify API
Date: Fri, 06 May 2016 12:36:29 +0200
Message-ID: <1766747.q7yy3uptgu@positron.chronox.de>
References: <20160505195048.1843.7817.stgit@tstruk-mobl1> <20160505195054.1843.11748.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160505195054.1843.11748.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 5. Mai 2016, 12:50:54 schrieb Tadeusz Struk:

Hi Tadeusz, David,

> From: Stephan Mueller <smueller@chronox.de>
> 
> Add the flags for handling signature generation and signature
> verification.
> 
> Also, the patch adds the interface for setting a public key.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

All four patches from me:

Acked-by: Stephan Mueller <smueller@chronox.de>

> ---
>  include/uapi/linux/if_alg.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index f2acd2f..02e6162 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -34,9 +34,12 @@ struct af_alg_iv {
>  #define ALG_SET_OP			3
>  #define ALG_SET_AEAD_ASSOCLEN		4
>  #define ALG_SET_AEAD_AUTHSIZE		5
> +#define ALG_SET_PUBKEY			6
> 
>  /* Operations */
>  #define ALG_OP_DECRYPT			0
>  #define ALG_OP_ENCRYPT			1
> +#define ALG_OP_SIGN			2
> +#define ALG_OP_VERIFY			3
> 
>  #endif	/* _LINUX_IF_ALG_H */


Ciao
Stephan
