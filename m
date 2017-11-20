From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] mm/mempolicy: remove redundant check in
 get_nodes
Date: Mon, 20 Nov 2017 14:24:21 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1711201424100.42955@chino.kir.corp.google.com>
References: <1510882624-44342-1-git-send-email-xieyisheng1@huawei.com> <1510882624-44342-2-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510882624-44342-2-git-send-email-xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 17 Nov 2017, Yisheng Xie wrote:

> We have already checked whether maxnode is a page worth of bits, by:
>     maxnode > PAGE_SIZE*BITS_PER_BYTE
> 
> So no need to check it once more.
> 
> Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
