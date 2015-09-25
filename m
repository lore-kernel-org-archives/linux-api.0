From: Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: Re: [PATCH v6 08/14] power: bq24257: Use managed power supply
 register
Date: Fri, 25 Sep 2015 16:43:16 +0300
Message-ID: <20150925134316.GE15509@lpalcu-desk>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
 <1443151618-29742-9-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443151618-29742-9-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Andreas Dannenberg <dannenberg@ti.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 24, 2015 at 10:26:52PM -0500, Andreas Dannenberg wrote:
[...] 
> -	bq->charger = power_supply_register(bq->dev, &bq24257_power_supply_desc,
> -					    &psy_cfg);
> +	bq->charger = devm_power_supply_register(bq->dev,
> +						 &bq24257_power_supply_desc,
> +						 &psy_cfg);
> +
>  	if (IS_ERR(bq->charger))
>  		return PTR_ERR(bq->charger);
This is unrelated but, since we're here and if you ever send another
version for these patches, we could change these two lines (and the 'return
0' that follows) to just:

return PTR_ERR_OR_ZERO(bq->charger);

laurentiu
