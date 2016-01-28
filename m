From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] man2: document FICLONE and FICLONERANGE
Date: Thu, 28 Jan 2016 05:33:29 -0800
Message-ID: <20160128133329.GA7610@infradead.org>
References: <20151219085607.12660.75196.stgit@birch.djwong.org>
 <20151219085613.12660.75735.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151219085613.12660.75735.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that we have this in 4.5-rc1 let's get this into man-pages as well.

> --- /dev/null
> +++ b/man2/ioctl_ficlone.2

think this should be a link to the clone range man page, and the
both ioctls should be documented together.  Basically just document
FICLONERANGE and then mentiond that FICLONE does a whole file clone.

> +.B #include <sys/ioctl.h>

Don't we need uapi/linux/fs.h as well?

> Not all filesystems support
> +overlapping reflink ranges in the same file.

Which one doesn't?


Also there should be a sentence that the clones are atomic vs
concurrent writes, so no locks need to be taken for a consistent
snapshot.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
