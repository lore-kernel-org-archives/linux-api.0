From: Joel Stanley <joel@jms.id.au>
Subject: Re: [patch v15 3/4] Documentation: jtag: Add bindings for Aspeed SoC
 24xx and 25xx families JTAG master driver
Date: Thu, 11 Jan 2018 09:50:19 -0800
Message-ID: <CACPK8XfH-4r0mBQYA+BwvUo2+RF8igai2jy+RqTDQcxx2-acsQ@mail.gmail.com>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com> <1514202808-29747-4-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514202808-29747-4-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, devicetree <devicetree@vger.kernel.org>, OpenBMC Maillist <openbmc@lists.ozlabs.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, mchehab@kernel.org, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 25, 2017 at 3:53 AM, Oleksandr Shamray
<oleksandrs@mellanox.com> wrote:
> It has been tested on Mellanox system with BMC equipped with
> Aspeed 2520 SoC for programming CPLD devices.
>
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> v14->v15
> v13->v14
> v12->v13
> v11->v12
> v10->v11
> v9->v10
> v8->v9
> v7->v8
> Comments pointed by pointed by Joel Stanley <joel.stan@gmail.com>
> - Change compatible string to ast2400 and ast2000
>
> V6->v7
> Comments pointed by Tobias Klauser <tklauser@distanz.ch>
>  - Fix spell "Doccumentation" -> "Documentation"
>
> v5->v6
> Comments pointed by Tobias Klauser <tklauser@distanz.ch>
> - Small nit: s/documentation/Documentation/
>
> v4->v5
>
> V3->v4
> Comments pointed by Rob Herring <robh@kernel.org>
> - delete unnecessary "status" and "reg-shift" descriptions in
>   bndings file
>
> v2->v3
> Comments pointed by Rob Herring <robh@kernel.org>
> - split Aspeed jtag driver and binding to sepatrate patches
> - delete unnecessary "status" and "reg-shift" descriptions in
>   bndings file
> ---
>  .../devicetree/bindings/jtag/aspeed-jtag.txt       |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/jtag/aspeed-jtag.txt
>
> diff --git a/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt b/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt
> new file mode 100644
> index 0000000..8cfc610
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/jtag/aspeed-jtag.txt
> @@ -0,0 +1,18 @@
> +Aspeed JTAG driver for ast2400 and ast2500 SoC
> +
> +Required properties:
> +- compatible:          Should be one of
> +      - "aspeed,ast2400-jtag"
> +      - "aspeed,ast2500-jtag"
> +- reg                  contains the offset and length of the JTAG memory
> +                       region
> +- clocks               root clock of bus, should reference the APB clock
> +- interrupts           should contain JTAG controller interrupt
> +
> +Example:
> +jtag: jtag@1e6e4000 {
> +       compatible = "aspeed,ast2500-jtag";
> +       reg = <0x1e6e4000 0x1c>;
> +       clocks = <&clk_apb>;

We've now got a proper clock driver upstream. Can you update the
example to match the newly added bindings?

 clocks = <&syscon ASPEED_CLK_APB>;

Cheers,

Joel
