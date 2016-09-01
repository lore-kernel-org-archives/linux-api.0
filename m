From: Robert Foss <robert.foss@collabora.com>
Subject: Re: [PACTH v4 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Thu, 1 Sep 2016 19:42:49 -0400
Message-ID: <644216ff-961e-bcb1-80bc-2d4c1f94f0db@collabora.com>
References: <1471386804-7236-1-git-send-email-robert.foss@collabora.com>
 <1471386804-7236-2-git-send-email-robert.foss@collabora.com>
 <ca113c1a-d016-74a9-2e72-da1f881bfb8e@samsung.com>
 <030a5655-bdc2-94a2-ee52-d6ea7be19a31@collabora.com>
 <20160831170415.pc2hlvb7fevpichy@mguzik>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160831170415.pc2hlvb7fevpichy@mguzik>
Sender: linux-doc-owner@vger.kernel.org
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, john.stultz@linaro.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, mnfhuang@gmail.com, adobriyan@gmail.com, calvinowens@fb.com, jdanis@google.com, jann@thejh.net, sonnyrao@chromium.org, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Michal Hocko <mhocko@kernel.org>, linux-api@vg
List-Id: linux-api@vger.kernel.org



On 2016-08-31 01:04 PM, Mateusz Guzik wrote:
> On Wed, Aug 31, 2016 at 12:36:26PM -0400, Robert Foss wrote:
>> On 2016-08-31 05:45 AM, Jacek Anaszewski wrote:
>>>> +static void *m_totmaps_start(struct seq_file *p, loff_t *pos)
>>>> +{
>>>> +    return NULL + (*pos == 0);
>>>> +}
>>>> +
>>>> +static void *m_totmaps_next(struct seq_file *p, void *v, loff_t *pos)
>>>> +{
>>>> +    ++*pos;
>>>> +    return NULL;
>>>> +}
>>>> +
>>>
>>> When reading totmaps of kernel processes the following NULL pointer
>>> dereference occurs:
>>>
>>> Unable to handle kernel NULL pointer dereference at virtual address
>>> 00000044
>>> [<c06c01f4>] (down_read) from [<c022a154>] (totmaps_proc_show+0x2c/0x1e8)
>>> [<c022a154>] (totmaps_proc_show) from [<c01fe564>] (seq_read+0x1c8/0x4b8)
>>> [<c01fe564>] (seq_read) from [<c01dc850>] (__vfs_read+0x2c/0x110)
>>> [<c01dc850>] (__vfs_read) from [<c01ddca0>] (vfs_read+0x8c/0x110)
>>> [<c01ddca0>] (vfs_read) from [<c01ddd64>] (SyS_read+0x40/0x8c)
>>> [<c01ddd64>] (SyS_read) from [<c0107900>] (ret_fast_syscall+0x0/0x3c)
>>>
>>> It seems that some protection is needed for such processes, so that
>>> totmaps would return empty string then, like in case of smaps.
>>>
>>
>> Thanks for the testing Jacek!
>>
>> I had a look around the corresponding smaps code, but I'm not seeing any
>> checks, do you know where that check actually is made?
>>
>
> See m_start in f/sproc/task_mmu.c. It not only check for non-null mm,
> but also tries to bump ->mm_users and only then proceeds to walk the mm.

So a m_totmaps_start that looks something like the below would be 
enough? And if so, would mm->mm_users need to be decrement inside of
m_totmaps_start?

static void *m_totmaps_start(struct seq_file *p, loff_t *pos)
{
	struct proc_maps_private *priv = m->private;
	struct mm_struct *mm;

	mm = priv->mm;
	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
		return NULL;

	return NULL + (*pos == 0);
}

