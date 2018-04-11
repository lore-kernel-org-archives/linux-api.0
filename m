From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is locked down
Date: Wed, 11 Apr 2018 21:09:16 +0100
Message-ID: <12769.1523477356@warthog.procyon.org.uk>
References: <20180411195436.GA7126@kroah.com> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180411195436.GA7126@kroah.com>
Content-ID: <12768.1523477356.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH <greg@kroah.com> wrote:

> Why not just disable debugfs entirely?  This half-hearted way to sorta
> lock it down is odd, it is meant to not be there at all, nothing in your
> normal system should ever depend on it.
> 
> So again just don't allow it to be mounted at all, much simpler and more
> obvious as to what is going on.

Yeah, I agree - and then I got complaints because it seems that it's been
abused to allow drivers and userspace components to communicate.

David
