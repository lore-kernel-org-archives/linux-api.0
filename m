From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Sat, 8 Jul 2017 21:01:55 -0400
Message-ID: <20170709010155.3nql5ixdeozemgfd@thunk.org>
References: <20170706152304.GA10584@infradead.org>
 <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk>
 <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
 <31934.1499357651@warthog.procyon.org.uk>
 <2863583A-79F1-4998-8AC4-1C4C9D4C060F@dilger.ca>
 <CA+55aFyFEW8LTEoyckW2YNeMrk5q_FweRsGbZKxXHWQjGLRw8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyFEW8LTEoyckW2YNeMrk5q_FweRsGbZKxXHWQjGLRw8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Dilger <adilger@dilger.ca>, David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-afs@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 08, 2017 at 12:44:54PM -0700, Linus Torvalds wrote:
> Yeah, I think attributes are likely much better than some random crazy
> ioctl interface. They can be listed with generic tools, and have
> various scripting interfaces in ways that ioctl's do not sanely have.

I personally don't have a particular problem with these xattrs.  For
one thing, they are read-only.  You use them just to find out the AFS
cell, the AFS "fid", and the AFS volume name.

I think the place where people will start getting nervous is when we
start adding "write-only" xattrs or where writing to an xattr causes a
side-effect to take place.

So using xattr's to set AFS quota's for a volume, or to tell a client
about a new AFS cell, or to tell the client kernel about the database
servers for an AFS cell --- that I think would be pretty ugly.

Since such API's affect global state, and not a per-file state, I
don't believe xattrs are a good substitute for everything that was
done with the AFS pioctl system call for other operating systems.  For
those uses cases my personal opinion is that defining new Linux system
calls for such things would make a lot more sense.

Or maybe just use sysfs interfaces for such things, although that has
gotten abused in the past too....

      	       	      	    	       - Ted
