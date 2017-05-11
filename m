From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Thu, 11 May 2017 00:44:51 -0700
Message-ID: <20170511074451.GD15626@infradead.org>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-6-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-6-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although lifting the make_request limit is something a lot of users
would appreciate in the near future..
