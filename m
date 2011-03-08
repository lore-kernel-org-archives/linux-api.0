From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate name service errors
Date: Tue, 08 Mar 2011 15:09:59 +0000
Message-ID: <14977.1299596999@redhat.com>
References: <20110307160042.2ddc8e65@lxorguk.ukuu.org.uk> <20110307150208.28218.89348.stgit@warthog.procyon.org.uk> <20110307150218.28218.84916.stgit@warthog.procyon.org.uk>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20110307160042.2ddc8e65@lxorguk.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@linux-nfs.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Define ENONAMESERVICE to indicate "Network name service unavailable".
> > This can be used to indicate, for example, that an attempt was made by
> > dns_query() to make a query, but the name server (e.g. a DNS server) it is
> > supposed to contact didn't answer or that it couldn't determine the
> > location of a suitable server.
> 
> Are these in glibc and are there glibc patches submitted and accepted for
> this ?

No.

Are you saying that I should push them through glibc first - and then submit
them to the kernel?  Does the kernel lead or the C library?  And, if the
latter, which C library?  Can I not, for instance, push them through uclibc,
say?

Does submitting to glibc mean I have to sign my copyrights over to the FSF for
that code?  I've never gone through this process.

David
