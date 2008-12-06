From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v11][PATCH 00/13] Kernel based checkpoint/restart
Date: Fri, 5 Dec 2008 18:19:57 -0600
Message-ID: <20081206001957.GA29851@us.ibm.com>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1228498282-11804-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, MinChan Kim <minchan.kim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org):
> Checkpoint-restart (c/r): fixed races in file handling (comments from
> from Al Viro). Updated and tested against v2.6.28-rc7 (feaf384...)
> 
> We'd like these to make it into -mm. This version addresses the
> last of the known bugs. Please pull at least the first 11 patches,
> as they are similar to before.
> 
> Patches 1-11 are stable, providing self- and external- c/r of a
> single process.
> Patches 12 and 13 are newer, adding support for c/r of multiple
> processes.
> 
> The git tree tracking v11, branch 'ckpt-v11' (and older versions):
> 	git://git.ncl.cs.columbia.edu/pub/git/linux-cr.git
> 
> Restarting multiple processes requires 'mktree' userspace tool:
> 	git://git.ncl.cs.columbia.edu/pub/git/user-cr.git

Thanks Oren, this set is working great for me.  hours of
(run in container; while (1) { checkpoint; kill; restart in container;}
went fine.  500 simultaneoush checkpoints of the same task
went fine.  mktree works great.

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
