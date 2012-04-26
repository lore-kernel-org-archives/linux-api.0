From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] xstat: Add a pair of system calls to make extended file stats available
Date: Thu, 26 Apr 2012 14:32:36 +0100
Message-ID: <18195.1335447156@redhat.com>
References: <5D4BF4AB-47E9-4E25-B2A3-F895C98BDAA3@dilger.ca> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419140612.17272.57774.stgit@warthog.procyon.org.uk>
Return-path: <libc-alpha-return-27979-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <5D4BF4AB-47E9-4E25-B2A3-F895C98BDAA3@dilger.ca>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> > The idea was initially proposed as a set of xattrs that could be
> > retrieved with getxattr(), but the general preferance proved to be
> > for new syscalls with an extended stat structure.
> 
> I would comment that it was the opposite.  It was originally a
> stat()-like extension that degraded into a messy getxattr() mess.

Ummm...  No, my first attempt was definitely through getxattr().  You even
commented on it.

> > The fields in struct xstat come in a number of classes:
> > 
> > (0) st_dev, st_blksize, st_information.
> > 
> >     These are local data and are always available.
> 
> For the extra two bits it would cost us, I don't think st_blksize
> and st_information should always be returned.

Fair enough.

> st_blksize may be variable for a distributed filesystem,

I wonder if there's a way to make this explicit - or is it something that if
the bit isn't set, you can't use the value in st_blksize.  I wonder if this
value always has to be non-zero to make sure existing stat() doesn't explode.

> and some of the fields in st_information (offline) may not be free to access
> either.

True.

David
