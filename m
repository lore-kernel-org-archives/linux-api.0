From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Extended file stat: Splitting file- and fs-specific info?
Date: Wed, 9 May 2012 08:05:44 -0400
Message-ID: <20120509120544.GA17535@infradead.org>
References: <20120509002420.GL5091@dastard>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <16281.1336508382@redhat.com>
 <20170.1336555274@redhat.com>
 <20120509111958.GA11345@infradead.org>
 <4FAA5B24.1020306@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FAA5B24.1020306-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2012 at 01:55:16PM +0200, Bernd Schubert wrote:
> The basic idea of generation numbers is to check if an inode was
> recycled, so only if the tuple of inode-number and generation-number
> matches we still have the same file. Kernel nfs

NFS does not and should not look at the inode generation.  Except for a
bit of legacy code for the old pre-Linux 2.4 filehandles it looks at the
opaque file handle returned and only interpreted by the filesystem.  Any
userspace NFS server should do the same.
