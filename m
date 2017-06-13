From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/10 v11] No wait AIO
Date: Mon, 12 Jun 2017 23:14:31 -0700
Message-ID: <20170613061431.GA11432@infradead.org>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
 <20170610053441.GD6365@ZenIV.linux.org.uk>
 <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58bbe95e-5a4a-4387-3a00-16ed2e861bd3-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adam.manzanares-Sjgp3cTcYWE@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 12, 2017 at 05:38:13PM -0500, Goldwyn Rodrigues wrote:
> We had FS_NOWAIT in filesystem type flags (in v3), but retracted it
> later in v4.

A per-fs flag is wrong as file_operation may have different
capabilities.

> I will work on adding FMODE_AIO_NOWAIT in the meantime.

If Al prefers that let's go with it for now.  One other thing I'd
love is a supported flags field in struct file_operations that we
can compare the flags against.  Al, does that sound good as well?

> 
> Thanks,
> 
> -- 
> Goldwyn
---end quoted text---
