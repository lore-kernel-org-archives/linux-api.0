From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 2/8] hwpoison: use page_cgroup_ino for filtering
 by memcg
Date: Wed, 22 Jul 2015 12:45:04 +0300
Message-ID: <20150722094504.GI23374@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <94215634d13582d2a1453686d6cc6b1a59b07d2a.1437303956.git.vdavydov@parallels.com>
 <20150721163412.1b44e77f5ac3b742734d1ce6@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150721163412.1b44e77f5ac3b742734d1ce6-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 04:34:12PM -0700, Andrew Morton wrote:
> On Sun, 19 Jul 2015 15:31:11 +0300 Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > Hwpoison allows to filter pages by memory cgroup ino. Currently, it
> > calls try_get_mem_cgroup_from_page to obtain the cgroup from a page and
> > then its ino using cgroup_ino, but now we have an apter method for that,
> > page_cgroup_ino, so use it instead.
> 
> I assume "an apter" was supposed to be "a helper"?

Yes, sounds better :-)

> 
> > --- a/mm/hwpoison-inject.c
> > +++ b/mm/hwpoison-inject.c
> > @@ -45,12 +45,9 @@ static int hwpoison_inject(void *data, u64 val)
> >  	/*
> >  	 * do a racy check with elevated page count, to make sure PG_hwpoison
> >  	 * will only be set for the targeted owner (or on a free page).
> > -	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
> >  	 * memory_failure() will redo the check reliably inside page lock.
> >  	 */
> > -	lock_page(hpage);
> >  	err = hwpoison_filter(hpage);
> > -	unlock_page(hpage);
> >  	if (err)
> >  		goto put_out;
> >  
> > @@ -126,7 +123,7 @@ static int pfn_inject_init(void)
> >  	if (!dentry)
> >  		goto fail;
> >  
> > -#ifdef CONFIG_MEMCG_SWAP
> > +#ifdef CONFIG_MEMCG
> >  	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
> >  				    hwpoison_dir, &hwpoison_filter_memcg);
> >  	if (!dentry)
> 
> Confused.  We're changing the conditions under which this debugfs file
> is created.  Is this a typo or some unchangelogged thing or what?

This is an unchangelogged cleanup. In fact, there had been a comment
regarding it before v6, but then it got lost. Sorry about that. The
commit message should look like this:

"""
Hwpoison allows to filter pages by memory cgroup ino. Currently, it
calls try_get_mem_cgroup_from_page to obtain the cgroup from a page and
then its ino using cgroup_ino, but now we have a helper method for that,
page_cgroup_ino, so use it instead.

This patch also loosens the hwpoison memcg filter dependency rules - it
makes it depend on CONFIG_MEMCG instead of CONFIG_MEMCG_SWAP, because
hwpoison memcg filter does not require anything (nor it used to) from
CONFIG_MEMCG_SWAP side.
"""

Or we can simply revert this cleanups if you don't like it:
---
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index 5015679014c1..1cd105ee5a7b 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -123,7 +123,7 @@ static int pfn_inject_init(void)
 	if (!dentry)
 		goto fail;
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_SWAP
 	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
 				    hwpoison_dir, &hwpoison_filter_memcg);
 	if (!dentry)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 97005396a507..5ea7d8c760fa 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -130,7 +130,7 @@ static int hwpoison_filter_flags(struct page *p)
  * can only guarantee that the page either belongs to the memcg tasks, or is
  * a freed page.
  */
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_SWAP
 u64 hwpoison_filter_memcg;
 EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
 static int hwpoison_filter_task(struct page *p)
