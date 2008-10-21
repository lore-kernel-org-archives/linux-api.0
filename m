From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
Date: Tue, 21 Oct 2008 12:21:35 -0700
Message-ID: <20081021122135.4bce362c.akpm@linux-foundation.org>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1224481237-4892-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 20 Oct 2008 01:40:28 -0400
Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org> wrote:

> These patches implement basic checkpoint-restart [CR]. This version
> (v7) supports basic tasks with simple private memory, and open files
> (regular files and directories only).

This is a problem.  I wouldn't want to be in a position where we merge
this code in mainline, but it's just a not-very-useful toy.  Then, as
we turn it into a useful non-toy it all turns into an utter mess.

IOW, merging this code as-is will commit us to merging more code which
hasn't even been written yet.  It might even commit us to solving
thus-far-unknown problems which we don't know how to solve!

It's a big blank cheque.

So.

- how useful is this code as it stands in real-world usage?

- what additional work needs to be done to it?  (important!)

- how far are we down the design and implementation path with that new
  work?  Are we yet at least in a position where we can say "yes, this
  feature can be completed and no, it won't be a horrid mess"?

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
