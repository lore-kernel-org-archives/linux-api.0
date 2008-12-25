From: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Date: Thu, 25 Dec 2008 16:20:15 +0100
Message-ID: <20081225152014.GA3079@local>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com> <20081211003340.GB3078@local> <20081225123004.GA13640@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081225123004.GA13640-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Edward Estabrook <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 25, 2008 at 01:30:04PM +0100, Joerg Roedel wrote:
> On Thu, Dec 11, 2008 at 01:33:41AM +0100, Hans J. Koch wrote:
> > On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> > > From: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
> > > 
> > > Here is a patch that adds the ability to dynamically allocate and use
> > > coherent DMA
> > > from userspace by extending the Userspace IO driver.  This patch applies against
> > > 2.6.28-rc6.
> > 
> > Hi Edward,
> > sorry I didn't answer sooner. It was not lack of interest in your work, I
> > just had to think about it (and had quite a lot of other work, too).
> > I consider your idea of having DMA coherent memory allocatable from userspace
> > a valid demand. However, the interface should be implemented differently.
> > 
> > As a general requirement, all information you need to pass to userspace has
> > to go through sysfs. This is a UIO design decision and should not be changed
> > lightly. Please don't fill information into the allocated memory.
> > 
> > We shouldn't mix dynamically allocated DMA regions with the already existing
> > static memory mappings. There should be an extra directory, maybe called
> > /sys/class/uio/uioN/dyn_dma_mem/ containing information about this kind of
> > DMA memory. This directory would not exist by default, it's only created if
> > some user actually allocates such memory.
> > 
> > In the UIO core, these mappings should be handled with a dynamic list, not
> > a static array. The number of possible mappings has to be limited to a
> > sensible maximum, maybe 50 or 100. The code handling the existing static
> > mappings could mostly stay as-is.
> 
> I like that idea of a seperate directory in sysfs. How about allocating
> DMA memory by creating files in this directory.

Nice idea, but AFAICT sysfs doesn't support creating files from userspace.

> The memory itself can be
> accessed via mmap() and the dma address can be gathered using read().
> When a file is closed the dma memory is unmapped.
> This would work great as long as /sys/class/uio/uioN/ belongs only to
> one physical device.

That's guaranteed.

Thanks,
Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
