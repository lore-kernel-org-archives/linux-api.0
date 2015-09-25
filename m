From: Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 03/14] power: bq24257: Streamline input current limit
 setup
Date: Fri, 25 Sep 2015 16:23:03 +0300
Message-ID: <20150925132302.GD15509@lpalcu-desk>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
 <1443151618-29742-4-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443151618-29742-4-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 24, 2015 at 10:26:47PM -0500, Andreas Dannenberg wrote:
[...]
> -	if (reset_iilimit) {
> +		/* reset input current limit */
>  		ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
>  		if (ret < 0)
>  			goto error;
> -	} else if (config_iilimit) {
> -		schedule_delayed_work(&bq->iilimit_setup_work,
> +	} else if (!old_state.power_good) {
> +		dev_dbg(bq->dev, "Power inserted\n");
> +		if (bq->iilimit_autoset_enable)
iilimit_autoset_enable is introduced in patch 6. If we ever need to
bisect this code, this patch will fail to build.

> +			/* configure input current limit */
> +			schedule_delayed_work(&bq->iilimit_setup_work,
>  				      msecs_to_jiffies(BQ24257_ILIM_SET_DELAY));
> +	} else if (new_state->fault == FAULT_NO_BAT) {
> +		dev_warn(bq->dev, "Battery removed\n");
> +	} else if (new_state->fault == FAULT_TIMER) {
> +		dev_err(bq->dev, "Safety timer expired! Battery dead?\n");
>  	}
>  
>  	return;

laurentiu
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
