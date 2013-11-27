From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/3] statxat: Provide IOC flags for Windows fs attributes
Date: Wed, 27 Nov 2013 03:40:34 -0800
Message-ID: <20131127114034.GA13491@infradead.org>
References: <20131112173518.25813.67568.stgit@warthog.procyon.org.uk>
 <20131112173526.25813.85546.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131112173526.25813.85546.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 12, 2013 at 05:35:26PM +0000, David Howells wrote:
> Provide IOC flags for Windows fs attributes so that they can be retrieved (or
> even altered) using the FS_IOC_[GS]ETFLAGS ioctl and read using statxat().

As mentioned before we're running out of these flags and we already have
a horrible mash up between filesystem specific implementation details
an generally useful ones, so if you want to add them to a stat-like
call you better define an entirely new namespaces.

Also each of the added ones needs a good justification either way.
