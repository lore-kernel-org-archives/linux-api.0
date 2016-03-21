From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Date: Mon, 21 Mar 2016 08:46:37 -0700
Message-ID: <20160321154637.GA15069@infradead.org>
References: <20160302235638.GA27962@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160302235638.GA27962@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-api@vger.kernel.org

On Wed, Mar 02, 2016 at 03:56:38PM -0800, Darrick J. Wong wrote:
> Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> size hint, and actually plumb the CoW extent size hint into the fsxattr
> structure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
