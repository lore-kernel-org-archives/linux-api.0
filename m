From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH v7 00/15] power: bq24257: Add support for bq24250/bq24251
Date: Mon, 28 Sep 2015 21:14:33 +0900
Message-ID: <56092F29.8060106@samsung.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Andreas Dannenberg <dannenberg@ti.com>, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

W dniu 26.09.2015 o 00:54, Andreas Dannenberg pisze:
> This patch series extends the driver to also support bq24250/bq24251.
> 
> The bq24250/251/257 devices have a very similar feature set and are
> virtually identical from a control register point of view so it made
> sense to extend the existing driver rather than submitting a new driver.
> In addition to the new device support the driver is also extended to
> allow access to some device features previously hidden. Basic and
> potentially dangerous charger config parameters affecting the actual
> charging of the Li-Ion battery are only configurable through firmware
> rather than sysfs properties. However some newly introduced properties
> are exposed through sysfs properties as access to them may be desired
> from userspace. For example, it is now possible to manually configure
> the maximum current drawn from the input source to accommodate different
> chargers (0.5A, 1.5A, 2.0A and so on) based on system knowledge a
> userspace application may have rather than rely on the auto-detection
> mechanism that may not work in all possible scenarios.
> 
> Note that most patches have dependencies on other patches in the series.
> 
> v7:
> - Fixed an issue that would have impacted running bisect on the series
>   and double checked the entire series builds one by one by running
>   a git rebase -i --exec="make ..." ... on the Kernel tree
> - Minor simplification of a return from a function
> 
> v6:
> - Removed the ability to configure the IRQ through "stat-gpios"
> - Allow re-configuring the input_current_limit via sysfs also when
>   charger auto-detection is enabled
> - Use gpiod interface for initialization as a platform device (nice
>   GPIO setup simplification)
> - Document all newly introduced sysfs nodes
> - Streamlined/fixed/simplified charger state handling as it relates
>   to battery removal/insertion and the associated handling of the
>   input current limit setting
> - Minor simplifications/cleanup
> - Rebased onto git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-
>   power-supply.git (branch "next") and completely retested

It would be useful if you would mark which patches have changed. I
reviewed already the first patch but you did not add my reviewed-by tag.
I suppose something changed... but I can't find the exact reason for
missing review.

Best regards,
Krzysztof

