From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v06 30/36] uapi rdma/rdma_user_rxe.h: include in.h and
 in6.h
Date: Wed, 9 Aug 2017 09:52:41 -0600
Message-ID: <20170809155241.GB15586@obsidianresearch.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-31-mikko.rapeli@iki.fi>
 <20170808231306.GH29372@obsidianresearch.com>
 <CAG9sBKP=NuSJzhg8rMBTsTuZkfzPDjxYgAGjiCnEMe=9xXB0xA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKP=NuSJzhg8rMBTsTuZkfzPDjxYgAGjiCnEMe=9xXB0xA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 09, 2017 at 04:48:08PM +0300, Moni Shoua wrote:
> >
> > I'm not sure this is a good idea, linux/in.h should not be included in
> > userspace users of this file, 'sockaddr_in' needs to come from glibc's
> > 'netinet/in.h' instead..

> Is it wrong to include include/uapi/linux/in.h from userspace?

Generally speaking userspace should always use the glibc version of
the headers and not headers from under linux/

Even if it is OK to include both today, that may not be true as glibc
or the kernel changes, and we end up with broken builds.

For instance look at this commit for a real problem caused by mixing
net/if.h and linux/if.h:

commit dc386fcf4a6d5dc0cc0052437c1cb161b7781592
Author: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date:   Fri Oct 14 12:04:42 2016 -0600

    verbs: Use cmake to detect if net/if.h vs netling/route/link.h is broken
    
    If not then just use the header directly, otherwise use the work around.
    
    The issue is that old libnl libraries include linux/if.h and the
    declarations there conflict with net/if.h. New libraries do not
    do this.
    
    Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
