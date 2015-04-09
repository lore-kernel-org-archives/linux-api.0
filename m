From: Tal Shorer <tal.shorer@gmail.com>
Subject: Re: [PATCH v2 4/4] Documentation: ABI: Fix documentation for
 mass_storage function
Date: Thu, 9 Apr 2015 11:32:24 +0300
Message-ID: <CAFDyS3P+c=hNKJZdQcaPDdh2sW=dCNkn6PPFTZxdh5HO8r7ehA@mail.gmail.com>
References: <1428494808-12566-1-git-send-email-k.opasiak@samsung.com>
	<1428494808-12566-5-git-send-email-k.opasiak@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428494808-12566-5-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: balbi@ti.com, "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>, jlbec@evilplan.org, andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 8, 2015 at 3:06 PM, Krzysztof Opasiak <k.opasiak@samsung.com> wrote:
> Luns in mass storage function are identified using their id.
> While creating lun's directory user cannot choose any arbitrary
> name other than arabic numeral from 1 to FSG_MAX_LUNS.
>
> Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
> ---
>  .../ABI/testing/configfs-usb-gadget-mass-storage   |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> index 9931fb0..0b54280 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> @@ -11,10 +11,15 @@ Description:
>                                 are 2..4. Available only if
>                                 CONFIG_USB_GADGET_DEBUG_FILES is set.
>
> -What:          /config/usb-gadget/gadget/functions/mass_storage.name/lun.name
> +What:          /config/usb-gadget/gadget/functions/mass_storage.name/lun.id
>  Date:          Oct 2013
>  KernelVersion: 3.13
>  Description:
> +               id - arabic numeral from 1 to FSG_MAX_LUNS
I think "decimal number" or "decimal value" would be easier to understand.
> +               (which is 8 by default) - 1. LUNs should be numbered contiguously.
> +               lun.0 is reserved for default lun which appears while creating
> +               mass_storage.name directory and cannot be removed by the user.
> +
>                 The attributes:
>
>                 file            - The path to the backing file for the LUN.
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
