From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] fs: add iomap_file_dirty
Date: Mon, 5 Sep 2016 07:57:51 -0700
Message-ID: <20160905145751.GC7662@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
	<147216786712.525.5901639662288553230.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <147216786712.525.5901639662288553230.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 25, 2016 at 04:31:07PM -0700, Christoph Hellwig wrote:
> Originally-from: Christoph Hellwig <hch@lst.de>

This should be a

From: Christoph Hellwig <hch@lst.de>

so that git picks up authorship information correctly.

> XXX: might want a bigger name, and possible a better implementation
> that doesn't require two lookups in the radix tree.

And these need to be looked into.  I can take a stab at it, but I need
to get a few other things off my plate first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
