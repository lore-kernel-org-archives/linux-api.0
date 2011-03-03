From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Date: Thu, 03 Mar 2011 14:59:39 +0800
Message-ID: <4D6F3C5B.8020307@cn.fujitsu.com>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.1103021912090.2701-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "Kirill A. Shutsemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>> +unsigned long get_task_timer_slack(struct task_struct *tsk)
>> +{
>> +	struct cgroup_subsys_state *css;
>> +	struct tslack_cgroup *tslack_cgroup;
>> +	unsigned long ret;
>> +
>> +	rcu_read_lock();
> 
> Did you just remove the odd comment or actually figure out why you
> need rcu_read_lock() here ?
> 

It's necessary to protect against task exiting or task moving between cgroups.

>> +	css = task_subsys_state(tsk, timer_slack_subsys.subsys_id);
>> +	tslack_cgroup = container_of(css, struct tslack_cgroup, css);
>> +	ret = max(tsk->timer_slack_ns, tslack_cgroup->min_slack_ns);
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>> +}
> 
> Otherwise, it's way more palatable than the last one.
> 
> Thanks,
> 
> 	tglx
> 
