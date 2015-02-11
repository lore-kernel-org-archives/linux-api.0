From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 04:46:16 +0100
Message-ID: <20150211034616.GA25022@mail.hallyn.com>
References: <54ACFC38.5070007@nod.at>
 <87fvbmir9q.fsf@x220.int.ebiederm.org>
 <20150107193059.GA1857@mail.hallyn.com>
 <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150107233553.GC28630-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> On Wed, Jan 07, 2015 at 05:27:38PM -0600, Eric W. Biederman wrote:
> > >> The -o SUBSYS option doesn't exist.  Jesus, at least get yourself
> > >> familiar with the basics before claiming random stuff.
> > 
> > Oh let's see I got that command line option out of /proc/mounts and yes
> > it works.  Perhaps it doesn't if I invoke unified hiearchies but the
> > option does in fact exist and work.
> 
> I meant the -o SUBSYS doesn't exist for unified hierarchy.
> 
> > Now I really do need to test report regressions, and send probably send
> > regression fixes.  If I understand your strange ranting I think you just
> > told me that option that -o SUBSYS does work with unified hierarchies.
> 
> What?  Why would -O SUBSYS exist for unified hierarchy?  It's unified
> for all controllers.
> 
> > Tejun.  I asked you specifically about this case 2 years ago at plumbers
> > and you personally told me this would continue to work.  I am going to
> > hold you to that.
> 
> I have no idea what you're talking about in *THIS* thread.  I'm fully
> aware of what was discussed *THEN*.
> 
> > Fixing bugs is one thing.  Gratuitious regressions that make supporting
> > existing user space applications insane is another.
> 
> Can you explain what problem you're actually trying to talk about
> without spouting random claims about regressions?

A few weeks ago, in order to test the cgroup namespace patchset with lxc,
I went through the motions of getting lxc to work with unified hierarchy.
A few of the things I had to change:

1. Hierarchy_num in /proc/cgroups and /proc/self/cgroup start at 0.  Used
to start with 1.  I expect many userspace parsers to be broken by this.

2. After creating every non-leaf cgroup, we must fill in the
cgroup.subtree_cgroups file.  This is extra work which userspace
doesn't have to do right now.

3. Let's say we want to create a freezer cgroup /foo/bar for some set of
tasks, which they will administer.  In fact let's assume we are going to
use cgroup namespaces.  We have to put the tasks into /foo/bar, unshare
the cgroup ns, then create /foo/bar/leaf, move the tasks into /foo/bar/leaf,
and then write 'freezer' into /foo/bar.  (If we're not using cgroup
namespaces, then we have to do a similar thing to let the tasks administer
/foo/bar while placing them under /foo/bar/leaf).  The oddness I'm pointing
to is where the tasks have to know that they can create cgroups in "..".

For containers this becomes odd.  We tend to group containers by the
tasks in and under a cgroup.  We now will have to assume a convention
where we know to check for tasks in and under "..", since by definition
pid 1's cgroup (in a container) cannot have children.

4. The per-cgroup "tasks" file not existing seems odd, although certainly
unexpected by much current software.

So, if the unified hierarchy is going to not cause undue pain, existing
software really needs to start working now to use it.  It's going to be
a sizeable task for lxc.

-serge
