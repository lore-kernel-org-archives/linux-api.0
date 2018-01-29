From: Julia Cartwright <juliac-SPobxgzVcRdvFhSgSjN+lA@public.gmane.org>
Subject: Re: [patch v18 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 29 Jan 2018 09:56:00 -0600
Message-ID: <20180129155600.GA1924@kryptos.localdomain>
References: <1517236305-4880-1-git-send-email-oleksandrs@mellanox.com>
 <1517236305-4880-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517236305-4880-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 29, 2018 at 04:31:42PM +0200, Oleksandr Shamray wrote:
> Initial patch for JTAG driver
> JTAG class driver provide infrastructure to support hardware/software
> JTAG platform drivers. It provide user layer API interface for flashing
> and debugging external devices which equipped with JTAG interface
> using standard transactions.
> 
> Driver exposes set of IOCTL to user space for:
> - XFER:
> - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
> - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
> - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
>   number of clocks).
> - SIOCFREQ/GIOCFREQ for setting and reading JTAG frequency.
> 
> Driver core provides set of internal APIs for allocation and
> registration:
> - jtag_register;
> - jtag_unregister;
> - jtag_alloc;
> - jtag_free;
> 
> Platform driver on registration with jtag-core creates the next
> entry in dev folder:
> /dev/jtagX
> 
> Signed-off-by: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
[..]
> diff --git a/drivers/jtag/jtag.c b/drivers/jtag/jtag.c
[..]
> +struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
> +{
> +	struct jtag *jtag;
> +
> +	jtag = kzalloc(sizeof(*jtag) + priv_size, GFP_KERNEL);
> +	if (!jtag)
> +		return NULL;
> +
> +	if (!ops)
> +		return NULL;
> +
> +	if (!ops->idle || !ops->mode_set || !ops->status_get || !ops->xfer)
> +		return NULL;

Did you think through this?

You leak 'jtag' here and above.

Perform all the ops checks prior to the allocation.

   Julia
