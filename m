From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch v9 0/4] JTAG driver introduction
Date: Thu, 28 Sep 2017 11:02:10 +0200
Message-ID: <CAMuHMdX1HNym4n67y2VbZqFDLHFGunfRp-LPn0g2K4qhya_w9g@mail.gmail.com>
References: <1505985932-27568-1-git-send-email-oleksandrs@mellanox.com>
 <CAMuHMdWfoYzWPJYaGOhF8qshKhvngwFKs=kvuH62PYif9q9+0g@mail.gmail.com> <AM4PR0501MB2194D67623C640E20B3A7FABB1790@AM4PR0501MB2194.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AM4PR0501MB2194D67623C640E20B3A7FABB1790@AM4PR0501MB2194.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, Joel Stanley <joel@jms.id.au>, Jiri Pirko <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "mec@shout.net" <mec@shout.net>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level <system-sw-low-level@mellanox.com>, Rob Herring <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owner@lists.sourceforge.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Oleksandr,

On Thu, Sep 28, 2017 at 10:53 AM, Oleksandr Shamray
<oleksandrs@mellanox.com> wrote:
>> [My attention was drawn by
>> https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flwn.net
>> %2FArticles%2F734440%2F&data=02%7C01%7Coleksandrs%40mellanox.com%7
>> C97b8ba88686a42daaace08d5064b92eb%7Ca652971c7d2e4d9ba6a4d149256f
>> 461b%7C0%7C0%7C636421844026854216&sdata=TeHD4a3%2FBN6a5XG3Jizf5
>> pmsyJHJjzkEzkpnqsXC6S0%3D&reserved=0]
>> [CC linux-spi, which was never included, while linux-serial was]
>>
>> On Thu, Sep 21, 2017 at 11:25 AM, Oleksandr Shamray
>> <oleksandrs@mellanox.com> wrote:
>> > When a need raise up to use JTAG interface for system's devices
>> > programming or CPU debugging, usually the user layer application
>> > implements jtag protocol by bit-bang or using a proprietary connection
>> > to vendor hardware.
>> > This method can be slow and not generic.
>> >
>
>
> [..]
>
>> >
>> > Initial version provides the system calls set for:
>> > - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
>> > - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
>> > - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
>> >   number of clocks.
>> >
>> > SoC which are not equipped with JTAG master interface, can be built on
>> > top of JTAG core driver infrastructure, by applying bit-banging of
>> > TDI, TDO, TCK and TMS pins within the hardware specific driver.
>>
>> Or by using an SPI master?
>>
>
> I think it depends on how flexible the SPI interface is. If you can set it to transfer
> from 1 to n bits at a time, and you control the TMS line in software, you should
> be able to use it. If the SPI interface can only transfer a multiple of 8 bits
> at a time, then in general it would not be suitable for JTAG.

Sure, that depends on the actual SPI master interface.
But I guess you can write a generic JTAG-over-SPI driver, and use a tms-gpios
property in DT to specify how to control TMS.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
