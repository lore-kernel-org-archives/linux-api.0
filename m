From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
Date: Tue, 24 Jun 2014 18:54:14 +0200
Message-ID: <1403628854.1960.21.camel@x220>
References: <Pine.LNX.4.44L0.1406241010160.990-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1406241010160.990-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-06-24 at 10:15 -0400, Alan Stern wrote:
> The default value for the persist facility depends on the setting of 
> CONFIG_USB_DEFAULT_PERSIST.  If that symbol is set then persist is 
> enabled by default for all devices, except those which have the 
> USB_QUIRK_RESET flag set (meaning that they will morph or change modes 
> when reset).  If the symbol is not set then persist is enabled by 
> default only for hubs.
> 
> Thanks for the documentation update.

You do expect a v2 updated to reflect your comments, don't you?


Paul Bolle 
