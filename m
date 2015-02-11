From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 05:29:42 +0100
Message-ID: <20150211042942.GA27931@mail.hallyn.com>
References: <20150107193059.GA1857@mail.hallyn.com>
 <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211040957.GC21356-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> On Wed, Feb 11, 2015 at 04:46:16AM +0100, Serge E. Hallyn wrote:
> > 1. Hierarchy_num in /proc/cgroups and /proc/self/cgroup start at 0.  Used
> > to start with 1.  I expect many userspace parsers to be broken by this.
> 
> This is intentional.  The unified hierarchy will always have the
> hierarchy number zero.  Userland needs to be updated anyway and the
> unified hierarchy won't show up unless explicitly enabled.
> 
> > 2. After creating every non-leaf cgroup, we must fill in the
> > cgroup.subtree_cgroups file.  This is extra work which userspace
> > doesn't have to do right now.
> 
> Again, by design.  This is how organization and control are separated
> and the differing levels of granularity is achieved.
> 
> > 3. Let's say we want to create a freezer cgroup /foo/bar for some set of
> 
> There shouldn't be a "freezer" cgroup.  The processes are categorized
> according to their logical structure and controllers are applied to
> the hierarchy as necessary.

But there can well be cgroups for which only freezer is enabled.  If
I'm wrong about that, then I am suffering a fundamental misunderstanding.

> > tasks, which they will administer.  In fact let's assume we are going to
> > use cgroup namespaces.  We have to put the tasks into /foo/bar, unshare
> > the cgroup ns, then create /foo/bar/leaf, move the tasks into /foo/bar/leaf,
> > and then write 'freezer' into /foo/bar.  (If we're not using cgroup
> > namespaces, then we have to do a similar thing to let the tasks administer
> > /foo/bar while placing them under /foo/bar/leaf).  The oddness I'm pointing
> > to is where the tasks have to know that they can create cgroups in "..".
> > 
> > For containers this becomes odd.  We tend to group containers by the
> > tasks in and under a cgroup.  We now will have to assume a convention
> > where we know to check for tasks in and under "..", since by definition
> > pid 1's cgroup (in a container) cannot have children.
> 
> The semantics is that the parent enables distribution of its given
> type of resource by enabling the controller in its subtree_control.
> This scoping isn't necessary for freezer and I'm debating whether to
> enable controllers which don't need granularity control to be enabled
> unconditionally.  Right now, I'm leaning against it mostly for
> consistency.

Yeah, IIUC (i.e. freezer would always be enabled?) that would be
even-more-confusing.

> > 4. The per-cgroup "tasks" file not existing seems odd, although certainly
> > unexpected by much current software.
> 
> And, yes, everything is per-process for reasons described in
> unified-hierarchy.txt.
> 
> > So, if the unified hierarchy is going to not cause undue pain, existing
> > software really needs to start working now to use it.  It's going to be
> > a sizeable task for lxc.
> 
> Yes, this isn't gonna be a trivial conversion.  The usage model
> changes and so will a lot of controller knobs and behaviors.
> 
> Thanks.
> 
> -- 
> tejun
