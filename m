From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
Date: Fri, 31 May 2019 18:12:42 +0100
Message-ID: <15401.1559322762@warthog.procyon.org.uk>
References: <20190531164444.GD2606@hirez.programming.kicks-ass.net> <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com> <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk> <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk> <16193.1559163763@warthog.procyon.org.uk> <21942.1559304135@warthog.procyon.org.uk> <606.1559312412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531164444.GD2606@hirez.programming.kicks-ass.net>
Content-ID: <15400.1559322762.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> > > (and it has already been established that refcount_t doesn't work for
> > > usage count scenarios)
> > 
> > ?
> > 
> > Does that mean struct kref doesn't either?
> 
> Indeed, since kref is just a pointless wrapper around refcount_t it does
> not either.
> 
> The main distinction between a reference count and a usage count is that
> 0 means different things. For a refcount 0 means dead. For a usage count
> 0 is merely unused but valid.

Ah - I consider the terms interchangeable.

Take Documentation/filesystems/vfs.txt for instance:

  dget: open a new handle for an existing dentry (this just increments
	the usage count)

  dput: close a handle for a dentry (decrements the usage count). ...

  ...

  d_lookup: look up a dentry given its parent and path name component
	It looks up the child of that given name from the dcache
	hash table. If it is found, the reference count is incremented
	and the dentry is returned. The caller must use dput()
	to free the dentry when it finishes using it.

Here we interchange the terms.

Or https://www.kernel.org/doc/gorman/html/understand/understand013.html
which seems to interchange the terms in reference to struct page.

David
