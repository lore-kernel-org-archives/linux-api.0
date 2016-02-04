From: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] mm/slub: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 4 Feb 2016 09:31:14 +0100
Message-ID: <56B30C52.7040907@de.ibm.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1454565386-10489-3-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454565386-10489-3-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/04/2016 06:56 AM, Joonsoo Kim wrote:
> We can disable debug_pagealloc processing even if the code is complied
> with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
> whether it is enabled or not in runtime.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
> ---
>  mm/slub.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 7d4da68..7b5a965 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -256,11 +256,12 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
>  {
>  	void *p;
> 
> -#ifdef CONFIG_DEBUG_PAGEALLOC
> -	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
> -#else
> -	p = get_freepointer(s, object);
> -#endif
> +	if (debug_pagealloc_enabled()) {
> +		probe_kernel_read(&p,
> +			(void **)(object + s->offset), sizeof(p));

Hmm, this might be a good case for a line longer than 80 chars....

As an alternative revert the logic and return early:


	if (!debug_pagealloc_enabled())
		return get_freepointer(s, object);
	probe_kernel_read(&p, (void **)(object + s->offset), sizeof(p));
	return p;

?


> +	} else
> +		p = get_freepointer(s, object);
> +
>  	return p;
>  }
> 
