From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [PATCH v2] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Wed, 18 Mar 2015 17:21:04 +0100
Message-ID: <2231139.ojeyer6qnI@ws-stein>
References: <1426694157-10866-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426694157-10866-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Kepplinger <martink@posteo.de>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martin.kepplinger@theobroma-systems.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

On Wednesday 18 March 2015 16:55:57, Martin Kepplinger wrote:
> From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
> 
> The MMA8653FC is a low-power, three-axis, capacitive micromachined
> accelerometer with 10 bits of resolution with flexible user-programmable
> options.
> 
> Embedded interrupt functions enable overall power savings, by relieving the
> host processor from continuously polling data, for example using the poll()
> system call.
> 
> The device can be configured to generate wake-up interrupt signals from any
> combination of the configurable embedded functions, enabling the MMA8653FC
> to monitor events while remaining in a low-power mode during periods of
> inactivity.
> 
> This driver provides devicetree properties to program the device's behaviour
> and a simple, tested and documented sysfs interface. The data sheet and more
> information is available on Freescale's website.
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
> Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
> ---
> applies to v4.0-rc4 and the current -next.
> 
> patch revision history
> ......................
> v2 corrects licensing and commit messages and adds appropriate recipients
> 
>  .../testing/sysfs-bus-i2c-devices-fsl-mma8653fc    |  39 +
>  .../devicetree/bindings/misc/fsl,mma8653fc.txt     |  96 +++
>  MAINTAINERS                                        |   5 +
>  drivers/input/misc/Kconfig                         |  11 +
>  drivers/input/misc/Makefile                        |   1 +
>  drivers/input/misc/mma8653fc.c                     | 913 +++++++++++++++++++++
>  6 files changed, 1065 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-fsl-mma8653fc
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
>  create mode 100644 drivers/input/misc/mma8653fc.c

Shouldn't this go to drivers/iio/magnetometer instead of defining a new sysfs ABI?

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082
