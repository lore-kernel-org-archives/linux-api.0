From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Tue, 26 Apr 2016 12:29:25 +0200
Message-ID: <20160426102925.vkydkjtrsnibuc7c@ws.net.home>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
 <20160418041126.GA424@mail.hallyn.com>
 <87mvoqqu48.fsf@x220.int.ebiederm.org>
 <20160419014419.GA19080@mail.hallyn.com>
 <20160419040546.GA20350@mail.hallyn.com>
 <20160426024207.GA2783@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426024207.GA2783-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 25, 2016 at 09:42:07PM -0500, Serge E. Hallyn wrote:
> > Looking at it another way...  The value we're talking about shows us
> > the path of the root dentry of a cgroup mount.  If a task in cgns2
> > rooted at /a/b/c mounts a cgroupfs, it will see '/' as the root dentry.
> > If a task in cgns1 rooted at /a/b looks at that mountinfo, '/' would
> > be misleading.  It really should be '/c'.
> 
> So I think that for cgroup mount entries in mountinfo to be useful (i.e.
> to criu) we either need the root dentry path to be given as relative to
> the reader's cgroup namespace (as I have it in this patchset), or else
> we need to add another piece of information in the mountinfo entry, such
> as the nsfd inode number of the cgroup namespace in which it was
> mounted.

In the ideal world there is no mountinfo file, but /proc/self/mountinfo/<id>/
directory with individual files, so every subsystem and filesystem has 
absolute freedom to store there all relevant information. The result will 
be also lucky kernel that does not have to always generate entire huge 
mountinfo file for all mountpoins... etc. :-)

    Karel

-- 
 Karel Zak  <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 http://karelzak.blogspot.com
