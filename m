From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Date: Wed, 2 Mar 2011 19:40:01 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299084001-3916-2-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2 Mar 2011, Kirill A. Shutsemov wrote:

Not CC'ing me does not avoid another review :)

> diff --git a/fs/select.c b/fs/select.c
> index e56560d..a189e4d 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -69,7 +69,6 @@ static long __estimate_accuracy(struct timespec *tv)
>  
>  long select_estimate_accuracy(struct timespec *tv)
>  {
> -	unsigned long ret;
>  	struct timespec now;
>  
>  	/*
> @@ -81,10 +80,8 @@ long select_estimate_accuracy(struct timespec *tv)
>  
>  	ktime_get_ts(&now);
>  	now = timespec_sub(*tv, now);
> -	ret = __estimate_accuracy(&now);
> -	if (ret < current->timer_slack_ns)
> -		return current->timer_slack_ns;
> -	return ret;
> +	return clamp(__estimate_accuracy(&now),
> +			get_task_timer_slack(current), LONG_MAX);
>  }

Can you please split out the get_task_timer_slack() change into a
separate patch?

Also the function wants to be named different.

task_get_effective_timer_slack() or such, so it becomes clear, that
it's not just a wrapper around tsk->timer_slack_ns

And the places which access tsk->timer_slack_ns directly should be
updated with comments, why they are not using the wrapper.

> +static int tslack_write_min(struct cgroup *cgroup, struct cftype *cft, u64 val)
> +{
> +	struct cgroup *cur;
> +
> +	if (val > ULONG_MAX)
> +		return -EINVAL;
> +
> +	/* the min timer slack value should be more or equal than parent's */

s/should/must/

> +	if (cgroup->parent) {
> +		struct tslack_cgroup *parent = cgroup_to_tslack(cgroup->parent);

New line between variables and code please

> +		if (parent->min_slack_ns > val)
> +			return -EPERM;
> +	}
> +
> +	cgroup_to_tslack(cgroup)->min_slack_ns = val;
> +
> +	/* update children's min slack value if needed */
> +	list_for_each_entry(cur, &cgroup->children, sibling) {
> +		struct tslack_cgroup *child = cgroup_to_tslack(cur);

Ditto

> +		if (val > child->min_slack_ns)
> +			tslack_write_min(cur, cft, val);
> +	}

So, we can increase the value and propagate it through the groups
children, but decreasing it requires to go through all child groups
seperately. 

When I'm trying to optimize something during runtime and chose a too
high value I need to go through hoops and loops to make it smaller
again.

Asymetric behaviour sucks always.

> +unsigned long get_task_timer_slack(struct task_struct *tsk)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct tslack_cgroup *tslack_cgroup;
> +	unsigned long ret;
> +
> +	rcu_read_lock();

Did you just remove the odd comment or actually figure out why you
need rcu_read_lock() here ?

> +	css = task_subsys_state(tsk, timer_slack_subsys.subsys_id);
> +	tslack_cgroup = container_of(css, struct tslack_cgroup, css);
> +	ret = max(tsk->timer_slack_ns, tslack_cgroup->min_slack_ns);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}

Otherwise, it's way more palatable than the last one.

Thanks,

	tglx
