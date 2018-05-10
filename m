From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [patch v19 1/4] drivers: jtag: Add JTAG core driver
Date: Thu, 10 May 2018 09:09:45 -0700
Message-ID: <a6ff3a11-3fe5-311e-3097-d6477ed86015@infradead.org>
References: <1525967064-10760-1-git-send-email-oleksandrs@mellanox.com>
 <1525967064-10760-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525967064-10760-2-git-send-email-oleksandrs@mellanox.com>
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

On 05/10/2018 08:44 AM, Oleksandr Shamray wrote:
> Initial patch for JTAG driver
> JTAG class driver provide infrastructure to support hardware/software
> JTAG platform drivers. It provide user layer API interface for flashing
> and debugging external devices which equipped with JTAG interface
> using standard transactions.

> ---
>  Documentation/ioctl/ioctl-number.txt |    2 +
>  MAINTAINERS                          |   10 ++
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/jtag/Kconfig                 |   16 ++
>  drivers/jtag/Makefile                |    1 +
>  drivers/jtag/jtag.c                  |  273 ++++++++++++++++++++++++++++++++++
>  include/linux/jtag.h                 |   41 +++++
>  include/uapi/linux/jtag.h            |  105 +++++++++++++
>  9 files changed, 451 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/jtag/Kconfig
>  create mode 100644 drivers/jtag/Makefile
>  create mode 100644 drivers/jtag/jtag.c
>  create mode 100644 include/linux/jtag.h
>  create mode 100644 include/uapi/linux/jtag.h
> 
> diff --git a/drivers/jtag/Kconfig b/drivers/jtag/Kconfig
> new file mode 100644
> index 0000000..5e2c75b
> --- /dev/null
> +++ b/drivers/jtag/Kconfig
> @@ -0,0 +1,16 @@
> +menuconfig JTAG
> +	tristate "JTAG support"
> +	help
> +	  This provides basic core functionality support for jtag class devices

	                                                     JTAG class devices.

> +	  Hardware equipped with JTAG microcontroller which can be built

I'm having problems understanding the line above + first 1/2 of the line below.
Maybe something like:

	  Hardware that is equipped with a JTAG microcontroller can be
	  supported by using this driver's interfaces.

> +	  on top of this drivers. Driver exposes the set of IOCTL to the

	                          This driver exposes a set of IOCTLs to

> +	  user space for:

> +	  SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);

	                                              ^^^^? Instruction?

> +	  SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);

	                                       ^^^^^^^^^^^? Data?

> +	  RUNTEST (Forces IEEE 1149.1 bus to a run state for specified
> +	  number of clocks).
> +
> +	  If you want this support, you should say Y here.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called jtag.


-- 
~Randy
