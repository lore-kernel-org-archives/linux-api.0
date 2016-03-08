From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH] firmware: qemu_fw_cfg.c: hold ACPI global lock
 during device access
Date: Mon, 7 Mar 2016 16:02:15 -0800
Message-ID: <20160308000215.GA11917@kroah.com>
References: <20160307235543.GD2049@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160307235543.GD2049-h65ZQ0r4j6KKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 07, 2016 at 06:55:43PM -0500, Gabriel Somlo wrote:
> Allowing for the future possibility of implementing AML-based
> (i.e., firmware-triggered) access to the QEMU fw_cfg device,
> acquire the global ACPI lock when accessing the device on behalf
> of the guest-side sysfs driver, to prevent any potential race
> conditions.
> 
> Suggested-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> ---
> 
> Turns out, there *is* a way to acquire a global ACPI lock from within
> a "random" kernel driver after all. Luckily I have a healthy dose of
> respect for Michael's opinions :) so I kept circling back through
> existing kernel sources for an example I can use, and I think this
> might be it.
> 
> I'm posting as RFC because I'm not really confident about assessing
> the likelihood of there ever being a race condition between the kernel
> fw_cfg sysfs driver and firmware on my own. Obviously Michael has
> concerns about it, but any additional opinions from the QEMU camp would
> be much appreciated.
> 
> Thanks again,
>  --Gabriel
> 
>  drivers/firmware/qemu_fw_cfg.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
> index 7bba76c..cc4c27a 100644
> --- a/drivers/firmware/qemu_fw_cfg.c
> +++ b/drivers/firmware/qemu_fw_cfg.c
> @@ -77,12 +77,26 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
>  static inline void fw_cfg_read_blob(u16 key,
>  				    void *buf, loff_t pos, size_t count)
>  {
> +#ifdef CONFIG_ACPI
> +	u32 glk;
> +	int status;
> +	status = acpi_acquire_global_lock(ACPI_WAIT_FOREVER, &glk);

Why not fix up the ACPI api to not require #ifdef here?  It should be
added to a .h file somewhere instead.


> +	if (ACPI_FAILURE(status)) {
> +		/* Should never get here */
> +		WARN(1, "fw_cfg_read_blob: Failed to lock ACPI!\n");
> +		memset(buf, 0, count);
> +		return;
> +	}
> +#endif
>  	mutex_lock(&fw_cfg_dev_lock);
>  	iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
>  	while (pos-- > 0)
>  		ioread8(fw_cfg_reg_data);
>  	ioread8_rep(fw_cfg_reg_data, buf, count);
>  	mutex_unlock(&fw_cfg_dev_lock);
> +#ifdef CONFIG_ACPI
> +	acpi_release_global_lock(glk);

Same here.

thanks,

greg k-h
