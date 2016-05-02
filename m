From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 2 May 2016 12:33:32 -0400
Message-ID: <20160502163332.GU7822@mtj.duckdns.org>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
	<1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
	<20160418041126.GA424@mail.hallyn.com>
	<87mvoqqu48.fsf@x220.int.ebiederm.org>
	<20160419014419.GA19080@mail.hallyn.com>
	<20160419040546.GA20350@mail.hallyn.com>
	<20160426024207.GA2783@mail.hallyn.com>
	<20160426102925.vkydkjtrsnibuc7c@ws.net.home>
	<20160426143622.GA11021@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160426143622.GA11021-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 26, 2016 at 09:36:23AM -0500, Serge E. Hallyn wrote:
> > In the ideal world there is no mountinfo file, but /proc/self/mountinfo/<id>/
> > directory with individual files, so every subsystem and filesystem has 
> > absolute freedom to store there all relevant information. The result will 
> > be also lucky kernel that does not have to always generate entire huge 
> > mountinfo file for all mountpoins... etc. :-)
> 
> Yeah mountinfo does seem like a big stick to swing around every time I want
> one little piece of information.  Also mght be good to have per-fstype
> directories so we can just look under /proc/self/mountsdir/cgroupfs/ for
> only cgroupfs <id>s.
> 
> There we might also find open fds for source and mountdir, kinda fitting
> in with previous discussions of separating bdev_open() and mountat().
> 
> BTW, assuming this would in fact report source and mountpoint location
> with fds, these would really (through realpath) be reported relative to
> the reader's namespace, as I'm doing and advocating here.

So, what's the consensus here?  Is everyone okay with the posted
patches?

Thanks.

-- 
tejun
