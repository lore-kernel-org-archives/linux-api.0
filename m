From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [patch v9 0/4] JTAG driver introduction
Date: Thu, 28 Sep 2017 10:33:18 +0200
Message-ID: <CAMuHMdWfoYzWPJYaGOhF8qshKhvngwFKs=kvuH62PYif9q9+0g@mail.gmail.com>
References: <1505985932-27568-1-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505985932-27568-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, Vadim Pasternak <vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>l
List-Id: linux-api@vger.kernel.org

Hi Oleksandr,

[My attention was drawn by https://lwn.net/Articles/734440/]
[CC linux-spi, which was never included, while linux-serial was]

On Thu, Sep 21, 2017 at 11:25 AM, Oleksandr Shamray
<oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> When a need raise up to use JTAG interface for system's devices
> programming or CPU debugging, usually the user layer
> application implements jtag protocol by bit-bang or using a
> proprietary connection to vendor hardware.
> This method can be slow and not generic.
>
> We propose to implement general JTAG interface and infrastructure
> to communicate with user layer application. In such way, we can
> have the standard JTAG interface core part and separation from
> specific HW implementation.
> This allow new capability to debug the CPU or program system's
> device via BMC without additional devices nor cost.
>
> This patch purpose is to add JTAG master core infrastructure by
> defining new JTAG class and provide generic JTAG interface
> to allow hardware specific drivers to connect this interface.
> This will enable all JTAG drivers to use the common interface
> part and will have separate for hardware implementation.
>
> The JTAG (Joint Test Action Group) core driver provides minimal generic
> JTAG interface, which can be used by hardware specific JTAG master
> controllers. By providing common interface for the JTAG controllers,
> user space device programing is hardware independent.
>
> Modern SoC which in use for embedded system' equipped with
> internal JTAG master interface.
> This interface is used for programming and debugging system's
> hardware components, like CPLD, FPGA, CPU, voltage and
> industrial controllers.
> Firmware for such devices can be upgraded through JTAG interface during
> Runtime. The JTAG standard support for multiple devices programming,
> is in case their lines are daisy-chained together.
>
> For example, systems which equipped with host CPU, BMC SoC or/and
> number of programmable devices are capable to connect a pin and
> select system components dynamically for programming and debugging,
> This is using by the BMC which is equipped with internal SoC master
> controller.
> For example:
>
> BMC JTAG master --> pin selected to CPLDs chain for programming (filed
> upgrade, production)
> BMC JTAG master --> pin selected to voltage monitors for programming
> (field upgrade, production)
> BMC JTAG master --> pin selected to host CPU (on-site debugging
> and developers debugging)
>
> For example, we can have application in user space which using calls
> to JTAG driver executes CPLD programming directly from SVF file
>
> The JTAG standard (IEEE 1149.1) defines the next connector pins:
> - TDI (Test Data In);
> - TDO (Test Data Out);
> - TCK (Test Clock);
> - TMS (Test Mode Select);
> - TRST (Test Reset) (Optional);
>
> The SoC equipped with JTAG master controller, performs
> device programming on command or vector level. For example
> a file in a standard SVF (Serial Vector Format) that contains
> boundary scan vectors, can be used by sending each vector
> to the JTAG interface and the JTAG controller will execute
> the programming.
>
> Initial version provides the system calls set for:
> - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
> - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
> - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
>   number of clocks.
>
> SoC which are not equipped with JTAG master interface, can be built
> on top of JTAG core driver infrastructure, by applying bit-banging of
> TDI, TDO, TCK and TMS pins within the hardware specific driver.

Or by using an SPI master?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
