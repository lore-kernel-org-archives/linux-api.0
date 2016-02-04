From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 4 Feb 2016 14:18:28 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1602041417330.29117@chino.kir.corp.google.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com> <1454565386-10489-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454565386-10489-2-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 4 Feb 2016, Joonsoo Kim wrote:

> We can disable debug_pagealloc processing even if the code is complied
> with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
> whether it is enabled or not in runtime.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

I think the comment immediately before this code referencing 
CONFIG_DEBUG_PAGEALLOC should be changed to refer to pagealloc debugging 
being enabled.

After that:

	Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
