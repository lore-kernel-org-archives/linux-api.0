From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH -mm v9 4/8] proc: add kpagecgroup file
Date: Wed, 22 Jul 2015 13:33:06 +0300
Message-ID: <20150722103306.GJ23374@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <679498f8d3f87c1ee57b7c3b58382193c9046b6a.1437303956.git.vdavydov@parallels.com>
 <20150721163433.618855e1f61536a09dfac30b@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150721163433.618855e1f61536a09dfac30b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 04:34:33PM -0700, Andrew Morton wrote:
> On Sun, 19 Jul 2015 15:31:13 +0300 Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
> > /proc/kpagecgroup contains a 64-bit inode number of the memory cgroup
> > each page is charged to, indexed by PFN. Having this information is
> > useful for estimating a cgroup working set size.
> > 
> > The file is present if CONFIG_PROC_PAGE_MONITOR && CONFIG_MEMCG.
> >
> > ...
> >
> > @@ -225,10 +226,62 @@ static const struct file_operations proc_kpageflags_operations = {
> >  	.read = kpageflags_read,
> >  };
> >  
> > +#ifdef CONFIG_MEMCG
> > +static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
> > +				size_t count, loff_t *ppos)
> > +{
> > +	u64 __user *out = (u64 __user *)buf;
> > +	struct page *ppage;
> > +	unsigned long src = *ppos;
> > +	unsigned long pfn;
> > +	ssize_t ret = 0;
> > +	u64 ino;
> > +
> > +	pfn = src / KPMSIZE;
> > +	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
> > +	if (src & KPMMASK || count & KPMMASK)
> > +		return -EINVAL;
> 
> The user-facing documentation should explain that reads must be
> performed in multiple-of-8 sizes.

It does. It's in the end of Documentation/vm/pagemap.c:

: Other notes:
: 
: Reading from any of the files will return -EINVAL if you are not starting
: the read on an 8-byte boundary (e.g., if you sought an odd number of bytes
: into the file), or if the size of the read is not a multiple of 8 bytes.

> 
> > +	while (count > 0) {
> > +		if (pfn_valid(pfn))
> > +			ppage = pfn_to_page(pfn);
> > +		else
> > +			ppage = NULL;
> > +
> > +		if (ppage)
> > +			ino = page_cgroup_ino(ppage);
> > +		else
> > +			ino = 0;
> > +
> > +		if (put_user(ino, out)) {
> > +			ret = -EFAULT;
> 
> Here we do the usual procfs violation of read() behaviour.  read()
> normally only returns an error if it read nothing.  This code will
> transfer a megabyte then return -EFAULT so userspace doesn't know that
> it got that megabyte.

Yeah, that's how it works. I did it preliminary for /proc/kpagecgroup to
work exactly like /proc/kpageflags and /proc/kpagecount.

FWIW, the man page I have on my system already warns about this
peculiarity of read(2):

: On error, -1 is returned, and errno is set appropriately. In this
: case, it is left unspecified whether the file position (if any)
: changes.

> 
> That's easy to fix, but procfs files do this all over the place anyway :(
> 
> > +			break;
> > +		}
> > +
> > +		pfn++;
> > +		out++;
> > +		count -= KPMSIZE;
> > +	}
> > +
> > +	*ppos += (char __user *)out - buf;
> > +	if (!ret)
> > +		ret = (char __user *)out - buf;
> > +	return ret;
> > +}
> > +
> 
