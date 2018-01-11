From: Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
Subject: Re: [patch v15 3/4] Documentation: jtag: Add bindings for Aspeed SoC
 24xx and 25xx families JTAG master driver
Date: Thu, 11 Jan 2018 15:54:36 -0800
Message-ID: <CACPK8Xeb3K9PqynV2xymJwvhkZ9fLKsbodEFYiZtQ+SXXgGA5g@mail.gmail.com>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com>
 <1514202808-29747-4-git-send-email-oleksandrs@mellanox.com> <CACPK8XfH-4r0mBQYA+BwvUo2+RF8igai2jy+RqTDQcxx2-acsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACPK8XfH-4r0mBQYA+BwvUo2+RF8igai2jy+RqTDQcxx2-acsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 11, 2018 at 9:50 AM, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org> wrote:
> On Mon, Dec 25, 2017 at 3:53 AM, Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> +jtag: jtag@1e6e4000 {
>> +       compatible = "aspeed,ast2500-jtag";
>> +       reg = <0x1e6e4000 0x1c>;
>> +       clocks = <&clk_apb>;
>
> We've now got a proper clock driver upstream. Can you update the
> example to match the newly added bindings?
>
>  clocks = <&syscon ASPEED_CLK_APB>;
>

I think we need to ensure the reset is deasserted as well. You will need:

 resets = <&syscon ASPEED_RESET_JTAG_MASTER>;

In addition, we need to make sure the reset line is deasserted in the
driver. Take a look at how I did this in the i2c driver:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=edd20e95bca4a5434f264d8ab40d729761479825

+       bus->rst = devm_reset_control_get_shared(&pdev->dev, NULL);
+       if (IS_ERR(bus->rst)) {
+               dev_err(&pdev->dev,
+                       "missing or invalid reset controller device
tree entry");
+               return PTR_ERR(bus->rst);
+       }
+       reset_control_deassert(bus->rst);

Please give this a test with an upstream kernel from a fresh power on.

Cheers,

Joel
