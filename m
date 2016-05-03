From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/2] cgroup_show_path: use a new helper to get current
 cgns css_set
Date: Tue, 3 May 2016 09:26:58 -0500
Message-ID: <20160503142658.GB6309@mail.hallyn.com>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
 <20160418041126.GA424@mail.hallyn.com>
 <20160418052905.GA3848@mail.hallyn.com>
 <20160429214254.GA13615@mail.hallyn.com>
 <20160502163526.GW7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502163526.GW7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> On Fri, Apr 29, 2016 at 04:42:54PM -0500, Serge E. Hallyn wrote:
> > [ I'm sorry, apparently I had sent the wrong version of this patch.  Here
> > is the correct one from
> > https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=2016-04-17/kernfs.show&id=79f784037098fddae92258579ef494537a12f1b2
> > Thanks Michael for pointing that out
> > ]
> > 
> > Since we're getting current's cgroup namespace info, and are
> > not modifying it, we don't need the cgroup_mutex.
> > 
> > Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Can you please fold this into the previous patch?

Will do, and will add the documentation Michael asked for.  In the
middle of something still today, but will send this out this week.

thanks,
-serge
