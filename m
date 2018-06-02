From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with
 open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Sat, 2 Jun 2018 04:42:56 +0100
Message-ID: <20180602034255.GV30522@ZenIV.linux.org.uk>
References: <20180601063928.GS30522@ZenIV.linux.org.uk>
 <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org>
 <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180602030913.GU30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jun 02, 2018 at 04:09:14AM +0100, Al Viro wrote:
> On Fri, Jun 01, 2018 at 09:27:43AM +0100, David Howells wrote:
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > > Instead of overloading this on open having a specific syscalls just
> > > > seems like a much saner idea.
> > > 
> > > It's not just mount API; these can be used independently of that.
> > > Think of the uses where you pass those to ...at() and you'll see
> > > a bunch of applications of that thing.
> > 
> > I kind of agree with Christoph on this point.  Yes, you can use the resultant
> > fd for other things, but that doesn't mean it has to be obtained initially
> > through open() or openat() rather than, say, a new pick_mount() syscall.
> > 
> > Further, having more parameters available gives us the opportunity to change
> > the settings on any mounts we create at the point of creation.
> 
> open_subtree(int dirfd, const char *pathname, int flags), then?  How would
> flags be interpreted?  What I see mapping at that thing is
> 	* equivalent of O_PATH open
> 	* clone subtree, O_PATH open root
> 	* clone one mount, O_PATH open root
> and apparently you want to add (orthogonal to that)
> 	* make shared/slave/private/unbindable
> 	* ditto with recursion?
> 	* same for nodev/nosuid/noexec/noatime/nodiratime/relatime/ro/?
> as well as usual AT_... flags (empty path, follow)
> 
> Choose the encoding...

_If_ I'm interpreting that correctly, that should be something like a bitmap
of attributes to modify + values to set for each.  Let's see -
	propagation	1 + 2 bits
	nodev		1 + 1
	noexec		1 + 1
	nosuid		1 + 1
	ro		1 + 1
	atime		1 + 3
That's 15 bits.  On top of that, we have 1 bit for "clone or original"
and 1 bit for "recursive or single-mount".  As well as AT_EMPTY_PATH,
and AT_NO_AUTOMOUNT (inconvenient, since these are fixed bits).  In
principle, that does fit into int, with some space to spare...

Is that what you have in mind?
