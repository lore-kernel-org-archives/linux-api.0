From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Date: Tue, 4 Apr 2017 01:41:22 -0700
Message-ID: <20170404084122.GA10252@infradead.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404075853.GB28522@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 04, 2017 at 09:58:53AM +0200, Jan Kara wrote:
> FS_NOWAIT looks a bit too generic given these are filesystem feature flags.
> Can we call it FS_NOWAIT_IO?

It's way to generic as it's a feature of the particular file_operations
instance.  But once we switch to using RWF_* we can just the existing
per-op feature checks for thos and the per-fs flag should just go away.
