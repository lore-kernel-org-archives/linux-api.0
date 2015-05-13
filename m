From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 4/5] doc: ABI: bone_capemgr sysfs API
Date: Wed, 13 May 2015 04:52:59 -0700
Message-ID: <20150513115259.GA1021@kroah.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1431503985-31853-5-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431503985-31853-5-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Robert Nelson <robertcnelson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Geert Uytterhoeven <geert+renesas-gXvu3+zWzMSzQB+pC5nmwQ@public.gmane.org>, =?iso-8859-1?Q?Beno=EEt?= Cousso <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 10:59:44AM +0300, Pantelis Antoniou wrote:
> Document the beaglebone's capemgr sysfs API
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> ---
>  .../testing/sysfs-devices-platform-bone_capemgr    | 63 ++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
> new file mode 100644
> index 0000000..e2df613
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
> @@ -0,0 +1,63 @@
> +What:		/sys/devices/platform/bone_capemgr/slots
> +Date:		May 2015
> +KernelVersion:	4.0

I don't think that version is correct :)

> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> +Description:
> +		READ:
> +		  Describe the state of all the slots of the beaglebone capemgr.
> +		  Each line of the output describes a slot:

sysfs files are "one value per file", so a sysfs file that displays
multiple lines like this is not allowed at all, sorry.

Please either make it a debugfs file (if this is only for debugging, or
split it out into individual files, one per slot (hint, one per slot is
probably best.)

> +		  The slot format is as following:
> +		  <slot-id>: [P-][F-][O-][l-][L-][D-] \
> +			  <overlay-id> <board-name>,<version>,
> +			  <manufacturer>,<part-number>
> +
> +		Where the flags are:
> +		P: Slot has been probed
> +		F: Slot has failed probing (i.e. no EEPROM detected)
> +		O: Slot has been overridden by the user
> +		l: Slot is current loading
> +		L: Slot has completed loading and is ready
> +		D: Slot has been disabled
> +
> +		Example:
> +		0: P---L-  -1 BeagleBone RS232 CAPE,00A1,Beagleboardtoys,BB-BONE-SERL-03
> +		1: PF----  -1
> +		2: PF----  -1
> +		3: PF----  -1
> +
> +		WRITE:
> +		  Writing a string of the form <part-number>[:version] issues a request to
> +		  load a firmware blob containing an overlay. The name of the firmware blob
> +		  is <part-number>-[version|00A0].dtbo. This act is defined as a slot override.
> +
> +		  Writing a negative slot id removes the slot if it was an overridden one, or
> +		  unloads a slot that was probed.
> +
> +What:		/sys/devices/platform/bone_capemgr/baseboard/<eeprom-field>
> +Date:		May 2015
> +KernelVersion:	4.0
> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> +Description:	Contains the probed base board EEPROM field; one of:
> +		board-name		- board-name as stored in cape EEPROM
> +		dc-supplied		- whether the cape draws or supplies DC
> +		eeprom-format-revision	- EEPROM format rev, only 00A0 supported
> +		header			- header; should be 'aa 55 33 ee'

If it's always this value, why have the file?

> +		manufacturer		- manufacturer string
> +		part-number		- part-number of the cape
> +		serial-number		- serial number of the cape
> +		version			- version of the cape, i.e. 00A0
> +		number-of-pins		- displayed but ignored
> +		pin-usage		- displayed but ignored
> +		sys-5v			- displayed but ignored
> +		vdd-3v3exp		- displayed but ignored
> +		vdd-5v			- displayed but ignored

Are these all individual different files?

> +What:		/sys/devices/platform/bone_capemgr/slot-<n>/<eeprom-field>

No blank line?

> +Date:		May 2015
> +KernelVersion:	4.0
> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> +Description:	Contains the probed cape's EEPROM field; the field is one of:
> +		board-name		- baseboard name i.e. A335BNLT
> +		header			- header; should be 'aa 55 33 ee'
> +		revision		- baseboard revision
> +		serial-number		- baseboard serial number
> +		config-option		- displayed but ignored

Same here, are these all individual files?

thanks,

greg k-h
