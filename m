From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH v8 12/14] power: bq24257: Add various device-specific
 sysfs properties
Date: Tue, 29 Sep 2015 15:15:47 +0900
Message-ID: <560A2C93.7030505@samsung.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
 <1443479642-23712-13-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443479642-23712-13-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Andreas Dannenberg <dannenberg@ti.com>, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

W dniu 29.09.2015 o 07:34, Andreas Dannenberg pisze:
> This patch adds support for enabling/disabling optional device specific
> features through sysfs properties at runtime.
> 
> * High-impedance mode enable/disable
> * Sysoff enable/disable
> 
> Refer to the respective device datasheets for more information:
> 
> http://www.ti.com/product/bq24250
> http://www.ti.com/product/bq24251
> http://www.ti.com/product/bq24257
> 
> Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
> ---
>  drivers/power/bq24257_charger.c | 53 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>

Looks okay now:

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


