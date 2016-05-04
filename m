From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 03/13] iio: health/afe440x: Remove unneeded initializers
Date: Wed, 4 May 2016 10:59:58 +0100
Message-ID: <8cfe5a59-b3fd-aa25-d751-defa75aca42e@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-4-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-4-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> The drivers set some register values during initialization that can be
> set at runtime, these defaults were used in testing but are not
> necessary, remove these.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
Fair enough - applied.
> ---
>  drivers/iio/health/afe4403.c | 7 +------
>  drivers/iio/health/afe4404.c | 4 ----
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index e3700cf..5484785 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -472,12 +472,7 @@ static const struct iio_trigger_ops afe4403_trigger_ops = {
>  
>  static const struct reg_sequence afe4403_reg_sequences[] = {
>  	AFE4403_TIMING_PAIRS,
> -	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN | 0x000007},
> -	{ AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES_1_M },
> -	{ AFE440X_LEDCNTRL, (0x14 << AFE440X_LEDCNTRL_LED1_SHIFT) |
> -			    (0x14 << AFE440X_LEDCNTRL_LED2_SHIFT) },
> -	{ AFE440X_CONTROL2, AFE440X_CONTROL2_TX_REF_050 <<
> -			    AFE440X_CONTROL2_TX_REF_SHIFT },
> +	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
>  };
>  
>  static const struct regmap_range afe4403_yes_ranges[] = {
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 783b9b4..2d4c522 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -443,10 +443,6 @@ static const struct iio_trigger_ops afe4404_trigger_ops = {
>  static const struct reg_sequence afe4404_reg_sequences[] = {
>  	AFE4404_TIMING_PAIRS,
>  	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
> -	{ AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES_50_K },
> -	{ AFE440X_LEDCNTRL, (0xf << AFE4404_LEDCNTRL_ILED1_SHIFT) |
> -			    (0x3 << AFE4404_LEDCNTRL_ILED2_SHIFT) |
> -			    (0x3 << AFE4404_LEDCNTRL_ILED3_SHIFT) },
>  	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
>  };
>  
> 
