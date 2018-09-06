From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 03/11] UAPI: virtio_net: Fix use of C++ keywords as
 structural members
Date: Thu, 6 Sep 2018 10:36:59 -0400
Message-ID: <20180906101318-mutt-send-email-mst@kernel.org>
References: <20180905125636-mutt-send-email-mst@kernel.org>
 <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616289529.23468.7498785670556620808.stgit@warthog.procyon.org.uk>
 <9357.1536217759@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9357.1536217759@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 06, 2018 at 08:09:19AM +0100, David Howells wrote:
> Michael S. Tsirkin <mst@redhat.com> wrote:
> 
> > As long as you do not intend to use any classes, how about
> > simply adding
> > 
> > -Dclass=_class
> > 
> > to your command line?
> 
> That kind of misses the point;-).  It's not reasonable to expect all userspace
> C++ users to do this.
> 
> David

I thought one of the points was that building kernel with c++ catches
some bugs, no?  If the point is to make life easier for c++ userspace
I'm not sure what we can do to be frank. C++ seems to be adding new
keywords with no restraint (C99 did it with inline and restrict too, but
it seems this stopped) so no good way to future-proof code for all
language dialects.

So I'd like to know which are the actual c++ users asking for this - we
can then accomodate the specific version they need.
Meanwhile people can get by with a wrapper along the lines of
#define class _class
#include <linux/virtio_net.h>
#undef class

-- 
MST
