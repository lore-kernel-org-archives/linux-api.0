From: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PACTH v3 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Tue, 16 Aug 2016 14:34:15 -0400
Message-ID: <f8b3bfc6-dbee-dbd1-482b-cfce2c5766d3@collabora.com>
References: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
 <1471368856-11455-2-git-send-email-robert.foss@collabora.com>
 <20160816181840.GB7298@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816181840.GB7298-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, plaguedbypenguins-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.engestrom-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, calvinowens-b10kYP2dOMg@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ldufour-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Zhang <benzh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Filipe Brandenburger <filbranden-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 2016-08-16 02:18 PM, Jann Horn wrote:
> On Tue, Aug 16, 2016 at 01:34:14PM -0400, robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org wrote:
>> From: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
>>
>> This is based on earlier work by Thiago Goncales. It implements a new
>> per process proc file which summarizes the contents of the smaps file
>> but doesn't display any addresses.  It gives more detailed information
>> than statm like the PSS (proprotional set size).  It differs from the
>> original implementation in that it doesn't use the full blown set of
>> seq operations, uses a different termination condition, and doesn't
>> displayed "Locked" as that was broken on the original implemenation.
>>
>> This new proc file provides information faster than parsing the potentially
>> huge smaps file.
>>
>> Tested-by: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
>> Signed-off-by: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
>>
>> Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> ---
> [...]
>> +static int totmaps_open(struct inode *inode, struct file *file)
>> +{
>> +	struct proc_maps_private *priv = NULL;
>> +	struct seq_file *seq;
>> +	int ret;
>> +
>> +	ret = do_maps_open(inode, file, &proc_totmaps_op);
>> +	if (ret)
>> +		goto error;
>> +
>> +	/*
>> +	 * We need to grab references to the task_struct
>> +	 * at open time, because there's a potential information
>> +	 * leak where the totmaps file is opened and held open
>> +	 * while the underlying pid to task mapping changes
>> +	 * underneath it
>> +	 */
>> +	seq = file->private_data;
>> +	priv = seq->private;
>> +	priv->task = get_proc_task(inode);
>> +	if (!priv->task) {
>> +		ret = -ESRCH;
>> +		goto error;
>
> I see that you removed the proc_map_release() call for the upper
> error case as I recommended. However, for the second error case,
> you do have to call it because do_maps_open() succeeded.
>
> You could fix this by turning the first "goto error;" into
> "return;" and adding the proc_map_release() call back in after
> the "error:" label. This would be fine - if an error branch just
> needs to return an error code, it's okay to do so directly
> without jumping to an error label.
>
> Alternatively, you could add a second label
> in front of the existing "error:" label, jump to the new label
> for the second error case, and call proc_map_release() between
> the new label and the old one.

Ah, naturally. Thanks for the patience and advice!

>
>
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	return ret;
>> +}
>> +
> [...]
>> +const struct file_operations proc_totmaps_operations = {
>> +	.open		= totmaps_open,
>> +	.read		= seq_read,
>> +	.llseek		= seq_lseek,
>> +	.release	= proc_map_release,
>> +};
>
> As I said regarding v2 already:
> This won't release priv->task, causing a memory leak (exploitable
> through a reference counter overflow of the task_struct usage
> counter).
>

Sorry about dropping the ball on that one, what's correct way to release 
priv->task?
