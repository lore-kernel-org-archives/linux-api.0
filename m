From: Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 13:55:33 +0800
Message-ID: <20110120055533.GA20836@localhost>
References: <1295399718.1949.864.camel@sli10-conroe>
 <20110119124158.b0348c44.akpm@linux-foundation.org>
 <1295490647.1949.890.camel@sli10-conroe>
 <20110119184240.b0a6a016.akpm@linux-foundation.org>
 <1295491713.1949.898.camel@sli10-conroe>
 <20110119190548.e1f7f01f.akpm@linux-foundation.org>
 <1295493709.1949.910.camel@sli10-conroe>
 <20110119201014.adf02a78.akpm@linux-foundation.org>
 <20110120054645.GA18642@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110120054645.GA18642@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Li, Shaohua" <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> > And a third approach is to save all the cache into a special
> > file/partition/etc and to preload all that into kernel data structures
> > at boot.  Obviously this one is ricky/tricky because the on-disk
> > replica of the real data can get out of sync with the real data.
> 
> Hah! We are thinking much alike :)
> 
> It's a very good optimization for LiveCDs and readonly mounted NFS /usr.
> 
> For a typical desktop, the solution in my mind is to install some
> initscript to run at halt/reboot time, after all other tasks have been
> killed and filesystems remounted readonly.  At the time it may dump
> whatever in the page cache to the swap partition. At the next boot,

Not "whatever", to be practical. One obvious optimization is to filter
out large cached files, which can be read _sequentially_ at next boot
anyway. It's a technique mainly for reducing seeks at the cost of some
extra writes at halt/reboot time. And I suspect btrfs will obsolete
this technique, as it can already pack data/metadata nicely.

Thanks,
Fengguang

> the data/metadata can then be read back _perfectly sequentially_ for
> populating the page cache.
> 
> For kexec based reboot, the data can even be passed to next kernel
> directly, saving the disk IO totally.
> 
> Thanks,
> Fengguang

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ mmotm/include/trace/events/mm.h	2010-12-26 20:59:48.000000000 +0800
> @@ -0,0 +1,164 @@
> +#if !defined(_TRACE_MM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MM_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/page-flags.h>
> +#include <linux/memcontrol.h>
> +#include <linux/pagemap.h>
> +#include <linux/mm.h>
> +#include <linux/kernel-page-flags.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM mm
> +
> +extern struct trace_print_flags pageflag_names[];
> +
> +/**
> + * dump_page_frame - called by the trace page dump trigger
> + * @pfn: page frame number
> + * @page: pointer to the page frame
> + *
> + * This is a helper trace point into the dumping of the page frames.
> + * It will record various infromation about a page frame.
> + */
> +TRACE_EVENT(dump_page_frame,
> +
> +	TP_PROTO(unsigned long pfn, struct page *page),
> +
> +	TP_ARGS(pfn, page),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	pfn		)
> +		__field(	struct page *,	page		)
> +		__field(	u64,		stable_flags	)
> +		__field(	unsigned long,	flags		)
> +		__field(	unsigned int,	count		)
> +		__field(	unsigned int,	mapcount	)
> +		__field(	unsigned long,	private		)
> +		__field(	unsigned long,	mapping		)
> +		__field(	unsigned long,	index		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pfn		= pfn;
> +		__entry->page		= page;
> +		__entry->stable_flags	= stable_page_flags(page);
> +		__entry->flags		= page->flags;
> +		__entry->count		= atomic_read(&page->_count);
> +		__entry->mapcount	= page_mapcount(page);
> +		__entry->private	= page->private;
> +		__entry->mapping	= (unsigned long)page->mapping;
> +		__entry->index		= page->index;
> +	),
> +
> +	TP_printk("%12lx %16p %8x %8x %16lx %16lx %16lx %s",
> +		  __entry->pfn,
> +		  __entry->page,
> +		  __entry->count,
> +		  __entry->mapcount,
> +		  __entry->private,
> +		  __entry->mapping,
> +		  __entry->index,
> +		  ftrace_print_flags_seq(p, "|",
> +					 __entry->flags & PAGE_FLAGS_MASK,
> +					 pageflag_names)
> +	)
> +);
> +
> +TRACE_EVENT(dump_page_cache,
> +
> +	TP_PROTO(struct page *page, unsigned long len),
> +
> +	TP_ARGS(page, len),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	index		)
> +		__field(	unsigned long,	len		)
> +		__field(	u64,		flags		)
> +		__field(	unsigned int,	count		)
> +		__field(	unsigned int,	mapcount	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->index		= page->index;
> +		__entry->len		= len;
> +		__entry->flags		= stable_page_flags(page);
> +		__entry->count		= atomic_read(&page->_count);
> +		__entry->mapcount	= page_mapcount(page);
> +	),
> +
> +	TP_printk("%12lu %6lu %c%c%c%c%c%c%c%c%c%c%c %4u %4u",
> +		  __entry->index,
> +		  __entry->len,
> +		  __entry->flags & (1ULL << KPF_MMAP)		? 'M' : '_',
> +		  __entry->flags & (1ULL << KPF_MLOCKED)	? 'm' : '_',
> +		  __entry->flags & (1ULL << KPF_UNEVICTABLE)	? 'u' : '_',
> +		  __entry->flags & (1ULL << KPF_ACTIVE)		? 'A' : '_',
> +		  __entry->flags & (1ULL << KPF_REFERENCED)	? 'R' : '_',
> +		  __entry->flags & (1ULL << KPF_UPTODATE)	? 'U' : '_',
> +		  __entry->flags & (1ULL << KPF_DIRTY)		? 'D' : '_',
> +		  __entry->flags & (1ULL << KPF_WRITEBACK)	? 'W' : '_',
> +		  __entry->flags & (1ULL << KPF_RECLAIM)	? 'I' : '_',
> +		  __entry->flags & (1ULL << KPF_MAPPEDTODISK)	? 'd' : '_',
> +		  __entry->flags & (1ULL << KPF_PRIVATE)	? 'P' : '_',
> +		  __entry->count,
> +		  __entry->mapcount)
> +);
> +
> +
> +#define show_inode_type(val)	__print_symbolic(val, 	   \
> +				{ S_IFREG,	"REG"	}, \
> +				{ S_IFDIR,	"DIR"	}, \
> +				{ S_IFLNK,	"LNK"	}, \
> +				{ S_IFBLK,	"BLK"	}, \
> +				{ S_IFCHR,	"CHR"	}, \
> +				{ S_IFIFO,	"FIFO"	}, \
> +				{ S_IFSOCK,	"SOCK"	})
> +
> +TRACE_EVENT(dump_inode_cache,
> +
> +	TP_PROTO(struct inode *inode, char *name, int len),
> +
> +	TP_ARGS(inode, name, len),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	ino		)
> +		__field(	loff_t,		size		) /* bytes */
> +		__field(	loff_t,		cached		) /* bytes */
> +		__field(	unsigned long,	age		) /*    ms */
> +		__field(	unsigned long,	state		)
> +		__field(	umode_t,	mode		)
> +		__array(	char,		comm, TASK_COMM_LEN)
> +		__dynamic_array(char,		file,	len	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ino	= inode->i_ino;
> +		__entry->size	= i_size_read(inode);
> +		__entry->cached	= inode->i_mapping->nrpages;
> +		__entry->cached	<<= PAGE_CACHE_SHIFT;
> +		__entry->age	= (jiffies - inode->dirtied_when) * 1000 / HZ;
> +		__entry->state	= inode->i_state;
> +		__entry->mode	= inode->i_mode;
> +		memcpy(__entry->comm, inode->i_comm, TASK_COMM_LEN);
> +		memcpy(__get_str(file), name, len);
> +	),
> +
> +	TP_printk("%12lu %12llu %12llu %12lu %c%c%c%c %4s %16s %s",
> +		  __entry->ino,
> +		  __entry->size,
> +		  __entry->cached,
> +		  __entry->age,
> +		  __entry->state & I_DIRTY_PAGES	? 'D' : '_',
> +		  __entry->state & I_DIRTY_DATASYNC	? 'd' : '_',
> +		  __entry->state & I_DIRTY_SYNC		? 'm' : '_',
> +		  __entry->state & I_SYNC		? 'S' : '_',
> +		  show_inode_type(__entry->mode & S_IFMT),
> +		  __entry->comm,
> +		  __get_str(file))
> +);
> +
> +#endif /*  _TRACE_MM_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --- mmotm.orig/kernel/trace/Makefile	2010-12-26 20:58:46.000000000 +0800
> +++ mmotm/kernel/trace/Makefile	2010-12-26 20:59:41.000000000 +0800
> @@ -26,6 +26,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer
>  obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
>  
>  obj-$(CONFIG_TRACING) += trace.o
> +obj-$(CONFIG_TRACING) += trace_objects.o
>  obj-$(CONFIG_TRACING) += trace_output.o
>  obj-$(CONFIG_TRACING) += trace_stat.o
>  obj-$(CONFIG_TRACING) += trace_printk.o
> @@ -53,6 +54,7 @@ endif
>  obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
>  obj-$(CONFIG_EVENT_TRACING) += power-traces.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_mm.o
>  ifeq ($(CONFIG_TRACING),y)
>  obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
>  endif
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ mmotm/kernel/trace/trace_mm.c	2010-12-26 20:59:41.000000000 +0800
> @@ -0,0 +1,367 @@
> +/*
> + * Trace mm pages
> + *
> + * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> + *
> + * Code based on Matt Mackall's /proc/[kpagecount|kpageflags] code.
> + */
> +#include <linux/module.h>
> +#include <linux/bootmem.h>
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>
> +#include <linux/ctype.h>
> +#include <linux/pagevec.h>
> +#include <linux/writeback.h>
> +#include <linux/file.h>
> +#include <linux/slab.h>
> +
> +#include "trace_output.h"
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/mm.h>
> +
> +void trace_mm_page_frames(unsigned long start, unsigned long end,
> +			  void (*trace)(unsigned long pfn, struct page *page))
> +{
> +	unsigned long pfn = start;
> +	struct page *page;
> +
> +	if (start > max_pfn - 1)
> +		return;
> +
> +	if (end > max_pfn)
> +		end = max_pfn;
> +
> +	while (pfn < end) {
> +		page = NULL;
> +		if (pfn_valid(pfn))
> +			page = pfn_to_page(pfn);
> +		pfn++;
> +		if (page)
> +			trace(pfn, page);
> +	}
> +}
> +
> +static void trace_mm_page_frame(unsigned long pfn, struct page *page)
> +{
> +	trace_dump_page_frame(pfn, page);
> +}
> +
> +static ssize_t
> +trace_mm_pfn_range_read(struct file *filp, char __user *ubuf, size_t cnt,
> +			loff_t *ppos)
> +{
> +	return simple_read_from_buffer(ubuf, cnt, ppos, "0\n", 2);
> +}
> +
> +
> +/*
> + * recognized formats:
> + * 		"M N"	start=M, end=N
> + * 		"M"	start=M, end=M+1
> + * 		"M +N"	start=M, end=M+N-1
> + */
> +static ssize_t
> +trace_mm_pfn_range_write(struct file *filp, const char __user *ubuf, size_t cnt,
> +			 loff_t *ppos)
> +{
> +	unsigned long start;
> +	unsigned long end = 0;
> +	char buf[64];
> +	char *ptr;
> +
> +	if (cnt >= sizeof(buf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&buf, ubuf, cnt))
> +		return -EFAULT;
> +
> +	if (tracing_update_buffers() < 0)
> +		return -ENOMEM;
> +
> +	if (trace_set_clr_event("mm", "dump_page_frame", 1))
> +		return -EINVAL;
> +
> +	buf[cnt] = 0;
> +
> +	start = simple_strtoul(buf, &ptr, 0);
> +
> +	for (; *ptr; ptr++) {
> +		if (isdigit(*ptr)) {
> +			if (*(ptr - 1) == '+')
> +				end = start;
> +			end += simple_strtoul(ptr, NULL, 0);
> +			break;
> +		}
> +	}
> +	if (!*ptr)
> +		end = start + 1;
> +
> +	trace_mm_page_frames(start, end, trace_mm_page_frame);
> +
> +	return cnt;
> +}
> +
> +static const struct file_operations trace_mm_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= trace_mm_pfn_range_read,
> +	.write		= trace_mm_pfn_range_write,
> +};
> +
> +static struct dentry *trace_objects_mm_dir(void)
> +{
> +	static struct dentry *d_mm;
> +	struct dentry *d_objects;
> +
> +	if (d_mm)
> +		return d_mm;
> +
> +	d_objects = trace_objects_dir();
> +	if (!d_objects)
> +		return NULL;
> +
> +	d_mm = debugfs_create_dir("mm", d_objects);
> +	if (!d_mm)
> +		pr_warning("Could not create 'objects/mm' directory\n");
> +
> +	return d_mm;
> +}
> +
> +static unsigned long page_flags(struct page *page)
> +{
> +	return page->flags & ((1 << NR_PAGEFLAGS) - 1);
> +}
> +
> +static int pages_similar(struct page *page0, struct page *page)
> +{
> +	if (page_flags(page0) != page_flags(page))
> +		return 0;
> +
> +	if (page_count(page0) != page_count(page))
> +		return 0;
> +
> +	if (page_mapcount(page0) != page_mapcount(page))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static void dump_pagecache(struct address_space *mapping)
> +{
> +	unsigned long nr_pages;
> +	struct page *pages[PAGEVEC_SIZE];
> +	struct page *uninitialized_var(page0);
> +	struct page *page;
> +	unsigned long start = 0;
> +	unsigned long len = 0;
> +	int i;
> +
> +	for (;;) {
> +		rcu_read_lock();
> +		nr_pages = radix_tree_gang_lookup(&mapping->page_tree,
> +				(void **)pages, start + len, PAGEVEC_SIZE);
> +		rcu_read_unlock();
> +
> +		if (nr_pages == 0) {
> +			if (len)
> +				trace_dump_page_cache(page0, len);
> +			return;
> +		}
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			page = pages[i];
> +
> +			if (len &&
> +			    page->index == start + len &&
> +			    pages_similar(page0, page))
> +				len++;
> +			else {
> +				if (len)
> +					trace_dump_page_cache(page0, len);
> +				page0 = page;
> +				start = page->index;
> +				len = 1;
> +			}
> +		}
> +		cond_resched();
> +	}
> +}
> +
> +static void dump_inode_cache(struct inode *inode,
> +			     char *name_buf,
> +			     struct vfsmount *mnt)
> +{
> +	struct path path = {
> +		.mnt = mnt,
> +		.dentry = d_find_alias(inode)
> +	};
> +	char *name;
> +	int len;
> +
> +	if (!mnt) {
> +		trace_dump_inode_cache(inode, name_buf, strlen(name_buf));
> +		return;
> +	}
> +
> +	if (!path.dentry) {
> +		trace_dump_inode_cache(inode, "", 1);
> +		return;
> +	}
> +
> +	name = d_path(&path, name_buf, PAGE_SIZE);
> +	if (IS_ERR(name)) {
> +		name = "";
> +		len = 1;
> +	} else
> +		len = PAGE_SIZE + name_buf - name;
> +
> +	trace_dump_inode_cache(inode, name, len);
> +
> +	if (path.dentry)
> +		dput(path.dentry);
> +}
> +
> +static void dump_fs_pagecache(struct super_block *sb, struct vfsmount *mnt)
> +{
> +	struct inode *inode;
> +	struct inode *prev_inode = NULL;
> +	char *name_buf;
> +
> +	name_buf = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!name_buf)
> +		return;
> +
> +	down_read(&sb->s_umount);
> +	if (!sb->s_root)
> +		goto out;
> +
> +	spin_lock(&inode_lock);
> +	list_for_each_entry_reverse(inode, &sb->s_inodes, i_sb_list) {
> +		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
> +			continue;
> +		__iget(inode);
> +		spin_unlock(&inode_lock);
> +		dump_inode_cache(inode, name_buf, mnt);
> +		if (inode->i_mapping->nrpages)
> +			dump_pagecache(inode->i_mapping);
> +		iput(prev_inode);
> +		prev_inode = inode;
> +		cond_resched();
> +		spin_lock(&inode_lock);
> +	}
> +	spin_unlock(&inode_lock);
> +	iput(prev_inode);
> +out:
> +	up_read(&sb->s_umount);
> +	free_page((unsigned long)name_buf);
> +}
> +
> +static ssize_t
> +trace_pagecache_write(struct file *filp, const char __user *ubuf, size_t count,
> +		      loff_t *ppos)
> +{
> +	struct file *file = NULL;
> +	char *name;
> +	int err = 0;
> +
> +	if (count <= 1)
> +		return -EINVAL;
> +	if (count >= PAGE_SIZE)
> +		return -ENAMETOOLONG;
> +
> +	name = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!name)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(name, ubuf, count)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	/* strip the newline added by `echo` */
> +	if (name[count-1] == '\n')
> +		name[count-1] = '\0';
> +	else
> +		name[count] = '\0';
> +
> +	file = filp_open(name, O_RDONLY|O_LARGEFILE, 0);
> +	if (IS_ERR(file)) {
> +		err = PTR_ERR(file);
> +		file = NULL;
> +		goto out;
> +	}
> +
> +	if (tracing_update_buffers() < 0) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	if (trace_set_clr_event("mm", "dump_page_cache", 1)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +	if (trace_set_clr_event("mm", "dump_inode_cache", 1)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (filp->f_path.dentry->d_inode->i_private) {
> +		dump_fs_pagecache(file->f_path.dentry->d_sb, file->f_path.mnt);
> +	} else {
> +		dump_inode_cache(file->f_mapping->host, name, NULL);
> +		dump_pagecache(file->f_mapping);
> +	}
> +
> +out:
> +	if (file)
> +		fput(file);
> +	kfree(name);
> +
> +	return err ? err : count;
> +}
> +
> +static const struct file_operations trace_pagecache_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= trace_mm_pfn_range_read,
> +	.write		= trace_pagecache_write,
> +};
> +
> +static struct dentry *trace_objects_mm_pages_dir(void)
> +{
> +	static struct dentry *d_pages;
> +	struct dentry *d_mm;
> +
> +	if (d_pages)
> +		return d_pages;
> +
> +	d_mm = trace_objects_mm_dir();
> +	if (!d_mm)
> +		return NULL;
> +
> +	d_pages = debugfs_create_dir("pages", d_mm);
> +	if (!d_pages)
> +		pr_warning("Could not create debugfs "
> +			   "'objects/mm/pages' directory\n");
> +
> +	return d_pages;
> +}
> +
> +static __init int trace_objects_mm_init(void)
> +{
> +	struct dentry *d_pages;
> +
> +	d_pages = trace_objects_mm_pages_dir();
> +	if (!d_pages)
> +		return 0;
> +
> +	trace_create_file("dump-pfn", 0600, d_pages, NULL,
> +			  &trace_mm_fops);
> +
> +	trace_create_file("dump-file", 0600, d_pages, NULL,
> +			  &trace_pagecache_fops);
> +
> +	trace_create_file("dump-fs", 0600, d_pages, (void *)1,
> +			  &trace_pagecache_fops);
> +
> +	return 0;
> +}
> +fs_initcall(trace_objects_mm_init);
> --- mmotm.orig/kernel/trace/trace.h	2010-12-26 20:58:46.000000000 +0800
> +++ mmotm/kernel/trace/trace.h	2010-12-26 20:59:41.000000000 +0800
> @@ -295,6 +295,7 @@ struct dentry *trace_create_file(const c
>  				 const struct file_operations *fops);
>  
>  struct dentry *tracing_init_dentry(void);
> +struct dentry *trace_objects_dir(void);
>  
>  struct ring_buffer_event;
>  
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ mmotm/kernel/trace/trace_objects.c	2010-12-26 20:59:41.000000000 +0800
> @@ -0,0 +1,26 @@
> +#include <linux/debugfs.h>
> +
> +#include "trace.h"
> +#include "trace_output.h"
> +
> +struct dentry *trace_objects_dir(void)
> +{
> +	static struct dentry *d_objects;
> +	struct dentry *d_tracer;
> +
> +	if (d_objects)
> +		return d_objects;
> +
> +	d_tracer = tracing_init_dentry();
> +	if (!d_tracer)
> +		return NULL;
> +
> +	d_objects = debugfs_create_dir("objects", d_tracer);
> +	if (!d_objects)
> +		pr_warning("Could not create debugfs "
> +			   "'objects' directory\n");
> +
> +	return d_objects;
> +}
> +
> +
> --- mmotm.orig/mm/page_alloc.c	2010-12-26 20:58:46.000000000 +0800
> +++ mmotm/mm/page_alloc.c	2010-12-26 20:59:41.000000000 +0800
> @@ -5493,7 +5493,7 @@ bool is_free_buddy_page(struct page *pag
>  }
>  #endif
>  
> -static struct trace_print_flags pageflag_names[] = {
> +struct trace_print_flags pageflag_names[] = {
>  	{1UL << PG_locked,		"locked"	},
>  	{1UL << PG_error,		"error"		},
>  	{1UL << PG_referenced,		"referenced"	},
> @@ -5541,7 +5541,7 @@ static void dump_page_flags(unsigned lon
>  	printk(KERN_ALERT "page flags: %#lx(", flags);
>  
>  	/* remove zone id */
> -	flags &= (1UL << NR_PAGEFLAGS) - 1;
> +	flags &= PAGE_FLAGS_MASK;
>  
>  	for (i = 0; pageflag_names[i].name && flags; i++) {
>  
> --- mmotm.orig/include/linux/page-flags.h	2010-12-26 20:58:46.000000000 +0800
> +++ mmotm/include/linux/page-flags.h	2010-12-26 20:59:41.000000000 +0800
> @@ -414,6 +414,7 @@ static inline void __ClearPageTail(struc
>   * there has been a kernel bug or struct page corruption.
>   */
>  #define PAGE_FLAGS_CHECK_AT_PREP	((1 << NR_PAGEFLAGS) - 1)
> +#define PAGE_FLAGS_MASK			((1 << NR_PAGEFLAGS) - 1)
>  
>  #define PAGE_FLAGS_PRIVATE				\
>  	(1 << PG_private | 1 << PG_private_2)
> --- mmotm.orig/fs/inode.c	2010-12-26 20:58:45.000000000 +0800
> +++ mmotm/fs/inode.c	2010-12-26 21:00:09.000000000 +0800
> @@ -182,7 +182,13 @@ int inode_init_always(struct super_block
>  	inode->i_bdev = NULL;
>  	inode->i_cdev = NULL;
>  	inode->i_rdev = 0;
> -	inode->dirtied_when = 0;
> +
> +	/*
> +	 * This records inode load time. It will be invalidated once inode is
> +	 * dirtied, or jiffies wraps around. Despite the pitfalls it still
> +	 * provides useful information for some use cases like fastboot.
> +	 */
> +	inode->dirtied_when = jiffies;
>  
>  	if (security_inode_alloc(inode))
>  		goto out;
> @@ -226,6 +232,9 @@ int inode_init_always(struct super_block
>  
>  	percpu_counter_inc(&nr_inodes);
>  
> +	BUILD_BUG_ON(sizeof(inode->i_comm) != TASK_COMM_LEN);
> +	memcpy(inode->i_comm, current->comm, TASK_COMM_LEN);
> +
>  	return 0;
>  out:
>  	return -ENOMEM;
> --- mmotm.orig/include/linux/fs.h	2010-12-26 20:59:50.000000000 +0800
> +++ mmotm/include/linux/fs.h	2010-12-26 21:00:09.000000000 +0800
> @@ -800,6 +800,8 @@ struct inode {
>  	struct posix_acl	*i_default_acl;
>  #endif
>  	void			*i_private; /* fs or device private pointer */
> +
> +	char			i_comm[16]; /* first opened by */
>  };
>  
>  static inline int inode_unhashed(struct inode *inode)
