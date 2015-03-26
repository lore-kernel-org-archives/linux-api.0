From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v5] add support for Freescale's MMA8653FC 10 bit
 accelerometer
Date: Thu, 26 Mar 2015 23:19:44 +0100
Message-ID: <20150326221944.GA7322@kroah.com>
References: <1426936150-2439-1-git-send-email-martink@posteo.de>
 <1426937164-10997-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426937164-10997-1-git-send-email-martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Kepplinger <martink-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org>
Cc: benjamin.tissoires-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexander.stein-93q1YBGzJSMe9JSWTWOYM3xStJ4P+DSV@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>, Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 21, 2015 at 12:26:04PM +0100, Martin Kepplinger wrote:
> From: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
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
> Signed-off-by: Martin Kepplinger <martin.kepplinger-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
> Signed-off-by: Christoph Muellner <christoph.muellner-SN7IsUiht6C/RdPyistoZJqQE7yCjDx5@public.gmane.org>
> ---
> 
> Still, I was missing the drivers/staging Makefile addition. This applies and
> builds automatically.

You sent 4 different copies of a "v5" patch, which kind of defeats the
whole purpose of a "v" number...

All of them now deleted from my todo queue, get it together and send a
correct one, properly numbered.

thanks,

greg k-h
