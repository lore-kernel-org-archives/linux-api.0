From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Tue, 7 Nov 2017 19:23:52 +0800
Message-ID: <a4f1212f-3903-abbc-772a-1ddee6f7f98b@huawei.com>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-5-git-send-email-xieyisheng1@huawei.com>
 <dccbeccc-4155-94a8-0e67-b7c28238896d@suse.cz>
 <bc57f574-92f2-0b69-4717-a1ec7170387c@huawei.com>
 <d774ecf6-5e7b-e185-85a0-27bf2bcacfb4@suse.cz>
 <alpine.DEB.2.20.1711060926001.9015@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711060926001.9015@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

hi Christopher and Vlastimil,

Thanks for your comment!
On 2017/11/6 23:29, Christopher Lameter wrote:
> On Mon, 6 Nov 2017, Vlastimil Babka wrote:
> 
>> I'm not sure what exactly is the EPERM intention. Should really the
>> capability of THIS process override the cpuset restriction of the TARGET
>> process? Maybe yes. Then, does "insufficient privilege (CAP_SYS_NICE) to
> 
> CAP_SYS_NICE never overrides cpuset restrictions. The cap can be used to
> migrate pages that are *also* mapped by other processes (and thus move
> pages of another process which may have different cpu set restrictions!).

So you means the specified nodes should be a subset of target cpu set, right?

Thanks
Yisheng Xie
> The cap should not allow migrating pages to nodes that are not allowed by
> the cpuset of the current process.
> 
> 
> 
> .
> 
