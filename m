From: Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Fri, 16 Jan 2015 12:11:08 +0100
Message-ID: <20150116111108.GG30960@localhost>
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-doc-owner@vger.kernel.org
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Johan Hovold <johan@kernel.org>, Alexandre Courbot <gnurou@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
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
> Hi Linus, Johan,
> 
> I rebased my patch. And things look good.

I took at closer look at this patch now and I really don't think it
should be merged at all.

We have a mechanism for handling wake-up sources (documented in
Documentation/power/devices.txt) as well as an ABI to enable/disable
them using the power/wakeup device attribute from userspace.

Implementing proper wakeup support for unclaimed GPIOs would take some
work (if at all desired), but that is not a reason to be adding custom
implementations that violates the kernel's power policies and new ABIs
that would need to be maintained forever.

[ And we really shouldn't be adding anything to the broken gpio sysfs
interface until it's been redesigned. ]

Meanwhile you can (should) use gpio-keys if you need to wake your system
on gpio events.

> But the 'is_visible' things does not behave the way I expected it to.
> It seems to be only triggered on an export but not when attributes
> change. Hence, in my case, everything was visiible since the inital
> state matches that, but even when changing the direction or things
> like that, attributes don't disappear. Is that something still worked
> on? Expected

That's expected. We generally don't want attributes to appear or
disappear after the device has been registered (although there is a
mechanism for cases were it makes sense). This is no different from
how your v3 patch worked either.

Johan
