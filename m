From: "prakash.sangappa" <prakash.sangappa@oracle.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Mon, 7 May 2018 15:50:30 -0700
Message-ID: <a61bc7b6-ed98-045d-95c0-b6c91fc8d1da@oracle.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake>
 <c80ee329-084b-367f-1937-3175c178e978@oracle.com>
 <alpine.DEB.2.21.1805040955550.10847@nuc-kabylake>
 <98e34010-d55a-5f2d-7d98-cba424de2e74@oracle.com>
 <alpine.DEB.2.21.1805070945200.21162@nuc-kabylake>
Reply-To: prakash.sangappa@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1805070945200.21162@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org



On 05/07/2018 07:47 AM, Christopher Lameter wrote:
> On Fri, 4 May 2018, Prakash Sangappa wrote:
>> Currently 'numa_maps' gives a list of numa nodes, memory is allocated per
>> VMA.
>> Ex. we get something like from numa_maps.
>>
>> 04000  N0=1,N2=2 kernelpagesize_KB=4
>>
>> First is the start address of a VMA. This VMA could be much larger then 3 4k
>> pages.
>> It does not say which address in the VMA has the pages mapped.
> Not precise. First the address is there as you already said. That is the
> virtual address of the beginning of the VMA. What is missing? You need

Yes,

> each address for each page? Length of the VMA segment?
> Physical address?

Need numa node information for each virtual address with pages mapped.
No need of physical address.
