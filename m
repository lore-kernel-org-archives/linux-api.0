From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: CGroup Namespaces (v4)
Date: Mon, 16 Nov 2015 14:46:06 -0600
Message-ID: <20151116204606.GA30681@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <CAFLxGvzVmbZHrpaTmXUAK03hsnVPwEs3SJGNFNXfthh3NL8EDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvzVmbZHrpaTmXUAK03hsnVPwEs3SJGNFNXfthh3NL8EDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 16, 2015 at 09:41:15PM +0100, Richard Weinberger wrote:
> Serge,
> 
> On Mon, Nov 16, 2015 at 8:51 PM,  <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > To summarize the semantics:
> >
> > 1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED
> >
> > 2. unsharing a cgroup namespace makes all your current cgroups your new
> > cgroup root.
> >
> > 3. /proc/pid/cgroup always shows cgroup paths relative to the reader's
> > cgroup namespce root.  A task outside of  your cgroup looks like
> >
> >         8:memory:/../../..
> >
> > 4. when a task mounts a cgroupfs, the cgroup which shows up as root depends
> > on the mounting task's  cgroup namespace.
> >
> > 5. setns to a cgroup namespace switches your cgroup namespace but not
> > your cgroups.
> >
> > With this, using github.com/hallyn/lxc #2015-11-09/cgns (and
> > github.com/hallyn/lxcfs #2015-11-10/cgns) we can start a container in a full
> > proper cgroup namespace, avoiding either cgmanager or lxcfs cgroup bind mounts.
> >
> > This is completely backward compatible and will be completely invisible
> > to any existing cgroup users (except for those running inside a cgroup
> > namespace and looking at /proc/pid/cgroup of tasks outside their
> > namespace.)
> >    cgroupns-root.
> 
> IIRC one downside of this series was that only the new "sane" cgroup
> layout was supported
> and hence it was useless for everything which expected the default layout.
> Hence, still no systemd for us. :)
> 
> Is this now different?

Yes, all hierachies are no supported.
