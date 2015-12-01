From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Tue, 1 Dec 2015 11:46:49 -0500
Message-ID: <20151201164649.GD12922@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151127051745.GA24521@mail.hallyn.com>
 <20151130150938.GF3535@mtj.duckdns.org>
 <20151201040704.GA31067@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151201040704.GA31067-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hey, Serge.

On Mon, Nov 30, 2015 at 10:07:04PM -0600, Serge E. Hallyn wrote:
> So actually the way the code is now, the first mount cannot
> be done from a non-init user namespace; and kernfs_obtain_root()
> is only called from non-init user namespace.  So can we assume
> that the root dentry will be instantiated?  (or can it get
> evicted?)
> 
> If we can assume that then most of that fn can go away.

The v2 hierarchy is always mounted and non-init ns shouldn't be able
to create new v1 hierarchies, so the root dentry should always be
there.

Thanks.

-- 
tejun
