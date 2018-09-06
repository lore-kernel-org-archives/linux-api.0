From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [PATCH 05/11] UAPI: coda: Don't use internal kernel structs in
 UAPI
Date: Thu, 6 Sep 2018 08:16:24 -0400
Message-ID: <20180906121623.6lrt6lajqstdymtx@cs.cmu.edu>
References: <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com>
 <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk>
 <9916.1536218032@warthog.procyon.org.uk>
 <2e337313415a1ede1fb7a777902a0de7cb7c2602.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2e337313415a1ede1fb7a777902a0de7cb7c2602.camel@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 06, 2018 at 01:52:29PM +0200, Yann Droneaud wrote:
> Hi,
> 
> Le jeudi 06 septembre 2018 à 08:13 +0100, David Howells a écrit :
> > Yann Droneaud <ydroneaud@opteya.com> wrote:
> > 
> > > This structure should not have been exposed to userspace in the
> > > first
> > > place: it's unusable by userspace as it is. It was incorrect to
> > > have it
> > > outside of #ifdef __KERNEL__ before commit 607ca46e97a1b ... 
> > > ...
> > > All CODA_REQ_* defines internals to kernel side and not exchanged
> > > with
> > > userspace.
> > > 
> > > Please move them back to <linux/coda_psdev.h>
> > 
> > Is there any reason coda_psdev.h needs to be in include/linux/ rather
> > than fs/coda/?
> > 
> 
> It's a valid concern.
> 
> At first I thought the first lines (see below) could have been useful
> for userspace:
> 
>   #define CODA_PSDEV_MAJOR 67
>   #define MAX_CODADEVS  5    /* how many do we allow */

Nope, userspace just tries to open /dev/cfs0, or a manually configured
alternative. We have only used linux/coda.h, and actually carry our own
copy of that file which is kept in sync manually, which is why there are
all those ifdefs for different systems in there. This all originates
from the time of the 2.1.x kernels when Coda was built externally.

> But the file was unsuable for a long long time so we can assume it's
> usage by userspace is deprecated, then we could remove it from UAPI,
> and moves its content back to include/linux.
> 
> As one could see include/linux/coda_psdev.h is not used outside of
> fs/coda, moving the header here as you suggests seems to be the correct
> solution.

Agreed.

Jan
