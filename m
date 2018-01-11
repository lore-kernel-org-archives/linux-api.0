From: Joel Stanley <joel@jms.id.au>
Subject: Re: [patch v15 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Thu, 11 Jan 2018 09:45:35 -0800
Message-ID: <CACPK8XfFxWy+XvWJNSV3Ouy2WyGe1Hc2QP0bddPenqH_6673hQ@mail.gmail.com>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com> <1514202808-29747-3-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514202808-29747-3-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, devicetree <devicetree@vger.kernel.org>, OpenBMC Maillist <openbmc@lists.ozlabs.org>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, mchehab@kernel.org, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 25, 2017 at 3:53 AM, Oleksandr Shamray
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
>
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Philippe Ombredanne <pombredanne@nexb.com>

Acked-by: Joel Stanley <joel@jms.id.au>

Cheers,

Joel
