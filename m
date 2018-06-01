From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 30/32] vfs: Allow cloning of a mount tree with
 open(O_PATH|O_CLONE_MOUNT) [ver #8]
Date: Fri, 1 Jun 2018 07:39:28 +0100
Message-ID: <20180601063928.GS30522@ZenIV.linux.org.uk>
References: <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601062654.GA32397@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 31, 2018 at 11:26:54PM -0700, Christoph Hellwig wrote:
> On Fri, May 25, 2018 at 01:08:38AM +0100, David Howells wrote:
> > Make it possible to clone a mount tree with a new pair of open flags that
> > are used in conjunction with O_PATH:
> > 
> >  (1) O_CLONE_MOUNT - Clone the mount or mount tree at the path.
> > 
> >  (2) O_NON_RECURSIVE - Don't clone recursively.
> 
> Err.  I don't think we should use up two O_* flags for something
> only useful for your new mount API.  Don't we have a better place
> to for these flags?
> 
> Instead of overloading this on open having a specific syscalls just
> seems like a much saner idea.

It's not just mount API; these can be used independently of that.
Think of the uses where you pass those to ...at() and you'll see
a bunch of applications of that thing.
