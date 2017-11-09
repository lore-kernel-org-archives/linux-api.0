From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Thu, 9 Nov 2017 18:54:57 +0800
Message-ID: <9991dd10-8883-7c82-bb4e-8145ea2b7299@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-5-git-send-email-xieyisheng1@huawei.com>
 <dccbeccc-4155-94a8-0e67-b7c28238896d@suse.cz>
 <bc57f574-92f2-0b69-4717-a1ec7170387c@huawei.com>
 <d774ecf6-5e7b-e185-85a0-27bf2bcacfb4@suse.cz>
 <alpine.DEB.2.20.1711060926001.9015@nuc-kabylake>
 <a4f1212f-3903-abbc-772a-1ddee6f7f98b@huawei.com>
 <alpine.DEB.2.20.1711070851560.18776@nuc-kabylake>
 <04e4cb50-8cba-58af-1a5e-61e818cffa70@suse.cz>
 <alpine.DEB.2.20.1711070948410.19176@nuc-kabylake>
 <4b08f1e9-5449-6ea2-e7da-65fe5f678683@huawei.com>
 <alpine.DEB.2.20.1711080900050.6161@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1711080900050.6161@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, salls@cs.ucsb.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org, tanxiaojun@huawei.com, linux-api@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi Christopher,

On 2017/11/8 23:02, Christopher Lameter wrote:
> On Wed, 8 Nov 2017, Yisheng Xie wrote:
> 
>> Another case is current process is *not* the same as target process, and
>> when current process try to migrate pages of target process from old_nodes
>> to new_nodes, the new_nodes should be a subset of target process cpuset.
> 
> The caller of migrate_pages should be able to migrate the target process
> pages anywhere the caller can allocate memory. If that is outside the
> target processes cpuset then that is fine. Pagecache pages that are not
> allocated by the target process already are not subject to the target
> processes restriction. So this is not that unusual.

So there is no need to check the restriction of target process cpuset, right?
I hope that I do not miss anything :)

Thanks
Yisheng Xie
> 
> .
> 
