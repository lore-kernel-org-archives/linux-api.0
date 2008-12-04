From: "Edward Estabrook" <edward.estabrook.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA (corrected)
Date: Wed, 3 Dec 2008 21:34:40 -0800
Message-ID: <208aa0f00812032134l5d0df1d9pa1359aba6e719e26@mail.gmail.com>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
	 <20081204041739.GA16329@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081204041739.GA16329-l3A5Bk7waGM@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hjk-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, edward.estabrook-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, edward_estabrook-+2HdxjxtzLdBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

> Anyway, what about 64bit processors?  What happens if they try to use a
> valid address in this range?
>
> Is this value always an "invalid" value for all arches that Linux runs
> on?

Yes. I have run this on 64-bit systems.

The offset parameter in UIO is used to specify the memory-mapping index
of interest, where offset = N * getpagesize().

In include/linux/uio_driver.h we had:
#define MAX_UIO_MAPS 5

so assuming a page size of 4k the maximum legal value was 0x5000.

This logic is equally true on in any architecture.

With the dynamic DMA allocation one can now have an arbitrarily large
number of mappings.  This magic number simply reduces the theoretical limit
to the number of distinct mappings to of 1,048,574.

Note that even if the in-kernel driver-stub choose to overload the mmap method
both the original code and these modifications would error out on any value
which did not correlate with a valid memory-mapping index number before
handing control to the overloaded implementation.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
