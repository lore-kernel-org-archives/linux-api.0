From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Fri, 01 Jun 2018 09:27:43 +0100
Message-ID: <7067.1527841663@warthog.procyon.org.uk>
References: <20180601063928.GS30522@ZenIV.linux.org.uk> <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk> <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk> <20180601062654.GA32397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601063928.GS30522@ZenIV.linux.org.uk>
Content-ID: <7066.1527841663.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > Instead of overloading this on open having a specific syscalls just
> > seems like a much saner idea.
> 
> It's not just mount API; these can be used independently of that.
> Think of the uses where you pass those to ...at() and you'll see
> a bunch of applications of that thing.

I kind of agree with Christoph on this point.  Yes, you can use the resultant
fd for other things, but that doesn't mean it has to be obtained initially
through open() or openat() rather than, say, a new pick_mount() syscall.

Further, having more parameters available gives us the opportunity to change
the settings on any mounts we create at the point of creation.

David
