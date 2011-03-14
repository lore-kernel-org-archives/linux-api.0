From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 13:10:42 -0700
Message-ID: <20110314131042.5a7fb32f.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	<Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	<edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	<201103111255.44979.arnd@arndb.de>
	<ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	<20110311235607.GB15853@elie>
	<9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	<20110312021001.GA16833@elie>
	<20110312173217.GA24981@kroah.com>
	<1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1e597aedd3d7825dcc0630b1cf2399fa.squirrel-2RFepEojUI3wYrDfM2ltn5vKXLoBo5SK@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Mon, 14 Mar 2011 02:56:52 +0100 (CET)
"Indan Zupancic" <indan-1J6HnF7K7zE@public.gmane.org> wrote:

> On Sat, March 12, 2011 18:32, Greg KH wrote:
> > On Fri, Mar 11, 2011 at 08:10:01PM -0600, Jonathan Nieder wrote:
> >> Indan Zupancic wrote:
> >>
> >> > I'm not pushing for any official convention, just what seems good taste.
> >>
> >> In cases like this, conventions (consistency and best practices) are
> >> very important.
> >>
> >> > Less code added, less bloat. Architecture independent, no need to update
> >> > all system call tables everywhere (all archs, libc versions and strace).
> >> > Two files changed, instead of 7 (which only hooks up x86).
> >>
> >> Thanks for explaining.  Those do seem like good reasons to use a ioctl
> >> instead of a new syscall.
> >
> > No, make it a syscall, it's more obvious and will be documented much
> > better.
> 
> There is no such guarantee. Everyone seems to want to add this new syncfs,
> but it's not even defined what it does. "Same as sync, but only on one fs"
> is IMHO not good enough, because sync's behaviour is pretty badly documented,
> and that's a system call. The sync_file_range argument effects are quite
> well defined, on the other hand, unlike sync behaviour. You're right for
> ioctls though.

I think the semantics of sync are easily enough defined, even if
they're not well-defined in the documentation: all data which was dirty
at the time sync() was called will be written back and accessible when
the sync() returns.

I do agree that this should be a standalone syscall, not grafted into
sync_file_range() or into an ioctl.


That being said, we have two similar-looking-but-quite-different "sync"
concepts in the kernel.  One is "sync for data integrity" and the other
is "sync to reduce the dirty memory load".  The latter is not a data
integrity thing - it is a resource management thing.

There might one day be a requirement to be able to initiate a
resource-management-style writeback against a whole filesystem.  When
that happens, we'll regret not having added a "mode" argument to
sys_syncfs().

Or maybe not - given that we're syncing the entire fs and that
sync_filesystem() does the two-pass "write for data cleaning then write
for data integrity" thing, it could be that a syncfs-for-data-cleaning
operation has little performance benefit over a
syncfs-for-data-integrity operation.
