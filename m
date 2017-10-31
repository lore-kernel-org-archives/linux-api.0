From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/4] mm/mempolicy: fix the check of nodemask from
 user
Date: Tue, 31 Oct 2017 12:28:41 +0100
Message-ID: <1e0f1e50-4900-78d2-6586-bd68f5849337@suse.cz>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-4-git-send-email-xieyisheng1@huawei.com>
 <56c4cdbf-c228-6203-285c-15f19a841538@suse.cz>
 <65c0e6cb-28b4-f202-1d7f-278b5dfc3440@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <65c0e6cb-28b4-f202-1d7f-278b5dfc3440-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/31/2017 12:01 PM, Yisheng Xie wrote:
> 
> 
> On 2017/10/31 17:30, Vlastimil Babka wrote:
>> On 10/27/2017 12:14 PM, Yisheng Xie wrote:
>>> +	/*
>>> +	 * When the user specified more nodes than supported just check
>>> +	 * if the non supported part is all zero.
>>> +	 *
>>> +	 * If maxnode have more longs than MAX_NUMNODES, check
>>> +	 * the bits in that area first. And then go through to
>>> +	 * check the rest bits which equal or bigger than MAX_NUMNODES.
>>> +	 * Otherwise, just check bits [MAX_NUMNODES, maxnode).
>>> +	 */
>>>  	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
>>>  		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
>>> -			unsigned long t;
>>>  			if (get_user(t, nmask + k))
>>>  				return -EFAULT;
>>>  			if (k == nlongs - 1) {
>>> @@ -1294,6 +1301,16 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>>>  		endmask = ~0UL;
>>>  	}
>>>  
>>> +	if (maxnode > MAX_NUMNODES && MAX_NUMNODES % BITS_PER_LONG != 0) {
>>> +		unsigned long valid_mask = endmask;
>>> +
>>> +		valid_mask &= ~((1UL << (MAX_NUMNODES % BITS_PER_LONG)) - 1);
>>
>> I'm not sure if the combination with endmask works in this case:
>>
>> 0      BITS_PER_LONG  2xBITS_PER_LONG
>> |____________|____________|
>>        |             |
>>   MAX_NUMNODES      maxnode
>>
>> endmask will contain bits between 0 and maxnode
> 
> In the case, BITS_TO_LONGS(maxnode) > BITS_TO_LONGS(MAX_NUMNODES), right?
> And after checking BITS_PER_LONG to 2xBITS_PER_LONG，endmask will set to
> "~0UL". e.g. endmask will be 0xffff ffff ffff ffff if
> unsigned long is 64bit.
> 
> Then the valid_mask will just contain bits MAX_NUMNODES to BITS_PER_LONG.

Ugh, right. I missed that. This code is not simple...

> Thanks
> Yisheng Xie
> 
>> but here we want to check bits between MAX_NUMNODES and BITS_PER_LONG
>> and endmask should not be mixed up with that?
>>
>>
>> Vlastimil
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
