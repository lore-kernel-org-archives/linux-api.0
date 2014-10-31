From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 31 Oct 2014 08:03:56 +0100
Message-ID: <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Soren Brinkmann <soren.brinkmann@xilinx.com>, linux-api@vger.kernel.org
Cc: Alexandre Courbot <gnurou@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 27, 2014 at 7:30 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation
> v2:
>  - fix error path to unlock mutex before return
(...)

Looking better!

> +       "wakeup" ... reads as either "enabled" or "disabled". Write these
> +               strings to set/clear the 'wakeup' flag of the IRQ associated
> +               with this GPIO. If the IRQ has the 'wakeup' flag set, it can
> +               wake the system from sleep states.
> +
> +               This file exists only if the pin can generate interrupts and
> +               the driver implements the required infrastructure.

Should this not be 0/1 rather than the string "enabled"/"disabled"?

I think that is the common pattern in sysfs?

Not sure, but want an indication from the ABI people.

Yours,
Linus Walleij
