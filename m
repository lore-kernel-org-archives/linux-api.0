From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Persistent Reservation API
Date: Tue, 4 Aug 2015 13:53:49 -0400
Message-ID: <20150804175349.GA29013@redhat.com>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438672271-11309-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-api@vger.kernel.org, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 04 2015 at  3:11am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> This series adds support for a simplified persistent reservation API
> to the block layer.  The intent is that both in-kernel and userspace
> consumers can use the API instead of having to hand craft SCSI or NVMe
> command through the various pass through interfaces.  It also adds
> DM support as getting reservations through dm-multipath is a major
> pain with the current scheme.

The DM changes need to go through linux-dm.git.  Once the block and SCSI
bits land I'll rebase accordingly.  That cross-maintainer logisitics
aside, I'll reply with feedback on the DM patches.
