From: Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>
Subject: Re: [patch v14 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Fri, 15 Dec 2017 12:04:26 +1030
Message-ID: <CACPK8XdXuqi6Xi+6v==SgpQX7xndeGZ+CGfWr9UF7ppv9zbfAQ@mail.gmail.com>
References: <1513268971-13518-1-git-send-email-oleksandrs@mellanox.com> <1513268971-13518-3-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513268971-13518-3-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenBMC Maillist <openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 15, 2017 at 2:59 AM, Oleksandr Shamray
<oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Driver adds support of Aspeed 2500/2400 series SOC JTAG master controller.

Looks good. I have a few small things below, but I am happy to see
this merged from my point of view as ASPEED maintainer.

Cheers,

Joel


> +
> +menuconfig JTAG_ASPEED
> +       tristate "Aspeed SoC JTAG controller support"
> +       depends on JTAG && HAS_IOMEM

Add ARCH_ASPEED || COMPILE_TEST

> +       ---help---
> +         This provides a support for Aspeed JTAG device, equipped on
> +         Aspeed SoC 24xx and 25xx families. Drivers allows programming
> +         of hardware devices, connected to SoC through the JTAG interface.
> +
> +         If you want this support, you should say Y here.
> +
> +         To compile this driver as a module, choose M here: the module will
> +         be called jtag-aspeed.
> diff --git a/drivers/jtag/Makefile b/drivers/jtag/Makefile
> index af37493..04a855e 100644
> --- a/drivers/jtag/Makefile
> +++ b/drivers/jtag/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_JTAG)             += jtag.o
> +obj-$(CONFIG_JTAG_ASPEED)      += jtag-aspeed.o
> diff --git a/drivers/jtag/jtag-aspeed.c b/drivers/jtag/jtag-aspeed.c
> new file mode 100644
> index 0000000..99277d2
> --- /dev/null
> +++ b/drivers/jtag/jtag-aspeed.c
> @@ -0,0 +1,783 @@


> +static int aspeed_jtag_xfer(struct jtag *jtag, struct jtag_xfer *xfer,
> +                           u8 *xfer_data)
> +{
> +       static const u8 sm_update_shiftir[] = {1, 1, 0, 0};
> +       static const u8 sm_update_shiftdr[] = {1, 0, 0};
> +       static const u8 sm_pause_idle[] = {1, 1, 0};
> +       static const u8 sm_pause_update[] = {1, 1};
> +       struct aspeed_jtag *aspeed_jtag = jtag_priv(jtag);
> +       unsigned long *data = (unsigned long *)xfer_data;
> +       unsigned long remain_xfer = xfer->length;
> +       unsigned long offset;
> +       char dbg_str[256];
> +       int pos = 0;
> +       int i;
> +
> +       for (offset = 0, i = 0; offset < xfer->length;
> +                       offset += ASPEED_JTAG_DATA_CHUNK_SIZE, i++) {

It looks like offset is unused.

> +               pos += snprintf(&dbg_str[pos], sizeof(dbg_str) - pos,
> +                               "0x%08lx ", data[i]);
> +       }
> +
> +       dev_dbg(aspeed_jtag->dev, "aspeed_jtag %s %s xfer, mode:%s, END:%d, len:%lu, TDI[%s]\n",
> +               xfer->type == JTAG_SIR_XFER ? "SIR" : "SDR",
> +               xfer->direction == JTAG_READ_XFER ? "READ" : "WRITE",
> +               aspeed_jtag->mode & JTAG_XFER_HW_MODE ? "HW" : "SW",
> +               xfer->endstate, remain_xfer, dbg_str);
> +
> +       if (!(aspeed_jtag->mode & JTAG_XFER_HW_MODE)) {
> +               /* SW mode */
> +               aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_SW_MODE_EN |
> +                                 ASPEED_JTAG_SW_MODE_TDIO, ASPEED_JTAG_SW);
> +
> +               if (aspeed_jtag->status != JTAG_STATE_IDLE) {
> +                       /*IR/DR Pause->Exit2 IR / DR->Update IR /DR */
> +                       aspeed_jtag_sm_cycle(aspeed_jtag, sm_pause_update,
> +                                            sizeof(sm_pause_update));
> +               }
> +
> +               if (xfer->type == JTAG_SIR_XFER)
> +                       /* ->IRSCan->CapIR->ShiftIR */
> +                       aspeed_jtag_sm_cycle(aspeed_jtag, sm_update_shiftir,
> +                                            sizeof(sm_update_shiftir));
> +               else
> +                       /* ->DRScan->DRCap->DRShift */
> +                       aspeed_jtag_sm_cycle(aspeed_jtag, sm_update_shiftdr,
> +                                            sizeof(sm_update_shiftdr));
> +
> +               aspeed_jtag_xfer_sw(aspeed_jtag, xfer, data);
> +
> +               /* DIPause/DRPause */
> +               aspeed_jtag_tck_cycle(aspeed_jtag, 0, 0);
> +
> +               if (xfer->endstate == JTAG_STATE_IDLE) {
> +                       /* ->DRExit2->DRUpdate->IDLE */
> +                       aspeed_jtag_sm_cycle(aspeed_jtag, sm_pause_idle,
> +                                            sizeof(sm_pause_idle));
> +               }
> +       } else {
> +               /* hw mode */
> +               aspeed_jtag_write(aspeed_jtag, 0, ASPEED_JTAG_SW);
> +               aspeed_jtag_xfer_hw(aspeed_jtag, xfer, data);
> +       }
> +
> +       aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_SW_MODE_EN |
> +                         ASPEED_JTAG_SW_MODE_TDIO, ASPEED_JTAG_SW);
> +       aspeed_jtag->status = xfer->endstate;
> +       return 0;
> +}
>
> +
> +static irqreturn_t aspeed_jtag_interrupt(s32 this_irq, void *dev_id)
> +{
> +       struct aspeed_jtag *aspeed_jtag = dev_id;
> +       irqreturn_t ret;
> +       u32 status;
> +
> +       status = aspeed_jtag_read(aspeed_jtag, ASPEED_JTAG_ISR);
> +       dev_dbg(aspeed_jtag->dev, "status %x\n", status);
> +
> +       if (status & ASPEED_JTAG_ISR_INT_MASK) {
> +               aspeed_jtag_write(aspeed_jtag,
> +                                 (status & ASPEED_JTAG_ISR_INT_MASK)
> +                                 | (status & ASPEED_JTAG_ISR_INT_EN_MASK),
> +                                 ASPEED_JTAG_ISR);
> +               aspeed_jtag->flag |= status & ASPEED_JTAG_ISR_INT_MASK;
> +       }
> +
> +       if (aspeed_jtag->flag) {
> +               wake_up_interruptible(&aspeed_jtag->jtag_wq);
> +               ret = IRQ_HANDLED;
> +       } else {
> +               dev_err(aspeed_jtag->dev, "aspeed_jtag irq status:%x\n",

using dev_err will give you sensible prefixes for any messages that
print out. You could remove "aspeed_jtag" from this any any other
prints you have.

> +                       status);
> +               ret = IRQ_NONE;
> +       }
> +       return ret;
> +}
> +
> +int aspeed_jtag_init(struct platform_device *pdev,
> +                    struct aspeed_jtag *aspeed_jtag)
> +{
> +       struct resource *res;
> +       int err;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       aspeed_jtag->reg_base = devm_ioremap_resource(aspeed_jtag->dev, res);
> +       if (IS_ERR(aspeed_jtag->reg_base))
> +               return -ENOMEM;
> +
> +       aspeed_jtag->pclk = devm_clk_get(aspeed_jtag->dev, NULL);
> +       if (IS_ERR(aspeed_jtag->pclk)) {
> +               dev_err(aspeed_jtag->dev, "devm_clk_get failed\n");
> +               return PTR_ERR(aspeed_jtag->pclk);
> +       }
> +
> +       clk_prepare_enable(aspeed_jtag->pclk);

Can you move this below the platform_get_irq? that way you can return
an error if the getting the IRQ fails, without having to clean up the
clock.

> +
> +       aspeed_jtag->irq = platform_get_irq(pdev, 0);
> +       if (aspeed_jtag->irq < 0) {
> +               dev_err(aspeed_jtag->dev, "no irq specified\n");
> +               err = -ENOENT;
> +               goto clk_unprep;
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
> +               goto clk_unprep;
> +       }
> +       dev_dbg(&pdev->dev, "aspeed_jtag:IRQ %d.\n", aspeed_jtag->irq);

Again, remove the aspeed_jtag prefix.

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
> +       aspeed_jtag->mode = 0;
> +       init_waitqueue_head(&aspeed_jtag->jtag_wq);
> +       return 0;
> +
> +clk_unprep:
> +       clk_disable_unprepare(aspeed_jtag->pclk);
> +       return err;
> +}
> +
> +int aspeed_jtag_deinit(struct platform_device *pdev,
> +                      struct aspeed_jtag *aspeed_jtag)
> +{
> +       aspeed_jtag_write(aspeed_jtag, 0, ASPEED_JTAG_ISR);
> +       /* Disable clock */
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
> +       .xfer = aspeed_jtag_xfer,
> +       .mode_set = aspeed_jtag_mode_set
> +};
> +
> +static int aspeed_jtag_probe(struct platform_device *pdev)
> +{
> +       struct aspeed_jtag *aspeed_jtag;
> +       struct device *dev;
> +       struct jtag *jtag;
> +       int err;
> +
> +       dev = &pdev->dev;
> +       if (!of_device_is_compatible(pdev->dev.of_node,
> +                                    "aspeed,ast2500-jtag") &&
> +           !of_device_is_compatible(pdev->dev.of_node,
> +                                    "aspeed,ast2400-jtag"))
> +               return -ENODEV;

Given the Aspeed device only ever probes with device tree,  can you
drop these redundant checks?

> +
> +       jtag = jtag_alloc(sizeof(*aspeed_jtag), &aspeed_jtag_ops);
> +       if (!jtag)
> +               return -ENOMEM;
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
> +       { .compatible = "aspeed,ast2400-jtag", },
> +       { .compatible = "aspeed,ast2500-jtag", },
> +       {}
> +};
> +
> +static struct platform_driver aspeed_jtag_driver = {
> +       .probe = aspeed_jtag_probe,
> +       .remove = aspeed_jtag_remove,
> +       .driver = {
> +               .name = ASPEED_JTAG_NAME,
> +               .of_match_table = aspeed_jtag_of_match,
> +       },
> +};
> +module_platform_driver(aspeed_jtag_driver);
> +
> +MODULE_AUTHOR("Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
> +MODULE_DESCRIPTION("ASPEED JTAG driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.1
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
