From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH]: MUX n_gsm debug print improvements
Date: Mon, 29 Jun 2015 18:11:18 +0200
Message-ID: <0D037329-0F84-428A-91AA-9E2077099528@holtmann.org>
References: <1435593298.25711.4.camel@tldlab125>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435593298.25711.4.camel@tldlab125>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Gwenn_Bourr=C3=A9e?= <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Gwenn,

> Please review the following patch:
> 
> From 0ac5da0a4653f43ce4b0761a2be8073185c549bb Mon Sep 17 00:00:00 2001
> From: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Mon, 29 Jun 2015 16:09:06 +0200
> Subject: [PATCH] Add Debug define
> 
> Improve the debug print out and make be clearest
> 
> Signed-off-by: Gwenn Bourree <gwenn.bourree-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mustapha Ben Zoubeir <mustaphax.ben.zoubeir-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Nicolas LOUIS <nicolasx.louis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ravindran, Arun <arun.ravindran-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> 
> ---
> drivers/tty/n_gsm.c | 49
> ++++++++++++++++++++++++++++---------------------
> 1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 382d3fc..d6e0ea0 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -66,17 +66,18 @@
> static int debug;
> module_param(debug, int, 0600);
> 
> -/* Defaults: these are from the specification */
> +#define GSMDBG_VERBOSE_PACKET_REPORT(x) ((x) &  1)
> +#define GSMDBG_FORCE_CARRIER(x)         ((x) &  2)
> +#define GSMDBG_DATA_FULL_REPORT(x)      ((x) &  4)
> +#define GSMDBG_DLCI_STREAM_REPORT(x)    ((x) &  8)
> +#define GSMDBG_DLCI_DATA_REPORT(x)      ((x) & 16)
> +#define GSMDBG_DATA_LEN_REPORT(x)       ((x) & 32)

what is actually wrong with just using dynamic debug. That lets you easily switch on certain debug statements. I would actually remove all of this and rely completely on dynamic debug instead.

Anyway, there are also BIT(0), BIT(1) etc. choices that would be a lot clearer than 1, 2, 4 etc.

Regards

Marcel
