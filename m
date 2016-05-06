From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Fri, 6 May 2016 13:42:32 -0400
Message-ID: <20160506174232.GC7110@mtj.duckdns.org>
References: <20160505152058.GC13186@mail.hallyn.com>
 <6db5b7e5-3f15-39bd-cc9e-e3c296378e54@gmail.com>
 <20160506173356.GA1228@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160506173356.GA1228-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, May 06, 2016 at 12:33:56PM -0500, Serge E. Hallyn wrote:
> Right.  So in particular, docker wants to do something like:
> 
> bindpath=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $4 }'`
> mountpoint=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $5 }'`
> mycg=`awk -F: '/freezer/ { print $3 }' /proc/self/cgroup`
> cat ${mountpoint}/${bindpath}/${mycg}/cgroup.procs
> 
> and see its own task.

Can you please make the example more concrete?  e.g. Use actual paths
and show what they show now vs. what they should.

Thanks.

-- 
tejun
