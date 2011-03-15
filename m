From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Tue, 15 Mar 2011 21:11:55 +1100
Message-ID: <20110315101155.GO15097@dastard>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
 <20110312021001.GA16833@elie>
 <20110312173217.GA24981@kroah.com>
 <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
 <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103132114380.5145-vIokxiIdD2AQNTJnQDzGJqxOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>
Cc: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sun, Mar 13, 2011 at 09:29:17PM -0700, Sage Weil wrote:
> On Mon, 14 Mar 2011, Indan Zupancic wrote:
> > Everyone seems to want to add this new syncfs, but it's not even defined 
> > what it does. "Same as sync, but only on one fs" is IMHO not good 
> > enough, because sync's behaviour is pretty badly documented, and that's 
> > a system call.
> 
> How about the man page below?  I tried to avoid the somewhat antiquated 
> implementation specific terminology in the sync(2) man page.
> 
> I think adding this functionality into sync_file_range(2) is forcing 
> unrelated functionality into an existing interface; sync_file_range 
> operates on _files_, not an entire file system.  With each API addition it 
> is more important to make the interface simple and intuitive than to 
> minimize the size of our patches.  IMO that's why a new syscall is 
> preferable to, say, an equivalent ioctl.
> 
> Thanks-
> sage
> 
> 
> .TH SYNCFS 2 2011-03-13 "Linux" "Linux Programmer's Manual"
> .SH NAME
> syncfs \- commit cached file system state to stable storage
> .SH SYNOPSIS
> .B #include <unistd.h>
> .sp
> .B void syncfs(int fd);
> .SH DESCRIPTION
> .BR syncfs ()
> flushes any cached data modifications to the file system containing the 
> file referenced by the file descriptor
> .I fd
> to stable storage (usually a disk).  This includes the results of any
> file modifications or other file system operations that have completed
> prior to the call to
> .BR syncfs(2).
> This is similar to 
> .BR sync(2),
> but will commit changes for only a single file system instead of all
> mounted file systems.
> .SH ERRORS
> This function is always successful.

Perhaps we should consider propagating errors out to the user
application rather than discarding them in kernel and pretending we
can't ever have a write error?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
