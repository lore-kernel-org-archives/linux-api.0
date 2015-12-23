From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/8] cgroup: introduce cgroup namespaces
Date: Wed, 23 Dec 2015 11:15:26 -0500
Message-ID: <20151223161526.GG5003@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <1450844609-9194-4-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450844609-9194-4-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Dec 22, 2015 at 10:23:24PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
...
> +char *cgroup_path(struct cgroup *cgrp, char *buf, size_t buflen)
> +{
> +	int ret;
> +	
> +	ret = cgroup_path_ns(cgrp, buf, buflen, current->nsproxy->cgroup_ns);
> +	if (ret < 0 || ret >= buflen)
> +		return NULL;
> +	return buf;
> +}
> +EXPORT_SYMBOL_GPL(cgroup_path);

Shouldn't this function check whether it's being called from a task
context?  e.g. it could be being called from an irq handler and may
end up scoping the path incorrectly.

Thanks.

-- 
tejun
