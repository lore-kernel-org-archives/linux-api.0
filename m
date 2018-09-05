From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [PATCH 05/11] UAPI: coda: Don't use internal kernel structs in
 UAPI
Date: Wed, 5 Sep 2018 13:28:58 -0400
Message-ID: <20180905172858.pv2vafetjzzk5jxs@cs.cmu.edu>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk>
 <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 05, 2018 at 07:12:37PM +0200, Yann Droneaud wrote:
> Le mercredi 05 septembre 2018 à 16:55 +0100, David Howells a écrit :
> > The size and layout of internal kernel structures may not be relied
> > upon outside of the kernel and may even change in a containerised
> > environment if a container image is frozen and shifted to another
> > machine.
> > 
> > Excise these from Coda's upc_req struct.
...
> 
> This structure should not have been exposed to userspace in the first
> place: it's unusable by userspace as it is. It was incorrect to have it
> outside of #ifdef __KERNEL__ before commit 607ca46e97a1b ... 
...
> So the structure can be moved back to <linux/coda_psdev.h>.

I found a year old patch that clearly fell through the cracks that
fixes this exact thing.

    https://lkml.org/lkml/2017/8/6/186

Jan
