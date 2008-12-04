From: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Date: Wed, 3 Dec 2008 20:17:39 -0800
Message-ID: <20081204041739.GA16329@suse.de>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <208aa0f00812031751n27a75d21h8747054651639463-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Edward Estabrook <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> From: Edward Estabrook <Edward_Estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org>
> 
> Here is a patch that adds the ability to dynamically allocate and use
> coherent DMA
> from userspace by extending the Userspace IO driver.  This patch applies against
> 2.6.28-rc6.
> 
> The gist of this implementation is to overload uio's mmap
> functionality to allocate
> and map a new DMA region on demand.  The bus-specific DMA address as returned by
> dma_alloc_coherent is made available to userspace in the 1st long word
> of the newly
> created region (as well as through the conventional 'addr' file in sysfs).
> 
> The kernel-api change is that passing an offset value of 0xFFFFF000UL
> to the a uio
> device's mmap operation will dynamically allocate a DMA region.  This
> cannot change/
> break existing behavior as the previous UIO code only allowed a maximum of 5
> mappings.

Odd formatting of your paragraphs :(

Anyway, what about 64bit processors?  What happens if they try to use a
valid address in this range?

Is this value always an "invalid" value for all arches that Linux runs
on?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
