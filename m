From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v15 0/4] JTAG driver introduction
Date: Mon, 25 Dec 2017 15:17:50 -0800
Message-ID: <4425f51e-d3b3-3555-7afd-5dd1b1e698fa@gmail.com>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514202808-29747-1-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

Le 12/25/17 à 03:53, Oleksandr Shamray a écrit :
> When a need raise up to use JTAG interface for system's devices
> programming or CPU debugging, usually the user layer
> application implements jtag protocol by bit-bang or using a 
> proprietary connection to vendor hardware.
> This method can be slow and not generic.
>  
> We propose to implement general JTAG interface and infrastructure
> to communicate with user layer application. In such way, we can
> have the standard JTAG interface core part and separation from
> specific HW implementation.

Well, the framework in its current shape is still extremely simplistic,
therefore leaving a lot of room (read: bugs, inconsistencies) within the
hands of the driver, so while the user-space interface is standard
through the proposed character device, the user experience, likely might
not.

> This allow new capability to debug the CPU or program system's 
> device via BMC without additional devices nor cost. 

If that is the case, should not we leverage the kernel's device driver
model and expect the JTAG framework to create specific devices for the
different pieces of HW discovered on the scan chain? That would also
presumably allow the core JTAG framework to retain the necessary state
changes in order to address one particular device within the scan chain.

> 
> This patch purpose is to add JTAG master core infrastructure by 
> defining new JTAG class and provide generic JTAG interface
> to allow hardware specific drivers to connect this interface.
> This will enable all JTAG drivers to use the common interface
> part and will have separate for hardware implementation.

Let's consider I want to get rid of OpenOCD, or rather, move its driver
interface within the kernel and replace it on the OpenOCD side with a
generic character device interface. I could presumably amortize the
costly operations which are currently I/O and/or system call limiting
when running in user-space, what would it look like with your proposed
framework, have you given some thoughts about that?

Thanks!
-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
