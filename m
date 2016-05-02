From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] mountinfo: implement show_path for kernfs and cgroup
Date: Mon, 2 May 2016 12:34:41 -0400
Message-ID: <20160502163441.GV7822@mtj.duckdns.org>
References: <1460923472-29370-1-git-send-email-serge.hallyn@ubuntu.com>
	<1460923472-29370-3-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460923472-29370-3-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Sun, Apr 17, 2016 at 03:04:32PM -0500, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> +static int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
> +			    struct kernfs_root *kf_root)
> +{
> +	int len = 0, ret = 0;
> +	char *buf = NULL;
> +	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
> +	struct cgroup_root *kf_cgroot = cgroup_root_from_kf(kf_root);
> +	struct cgroup *ns_cgroup;
> +
> +	mutex_lock(&cgroup_mutex);
> +	spin_lock_bh(&css_set_lock);
> +	ns_cgroup = cset_cgroup_from_root(ns->root_cset, kf_cgroot);
> +	len = kernfs_path_from_node(kf_node, ns_cgroup->kn, NULL, 0);
> +	if (len > 0)
> +		buf = kmalloc(len + 1, GFP_ATOMIC);

Ugh... What's up with GFP_ATOMIC?  Just allocate maximum sized buffer
before grabbing any locks.

Thanks.

-- 
tejun
