From: Robert Foss <robert.foss@collabora.com>
Subject: Re: [PATCH v5 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 12 Sep 2016 18:12:28 -0400
Message-ID: <1f5541b1-cb6d-32ef-a528-56dbfb5c29b1@collabora.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
 <1473106449-12847-2-git-send-email-robert.foss@collabora.com>
 <20160907125806.GA3849@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160907125806.GA3849@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, hughd@google.com, mhocko@suse.com, koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, keescook@chromium.org, viro@zeniv.linux.org.uk, mguzik@redhat.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, ebiederm@xmission.com, sonnyrao@chromium.org, seth.forshee@canonical.com, tixxdz@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Jann Horn <jann@thejh.net>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org, Jacek
List-Id: linux-api@vger.kernel.org

Hey Oleg!

Thanks for the feedback, I'll keep it in mind, but currently it looks 
like the patch is on ice for non-implementation related reasons.


Rob.

>>
>> @@ -2854,6 +2854,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>>  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
>>  	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>> +	REG("totmaps",    S_IRUGO, proc_totmaps_operations),
>
> I must have missed something, but I fail to understand why this patch
> is so complicated.
>
> Just use ONE("totmaps", S_IRUGO, proc_totmaps_operations) ?
>
>> +static int totmaps_proc_show(struct seq_file *m, void *data)
>> +{
>> +	struct proc_maps_private *priv = m->private;
>> +	struct mm_struct *mm = priv->mm;
>> +	struct vm_area_struct *vma;
>> +	struct mem_size_stats mss_sum;
>> +
>> +	memset(&mss_sum, 0, sizeof(mss_sum));
>> +	down_read(&mm->mmap_sem);
>> +	hold_task_mempolicy(priv);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^
> why?
>
>> +	for (vma = mm->mmap; vma != priv->tail_vma; vma = vma->vm_next) {
>
> Hmm. the usage of ->tail_vma looks just wrong. I guess the code should
> work because it is NULL but still.
>
>> +		struct mem_size_stats mss;
>> +		struct mm_walk smaps_walk = {
>> +			.pmd_entry = smaps_pte_range,
>> +			.mm = vma->vm_mm,
>> +			.private = &mss,
>> +		};
>> +
>> +		if (vma->vm_mm && !is_vm_hugetlb_page(vma)) {
>> +			memset(&mss, 0, sizeof(mss));
>> +			walk_page_vma(vma, &smaps_walk);
>> +			add_smaps_sum(&mss, &mss_sum);
>> +		}
>> +	}
>
> Why? I mean, why not walk_page_range() ? You do not need this for-each-vma
> loop at all? At least if you change this patch to use the ONE() helper, and
> everything else looks unneeded in this case.
>
> Oleg.
>
