From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 02/13] uapi: General notification ring definitions [ver #4]
Date: Thu, 13 Jun 2019 14:34:45 +0100
Message-ID: <30226.1560432885@warthog.procyon.org.uk>
References: <6b6f5bb0-1426-239b-ac9f-281e31ddcd04@infradead.org> <20190607151228.GA1872258@magnolia> <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk> <155991706083.15579.16359443779582362339.stgit@warthog.procyon.org.uk> <29222.1559922719@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b6f5bb0-1426-239b-ac9f-281e31ddcd04@infradead.org>
Content-ID: <30225.1560432885.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dhowells@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> What is the problem with inline functions in UAPI headers?

It makes compiler problems more likely; it increases the potential for name
collisions with userspace; it makes for more potential problems if the headers
are imported into some other language; and it's not easy to fix a bug in one
if userspace uses it, just in case fixing the bug breaks userspace.

Further, in this case, the first of Darrick's functions (calculating the
length) is probably reasonable, but the second is not.  It should crank the
tail pointer and then use that, but that requires 

> >> Also, weird multiline comment style.
> > 
> > Not really.
> 
> Yes really.

No.  It's not weird.  If anything, the default style is less good for several
reasons.  I'm going to deal with this separately as I need to generate some
stats first.

David
