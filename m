From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow
 cloning of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Mon, 4 Jun 2018 18:35:08 +0100
Message-ID: <20180604173508.GJ30522@ZenIV.linux.org.uk>
References: <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org>
 <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk>
 <20180602034255.GV30522@ZenIV.linux.org.uk>
 <21804.1527954321@warthog.procyon.org.uk>
 <20180602174957.GX30522@ZenIV.linux.org.uk>
 <20180603005532.GZ30522@ZenIV.linux.org.uk>
 <20180604171630.GA29059@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604171630.GA29059@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 04, 2018 at 10:16:30AM -0700, Matthew Wilcox wrote:
> On Sun, Jun 03, 2018 at 01:55:37AM +0100, Al Viro wrote:
> > +SYSCALL_DEFINE3(open_tree, int, dfd, const char *, filename, unsigned, flags)
> > +{
> > +	struct file *file;
> > +	struct path path;
> > +	int lookup_flags = LOOKUP_AUTOMOUNT | LOOKUP_FOLLOW;
> > +	bool detached = flags & OPEN_TREE_CLONE;
> > +	int error;
> > +	int fd;
> > +
> > +	BUILD_BUG_ON(OPEN_TREE_CLOEXEC != O_CLOEXEC);
> 
> Why do we need OPEN_TREE_CLOEXEC?  Wouldn't we be better off just making
> the fd returned by open_tree implicitly close-on-exec?  I can think of
> no good reason for these file descriptors to be inherited across exec()

How are they different from any file descriptor?  It's not as if it was
something usable only for mounting stuff - again, you can use them
with any ...at() syscalls.

> and if someone comes up with such a reason, fcntl(F_SETFD) is not an
> expensive call to make.
