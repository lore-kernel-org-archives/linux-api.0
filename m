From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
Date: Mon, 01 Dec 2008 13:25:45 -0800
Message-ID: <1228166745.2971.113.camel@nimitz>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>
	 <20081128101919.GO28946@ZenIV.linux.org.uk>
	 <1228153645.2971.36.camel@nimitz> <493447DD.7010102@cs.columbia.edu>
	 <1228164679.2971.91.camel@nimitz>
	 <alpine.LFD.2.00.0812011258390.3256@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0812011258390.3256-nfNrOhbfy2R17+2ddN/4kux8cNe9sq/dYPYVAmT7z5s@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2008-12-01 at 13:02 -0800, Linus Torvalds wrote:
> On Mon, 1 Dec 2008, Dave Hansen wrote:
> > 
> > Why is this done in two steps?  It first grabs a list of fd numbers
> > which needs to be validated, then goes back and turns those into 'struct
> > file's which it saves off.  Is there a problem with doing that
> > fd->'struct file' conversion under the files->file_lock?
> 
> Umm, why do we even worry about this?
> 
> Wouldn't it be much better to make sure that all other threads are 
> stopped before we snapshot, and if we cannot account for some thread (ie 
> there's some elevated count in the fs/files/mm structures that we cannot 
> see from the threads we've stopped), just refuse to dump.

My guess is that the mm is probably ok here, but we'll need some work on
the vfs structures, at least eventually.

The mm is nice that it has ->count separated from ->users.  We can
easily compare the sum of mm->users to the number of tasks we've frozen
since mm->users has nice defined behavior.

But, we've got suckers like proc_fd_info() that do a
get/put_files_struct().  So, somebody just doing lots of looks in /proc
could stop us from ever checkpointing.  Unfortunately, I know of a
number of "monitoring" programs that do just that. :)

I guess we can use the plain counts for now, and add something like
mm->users for the vfs structures in a bit.  

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
