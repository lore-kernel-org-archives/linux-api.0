From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Date: Wed, 07 Jul 2010 16:28:35 +0100
Message-ID: <17709.1278516515@redhat.com>
References: <9A36AB6B-7EC3-4789-89CD-D00715BEF34C@dilger.ca> <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com> <20100630233614.32422.97038.stgit@warthog.procyon.org.uk> <4859.1278341989@redhat.com>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9A36AB6B-7EC3-4789-89CD-D00715BEF34C-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> I saw your patch to that effect.  I'm of mixed feelings about this, since
> the S_* flags have traditionally been changed on an ad-hoc basis and I don't
> necessarily want to let this leak into the on-disk format of these flags for
> ext*.
> 
> One way to ensure that this holds true is to have a compile-time assertion
> that the respective S_* flags match FS_*_FL and EXT_*_FL.

Something like this:

	#if S_SYNC != FS_SYNC_FL               ||      \
	       S_IMMUTABLE != FS_IMMUTABLE_FL  ||      \
	       S_APPEND != FS_APPEND_FL        ||      \
	       S_NOATIME != FS_NOATIME_FL      ||      \
	       S_DIRSYNC != FS_DIRSYNC_FL
	#error Ext2/3/4 assumes these equivalences
	#endif

would do the trick.

> > (5) How often are these flags required?  E.g. does it make more sense to
> >   keep them as an additional result, or does it make sense to stick them
> >   in the kstat and xstat structs, knowing that these are allocated on the
> >   kernel stack maybe as three times if an ecryptfs file?
> 
> If they aren't requested by userspace, the cost is mostly irrelevant.  I
> think on OSX these flags are returned for every "ls" call, to mark the
> inodes with xattrs every time.

I suppose.  I was thinking that they may have to be retrieved from the server.

More concerning to me is the effect of adding more fields to the kstat struct.

Nonetheless, having these flags around may be useful to CIFS, Samba, NFS and
NFSD as various of them may appear in those protocols.  Certainly, SMB passes
a bit indicating compression around (ATTR_COMPRESSED).

David
