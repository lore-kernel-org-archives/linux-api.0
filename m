From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs_path_from_node_locked: don't overwrite nlen
Date: Mon, 2 May 2016 12:32:56 -0400
Message-ID: <20160502163256.GT7822@mtj.duckdns.org>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
 <1460923472-29370-2-git-send-email-serge.hallyn@ubuntu.com>
 <20160420194313.GA4775@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420194313.GA4775-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 20, 2016 at 03:43:13PM -0400, Tejun Heo wrote:
> On Sun, Apr 17, 2016 at 03:04:31PM -0500, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> > From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > 
> > We've calculated @len to be the bytes we need for '/..' entries from
> > @kn_from to the common ancestor, and calculated @nlen to be the extra
> > bytes we need to get from the common ancestor to @kn_to.  We use them
> > as such at the end.  But in the loop copying the actual entries, we
> > overwrite @nlen.  Use a temporary variable for that instead.
> > 
> > Without this, the return length, when the buffer is large enough, is
> > wrong.  (When the buffer is NULL or too small, the returned value is
> > correct. The buffer contents are also correct.)
> > 
> > Interestingly, no callers of this function are affected by this as of
> > yet.  However the upcoming cgroup_show_path() will be.
> > 
> > Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Greg, can you please pick this one up for v4.6?

Looks like Greg missed this one.  Greg, I'll route this through
cgroup/for-4.6-fixes.

Thanks.

-- 
tejun
