From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/4] mm/mempolicy: Fix get_nodes() mask
 miscalculation
Date: Wed, 1 Nov 2017 17:37:36 +0800
Message-ID: <c9b57bde-7834-45c4-2c22-3220e3680c93@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-2-git-send-email-xieyisheng1@huawei.com>
 <922a4767-9eed-40aa-c437-6f6fcdcab150@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <922a4767-9eed-40aa-c437-6f6fcdcab150-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

Thanks for comment!
On 2017/10/31 16:34, Vlastimil Babka wrote:
> On 10/27/2017 12:14 PM, Yisheng Xie wrote:
>> It appears there is a nodemask miscalculation in the get_nodes()
>> function in mm/mempolicy.c.  This bug has two effects:
>>
>> 1. It is impossible to specify a length 1 nodemask.
>> 2. It is impossible to specify a nodemask containing the last node.
> 
> This should be more specific, which syscalls are you talking about?
> I assume it's set_mempolicy() and mbind() and it's the same issue that
> was discussed at https://marc.info/?l=linux-mm&m=150732591909576&w=2 ?

I just missed this thread, sorry about that. Not only set_mempolicy() and
mbind(), but migrate_pages() also suffers this problem. Maybe related
manpage should documented this as your mentioned below.

Thanks
Yisheng Xie

> 
>> Brent have submmit a patch before v2.6.12, however, Andi revert his
>> changed for ABI problem. I just resent this patch as RFC, for do not
>> clear about what's the problem Andi have met.
> 
> You should have CC'd Andi. As was discussed in the other thread, this
> would make existing programs potentially unsafe, so we can't change it.
> Instead it should be documented.
> 
>> As manpage of set_mempolicy, If the value of maxnode is zero, the
>> nodemask argument is ignored. but we should not ignore the nodemask
>> when maxnode is 1.
>>
