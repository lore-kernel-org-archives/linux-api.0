From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Thu, 12 Feb 2009 14:48:42 -0600
Message-ID: <20090212204842.GA16269@us.ibm.com>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu> <1234285547.30155.6.camel@nimitz> <20090211141434.dfa1d079.akpm@linux-foundation.org> <20090212091721.GB1888@elte.hu> <1234462283.30155.173.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1234462283.30155.173.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Dave Hansen (dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org):
> Patch 12/14 is supposed to address this *concept*.  But, it hasn't been
> carried through so that it currently works.  My expectation was that we
> would go through and add things over time.  I'll go make sure I push it
> to the point that it actually works for at least the simple test
> programs that we have.
> 
> What I will probably do is something BKL-style.  Basically put a "this
> can't be checkpointed" marker over most everything I can think of and
> selectively remove it as we add features.  

So the question is: when can we unset the uncheckpointable flag?

In your patch you suggest clone(CLONE_NEWPID).  But that would
require that we at that point do a slew of checks for other
things like open files of a type which are not supported.

I'm wondering whether we should instead stick to calculating
whether a task is checkpointable or not at checkpoint time.
To help an application figure out whether it can be checkpointed,
we can hook /proc/$$/checkpointable to the same function, and
have the file output list all of the reasons the task is not
checkpointable.  i.e.

	mmap MAP_SHARED file which is not yet supported
	open file from another mounts namespace
	open TCP socket which is not yet supported
	open epoll fd which is not yet supported
	TASK NOT FROZEN

So now every time we do a checkpoint we have to do all these
checks, but that's better than at clone time.

You suggested on irc having a fops->is_checkpointable()
fn, which is imo a good idea to help implement the above.
The default value can be a fn returning false.  I suppose
we want to pass back a char* with the file type as well.

-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
