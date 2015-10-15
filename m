From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH v4 75/79] include/uapi/xen/privcmd.h: fix compilation in
 userspace
Date: Thu, 15 Oct 2015 14:18:01 +0300
Message-ID: <20151015111801.GW6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-76-git-send-email-mikko.rapeli@iki.fi>
 <561F7FF8.9030703@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561F7FF8.9030703@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Russell King <linux@arm.linux.org.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 11:29:12AM +0100, David Vrabel wrote:
> On 15/10/15 06:56, Mikko Rapeli wrote:
> > xen/interface/xen.h is not exported from kernel headers so remove the
> > dependency and provide needed defines for domid_t and xen_pfn_t if they
> > are not already defined by some other e.g. Xen specific headers.
> > 
> > Suggested by Andrew Cooper <andrew.cooper3@citrix.com> on lkml message
> > <5569F9C9.8000607@citrix.com>.
> >
> > The ifdef for ARM is ugly but did not find better solutions for it.
> > 
> > Fixes userspace compilation error:
> > 
> > xen/privcmd.h:38:31: fatal error: xen/interface/xen.h: No such file or directory
> [...]
> > --- a/include/uapi/xen/privcmd.h
> > +++ b/include/uapi/xen/privcmd.h
> > @@ -35,7 +35,19 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/compiler.h>
> > -#include <xen/interface/xen.h>
> > +
> > +/* Might be defined by Xen specific headers, but if not */
> > +#ifndef domid_t
> > +typedef __u16 domid_t;
> > +#endif /* domid_t */
> 
> As the kbuild bot points out, this does not work since the existence of
> a typedef cannot be checked with #ifdef.

Yeah, this hack doesn't cut it. Sorry. Tried to implement these changes:
http://www.spinics.net/lists/linux-api/msg11048.html

> I'm not really sure what problem you're trying to solve.  A user space
> program making use of this interface gets the domid_t and xen_pfn_t etc
> typedefs from the headers provided as part of the libxenctrl library.

I'm trying to make sure that kernel headers in userspace compile with minimal
dependencies which are gcc and libc.

For me it is clear by now that many Linux API's and ABI's like Xen parts do
not live in the uapi header files and instead there's a separate userspace
library with needed headers and defines which have embedded copies of
the needed API and ABI definitions, like header files.

So how could this file be changed so that it compiles in userspace without
definitions from libxenctrl?

I guess I could copy the needed definitions for domid_t and xen_pfn_t from
xen/interface/xen.h of libxenctrl. That I should have done to begin with
instead of trying to hack something on my own.

-Mikko
