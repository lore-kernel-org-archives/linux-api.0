From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH 96/98] HACK include/uapi/linux/coda_psdev.h: fix
 compilation in userspace
Date: Thu, 10 Sep 2015 22:48:30 +0300
Message-ID: <20150910194830.GC6104@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-97-git-send-email-mikko.rapeli@iki.fi>
 <20150531111913.GA23377@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150531111913.GA23377-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, May 31, 2015 at 07:19:13AM -0400, Jan Harkes wrote:
> On Sat, May 30, 2015 at 05:39:28PM +0200, Mikko Rapeli wrote:
> > Include linux/coda.h for caddr_t and use unsigned short type directly.
> > Userspace headers do not have list_head and wait_queue_head_t so just
> > ifdef them away which is a HACK. Any ideas how to fix this properly?
> 
> I grepped the Coda userspace sources and it doesn't look like this
> particular struct is used there anyway, it is only used by the kernel
> module to track which requests are waiting to be read by the Coda
> userspace application and after that which requests are waiting for a
> response.
> 
> I guess a proper fix would be to move this struct to a non-uapi header,
> or maybe even to the (probably) only C file in the kernel where it is
> used.

Thanks! I'm moving upc_req definition to kernel side linux/coda_psdev.h
in the next version of the patches.

-Mikko
