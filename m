From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [RFC 1/1 v2] Input: Add ps2emu module
Date: Tue, 21 Jul 2015 12:57:08 -0700
Message-ID: <20150721195708.GA22834@kroah.com>
References: <20150721191512.GB21710@kroah.com>
 <1437508037-13928-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437508037-13928-1-git-send-email-cpaul@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Stephen Chandler Paul <cpaul@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, linux-api@vger.kernel.org, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 03:47:17PM -0400, Stephen Chandler Paul wrote:
> Debugging input devices, specifically laptop touchpads, can be tricky
> without having the physical device handy. Here we try to remedy that
> with ps2emu. This module allows an application to connect to a character
> device provided by the kernel, and simulate any PS/2 device. In
> combination with userspace programs that can record PS/2 devices and
> replay them through the /dev/ps2emu device, this allows developers to
> debug driver issues on the PS/2 level with devices simply by requesting
> a recording from the user experiencing the issue without having to have
> the physical hardware in front of them.
> 
> Signed-off-by: Stephen Chandler Paul <cpaul@redhat.com>
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 				    Changes
> * Remove PS2EMU_MINOR, use MISC_DYNAMIC_MINOR
> * Remove ps2emu_warn(), just use dev_warn()
> * Don't return value from copy_to_user(), return -EFAULT
> * Remove usages of unlikely()
> * Remove call to nonseekable_open()
> 
> 			     Things I didn't change
> * Didn't rename this_device, I might have misinterpreted what you were saying
>   but this_device is a member of a struct that isn't defined in any of my own
>   patches. I could have renamed ps2emu_misc and ps2emu_fops to misc and fops,
>   but I'm guessing that's the wrong thing to do if I go off the style of the
>   other driver files in the kernel tree (in drivers/input, anyway).

Sorry, you are right, this is a structure that you don't have control
over.  Thanks for the other changes, looks good to me.

greg k-h
