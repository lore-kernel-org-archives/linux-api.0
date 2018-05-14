From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [patch v20 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 14 May 2018 11:01:36 -0700
Message-ID: <338d958b-f3c3-15b8-32b9-9d30bfb348b5@infradead.org>
References: <1526314803-3532-1-git-send-email-oleksandrs@mellanox.com>
 <1526314803-3532-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1526314803-3532-2-git-send-email-oleksandrs@mellanox.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>, gregkh@linuxfoundation.org, arnd@arndb.de
Cc: system-sw-low-level@mellanox.com, devicetree@vger.kernel.org, jiri@resnulli.us, vadimp@mellanox.com, linux-api@vger.kernel.org, openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org, openocd-devel-owner@lists.sourceforge.net, Jiri Pirko <jiri@mellanox.com>, robh+dt@kernel.org, joel@jms.id.au, linux-serial@vger.kernel.org, tklauser@distanz.ch, mchehab@kernel.org, davem@davemloft.net, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 05/14/2018 09:20 AM, Oleksandr Shamray wrote:

Hi,
Just a bit more Kconfig fixing below.

> ---
>  Documentation/ioctl/ioctl-number.txt |    2 +
>  MAINTAINERS                          |   10 ++
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/jtag/Kconfig                 |   18 +++
>  drivers/jtag/Makefile                |    1 +
>  drivers/jtag/jtag.c                  |  274 ++++++++++++++++++++++++++++++++++
>  include/linux/jtag.h                 |   41 +++++
>  include/uapi/linux/jtag.h            |  105 +++++++++++++
>  9 files changed, 454 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/jtag/Kconfig
>  create mode 100644 drivers/jtag/Makefile
>  create mode 100644 drivers/jtag/jtag.c
>  create mode 100644 include/linux/jtag.h
>  create mode 100644 include/uapi/linux/jtag.h

> diff --git a/drivers/jtag/Kconfig b/drivers/jtag/Kconfig
> new file mode 100644
> index 0000000..ba72a2b
> --- /dev/null
> +++ b/drivers/jtag/Kconfig
> @@ -0,0 +1,18 @@
> +menuconfig JTAG
> +	tristate "JTAG support"
> +	help
> +	  This provides basic core functionality support for JTAG class devices

(end sentence above with '.')                                           devices.

> +	  Hardware that is equipped with a JTAG microcontroller can be
> +	  supported by using this driver's interfaces.
> +	  This driver exposes a set of IOCTL to the user space for

	                               IOCTLs

> +	  another commands:

	  various commands:
or
	  the following commands:
or
	  associated commands:

> +	  SDR: (Scan Data Register) Performs an IEEE 1149.1 Data Register scan
> +	  SIR: (Scan Instruction Register) Performs an IEEE 1149.1 Instruction
> +	  Register scan.
> +	  RUNTEST: Forces the IEEE 1149.1 bus to a run state for a specified
> +	  number of clocks or a specified time period.
> +
> +	  If you want this support, you should say Y here.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called jtag.
thanks,
-- 
~Randy
