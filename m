From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Wed, 11 Mar 2015 00:48:00 +0200
Message-ID: <20150310224800.GX12550@lakka.kapsi.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <2309592.iOl8K3u7d8@wuerfel>
 <20150217133806.GA5220@agk-dp.fab.redhat.com>
 <2286739.alIuOL4vnt@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2286739.alIuOL4vnt@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 02:55:49PM +0100, Arnd Bergmann wrote:
> On Tuesday 17 February 2015 13:38:06 Alasdair G Kergon wrote:
> > On Tue, Feb 17, 2015 at 10:08:56AM +0100, Arnd Bergmann wrote:
> > > The normal way to do this in kernel headers is to use linux/types.h
> > > but change the data structures to use __u64 instead of uint64_t
> > > to avoid the build error.
> >  
> > That's what happened to dm-ioctl.h.
> 
> Ah, indeed. It turns out that it was my own change that did this:
> 
> 
> commit 9adfbfb611307060db54691bc7e6d53fdc12312b
> Author: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Date:   Thu Feb 26 00:51:40 2009 +0100
> 
>     make most exported headers use strict integer types
>     
>     This takes care of all files that have only a small number
>     of non-strict integer type uses.
> 
> > (Or someone could adjust linux/types.h to include these as standard.)
> 
> No, that wouldn't work. The C user space headers are not meant to
> be included implicitly by any standard headers, which might pull
> in linux/types.h implicitly.
> 
> I think it would be best to change all patches in the new series
> in the same way for consistency and try to avoid using stdint.h
> as much as we can.

Ok, I'll change all patches to use __u8 etc types instead of uint8_t etc via
stdint.h.

-Mikko
