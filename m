From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/4] vfs: Export new vector IO syscalls (with flags) to
 userland
Date: Fri, 24 Oct 2014 02:38:02 -0700
Message-ID: <20141024093802.GC29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <e43b43c1e7b14b454b6425a650cd45cbb75fd325.1413923420.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e43b43c1e7b14b454b6425a650cd45cbb75fd325.1413923420.git.milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:58PM -0400, Milosz Tanski wrote:
> This is only for x86_64 and x86. Will add other arch later.

Looks good, but I think the patch subject should read something like:

x86: wite up preadv2 and pwritev2

in which case you might also get away with an empty description.

Please also Cc linux-arch to get the attention of other architecture
maintainers for the next repost.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
