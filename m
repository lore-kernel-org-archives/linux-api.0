From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 4/4] Documentation: ABI:
 /sys/firmware/devicetree/overlays
Date: Fri, 24 Apr 2015 22:31:21 +0200
Message-ID: <20150424203121.GB14970@kroah.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1429868744-19863-5-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429868744-19863-5-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 12:45:44PM +0300, Pantelis Antoniou wrote:
> Documentation ABI entry for overlays sysfs entries.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  .../ABI/testing/sysfs-firmware-devicetree-overlays | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
> new file mode 100644
> index 0000000..6b81f1c
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
> @@ -0,0 +1,23 @@
> +What:		/sys/firmware/devicetree/overlays/
> +Date:		March 2015
> +Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> +Description:
> +		This directory contains the applied device tree overlays of
> +		the running system, as directories of the overlay id.

"as"?

> +
> +		enable: The master enable switch, by default is 1, and when
> +		        set to 0 it cannot be re-enabled for security reasons.

What are those reasons?

thanks,

greg k-h
