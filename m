From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Date: Mon, 10 Apr 2017 14:37:50 +0200
Message-ID: <20170410123750.GE3224@quack2.suse.cz>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
 <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
 <20170410074539.GA18250@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170410074539.GA18250-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 10-04-17 00:45:39, Christoph Hellwig wrote:
> On Tue, Apr 04, 2017 at 01:41:09PM -0500, Goldwyn Rodrigues wrote:
> > I am working on incorporating RWF_* flags. However, I am not sure how
> > RWF_* flags would get rid of FS_NOWAIT/FS_NOWAIT_IO. Since most of
> > "blocking" information is with the filesystem, it is a per-filesystem
> > flag to block out (EOPNOTSUPP) the filesystems which do not support it.
> 
> You need to check the flag in the actual read/write methods as the
> support for features on Linux is not a per-file_system_type thing.

I don't understand here. Do you want that all filesystems support NOWAIT
direct IO? IMO that's not realistic and also not necessary. In reality
different filesystems support different sets or operations and we have a
precedens for that in various fallocate operations, rename exchange, or
O_TMPFILE support...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
