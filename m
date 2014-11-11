From: Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH RFC v1b] firewire: cdev: prevent kernel stack leaking
	into ioctl arguments
Date: Tue, 11 Nov 2014 19:22:10 +0100
Message-ID: <546253D2.9050400@ladisch.de>
References: <55D28623-C1C7-47D2-9638-0B8FD0733C48@stanford.edu>	<20141111010340.3329bbd7@kant>
	<20141111130143.2ff3d42e@kant>	<20141111171356.2fc62440@kant>
	<20141111171644.7f6b17c7@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141111171644.7f6b17c7@kant>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Ramos <daramos-FGKo4X94FMn2fBVCVOL8/A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Stefan Richter wrote:
> This fix simply always null-initializes the entire ioctl argument buffer
> regardless of the actual length of expected user input.  That is, a
> runtime overhead of memset(..., 40) is added to each firewirew-cdev
> ioctl() call.

This part of the stack is most likely to be already in the cache.


Regards,
Clemens
