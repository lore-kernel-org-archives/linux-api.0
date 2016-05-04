From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 13/13] iio: health/afe4404: ENSEPGAIN is part of CONTROL2
 register
Date: Wed, 4 May 2016 11:14:29 +0100
Message-ID: <3030afe0-c4a1-f2a4-4e3f-ebb0d9808dc6@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-14-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-14-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:37, Andrew F. Davis wrote:
> Rename this definition, no functional changes.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
Applied.
> ---
>  drivers/iio/health/afe4404.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 3a8131d..4526640 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -48,8 +48,8 @@
>  #define AFE4404_AVG_LED2_ALED2VAL	0x3f
>  #define AFE4404_AVG_LED1_ALED1VAL	0x40
>  
> -/* AFE4404 CONTROL3 register fields */
> -#define AFE440X_CONTROL3_OSC_ENABLE	BIT(9)
> +/* AFE4404 CONTROL2 register fields */
> +#define AFE440X_CONTROL2_OSC_ENABLE	BIT(9)
>  
>  enum afe4404_fields {
>  	/* Gains */
> @@ -398,7 +398,7 @@ static const struct reg_sequence afe4404_reg_sequences[] = {
>  	AFE4404_TIMING_PAIRS,
>  	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
>  	{ AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN },
> -	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
> +	{ AFE440X_CONTROL2, AFE440X_CONTROL2_OSC_ENABLE	},
>  };
>  
>  static const struct regmap_range afe4404_yes_ranges[] = {
> 
