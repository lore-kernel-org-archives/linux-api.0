From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 07/13] iio: health/afe4404: Remove LED3 input channel
Date: Wed, 4 May 2016 11:04:52 +0100
Message-ID: <67d4be1c-29a4-16a4-5425-7a200694ab8f@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-8-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-8-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> Input channel LED3 is only an alias for stage ALED2, this virtual channel
> does nothing for us, remove this channel.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
Again, abi change, but I doubt anyone will notice *fingers crossed* ;)

Jonathan
> ---
>  drivers/iio/health/afe4404.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index b9c1666..2edb7d7 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -126,7 +126,6 @@ enum afe4404_chan_id {
>  	ALED1,
>  	LED2,
>  	ALED2,
> -	LED3,
>  	LED1_ALED1,
>  	LED2_ALED2,
>  	ILED1,
> @@ -139,7 +138,6 @@ static const struct afe440x_reg_info afe4404_reg_info[] = {
>  	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
>  	[LED2] = AFE440X_REG_INFO(AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2),
>  	[ALED2] = AFE440X_REG_INFO(AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED2),
> -	[LED3] = AFE440X_REG_INFO(AFE440X_ALED2VAL, 0, NULL),
>  	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
>  	[LED2_ALED2] = AFE440X_REG_INFO(AFE440X_LED2_ALED2VAL, 0, NULL),
>  	[ILED1] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1),
> @@ -153,7 +151,6 @@ static const struct iio_chan_spec afe4404_channels[] = {
>  	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
>  	AFE440X_INTENSITY_CHAN(LED2, "led2", BIT(IIO_CHAN_INFO_OFFSET)),
>  	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> -	AFE440X_INTENSITY_CHAN(LED3, "led3", BIT(IIO_CHAN_INFO_OFFSET)),
>  	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
>  	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
>  	/* LED current */
> 
