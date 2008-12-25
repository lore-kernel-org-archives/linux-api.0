From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA (corrected)
Date: Thu, 25 Dec 2008 13:30:04 +0100
Message-ID: <20081225123004.GA13640@8bytes.org>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com> <20081211003340.GB3078@local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752180AbYLYMaX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081211003340.GB3078@local>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Edward Estabrook <edward.estabrook.lkml@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@suse.de, edward.estabrook@gmail.com, edward_estabrook@agilent.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 11, 2008 at 01:33:41AM +0100, Hans J. Koch wrote:
> On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> > From: Edward Estabrook <Edward_Estabrook@agilent.com>
> > 
> > Here is a patch that adds the ability to dynamically allocate and use
> > coherent DMA
> > from userspace by extending the Userspace IO driver.  This patch applies against
> > 2.6.28-rc6.
> 
> Hi Edward,
> sorry I didn't answer sooner. It was not lack of interest in your work, I
> just had to think about it (and had quite a lot of other work, too).
> I consider your idea of having DMA coherent memory allocatable from userspace
> a valid demand. However, the interface should be implemented differently.
> 
> As a general requirement, all information you need to pass to userspace has
> to go through sysfs. This is a UIO design decision and should not be changed
> lightly. Please don't fill information into the allocated memory.
> 
> We shouldn't mix dynamically allocated DMA regions with the already existing
> static memory mappings. There should be an extra directory, maybe called
> /sys/class/uio/uioN/dyn_dma_mem/ containing information about this kind of
> DMA memory. This directory would not exist by default, it's only created if
> some user actually allocates such memory.
> 
> In the UIO core, these mappings should be handled with a dynamic list, not
> a static array. The number of possible mappings has to be limited to a
> sensible maximum, maybe 50 or 100. The code handling the existing static
> mappings could mostly stay as-is.

I like that idea of a seperate directory in sysfs. How about allocating
DMA memory by creating files in this directory. The memory itself can be
accessed via mmap() and the dma address can be gathered using read().
When a file is closed the dma memory is unmapped.
This would work great as long as /sys/class/uio/uioN/ belongs only to
one physical device.

Joerg
