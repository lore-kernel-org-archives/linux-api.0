From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Wed, 8 Nov 2017 09:38:36 +0800
Message-ID: <4b08f1e9-5449-6ea2-e7da-65fe5f678683@huawei.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711070948410.19176@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Christopher,

On 2017/11/7 23:55, Christopher Lameter wrote:
> On Tue, 7 Nov 2017, Vlastimil Babka wrote:
> 
>>> Migrate pages moves the pages of a single process there is no TARGET
>>> process.
>>
>> migrate_pages(2) takes a pid argument
>>
>> "migrate_pages()  attempts  to  move all pages of the process pid that
>> are in memory nodes old_nodes to the memory nodes in new_nodes. "
> 
> Ok missed that. Most use cases here are on the current process.

Yeah, so most case current process is the same as target process.
But maybe I still miss someting, see below:

> 
> Fundamentally a process can have shared pages outside of the cpuset that
> a process is restricted to. Thus I would think that migration to any of
> the allowed nodes of the current process that is calling migrate pages
> is ok. The caller wants this and the caller has a right to allocate on
> these nodes. It would be strange if migrate_pages would allow allocation
> outside of the current cpuset.
> 
>>> Thus thehe *target* nodes need to be a subset of the current cpu set.
> 
> And therefore the above still holds.

Another case is current process is *not* the same as target process, and
when current process try to migrate pages of target process from old_nodes
to new_nodes, the new_nodes should be a subset of target process cpuset.
CAP_SYS_NICE will insure that current process have the privilege, and will
not overwrite the restriction of target process cpuset.

However, for the current cpuset restriction, as manpage says :
  EINVAL... Or, _none_ of the node IDs specified by new_nodes are
  on-line and allowed by the process's current cpuset context, or none of
  the specified nodes contain memory.

So for current cpuset restriction, an intersection check should be enough
instead of subset? And it will also make sure migrate_pages will not
allocate pages outside of the current cpuset.

> 
> .
> 
