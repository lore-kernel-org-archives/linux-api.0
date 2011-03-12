From: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Fri, 11 Mar 2011 20:10:01 -0600
Message-ID: <20110312021001.GA16833@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9446ab1a2315c0d2476c30f8315a0503.squirrel-2RFepEojUI3wYrDfM2ltn5vKXLoBo5SK@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

Indan Zupancic wrote:

> I'm not pushing for any official convention, just what seems good taste.

In cases like this, conventions (consistency and best practices) are
very important.

> Less code added, less bloat. Architecture independent, no need to update
> all system call tables everywhere (all archs, libc versions and strace).
> Two files changed, instead of 7 (which only hooks up x86).

Thanks for explaining.  Those do seem like good reasons to use a ioctl
instead of a new syscall.

> In this case it's just a performance improvement over sync(2). It doesn't
> add a new feature. Main argument given for the performance problem seems
> to be "NFS can be slow". Anything else?

Huh?  It is not just the speed of the sync --- unnecessary writeback
will cause wear on your thumbdrive, eat up your laptop battery, and
kill I/O performance in other tasks running at the same time.

I'm afraid I don't understand what you're saying here at all.  Would
you say that fsync is superfluous, too?

Jonathan
