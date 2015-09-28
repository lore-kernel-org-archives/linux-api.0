From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v7 04/15] power: bq24257: Use managed power supply
 register
Date: Mon, 28 Sep 2015 22:10:16 +0900
Message-ID: <56093C38.6040309@samsung.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-5-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443196460-26156-5-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

W dniu 26.09.2015 o 00:54, Andreas Dannenberg pisze:
> Use the devm_* managed version of the function to register the power
> supply and remove the associated unregister function.

Add explanation for "why" you want to use devm method.

After that:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Best regards,
Krzysztof

> 
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/power/bq24257_charger.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
> index d2d077c..6757b41 100644
> --- a/drivers/power/bq24257_charger.c
> +++ b/drivers/power/bq24257_charger.c
> @@ -590,8 +590,10 @@ static int bq24257_power_supply_init(struct bq24257_device *bq)
>  	psy_cfg.supplied_to = bq24257_charger_supplied_to;
>  	psy_cfg.num_supplicants = ARRAY_SIZE(bq24257_charger_supplied_to);
>  
> -	bq->charger = power_supply_register(bq->dev, &bq24257_power_supply_desc,
> -					    &psy_cfg);
> +	bq->charger = devm_power_supply_register(bq->dev,
> +						 &bq24257_power_supply_desc,
> +						 &psy_cfg);
> +
>  	if (IS_ERR(bq->charger))
>  		return PTR_ERR(bq->charger);
>  
> @@ -742,8 +744,6 @@ static int bq24257_remove(struct i2c_client *client)
>  
>  	cancel_delayed_work_sync(&bq->iilimit_setup_work);
>  
> -	power_supply_unregister(bq->charger);
> -
>  	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */
>  
>  	return 0;
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
