From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v8 14/14] Documentation: power: bq24257: Document exported
 sysfs entries
Date: Tue, 29 Sep 2015 15:22:29 +0900
Message-ID: <560A2E25.70004@samsung.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
 <1443479642-23712-15-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-15-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

W dniu 29.09.2015 o 07:34, Andreas Dannenberg pisze:
> Document the settings exported by bq24257 charger driver through sysfs
> entries:
> - ovp_voltage
> - in_dpm_voltage
> - high_impedance_enable
> - sysoff_enable
> 
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-class-power | 58 +++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
> index 369d2a2..d96b5fc 100644
> --- a/Documentation/ABI/testing/sysfs-class-power
> +++ b/Documentation/ABI/testing/sysfs-class-power
> @@ -74,3 +74,61 @@ Description:
>  
>  		Valid values:
>  		- 0 - 70 (minutes), step by 10 (rounded down)
> +
> +What:		/sys/class/power_supply/bq24257-charger/ovp_voltage
> +Date:		September 2015
> +KernelVersion: 4.3.0

Date: October 2015 (yes, the future)
Kernel 4.4. We are already at 4.3 cycle so it won't go into 4.3.

Rest looks good:

Reviewed-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Best regards,
Krzysztof


> +Contact:	Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> +Description:
> +		This entry configures the overvoltage protection feature of bq24257-
> +		type charger devices. This feature protects the device and other
> +		components against damage from overvoltage on the input supply. See
> +		device datasheet for details.
> +
> +		Valid values:
> +		- 6000000, 6500000, 7000000, 8000000, 9000000, 9500000, 10000000,
> +		  10500000 (all uV)
> +
> +What:		/sys/class/power_supply/bq24257-charger/in_dpm_voltage
> +Date:		September 2015
> +KernelVersion: 4.3.0
> +Contact:	Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> +Description:
> +		This entry configures the input dynamic power path management voltage of
> +		bq24257-type charger devices. Once the supply drops to the configured
> +		voltage, the input current limit is reduced down to prevent the further
> +		drop of the supply. When the IC enters this mode, the charge current is
> +		lower than the set value. See device datasheet for details.
> +
> +		Valid values:
> +		- 4200000, 4280000, 4360000, 4440000, 4520000, 4600000, 4680000,
> +		  4760000 (all uV)
> +
> +What:		/sys/class/power_supply/bq24257-charger/high_impedance_enable
> +Date:		September 2015
> +KernelVersion: 4.3.0
> +Contact:	Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> +Description:
> +		This entry allows enabling the high-impedance mode of bq24257-type
> +		charger devices. If enabled, it places the charger IC into low power
> +		standby mode with the switch mode controller disabled. When disabled,
> +		the charger operates normally. See device datasheet for details.
> +
> +		Valid values:
> +		- 1: enabled
> +		- 0: disabled
> +
> +What:		/sys/class/power_supply/bq24257-charger/sysoff_enable
> +Date:		September 2015
> +KernelVersion: 4.3.0
> +Contact:	Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> +Description:
> +		This entry allows enabling the sysoff mode of bq24257-type charger
> +		devices. If enabled and the input is removed, the internal battery FET
> +		is turned off in order to reduce the leakage from the BAT pin to less
> +		than 1uA. Note that on some devices/systems this disconnects the battery
> +		from the system. See device datasheet for details.
> +
> +		Valid values:
> +		- 1: enabled
> +		- 0: disabled
> 
