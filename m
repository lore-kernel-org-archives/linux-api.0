From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 00:55:29 -0700
Message-ID: <20160331075529.GB4209@infradead.org>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331003242.GA5813@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160331003242.GA5813@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 30, 2016 at 05:32:42PM -0700, Liu Bo wrote:
> Well, btrfs fallocate doesn't allocate space if it's a shared one
> because it thinks the space is already allocated.  So a later overwrite
> over this shared extent may hit enospc errors.

And this makes it an incorrect implementation of posix_fallocate,
which glibcs implements using fallocate if available.
