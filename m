From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Date: Thu, 11 May 2017 00:42:50 -0700
Message-ID: <20170511074250.GC15626@infradead.org>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-4-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-4-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

It might make sense to move filemap_range_has_page into a separate
prep patch.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
