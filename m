From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] Define ENONAMESERVICE and ENAMEUNKNOWN to indicate name service errors
Date: Tue, 08 Mar 2011 16:37:01 +0000
Message-ID: <17429.1299602221@redhat.com>
References: <20110308152518.074d0996@lxorguk.ukuu.org.uk> <20110307160042.2ddc8e65@lxorguk.ukuu.org.uk> <20110307150208.28218.89348.stgit@warthog.procyon.org.uk> <20110307150218.28218.84916.stgit@warthog.procyon.org.uk> <14977.1299596999@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20110308152518.074d0996@lxorguk.ukuu.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@linux-nfs.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> I was wondering if at least there was some co-ordination going on so that
> functions like perror() produced sensible answers. Otherwise it's
> debatable if its actually an improvement for the poor end user ?

Fair point.  That's why I cc'd the messages to linux-api@, but I'm not sure who
actually reads it, besides Michael Kerrisk.  I guess it's probably a good idea
to wave my suggestions on the glibc list at least.

David
