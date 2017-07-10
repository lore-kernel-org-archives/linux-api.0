From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/2] mm, memory_hotplug: remove zone restrictions
Date: Mon, 10 Jul 2017 14:12:09 +0200
Message-ID: <cd2352fb-9831-d0f1-5cb8-b081b292eb38@suse.cz>
References: <20170629073509.623-1-mhocko@kernel.org>
 <20170629073509.623-3-mhocko@kernel.org>
 <64e889ae-24ab-b845-5751-978a76dd0dd9@suse.cz>
 <20170710064540.GA19185@dhcp22.suse.cz>
 <24c3606d-837a-266d-a294-7e100d1430f0@suse.cz>
 <20170710111750.GG19185@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170710111750.GG19185@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>, qiuxishi@huawei.com, Kani Toshimitsu <toshi.kani@hpe.com>, slaoub@gmail.com, Joonsoo Kim <js1304@gmail.com>, Daniel Kiper <daniel.kiper@oracle.com>, Igor Mammedov <imammedo@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wei Yang <richard.weiyang@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/10/2017 01:17 PM, Michal Hocko wrote:
> On Mon 10-07-17 13:11:29, Vlastimil Babka wrote:
>> On 07/10/2017 08:45 AM, Michal Hocko wrote:
>>> On Fri 07-07-17 17:02:59, Vlastimil Babka wrote:
>>>> [+CC linux-api]
>>>>
>>>>
>>>> Hm so previously, blocks 37-41 would only allow Movable at this point, right?
>>>
>>> yes
>>>
>>>> Shouldn't we still default to Movable for them? We might be breaking some
>>>> existing userspace here.
>>>
>>> I do not think so. Prior to this merge window f1dd2cd13c4b ("mm,
>>> memory_hotplug: do not associate hotadded memory to zones until online")
>>> we allowed only the last offline or the adjacent to existing movable
>>> memory block to be onlined movable. So the above wasn't possible.
>>
>> Not exactly the above, but let's say 1-34 is onlined as Normal, 35-37 is
>> Movable. Then the only possible action before would be online 38 as
>> Movable? Now it defaults to Normal?
> 
> Yes. And let me repeat you couldn't onlne 35-37 as movable before. So no
> userspace could depend on that before the rework. Or do I still miss
> your point?

Ah, I see. "the last offline or the adjacent to existing movable". OK then.

It would be indeed better to not change behavour twice then and merge
this to 4.13, but it's the middle of merge window, so it's not simple...
