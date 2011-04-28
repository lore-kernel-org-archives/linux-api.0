From: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Date: Thu, 28 Apr 2011 16:22:10 -0700
Message-ID: <20110428232210.GA4132@noexit.corp.google.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
 <20110427085910.GA1749@linux.betterlinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110427085910.GA1749-Td79XgCuBx/ToqTmb/eOq0M9+F4ksjoh@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 11:01:28AM +0200, Andrea Righi wrote:
> On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> > On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> > > Introduce sys_drop_pagecache() system call to drop the page cache pages of
> > > a single filesystem.
<snip>
> > > This functionality can be used by all the applications that want to have a
> > > better control over the page cache management (for example to immediately drop
> > > pages that for sure will not be reused in the near future, without calling
> > > posix_fadvise() for all the files they've touched), or to provide a more fine
> > > grained debugging feature usable by the filesystem benchmarks.
> > > 
> > > The system call does not require root privileges and it can be called by any
> > > unprivileged application. For example, we can write a userspace tool to run
> > > something like this:
> > > 
> > >   $ drop-pagecache /path/file_or_dir
> > 
> > That's a potential DOS vector, I think. Drop the pagecache in a hard
> > loop on the root fs of a busy server and watch it crawl...
> 
> Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
> this syscall.

	The majority of apps that want this do not run as root.  Do we
want them all setuid?  ;-)

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

			http://www.jlbec.org/
			jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org
