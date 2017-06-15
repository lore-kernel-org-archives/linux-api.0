From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10 v11] No wait AIO
Date: Thu, 15 Jun 2017 07:55:41 -0700
Message-ID: <20170615145541.GA14028@infradead.org>
References: <20170606111939.27272-1-rgoldwyn@suse.de>
 <20170608073910.GB9292@infradead.org>
 <20170610053441.GD6365@ZenIV.linux.org.uk>
 <58bbe95e-5a4a-4387-3a00-16ed2e861bd3@suse.de>
 <20170613061431.GA11432@infradead.org>
 <20170615111157.GL31671@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170615111157.GL31671@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com
List-Id: linux-api@vger.kernel.org

On Thu, Jun 15, 2017 at 12:11:58PM +0100, Al Viro wrote:
> Which flags are you talking about?  aio ones?  AFAICS, it's the same
> kind of thing as "can we lseek?" or "can we read/pread?", etc.
> What would that field look like?  Note that some of those might depend
> upon the flags passed to open(), so shoving them into file_operations
> might mean splitting file_operations instances...  Details, please.

Yeah, I'll take my suggestion back.
