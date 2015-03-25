From: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 1/5] usb: phy: twl4030: make runtime pm more reliable.
Date: Thu, 26 Mar 2015 03:02:21 +0530
Message-ID: <55132965.3090002@ti.com>
References: <20150322223307.21765.62974.stgit@notabene.brown> <20150322223523.21765.3199.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322223523.21765.3199.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Cc: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Monday 23 March 2015 04:05 AM, NeilBrown wrote:
> From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> 
> A construct like:
> 
>         if (pm_runtime_suspended(twl->dev))
>                pm_runtime_get_sync(twl->dev);
> 
> is against the spirit of the runtime_pm interface as it
> makes the internal refcounting useless.
> 
> In this case it is also racy, particularly as 'put_autosuspend'
> is use to drop a reference.
> When that happens a timer is started and the device is
> runtime-suspended after the timeout.
> If the above code runs in this window, the device will not be
> found to be suspended so no pm_runtime reference is taken.
> When the timer expires the device will be suspended, which is
> against the intention of the code.
> 
> So be more direct is taking and dropping references.
> If twl->linkstat is VBUS_VALID or ID_GROUND, then hold a
> pm_runtime reference, otherwise don't.
> Define "cable_present()" to test for this condition.

minor comment below..
> 
> Tested-by: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/phy/phy-twl4030-usb.c |   29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
> index 8e87f54671f3..1a244f34b748 100644
> --- a/drivers/phy/phy-twl4030-usb.c
> +++ b/drivers/phy/phy-twl4030-usb.c
> @@ -144,6 +144,16 @@
>  #define PMBR1				0x0D
>  #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
>  
> +/*
> + * If VBUS is valid or ID is ground, then we know a
> + * cable is present and we need to be runtime-enabled
> + */
> +static inline bool cable_present(enum omap_musb_vbus_id_status stat)

twl4030_cable_present?

-Kishon
