From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
Date: Tue, 24 Jun 2014 13:17:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406241316550.888-100000@iolanthe.rowland.org>
References: <1403628854.1960.21.camel@x220>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403628854.1960.21.camel@x220>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 24 Jun 2014, Paul Bolle wrote:

> On Tue, 2014-06-24 at 10:15 -0400, Alan Stern wrote:
> > The default value for the persist facility depends on the setting of 
> > CONFIG_USB_DEFAULT_PERSIST.  If that symbol is set then persist is 
> > enabled by default for all devices, except those which have the 
> > USB_QUIRK_RESET flag set (meaning that they will morph or change modes 
> > when reset).  If the symbol is not set then persist is enabled by 
> > default only for hubs.
> > 
> > Thanks for the documentation update.
> 
> You do expect a v2 updated to reflect your comments, don't you?

It would be nice.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
