From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [patch v25 4/4] Documentation: jtag: Add ABI documentation
Date: Tue, 29 May 2018 11:54:30 -0700
Message-ID: <b1afae1e-b93b-3b86-1a45-ab0e408087e1@infradead.org>
References: <1527605618-15705-1-git-send-email-oleksandrs@mellanox.com>
 <1527605618-15705-5-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1527605618-15705-5-git-send-email-oleksandrs@mellanox.com>
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
Cc: system-sw-low-level@mellanox.com, devicetree@vger.kernel.org, jiri@resnulli.us, vadimp@mellanox.com, linux-api@vger.kernel.org, openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org, openocd-devel-owner@lists.sourceforge.net, robh+dt@kernel.org, joel@jms.id.au, linux-serial@vger.kernel.org, tklauser@distanz.ch, mchehab@kernel.org, davem@davemloft.net, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 05/29/2018 07:53 AM, Oleksandr Shamray wrote:
> Added document that describe the ABI for JTAG class drivrer

Sorry, there are still a few typos.  Please see below.

> ---
>  Documentation/ABI/testing/gpio-cdev |    1 -
>  Documentation/ABI/testing/jtag-dev  |   23 +++++++
>  Documentation/jtag/overview         |   27 +++++++++
>  Documentation/jtag/transactions     |  109 +++++++++++++++++++++++++++++++++++
>  MAINTAINERS                         |    1 +
>  5 files changed, 160 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/ABI/testing/jtag-dev
>  create mode 100644 Documentation/jtag/overview
>  create mode 100644 Documentation/jtag/transactions
> 

> diff --git a/Documentation/jtag/overview b/Documentation/jtag/overview
> new file mode 100644
> index 0000000..f179095
> --- /dev/null
> +++ b/Documentation/jtag/overview
> @@ -0,0 +1,27 @@
> +Linux kernel JTAG support
> +=========================
> +
> +JTAG is an industry standard for verifying hardware.JTAG provides access to

needs space:
                                              hardware. JTAG provides

> +many logic signals of a complex integrated circuit, including the device pins.
> +
> +A JTAG interface is a special interface added to a chip.
> +Depending on the version of JTAG, two, four, or five pins are added.
> +
> +The connector pins are:
> +	TDI (Test Data In)
> +	TDO (Test Data Out)
> +	TCK (Test Clock)
> +	TMS (Test Mode Select)
> +	TRST (Test Reset) optional
> +
> +JTAG interface is designed to have two parts - basic core driver and
> +hardware specific driver. The basic driver introduces a general interface
> +which is not dependent of specific hardware. It provides communication
> +between user space and hardware specific driver.
> +Each JTAG device is represented as a char device from (jtag0, jtag1, ...).
> +Access to a JTAG device is performed through IOCTL calls.
> +
> +Call flow example:
> +User: open  -> /dev/jatgX
> +User: ioctl -> /dev/jtagX -> JTAG core driver -> JTAG hardware specific driver
> +User: close -> /dev/jatgX

> diff --git a/Documentation/jtag/transactions b/Documentation/jtag/transactions
> new file mode 100644
> index 0000000..c5176a7
> --- /dev/null
> +++ b/Documentation/jtag/transactions
> @@ -0,0 +1,109 @@
> +The JTAG API
> +=============
> +
> +JTAG master devices can be accessed through a character misc-device.
> +Each JTAG master interface can be accessed by using /dev/jtagN.
> +
> +JTAG system calls set:
> +- SIR (Scan Instruction Register, IEEE 1149.1 Instruction Register scan);
> +- SDR (Scan Data Register, IEEE 1149.1 Data Register scan);
> +- RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
> +number of clocks.
> +
> +open(), close()
> +-------
> +open() opens JTAG device.
> +
> +Open/Close  device:
> +- jtag_fd = open("/dev/jtag0", O_RDWR);
> +- close(jtag_fd);
> +
> +ioctl()
> +-------
> +All access operations to JTAG devices are erformed through ioctl interface.

                                             performed

> +The IOCTL interface supports these requests:
> +	JTAG_IOCRUNTEST - Force JTAG state machine to RUN_TEST/IDLE state
> +	JTAG_SIOCFREQ - Set JTAG TCK frequency
> +	JTAG_GIOCFREQ - Get JTAG TCK frequency
> +	JTAG_IOCXFER - send JTAG data Xfer
> +	JTAG_GIOCSTATUS - get current JTAG TAP status
> +	JTAG_SIOCMODE - set JTAG mode flags.



-- 
~Randy
