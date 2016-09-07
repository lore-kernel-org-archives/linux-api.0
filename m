From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Wed, 7 Sep 2016 14:58:07 +0200
Message-ID: <20160907125806.GA3849@redhat.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com> <1473106449-12847-2-git-send-email-robert.foss@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473106449-12847-2-git-send-email-robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, calvinowens-b10kYP2dOMg@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Zhang <benzh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Filipe Brandenburger <filbranden-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jacek
List-Id: linux-api@vger.kernel.org

On 09/05, robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org wrote:
>
> @@ -2854,6 +2854,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
>  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
> +	REG("totmaps",    S_IRUGO, proc_totmaps_operations),

I must have missed something, but I fail to understand why this patch
is so complicated.

Just use ONE("totmaps", S_IRUGO, proc_totmaps_operations) ?

> +static int totmaps_proc_show(struct seq_file *m, void *data)
> +{
> +	struct proc_maps_private *priv = m->private;
> +	struct mm_struct *mm = priv->mm;
> +	struct vm_area_struct *vma;
> +	struct mem_size_stats mss_sum;
> +
> +	memset(&mss_sum, 0, sizeof(mss_sum));
> +	down_read(&mm->mmap_sem);
> +	hold_task_mempolicy(priv);
        ^^^^^^^^^^^^^^^^^^^^^^^^^
why?

> +	for (vma = mm->mmap; vma != priv->tail_vma; vma = vma->vm_next) {

Hmm. the usage of ->tail_vma looks just wrong. I guess the code should
work because it is NULL but still.

> +		struct mem_size_stats mss;
> +		struct mm_walk smaps_walk = {
> +			.pmd_entry = smaps_pte_range,
> +			.mm = vma->vm_mm,
> +			.private = &mss,
> +		};
> +
> +		if (vma->vm_mm && !is_vm_hugetlb_page(vma)) {
> +			memset(&mss, 0, sizeof(mss));
> +			walk_page_vma(vma, &smaps_walk);
> +			add_smaps_sum(&mss, &mss_sum);
> +		}
> +	}

Why? I mean, why not walk_page_range() ? You do not need this for-each-vma
loop at all? At least if you change this patch to use the ONE() helper, and
everything else looks unneeded in this case.

Oleg.
