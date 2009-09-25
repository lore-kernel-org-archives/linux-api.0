From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Fri, 25 Sep 2009 06:59:06 -0700
Message-ID: <87ljk39lcl.fsf@caffeine.danplanet.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090924154139.2a7dd5ec.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> (Andrew Morton's message of "Thu\, 24 Sep 2009 15\:41\:39 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

>> Q: What additional work needs to be done to it?  A: Fill in the
>> gory details following the examples so far. Current WIP includes
>> inet sockets, event-poll, and early work on inotify, mount
>> namespace and mount-points, pseudo file systems

AM> Will this new code muck up the kernel, or will it be clean?

I have (and have previously posted) prototype code to do c/r of open
sockets, ignoring some things like updating timers and such.  It looks
rather similar to the existing UNIX bits, and is even easier in some
ways.

One particular use case is only migrating listening sockets and
allowing the connected ones to be reset upon restart.  That enables a
bunch of things like apache, postfix, vncserver, and even sshd.  I
will pull the listen-only bits out of my current patch, scrape off a
little bitrot, and post them in a few days.

-- 
Dan Smith
IBM Linux Technology Center
email: danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
