From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [patch v21 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Wed, 16 May 2018 00:00:00 +0300
Message-ID: <CAHp75Ve7EYiWBiE73i0CmyJhPMOdSKsGzCr0SUvta3Uya=Ov1Q@mail.gmail.com>
References: <1526394095-5069-1-git-send-email-oleksandrs@mellanox.com> <1526394095-5069-3-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526394095-5069-3-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, devicetree <devicetree@vger.kernel.org>, openbmc@lists.ozlabs.org, Joel Stanley <joel@jms.id.au>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 15, 2018 at 5:21 PM, Oleksandr Shamray
<oleksandrs@mellanox.com> wrote:
> Driver adds support of Aspeed 2500/2400 series SOC JTAG master controller.
>
> Driver implements the following jtag ops:
> - freq_get;
> - freq_set;
> - status_get;
> - idle;
> - xfer;
>
> It has been tested on Mellanox system with BMC equipped with
> Aspeed 2520 SoC for programming CPLD devices.

> +#define ASPEED_JTAG_DATA               0x00
> +#define ASPEED_JTAG_INST               0x04
> +#define ASPEED_JTAG_CTRL               0x08
> +#define ASPEED_JTAG_ISR                        0x0C
> +#define ASPEED_JTAG_SW                 0x10
> +#define ASPEED_JTAG_TCK                        0x14
> +#define ASPEED_JTAG_EC                 0x18
> +
> +#define ASPEED_JTAG_DATA_MSB           0x01
> +#define ASPEED_JTAG_DATA_CHUNK_SIZE    0x20


> +#define ASPEED_JTAG_IOUT_LEN(len)      (ASPEED_JTAG_CTL_ENG_EN |\
> +                                        ASPEED_JTAG_CTL_ENG_OUT_EN |\
> +                                        ASPEED_JTAG_CTL_INST_LEN(len))

Better to read

#define MY_COOL_CONST_OR_MACRO(xxx) \
 ...

> +#define ASPEED_JTAG_DOUT_LEN(len)      (ASPEED_JTAG_CTL_ENG_EN |\
> +                                        ASPEED_JTAG_CTL_ENG_OUT_EN |\
> +                                        ASPEED_JTAG_CTL_DATA_LEN(len))

Ditto.

> +static char *end_status_str[] = {"idle", "ir pause", "drpause"};

> +static int aspeed_jtag_freq_set(struct jtag *jtag, u32 freq)
> +{
> +       struct aspeed_jtag *aspeed_jtag = jtag_priv(jtag);
> +       unsigned long apb_frq;
> +       u32 tck_val;
> +       u16 div;
> +
> +       apb_frq = clk_get_rate(aspeed_jtag->pclk);

> +       div = (apb_frq % freq == 0) ? (apb_frq / freq) - 1 : (apb_frq / freq);

Isn't it the same as

div = (apb_frq - 1) / freq;

?

> +       tck_val = aspeed_jtag_read(aspeed_jtag, ASPEED_JTAG_TCK);
> +       aspeed_jtag_write(aspeed_jtag,
> +                         (tck_val & ASPEED_JTAG_TCK_DIVISOR_MASK) | div,
> +                         ASPEED_JTAG_TCK);
> +       return 0;
> +}

> +static void aspeed_jtag_sw_delay(struct aspeed_jtag *aspeed_jtag, int cnt)
> +{
> +       int i;
> +
> +       for (i = 0; i < cnt; i++)
> +               aspeed_jtag_read(aspeed_jtag, ASPEED_JTAG_SW);

Isn't it readsl() (or how it's called, I don't remember).

> +}

> +static void aspeed_jtag_wait_instruction_pause(struct aspeed_jtag *aspeed_jtag)
> +{
> +       wait_event_interruptible(aspeed_jtag->jtag_wq, aspeed_jtag->flag &
> +                                ASPEED_JTAG_ISR_INST_PAUSE);

In such cases I prefer to see a new line with a parameter in full.
Check all places.

> +       aspeed_jtag->flag &= ~ASPEED_JTAG_ISR_INST_PAUSE;
> +}

> +static void aspeed_jtag_sm_cycle(struct aspeed_jtag *aspeed_jtag, const u8 *tms,
> +                                int len)
> +{
> +       int i;
> +
> +       for (i = 0; i < len; i++)
> +               aspeed_jtag_tck_cycle(aspeed_jtag, tms[i], 0);
> +}
> +
> +static void aspeed_jtag_run_test_idle_sw(struct aspeed_jtag *aspeed_jtag,
> +                                        struct jtag_run_test_idle *runtest)
> +{
> +       static const u8 sm_pause_irpause[] = {1, 1, 1, 1, 0, 1, 0};
> +       static const u8 sm_pause_drpause[] = {1, 1, 1, 0, 1, 0};
> +       static const u8 sm_idle_irpause[] = {1, 1, 0, 1, 0};
> +       static const u8 sm_idle_drpause[] = {1, 0, 1, 0};
> +       static const u8 sm_pause_idle[] = {1, 1, 0};
> +       int i;
> +
> +       /* SW mode from idle/pause-> to pause/idle */
> +       if (runtest->reset) {
> +               for (i = 0; i < ASPEED_JTAG_RESET_CNTR; i++)
> +                       aspeed_jtag_tck_cycle(aspeed_jtag, 1, 0);
> +       }

I would rather split this big switch to a few helper functions per
each status of surrounding switch.

> +
> +       /* Stay on IDLE for at least  TCK cycle */
> +       for (i = 0; i < runtest->tck; i++)
> +               aspeed_jtag_tck_cycle(aspeed_jtag, 0, 0);
> +}


> +/**
> + * aspeed_jtag_run_test_idle:
> + * JTAG reset: generates at least 9 TMS high and 1 TMS low to force
> + * devices into Run-Test/Idle State.
> + */

It's rather broken kernel doc.

> +               aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_CTL_ENG_EN |
> +                                 ASPEED_JTAG_CTL_ENG_OUT_EN |
> +                                 ASPEED_JTAG_CTL_FORCE_TMS, ASPEED_JTAG_CTRL);

> +               aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_EC_GO_IDLE,
> +                                 ASPEED_JTAG_EC);

> +       aspeed_jtag_write(aspeed_jtag, ASPEED_JTAG_SW_MODE_EN |
> +                         ASPEED_JTAG_SW_MODE_TDIO, ASPEED_JTAG_SW);

Here you have permutations of flag some of which are repeatetive in
the code. Perhaps make additional definitions instead.
Check other similar places.


> +       char          tdo;

Indentation.

> +       if (xfer->direction == JTAG_READ_XFER)
> +               tdi = UINT_MAX;
> +       else
> +               tdi = data[index];

> +                       if (xfer->direction == JTAG_READ_XFER)
> +                               tdi = UINT_MAX;
> +                       else
> +                               tdi = data[index];

Take your time to think how the above duplication can be avoided.

> +               }
> +       }
> +
> +       tdo = aspeed_jtag_tck_cycle(aspeed_jtag, 1, tdi & ASPEED_JTAG_DATA_MSB);
> +       data[index] |= tdo << (shift_bits % ASPEED_JTAG_DATA_CHUNK_SIZE);
> +}


> +       if (endstate != JTAG_STATE_IDLE) {

Why not to use positive check?

> +       int i;
> +
> +       for (i = 0; i <= xfer->length / BITS_PER_BYTE; i++) {
> +               pos += snprintf(&dbg_str[pos], sizeof(dbg_str) - pos,
> +                               "0x%02x ", xfer_data[i]);
> +       }

Oh, NO! Consider reading printk-formats (for %*ph) and other
documentation about available APIs.

> +       if (!(aspeed_jtag->mode & JTAG_XFER_HW_MODE)) {
> +               /* SW mode */

This is rather too complex to be in one function.

> +       } else {

> +               /* hw mode */
> +               aspeed_jtag_write(aspeed_jtag, 0, ASPEED_JTAG_SW);
> +               aspeed_jtag_xfer_hw(aspeed_jtag, xfer, data);

For symmetry it might be another function.

> +       }

> +       dev_dbg(aspeed_jtag->dev, "status %x\n", status);

Perhaps someone should become familiar with tracepoints?

> +               dev_err(aspeed_jtag->dev, "irq status:%x\n",
> +                       status);


Huh, really?! SPAM.

(I would drop it completely, though you may use ratelimited variant)

> +               ret = IRQ_NONE;
> +       }
> +       return ret;
> +}

> +       clk_prepare_enable(aspeed_jtag->pclk);

This might fail.

> +       dev_dbg(&pdev->dev, "IRQ %d.\n", aspeed_jtag->irq);

Noise even for debug.

> +       err = jtag_register(jtag);

Perhaps we might have devm_ variant of this. Check how SPI framework
deal with a such.

> +static int aspeed_jtag_remove(struct platform_device *pdev)
> +{

> +       struct jtag *jtag;
> +
> +       jtag = platform_get_drvdata(pdev);

Usually we put this on one line

> +       aspeed_jtag_deinit(pdev, jtag_priv(jtag));
> +       jtag_unregister(jtag);
> +       jtag_free(jtag);
> +       return 0;
> +}


-- 
With Best Regards,
Andy Shevchenko
