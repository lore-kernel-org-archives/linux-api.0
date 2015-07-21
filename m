From: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [PATCH v4 5/5] pagemap: add mmap-exclusive bit for marking
 pages mapped only here
Date: Tue, 21 Jul 2015 08:17:56 +0000
Message-ID: <20150721081755.GD4490@hori1.linux.bs1.fc.nec.co.jp>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153749.29844.81954.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714153749.29844.81954.stgit@buzz>
Content-Language: ja-JP
Content-ID: <26C19608054104418F64BD8DB1EFF9D9-DVDfUyJTPxcTBYAz+LHnZg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:49PM +0300, Konstantin Khlebnikov wrote:
> This patch sets bit 56 in pagemap if this page is mapped only once.
> It allows to detect exclusively used pages without exposing PFN:
> 
> present file exclusive state
> 0       0    0         non-present
> 1       1    0         file page mapped somewhere else
> 1       1    1         file page mapped only here
> 1       0    0         anon non-CoWed page (shared with parent/child)
> 1       0    1         anon CoWed page (or never forked)
> 
> CoWed pages in (MAP_FILE | MAP_PRIVATE) areas are anon in this context.
> 
> MMap-exclusive bit doesn't reflect potential page-sharing via swapcache:
> page could be mapped once but has several swap-ptes which point to it.
> Application could detect that by swap bit in pagemap entry and touch
> that pte via /proc/pid/mem to get real information.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Requested-by: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
> Link: http://lkml.kernel.org/r/CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

Reviewed-by: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
