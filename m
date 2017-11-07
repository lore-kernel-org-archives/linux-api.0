From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Tue, 7 Nov 2017 16:05:10 +0100
Message-ID: <04e4cb50-8cba-58af-1a5e-61e818cffa70@suse.cz>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-5-git-send-email-xieyisheng1@huawei.com>
 <dccbeccc-4155-94a8-0e67-b7c28238896d@suse.cz>
 <bc57f574-92f2-0b69-4717-a1ec7170387c@huawei.com>
 <d774ecf6-5e7b-e185-85a0-27bf2bcacfb4@suse.cz>
 <alpine.DEB.2.20.1711060926001.9015@nuc-kabylake>
 <a4f1212f-3903-abbc-772a-1ddee6f7f98b@huawei.com>
 <alpine.DEB.2.20.1711070851560.18776@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.20.1711070851560.18776@nuc-kabylake>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Christopher Lameter <cl@linux.com>, Yisheng Xie <xieyisheng1@huawei.com>
Cc: akpm@linux-foundation.org, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, salls@cs.ucsb.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org, tanxiaojun@huawei.com, linux-api@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 11/07/2017 03:54 PM, Christopher Lameter wrote:
> On Tue, 7 Nov 2017, Yisheng Xie wrote:
> 
>> On 2017/11/6 23:29, Christopher Lameter wrote:
>>> On Mon, 6 Nov 2017, Vlastimil Babka wrote:
>>>
>>>> I'm not sure what exactly is the EPERM intention. Should really the
>>>> capability of THIS process override the cpuset restriction of the TARGET
>>>> process? Maybe yes. Then, does "insufficient privilege (CAP_SYS_NICE) to
>>>
>>> CAP_SYS_NICE never overrides cpuset restrictions. The cap can be used to
>>> migrate pages that are *also* mapped by other processes (and thus move
>>> pages of another process which may have different cpu set restrictions!).
>>
>> So you means the specified nodes should be a subset of target cpu set, right?
> 
> The specified nodes need to be part of the *current* cpu set.
> 
> Migrate pages moves the pages of a single process there is no TARGET
> process.

migrate_pages(2) takes a pid argument

"migrate_pages()  attempts  to  move all pages of the process pid that
are in memory nodes old_nodes to the memory nodes in new_nodes. "

> Thus thehe *target* nodes need to be a subset of the current cpu set.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
