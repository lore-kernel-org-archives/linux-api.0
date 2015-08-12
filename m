From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [CFT][PATCH 09/10] sysfs: Create mountpoints with
 sysfs_create_empty_dir
Date: Wed, 12 Aug 2015 15:15:15 -0400
Message-ID: <20150812191515.GA4496@mtj.duckdns.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <878ucrhxi9.fsf@x220.int.ebiederm.org>
 <20150811184426.GH23408@mtj.duckdns.org>
 <877fp1hcuj.fsf@x220.int.ebiederm.org>
 <CAOS58YOHU8SFv4UXeBRr4t88UU=DXQCPg2HU_dMBmgM7WBB1zQ@mail.gmail.com>
 <87fv3pe3zn.fsf@x220.int.ebiederm.org>
 <87a8txb1k8.fsf@x220.int.ebiederm.org>
 <871tf9b19v.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871tf9b19v.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LINUXFS-ML <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Eric.

On Tue, Aug 11, 2015 at 11:04:28PM -0500, Eric W. Biederman wrote:
> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
> 
> > ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
> >
> >> I just went and attempted to reproduce this, and on RHEL6 workstation
> >> (aka my work laptop), using the todays 4.2.0-rc6+ aka
> >> edf15b4d4b01b565cb5f4fd2e2d08940b9f92e2f and all of the mounts in
> >> /proc/self/mounts are the same between 4.2.0-rc6 and the RHEL6 stock
> >> 2.6.32-504.30.3.el6.x86_64, including the cgroups mounted on /cgroup.
> >
> > I built a few more kernels just to see if this was some weird backport
> > thing. The kernels 3.10.86, 3.14.58, 3.18.20, and 4.1.5 all boot and
> > mount their cgroup filesystems just fine.  Granted I kept having to
> > smack the memory cgroup into being compiled in as the config options
> > kept changing but otherwise I have not seen any problems.
> >
> > So I am very surprised you are having problems.
> 
> Although I guess I could have saved myself some time by noticing that
> 4.1.5 was the only one of the kernels with the change backported into
> it.  *Shrug*
> 
> I don't see the problem and I don't know where to look to see why you
> are having problems.

lol, this wasn't upstart but an internal tool which sets up a custom
cgroup hierarchy and the problem was the size of the directory inode
reported by stat(2).  It's kinda hilarious but that's what the tool
was depending on to tell whether tmpfs is mounted on /sys/fs/cgroup or
not.  A kernfs directory reports zero as its inode size while tmpfs
reports some non-zero number, so the tool did stat(2) on
/sys/fs/cgroup and mounted tmpfs iff size is zero to avoid mounting
tmpfs multiple times.  Now, make_empty_dir_inode() sets i_size to 2
and the tool thinks that tmpfs is already mounted there.

It's an icky behavior but it'd be better to maintain the original
behavior.  We should be able to set size to zero for empty dirs,
right?

Thanks.

-- 
tejun
