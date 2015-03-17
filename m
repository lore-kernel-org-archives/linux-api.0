From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] add support for Freescale's MMA8653FC 10 bit
 accelerometer
Date: Tue, 17 Mar 2015 20:26:00 +0100
Message-ID: <20150317192600.GC3611@kroah.com>
References: <1426612146-7836-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426612146-7836-1-git-send-email-martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 06:09:06PM +0100, Martin Kepplinger wrote:
> From: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
> 
> Signed-off-by: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
> Signed-off-by: Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
> ---
>  .../testing/sysfs-bus-i2c-devices-fsl-mma8653fc    |  36 +
>  .../devicetree/bindings/misc/fsl,mma8653fc.txt     |  95 +++
>  MAINTAINERS                                        |   6 +
>  drivers/input/misc/Kconfig                         |  11 +
>  drivers/input/misc/Makefile                        |   1 +
>  drivers/input/misc/mma8653fc.c                     | 907 +++++++++++++++++++++
>  6 files changed, 1056 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-fsl-mma8653fc
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,mma8653fc.txt
>  create mode 100644 drivers/input/misc/mma8653fc.c

Please use scripts/get_maintainer.pl to determine that I am not the
person to send this to.  Hint, it's an input device, send it to the
linux-input mailing list...

And you need a changelog entry it can't be blank.

good luck,

greg k-h
