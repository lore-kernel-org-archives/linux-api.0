From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [char-misc-next 04/11 V2] uuid: extract macros for assigning raw
 arrays
Date: Wed, 27 May 2015 10:29:19 -0700
Message-ID: <20150527172919.GA5525@kroah.com>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
 <20150527165054.GB3533@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C@hasmsx109.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C-Jy8z56yoSI/jxeytcECX8bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 05:24:01PM +0000, Winkler, Tomas wrote:
> 
> > 
> > On Wed, May 27, 2015 at 06:42:13PM +0300, Tomas Winkler wrote:
> > > In order for mei client devices to use device id based on uuid we
> > > have to use common types between user space (file2alias.c).
> > > Similarly to vmbus,  mei  uses raw 16 byte array for that.
> > > To leverage on existing infrastructure around uuid_le type
> > > defined in uuid.h we add helper macros to handle conversions between
> > > raw 16 byte array and uuid_{le,be} types.
> > 
> > You aren't adding a helper macro, you are just redefining the existing
> > macros using a different one. 
> 
> Not exactly I'm using both the one I've added for device ids and the old one for all the other flows.
> 
>  But I can't see why this is needed, what
> > does this solve that vmbus and other uses of the existing macros don't
> > need?  In other words, what makes mei so special that it needs a "lower"
> > level macro than every other subsystem?
> 
> It's not special there is actually a lot of code duplication around uuid handling 
> every subsystem is using their own macros but it can be consolidated around uuid.h
>  
> So vmbus can use that 
> Instead of 
> /*
>  * Network GUID
>  * {f8615163-df3e-46c5-913f-f2d2f965ed0e}
>  */
> #define HV_NIC_GUID \
>         .guid = { \
>                         0x63, 0x51, 0x61, 0xf8, 0x3e, 0xdf, 0xc5, 0x46, \
>                         0x91, 0x3f, 0xf2, 0xd2, 0xf9, 0x65, 0xed, 0x0e \
>                 }
> 
> The can use the new macro to make it more readable, something in spirit of:
> 
> #define HV_NIC_GUID __UUID_LE(f8615163-df3e-46c5-913f-f2d2f965ed0e)

Why the "__" usage here?  That signifies a "private" namespace, why add
that to the user visible header files?

And are you going to send patches for vmbus and other drivers to fix
everything up to use these new macros?  Someone has to...

thanks,

greg k-h
