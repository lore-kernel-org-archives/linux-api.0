From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v2] Documentation: sysfs-bus-usb: update power/persist
 description
Date: Wed, 2 Jul 2014 10:36:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407021035480.874-100000@iolanthe.rowland.org>
References: <1404295845.12021.29.camel@x220>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404295845.12021.29.camel@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2 Jul 2014, Paul Bolle wrote:

> There's no power/persist file for hubs. And CONFIG_USB_PERSIST was
> removed in v2.6.26. Update the description of power/persist accordingly.
> Also remove the line on its default value. It is not entirely correct, as
> CONFIG_USB_DEFAULT_PERSIST and the USB_QUIRK_RESET flag influence the
> default. It is not needed to understand this file anyhow.
> 
> Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
> ---
> v2: incorporate Alan's feedback. The clearest way to do that was to not
> mention the default value at all. Trying to do handle the default
> correctly made the text way too complicated. I hope Alan agrees.
> 
> Perhaps the line on hubs should not be added, as the text now states
> that device directories "can" contain this file.
> 
>  Documentation/ABI/stable/sysfs-bus-usb | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
> index a6b685724740..e2bc700a6f9c 100644
> --- a/Documentation/ABI/stable/sysfs-bus-usb
> +++ b/Documentation/ABI/stable/sysfs-bus-usb
> @@ -3,13 +3,13 @@ Date:		May 2007
>  KernelVersion:	2.6.23
>  Contact:	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
>  Description:
> -		If CONFIG_USB_PERSIST is set, then each USB device directory
> -		will contain a file named power/persist.  The file holds a
> -		boolean value (0 or 1) indicating whether or not the
> -		"USB-Persist" facility is enabled for the device.  Since the
> -		facility is inherently dangerous, it is disabled by default
> -		for all devices except hubs.  For more information, see
> -		Documentation/usb/persist.txt.
> +		USB device directories can contain a file named power/persist.
> +		The file holds a boolean value (0 or 1) indicating whether or
> +		not the "USB-Persist" facility is enabled for the device.  For
> +		hubs this facility is always enabled and their device
> +		directories will not contain this file.
> +
> +		For more information, see Documentation/usb/persist.txt.
>  
>  What:		/sys/bus/usb/devices/.../power/autosuspend
>  Date:		March 2007
> 

Acked-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
