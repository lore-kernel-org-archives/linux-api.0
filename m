From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v06 30/36] uapi rdma/rdma_user_rxe.h: include in.h and
 in6.h
Date: Thu, 10 Aug 2017 10:19:12 -0600
Message-ID: <20170810161912.GA2491@obsidianresearch.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-31-mikko.rapeli@iki.fi>
 <20170808231306.GH29372@obsidianresearch.com>
 <CAG9sBKP=NuSJzhg8rMBTsTuZkfzPDjxYgAGjiCnEMe=9xXB0xA@mail.gmail.com>
 <20170809155241.GB15586@obsidianresearch.com>
 <20170810024747.GA30198@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170810024747.GA30198-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 05:47:48AM +0300, Dmitry V. Levin wrote:
> On Wed, Aug 09, 2017 at 09:52:41AM -0600, Jason Gunthorpe wrote:
> > On Wed, Aug 09, 2017 at 04:48:08PM +0300, Moni Shoua wrote:
> > > >
> > > > I'm not sure this is a good idea, linux/in.h should not be included in
> > > > userspace users of this file, 'sockaddr_in' needs to come from glibc's
> > > > 'netinet/in.h' instead..
> > 
> > > Is it wrong to include include/uapi/linux/in.h from userspace?
> > 
> > Generally speaking userspace should always use the glibc version of
> > the headers and not headers from under linux/
> 
> Sorry?  Isn't the main idea of UAPI in providing the Linux interface for
> userspace, unlike glibc headers that provide other more or less standard
> interfaces like GNU, POSIX, etc?

The issue is when glibc and linux provide the same standards based API
(eg in.h) - then the uapi version of in.h is really only for
consumption by glibc and other very special cases.

Forcing apps that need to access the rdma uapi that is not implemented
in glibc to deal with that mess is what is problematic. The uapi
system has a number of issues like this :|

If you make it so I cannot include rdma_user_rxe.h and netinet/in.h,
(for instance) in the same file then you broke user space use of the
header and things are worse off..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
