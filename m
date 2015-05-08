From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 3/3] proc: add kpageidle file
Date: Fri, 8 May 2015 12:56:04 +0300
Message-ID: <20150508095604.GO31732@esperanza>
References: <cover.1430217477.git.vdavydov@parallels.com>
 <4c24a6bf2c9711dd4dbb72a43a16eba6867527b7.1430217477.git.vdavydov@parallels.com>
 <20150429043536.GB11486@blaptop>
 <20150429091248.GD1694@esperanza>
 <20150430082531.GD21771@blaptop>
 <20150430145055.GB17640@esperanza>
 <20150504031722.GA2768@blaptop>
 <20150504094938.GB4197@esperanza>
 <20150504105459.GA19384@blaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150504105459.GA19384@blaptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 04, 2015 at 07:54:59PM +0900, Minchan Kim wrote:
> So, I guess once below compiler optimization happens in __page_set_anon_rmap,
> it could be corrupt in page_refernced.
> 
> __page_set_anon_rmap:
>         page->mapping = (struct address_space *) anon_vma;
>         page->mapping = (struct address_space *)((void *)page_mapping + PAGE_MAPPING_ANON);
> 
> Because page_referenced checks it with PageAnon which has no memory barrier.
> So if above compiler optimization happens, page_referenced can pass the anon
> page in rmap_walk_file, not ramp_walk_anon. It's my theory. :)

FWIW

If such splits were possible, we would have bugs all over the kernel
IMO. An example is do_wp_page() vs shrink_active_list(). In do_wp_page()
we can call page_move_anon_rmap(), which sets page->mapping in exactly
the same fashion as above-mentioned __page_set_anon_rmap():

	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
	page->mapping = (struct address_space *) anon_vma;

The page in question may be on an LRU list, because nowhere in
do_wp_page() we remove it from the list, neither do we take any LRU
related locks. The page is locked, that's true, but shrink_active_list()
calls page_referenced() on an unlocked page, so according to your logic
they can race with the latter receiving a page with page->mapping equal
to anon_vma w/o PAGE_MAPPING_ANON bit set:

CPU0				CPU1
----				----
do_wp_page			shrink_active_list
 lock_page			 page_referenced
				  PageAnon->yes, so skip trylock_page
 page_move_anon_rmap
  page->mapping = anon_vma
				  rmap_walk
				   PageAnon->no
				   rmap_walk_file
				    BUG
  page->mapping = page->mapping+PAGE_MAPPING_ANON

However, this does not happen.

Thanks,
Vladimir
