From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: CGroup Namespaces (v4)
Date: Mon, 16 Nov 2015 21:54:58 -0600
Message-ID: <20151117035458.GA3158@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <CAFLxGvzVmbZHrpaTmXUAK03hsnVPwEs3SJGNFNXfthh3NL8EDg@mail.gmail.com>
 <20151116204606.GA30681@mail.hallyn.com>
 <564A41AF.4040208@nod.at>
 <20151116205452.GA30975@mail.hallyn.com>
 <87y4dxh9b8.fsf@x220.int.ebiederm.org>
 <20151117011349.GA1958@mail.hallyn.com>
 <20151117014026.GA2331@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151117014026.GA2331-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 16, 2015 at 07:40:26PM -0600, Serge E. Hallyn wrote:
> On Mon, Nov 16, 2015 at 07:13:49PM -0600, Serge E. Hallyn wrote:
> > On Mon, Nov 16, 2015 at 04:24:27PM -0600, Eric W. Biederman wrote:
...
> > > Similary have you considered what it required to be able to safely set
> > > FS_USERNS_MOUNT?
> > 
> > I think the only thing we need to do is
> > 
> > 1. go through and make sure that any ability to change mount flags is under
> > capable() (which I have not yet done).  The cgroup_mount() itself checks that
> > flags are not changed, but there may be some subtle way to effect a change
> > that I'm not aware of yet.
> > 
> 
> At least the ability to change the clone_children and release agent through
> remount need to be restricted to init_user_ns root.

No, they can only be changed on a new mount, so these are fine.
