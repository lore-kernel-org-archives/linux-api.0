From: "Hans J. Koch" <hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Date: Thu, 11 Dec 2008 01:33:41 +0100
Message-ID: <20081211003340.GB3078@local>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <208aa0f00812031751n27a75d21h8747054651639463-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Edward Estabrook <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> From: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
> 
> Here is a patch that adds the ability to dynamically allocate and use
> coherent DMA
> from userspace by extending the Userspace IO driver.  This patch applies against
> 2.6.28-rc6.

Hi Edward,
sorry I didn't answer sooner. It was not lack of interest in your work, I
just had to think about it (and had quite a lot of other work, too).
I consider your idea of having DMA coherent memory allocatable from userspace
a valid demand. However, the interface should be implemented differently.

As a general requirement, all information you need to pass to userspace has
to go through sysfs. This is a UIO design decision and should not be changed
lightly. Please don't fill information into the allocated memory.

We shouldn't mix dynamically allocated DMA regions with the already existing
static memory mappings. There should be an extra directory, maybe called
/sys/class/uio/uioN/dyn_dma_mem/ containing information about this kind of
DMA memory. This directory would not exist by default, it's only created if
some user actually allocates such memory.

In the UIO core, these mappings should be handled with a dynamic list, not
a static array. The number of possible mappings has to be limited to a
sensible maximum, maybe 50 or 100. The code handling the existing static
mappings could mostly stay as-is.

Userspace can allocate new DMA memory by using some magic number as the offset
parameter of mmap() like you suggested. However, this magic should be just one
of the bits 16..31 (e.g. 0x00010000) to have other bits available for future
extensions.

I think you should also reconsider the way you unmap the memory. It's certainly
right to unmap everything when the device is unregistered, but I think there's
more to think about:
- Should the memory be freed as soon as all users have the device closed?
- What happens if a user calls munmap() on such a mapping?

I'm looking forward to your next version.

Thanks,
Hans

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
