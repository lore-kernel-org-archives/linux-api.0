From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: mempolicy: fix the absence of the last bit of
 nodemask
Date: Mon, 14 Oct 2019 11:35:46 +0200
Message-ID: <e91614fa-4fc4-5e66-e8a9-3eede916e71f@suse.cz>
References: <1570882789-20579-1-git-send-email-zhangpan26@huawei.com>
 <20191014091243.GD317@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191014091243.GD317@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Pan Zhang <zhangpan26@huawei.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, jgg@ziepe.ca, aarcange@redhat.com, yang.shi@linux.alibaba.com, zhongjiang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Cristopher Lameter <cl@linux.com>, Linux API <linux-api@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 10/14/19 11:12 AM, Michal Hocko wrote:
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 4ae967b..a23509f 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1328,9 +1328,11 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>>  	unsigned long nlongs;
>>  	unsigned long endmask;
>>  
>> -	--maxnode;
>>  	nodes_clear(*nodes);
>> -	if (maxnode == 0 || !nmask)
>> +	/*
>> +	 * If the user specified only one node, no need to set nodemask
>> +	 */
>> +	if (maxnode - 1 == 0 || !nmask)
>>  		return 0;
>>  	if (maxnode > PAGE_SIZE*BITS_PER_BYTE)
>>  		return -EINVAL;
> 
> I am afraid this is a wrong fix. It is really hard to grasp the code but my
> understanding is that the caller is supposed to provide maxnode larger
> than than the nodemask. So if you want 2 nodes then maxnode should be 3.
> Have a look at the libnuma (which is a reference implementation)
> 
> static void setpol(int policy, struct bitmask *bmp)
> {
> 	if (set_mempolicy(policy, bmp->maskp, bmp->size + 1) < 0)
> 		numa_error("set_mempolicy");
> }
> 
> The semantic is quite awkward but it is that way for years.

Yes, unfortunately. Too late to change. We could just update the
manpages at this point.

get_mempolicy(2) says:
 maxnode specifies the number of node IDs that can be stored into
nodemask—that is, the maximum node ID plus one.

- Since node ID starts with 0, it should be actually "plus two".

set_mempolicy(2) says:
 nodemask  points to a bit mask of node IDs that contains up to maxnode
bits.

- should be also clarified.
