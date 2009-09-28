From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Mon, 28 Sep 2009 11:37:04 -0500
Message-ID: <20090928163704.GA3327@us.ibm.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com> <20090924154139.2a7dd5ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090924154139.2a7dd5ec.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Andrew Morton (akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org):
> On Wed, 23 Sep 2009 19:50:40 -0400
> Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org> wrote:
> > Q: What about namespaces ?
> > A: Currrently, UTS and IPC namespaces are restored. They demonstrate
> >    how namespaces are handled. More to come.
> 
> Will this new code muck up the kernel?

Actually user namespaces are handled as well.  Pid namespaces will
be named and recorded by kernel at checkpoint, and re-created in
userspace using clone(CLONE_NEWPID).  This shouldn't muck up the
kernel at all.  The handling of network and mounts namespaces is
at this point undecided.  Well, mounts namespaces themselves are
pretty simple, but not so much for mountpoints.  There it's mainly
a question of how to predict what a user wants to have automatically
recreated.  All mounts which differ between the root checkpoint task
and its parent?  Do we do no mounts for the restarted init task at
all, and only recreate mounts in private child namespaces (i.e. if a
task did a unshare(CLONE_NEWNS); mount --make-private /var; 
mount --bind /container2/var/run /var/run)?

I hear a decision was made at plumber's about how to begin
handling them, so I'll let someone (Oren? Dave?) give that info.

For network namespaces i think it's clearer that a wrapper
program should set up the network for the restarted init task,
while the usrspace code should recreate any private network
namespaces and veth's which were created by the application.
But it still needs discussion.

> > Q: What additional work needs to be done to it?
> > A: Fill in the gory details following the examples so far. Current WIP
> >    includes inet sockets, event-poll, and early work on inotify, mount
> >    namespace and mount-points, pseudo file systems
> 
> Will this new code muck up the kernel, or will it be clean?
> 
> > and x86_64 support.
> 
> eh?  You mean the code doesn't work on x86_64 at present?

There have been patches for it, but I think the main problem is noone
involved has hw to test.

> What is the story on migration?  Moving the process(es) to a different
> machine?

Since that's basically checkpoint; recreate container on remote
machine; restart on remote machine; that will mainly be done by
userspace code exploiting the c/r kernel patches.

The main thing we may want to add is a way to initiate pre-dump
of large amounts of VM while the container is still running.
I suspect Oren and Dave can say a lot more about that than I can
right now.

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
