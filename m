From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Date: Fri, 24 Oct 2014 02:40:47 -0700
Message-ID: <20141024094047.GD29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:59PM -0400, Milosz Tanski wrote:
> Filesystems that generic_file_read_iter will not be allowed to perform
> non-blocking reads. This only will read data if it's in the page cache and if
> there is no page error (causing a re-read).

I can't quite parse the first sentence, can you try to reword it?

> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).

s/specify/specific/.  It's so trivial that I don't think it matters.
