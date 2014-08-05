From: Varka Bhadram <varkabhadram@gmail.com>
Subject: Re: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
Date: Tue, 05 Aug 2014 17:25:31 +0530
Message-ID: <53E0C633.7060600@gmail.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com> <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org, heikki.krogerus@linux.intel.com, alan@linux.intel.com, paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org, dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com, mingo@elte.hu, balbi@ti.com, heiko@sntech.de, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/05/2014 04:24 PM, Matthias Brugger wrote:

(...)

> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/serial_8250.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +#include "8250.h"
> +

Better if we have includes in alphabetical order..

> +#define MTK_UART_RATE_FIX 0x0D /* UART Rate Fix Register */
> +
> +struct mtk8250_data {
> +	int			line;
> +	struct clk		*clk;
> +};
> +
> +static void
> +mtk8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
> +{
> +	if (!state)
> +		pm_runtime_get_sync(port->dev);
> +
> +	serial8250_do_pm(port, state, old);
> +
> +	if (state)
> +		pm_runtime_put_sync_suspend(port->dev);
> +}
> +
> +static int mtk8250_probe_of(struct uart_port *p,
> +			   struct mtk8250_data *data)

static int mtk8250_probe_of(struct uart_port *p,
			    struct mtk8250_data *data)

> +{
> +	int err;
> +	struct device_node	*np = p->dev->of_node;
> +
> +	data->clk = of_clk_get(np, 0);
> +	if (IS_ERR(data->clk)) {
> +		pr_warn("Can't get timer clock");

missed terminating new line...

> +		return PTR_ERR(data->clk);
> +	}
> +
> +	err = clk_prepare_enable(data->clk);
> +	if (err) {
> +		pr_warn("Can't prepare clock");

same...

> +		clk_put(data->clk);
> +		return err;
> +	}
> +	p->uartclk = clk_get_rate(data->clk);
> +
> +	return 0;
> +}

(...)

> +static struct platform_driver mtk8250_platform_driver = {
> +	.driver = {
> +		.name		= "mt6577-uart",
> +		.owner		= THIS_MODULE,

No need to update this field...

> +		.pm		= &mtk8250_pm_ops,
> +		.of_match_table	= mtk8250_of_match,
> +	},
> +	.probe			= mtk8250_probe,
> +	.remove			= mtk8250_remove,
> +};
> +module_platform_driver(mtk8250_platform_driver);
>
-- 
Regards,
Varka Bhadram.

