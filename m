From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Date: Mon, 10 Apr 2017 07:39:43 -0700
Message-ID: <20170410143943.GA2930@infradead.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-7-rgoldwyn@suse.de>
 <20170404075853.GB28522@quack2.suse.cz>
 <20170404084122.GA10252@infradead.org>
 <d6dac6ec-c71c-0082-972f-61e7299ed418@suse.de>
 <20170410074539.GA18250@infradead.org>
 <20170410123750.GE3224@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170410123750.GE3224@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 10, 2017 at 02:37:50PM +0200, Jan Kara wrote:
> I don't understand here. Do you want that all filesystems support NOWAIT
> direct IO?

No.  Per-file_system_type is way to coarse grained.  All feature flag
needs to be per-file_operation at least for cases like ext4 with our
without extents (or journal) XFS v4 vs v5, different NFS versions, etc.

For RWF_* each file operation simply declares if the feature is
supported not by rejecting unknown ones.  FIEMAP does the same as do
a few other interfaces.
