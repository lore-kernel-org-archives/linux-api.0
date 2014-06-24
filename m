From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
Date: Tue, 24 Jun 2014 10:15:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406241010160.990-100000@iolanthe.rowland.org>
References: <1403602404.1960.7.camel@x220>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403602404.1960.7.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 24 Jun 2014, Paul Bolle wrote:

> There's no power/persist file for hubs. And CONFIG_USB_PERSIST was
> removed in v2.6.26. Update the description of power/persist accordingly.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> I don't know anything about USB-Persist. Could Greg and Alan please
> check whether the new description does actually match reality?

Not exactly.  More details below.

>  Documentation/ABI/stable/sysfs-bus-usb | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
> index a6b685724740..a61d04b8fc78 100644
> --- a/Documentation/ABI/stable/sysfs-bus-usb
> +++ b/Documentation/ABI/stable/sysfs-bus-usb
> @@ -3,13 +3,13 @@ Date:		May 2007
>  KernelVersion:	2.6.23
>  Contact:	Alan Stern <stern@rowland.harvard.edu>
>  Description:
> -		If CONFIG_USB_PERSIST is set, then each USB device directory
> -		will contain a file named power/persist.  The file holds a
> -		boolean value (0 or 1) indicating whether or not the
> -		"USB-Persist" facility is enabled for the device.  Since the
> -		facility is inherently dangerous, it is disabled by default
> -		for all devices except hubs.  For more information, see
> -		Documentation/usb/persist.txt.
> +		USB device directories for all devices except hubs will contain
> +		a file named power/persist.  The file holds a boolean value (0
> +		or 1) indicating whether or not the "USB-Persist" facility is
> +		enabled for the device.  Since the facility is inherently
> +		dangerous, it is disabled by default.  For hubs this facility is
> +		always enabled making the file pointless.  For more information,
> +		see Documentation/usb/persist.txt.

Instead of depending on CONFIG_USB_PERSIST, the power/persist attribute
depends on CONFIG_PM.  But pointing that out would be redundant, since
the power/ device directory itself doesn't exist unless CONFIG_PM is
enabled.

The default value for the persist facility depends on the setting of 
CONFIG_USB_DEFAULT_PERSIST.  If that symbol is set then persist is 
enabled by default for all devices, except those which have the 
USB_QUIRK_RESET flag set (meaning that they will morph or change modes 
when reset).  If the symbol is not set then persist is enabled by 
default only for hubs.

Thanks for the documentation update.

Alan Stern
