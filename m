From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/5] follow-up "Optimize CONFIG_DEBUG_PAGEALLOC"
Date: Thu,  4 Feb 2016 14:56:21 +0900
Message-ID: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

As CONFIG_DEBUG_PAGEALLOC can be enabled/disabled via kernel
parameters we can optimize some cases by checking the enablement
state.

This is follow-up work for Christian's Optimize CONFIG_DEBUG_PAGEALLOC.

https://lkml.org/lkml/2016/1/27/194

I can't test patches for sound, power and tile,
so please review them, maintainers. :)

Remaining work is to make sparc to be aware of this but it looks
not easy for me so I skip that in this series.

It would be the best that these paches are routed through Andrew's tree,
because there is a dependency to MM.

Thanks.

Joonsoo Kim (5):
  mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
  mm/slub: query dynamic DEBUG_PAGEALLOC setting
  sound: query dynamic DEBUG_PAGEALLOC setting
  powerpc: query dynamic DEBUG_PAGEALLOC setting
  tile: query dynamic DEBUG_PAGEALLOC setting

 arch/powerpc/kernel/traps.c     |  5 ++---
 arch/powerpc/mm/hash_utils_64.c | 40 ++++++++++++++++++++--------------------
 arch/powerpc/mm/init_32.c       |  8 ++++----
 arch/tile/mm/init.c             | 11 +++++++----
 mm/slub.c                       | 11 ++++++-----
 mm/vmalloc.c                    |  8 ++++----
 sound/drivers/pcsp/pcsp.c       |  9 +++++----
 7 files changed, 48 insertions(+), 44 deletions(-)

-- 
1.9.1
