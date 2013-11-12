From: Andreas Schwab <schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH 2/3] statxat: Add a system call to make extended file stats available
Date: Tue, 12 Nov 2013 19:44:59 +0100
Message-ID: <87li0t31ec.fsf@igel.home>
References: <20131112173518.25813.67568.stgit@warthog.procyon.org.uk>
	<20131112173534.25813.70732.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131112173534.25813.70732.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org> (David
	Howells's message of "Tue, 12 Nov 2013 17:35:34 +0000")
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> 	struct statx {
> 		uint32_t		st_mask;
> 		uint32_t		st_information;
> 		uint16_t		st_mode;
> 		uint16_t		__spare0[1];
> 		uint32_t		st_nlink;
> 		uint32_t		st_uid;
> 		uint32_t		st_gid;
> 		uint32_t		st_alloc_blksize;
> 		uint32_t		st_blksize;
> 		uint32_t		st_small_io_size;
> 		uint32_t		st_large_io_size;
> 		struct statx_dev	st_rdev;
> 		struct statx_dev	st_dev;
> 		int32_t			st_atime_ns;
> 		int32_t			st_btime_ns;
> 		int32_t			st_ctime_ns;
> 		int32_t			st_mtime_ns;
> 		int64_t			st_atime;
> 		int64_t			st_btime;
> 		int64_t			st_ctime;
> 		int64_t			st_mtime;
> 		uint64_t		st_ino;
> 		uint64_t		st_size;
> 		uint64_t		st_blocks;
> 		uint64_t		st_version;
> 		uint64_t		st_ioc_flags;

I'd suggest to use a different prefix (stx_ instead of st_) for the
members.  st_[acm]time are typically defined as macros by <sys/stat.h>
which would conflict.

Andreas.

-- 
Andreas Schwab, schwab-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
