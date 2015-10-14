From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Wed, 14 Oct 2015 00:41:25 -0700
Message-ID: <20151014074125.GA2485@infradead.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <87vbai6sud.fsf@notabene.neil.brown.name>
 <5617A1E9.1080509@draigBrady.com>
 <561D68B9.8030209@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561D68B9.8030209-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: P??draig Brady <P@draigBrady.com>, Neil Brown <nfbrown-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 13, 2015 at 04:25:29PM -0400, Anna Schumaker wrote:
> I haven't tried it, but I think the hole would be expanded :(.  I'm having splice() handle the pagecache copy part, and (as far as I know) splice() doesn't know anything about sparse files.  I might be able to put in some kind of fallocate() / splice() loop to copy the range in multiple pieces.
> 
> I don't want to add COPY_FR_SPARSE_AUTO, because then the kernel will have to determine how best to interpret "auto".  I'm more inclined to add a single COPY_FR_SPARSE flag to enable creating sparse files, and then have the application tell us what to do for any given range.

Teh right think is to keep sparse ranges spare as much as possible.
This would require the same sort of support as NFS READ_PLUS so I think
it's worthwhile to try it.  If the file system can't support it it won't
be sparse, so we'll get a worse quality of implementation.

But please don't add even more weird flags that just confuse users.

So far I think the only useful flag for copy_file_range is a PREALLOC
or similar flag that says the destination range should have an implicit
poix_fallocate performed on it.  And due to the complexity of
implementation I'm not even sure we need that in the first version.
