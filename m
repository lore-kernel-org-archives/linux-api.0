From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
Date: Sat, 6 Feb 2016 01:13:15 +0900
Message-ID: <CAAmzW4P-09yqdCiZJpYbpueih7+gq0Qcg302nsaHLZASHUki9w@mail.gmail.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1454565386-10489-2-git-send-email-iamjoonsoo.kim@lge.com>
	<alpine.DEB.2.10.1602041417330.29117@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1602041417330.29117-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2016-02-05 7:18 GMT+09:00 David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
> On Thu, 4 Feb 2016, Joonsoo Kim wrote:
>
>> We can disable debug_pagealloc processing even if the code is complied
>> with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
>> whether it is enabled or not in runtime.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
>
> I think the comment immediately before this code referencing
> CONFIG_DEBUG_PAGEALLOC should be changed to refer to pagealloc debugging
> being enabled.

Andrew kindly did it. Thanks, Andrew.

> After that:
>
>         Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks.
