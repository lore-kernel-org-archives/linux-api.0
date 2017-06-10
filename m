From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/10 v11] No wait AIO
Date: Sat, 10 Jun 2017 06:34:41 +0100
Message-ID: <20170610053441.GD6365@ZenIV.linux.org.uk>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170608073910.GB9292@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com
List-Id: linux-api@vger.kernel.org

On Thu, Jun 08, 2017 at 12:39:10AM -0700, Christoph Hellwig wrote:
> As already indicated this whole series looks fine to me.
> 
> Al: are you going to pick this up?  Or Andrew?

The main issue here is "let's bail out from ->write_iter() instances"
patch.  It very obviously has holes in coverage.

Could we have FMODE_AIO_NOWAIT and make those who claim to support it
set that in ->open()?  And make aio check that and bail out if asked
for nowait on a file without that flag...
