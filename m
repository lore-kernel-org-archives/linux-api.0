From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Extended file stat: Splitting file- and fs-specific info?
Date: Wed, 9 May 2012 07:19:58 -0400
Message-ID: <20120509111958.GA11345@infradead.org>
References: <20120509002420.GL5091@dastard>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <16281.1336508382@redhat.com>
 <20170.1336555274@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170.1336555274-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2012 at 10:21:14AM +0100, David Howells wrote:
> Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> 
> > I don't think we want to expose the inode generation numbers. It is
> > trivial to construct NFS file handles (usually just fsid, inode
> > number and generation) with that information and hence bypass
> > security checks to access files.
> 
> I was asked for it by Bernd Schubert for userspace NFS servers and FUSE -
> maybe he can say what he wants it for.

It's entirely broken, as a generation number might be part of the file
handle (and for Linux-like filesystems normally is), but it's entirely
up to the filesystem to decide how it works.  That's why we added system
calls to do operations on opaque file handles that the file system
controls.  Exposing a completely meaningless "generation" is a bad idea.
