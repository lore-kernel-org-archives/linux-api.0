From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm v9 2/8] hwpoison: use page_cgroup_ino for filtering
 by memcg
Date: Tue, 21 Jul 2015 16:34:12 -0700
Message-ID: <20150721163412.1b44e77f5ac3b742734d1ce6@linux-foundation.org>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<94215634d13582d2a1453686d6cc6b1a59b07d2a.1437303956.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <94215634d13582d2a1453686d6cc6b1a59b07d2a.1437303956.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 19 Jul 2015 15:31:11 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:

> Hwpoison allows to filter pages by memory cgroup ino. Currently, it
> calls try_get_mem_cgroup_from_page to obtain the cgroup from a page and
> then its ino using cgroup_ino, but now we have an apter method for that,
> page_cgroup_ino, so use it instead.

I assume "an apter" was supposed to be "a helper"?

> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -45,12 +45,9 @@ static int hwpoison_inject(void *data, u64 val)
>  	/*
>  	 * do a racy check with elevated page count, to make sure PG_hwpoison
>  	 * will only be set for the targeted owner (or on a free page).
> -	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
>  	 * memory_failure() will redo the check reliably inside page lock.
>  	 */
> -	lock_page(hpage);
>  	err = hwpoison_filter(hpage);
> -	unlock_page(hpage);
>  	if (err)
>  		goto put_out;
>  
> @@ -126,7 +123,7 @@ static int pfn_inject_init(void)
>  	if (!dentry)
>  		goto fail;
>  
> -#ifdef CONFIG_MEMCG_SWAP
> +#ifdef CONFIG_MEMCG
>  	dentry = debugfs_create_u64("corrupt-filter-memcg", 0600,
>  				    hwpoison_dir, &hwpoison_filter_memcg);
>  	if (!dentry)

Confused.  We're changing the conditions under which this debugfs file
is created.  Is this a typo or some unchangelogged thing or what?


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
