From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v7 2/4] drivers: jtag: Add Aspeed SoC 24xx and 25xx
 families JTAG master driver
Date: Wed, 6 Sep 2017 22:52:26 +0200
Message-ID: <CAK8P3a1Ym1UxbFyeUBrSBeHnoQh9NtBn5r6iVEjU_1ki_p3W5A@mail.gmail.com>
References: <1504281966-6199-1-git-send-email-oleksandrs@mellanox.com> <1504281966-6199-3-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504281966-6199-3-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: gregkh <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org, OpenBMC Maillist <openbmc@lists.ozlabs.org>, Joel Stanley <joel@jms.id.au>, =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>, Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org, mec@shout.net, vadimp@maellanox.com, system-sw-low-level@mellanox.com, Rob Herring <robh+dt@kernel.org>, openocd-devel-owner@lists.sourceforge.net, Linux API <linux-api@vger.kernel.org>, David Miller <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 1, 2017 at 6:06 PM, Oleksandr Shamray
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

No further comments about this driver, if there is agreement about the subsystem
in general, it looks good to go in.

Acked-by: Arnd Bergmann <arnd@arndb.de

       Arnd
