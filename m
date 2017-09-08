From: Joel Stanley <joel@jms.id.au>
Subject: Re: [patch v7 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Fri, 8 Sep 2017 13:06:57 +0930
Message-ID: <CACPK8XeV9aBY+avimjiOsKZgzj-C6MTeaR0tJC-Tu+zWiAoWPw@mail.gmail.com>
References: <1504281966-6199-1-git-send-email-oleksandrs@mellanox.com> <1504281966-6199-3-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504281966-6199-3-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, devicetree <devicetree@vger.kernel.org>, OpenBMC Maillist <openbmc@lists.ozlabs.org>, jiri@resnulli.us, Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org, mec@shout.net, vadimp@maellanox.com, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, mchehab@kernel.org, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

Hello Oleksandr,

On Sat, Sep 2, 2017 at 1:36 AM, Oleksandr Shamray
<oleksandrs@mellanox.com> wrote:
> Driver adds support of Aspeed 2500/2400 series SOC JTAG master controller.

Looks good. I have some small comments. The most important is the
compatible string.


> --- a/drivers/jtag/Kconfig
> +++ b/drivers/jtag/Kconfig
> @@ -14,3 +14,16 @@ menuconfig JTAG
>
>           To compile this driver as a module, choose M here: the module will
>           be called jtag.
> +
> +menuconfig JTAG_ASPEED
> +       tristate "Aspeed SoC JTAG controller support"
> +       depends on JTAG && HAS_IOMEM

You could add this if you want:

 depends ARCH_ASPEED || COMPILE_TEST

> +       ---help---
> +         This provides a support for Aspeed JTAG device, equipped on
> +         Aspeed SoC 24xx and 25xx families. Drivers allows programming
> +         of hardware devices, connected to SoC through the JTAG interface.
> +

> +
> +static char *end_status_str[] = {"idle", "ir pause", "drpause"};
> +
> +static u32 aspeed_jtag_read(struct aspeed_jtag *aspeed_jtag, u32 reg)
> +{
> +       return readl(aspeed_jtag->reg_base + reg);
> +}
> +
> +static void
> +aspeed_jtag_write(struct aspeed_jtag *aspeed_jtag, u32 val, u32 reg)
> +{
> +       writel(val, aspeed_jtag->reg_base + reg);
> +}
> +
> +static int aspeed_jtag_freq_set(struct jtag *jtag, __u32 freq)

What's the __u32 for (the __ part)?

> +{
> +       struct aspeed_jtag *aspeed_jtag = jtag_priv(jtag);
> +       unsigned long apb_frq;
> +       u32 tck_val;
> +       u16 div;
> +
> +       apb_frq = clk_get_rate(aspeed_jtag->pclk);
> +       div = (apb_frq % freq == 0) ? (apb_frq / freq) - 1 : (apb_frq / freq);
> +       tck_val = aspeed_jtag_read(aspeed_jtag, ASPEED_JTAG_TCK);
> +       aspeed_jtag_write(aspeed_jtag,
> +                         (tck_val & ASPEED_JTAG_TCK_DIVISOR_MASK) | div,
> +                         ASPEED_JTAG_TCK);
> +       return 0;
> +}

> +
> +static int aspeed_jtag_xfer(struct jtag *jtag, struct jtag_xfer *xfer)
> +{
> +       static const char sm_update_shiftir[] = {1, 1, 0, 0};
> +       static const char sm_update_shiftdr[] = {1, 0, 0};
> +       static const char sm_pause_idle[] = {1, 1, 0};
> +       static const char sm_pause_update[] = {1, 1};

Nit: I was confused by the char, perhaps u8?

> +int aspeed_jtag_init(struct platform_device *pdev,
> +                    struct aspeed_jtag *aspeed_jtag)
> +{
> +       struct resource *res;
> +       int err;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       aspeed_jtag->reg_base = devm_ioremap_resource(aspeed_jtag->dev, res);
> +       if (IS_ERR(aspeed_jtag->reg_base)) {
> +               err = -ENOMEM;
> +               goto out_region;

Can you just return here?

> +       }
> +
> +       aspeed_jtag->pclk = devm_clk_get(aspeed_jtag->dev, NULL);
> +       if (IS_ERR(aspeed_jtag->pclk)) {
> +               dev_err(aspeed_jtag->dev, "devm_clk_get failed\n");
> +               return PTR_ERR(aspeed_jtag->pclk);
> +       }
> +
> +       clk_prepare_enable(aspeed_jtag->pclk);
> +
> +       aspeed_jtag->irq = platform_get_irq(pdev, 0);
> +       if (aspeed_jtag->irq < 0) {
> +               dev_err(aspeed_jtag->dev, "no irq specified\n");
> +               err = -ENOENT;
> +               goto out_region;
> +       }
> +
> +       /* Enable clock */
> +       aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_CTL_ENG_EN |
> +                         ASPEED_JTAG_CTL_ENG_OUT_EN, ASPEED_JTAG_CTRL);
> +       aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_SW_MODE_EN |
> +                         ASPEED_JTAG_SW_MODE_TDIO, ASPEED_JTAG_SW);
> +
> +       err = devm_request_irq(aspeed_jtag->dev, aspeed_jtag->irq,
> +                              aspeed_jtag_interrupt, 0,
> +                              "aspeed-jtag", aspeed_jtag);
> +       if (err) {
> +               dev_err(aspeed_jtag->dev, "aspeed_jtag unable to get IRQ");
> +               goto out_region;
> +       }

Can we grab the IRQ before enabling the clock? If not, we should
disable the clock in the error path.


> +       dev_dbg(&pdev->dev, "aspeed_jtag:IRQ %d.\n", aspeed_jtag->irq);
> +
> +       aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_ISR_INST_PAUSE |
> +                         ASPEED_JTAG_ISR_INST_COMPLETE |
> +                         ASPEED_JTAG_ISR_DATA_PAUSE |
> +                         ASPEED_JTAG_ISR_DATA_COMPLETE |
> +                         ASPEED_JTAG_ISR_INST_PAUSE_EN |
> +                         ASPEED_JTAG_ISR_INST_COMPLETE_EN |
> +                         ASPEED_JTAG_ISR_DATA_PAUSE_EN |
> +                         ASPEED_JTAG_ISR_DATA_COMPLETE_EN,
> +                         ASPEED_JTAG_ISR);
> +
> +       aspeed_jtag->flag = 0;
> +       init_waitqueue_head(&aspeed_jtag->jtag_wq);
> +       return 0;
> +
> +out_region:
> +       release_mem_region(res->start, resource_size(res));

I don't think this is necessary.

> +       return err;
> +}
> +
> +int aspeed_jtag_deinit(struct platform_device *pdev,
> +                      struct aspeed_jtag *aspeed_jtag)
> +{
> +       aspeed_jtag_write(aspeed_jtag, 0, ASPEED_JTAG_ISR);
> +       devm_free_irq(aspeed_jtag->dev, aspeed_jtag->irq, aspeed_jtag);

The IRQ freeing happen automatically thanks to devm.

> +       /* Disabe clock */

Disable

> +       aspeed_jtag_write(aspeed_jtag, 0, ASPEED_JTAG_CTRL);
> +       clk_disable_unprepare(aspeed_jtag->pclk);
> +       return 0;
> +}
> +
> +static const struct jtag_ops aspeed_jtag_ops = {
> +       .freq_get = aspeed_jtag_freq_get,
> +       .freq_set = aspeed_jtag_freq_set,
> +       .status_get = aspeed_jtag_status_get,
> +       .idle = aspeed_jtag_idle,
> +       .xfer = aspeed_jtag_xfer
> +};
> +
> +static int aspeed_jtag_probe(struct platform_device *pdev)
> +{
> +       struct aspeed_jtag *aspeed_jtag;
> +       struct jtag *jtag;
> +       int err;
> +
> +       if (!of_device_is_compatible(pdev->dev.of_node, "aspeed,aspeed-jtag"))
> +               return -ENOMEM;
> +
> +       jtag = jtag_alloc(sizeof(*aspeed_jtag), &aspeed_jtag_ops);
> +       if (!jtag)
> +               return -ENODEV;
> +
> +       platform_set_drvdata(pdev, jtag);
> +       aspeed_jtag = jtag_priv(jtag);
> +       aspeed_jtag->dev = &pdev->dev;
> +
> +       /* Initialize device*/
> +       err = aspeed_jtag_init(pdev, aspeed_jtag);
> +       if (err)
> +               goto err_jtag_init;
> +
> +       /* Initialize JTAG core structure*/
> +       err = jtag_register(jtag);
> +       if (err)
> +               goto err_jtag_register;
> +
> +       return 0;
> +
> +err_jtag_register:
> +       aspeed_jtag_deinit(pdev, aspeed_jtag);
> +err_jtag_init:
> +       jtag_free(jtag);
> +       return err;
> +}
> +
> +static int aspeed_jtag_remove(struct platform_device *pdev)
> +{
> +       struct jtag *jtag;
> +
> +       jtag = platform_get_drvdata(pdev);
> +       aspeed_jtag_deinit(pdev, jtag_priv(jtag));
> +       jtag_unregister(jtag);
> +       jtag_free(jtag);
> +       return 0;
> +}
> +
> +static const struct of_device_id aspeed_jtag_of_match[] = {
> +       { .compatible = "aspeed,aspeed2400-jtag", },
> +       { .compatible = "aspeed,aspeed2500-jtag", },

The convention is to use ast2500 for our compatible strings, so these should be:

 aspeed,ast2500-jtag
 aspeed,ast2400-jtag

Cheers,

Joel
