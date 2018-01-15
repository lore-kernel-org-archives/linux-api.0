From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 30/32] aio: add delayed cancel support
Date: Mon, 15 Jan 2018 09:54:16 +0100
Message-ID: <20180115085416.GC32532@lst.de>
References: <20180110155853.32348-1-hch@lst.de> <20180110155853.32348-31-hch@lst.de> <x49y3l52uda.fsf@segfault.boston.devel.redhat.com> <x49r2qx2t3k.fsf@segfault.boston.devel.redhat.com> <20180111134358.GA5926@lst.de> <x49373ce7qu.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49373ce7qu.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 11, 2018 at 10:27:05AM -0500, Jeff Moyer wrote:
> Duh, good point.  My main concern is that things like usb gadget will
> have to deal with races between cancellation and completion on their
> own.  It would be nice if we had infrastructure for them to use.  I'll
> have a look through that code to see if there's something we could or
> should be doing.

The current cancel interface is a bit of a mess, as it assumes the
kiocb is embedded into an aio_kiocb.  I think it would need a major
rework in general, but I'll need to fix a couple other aio issues
first.
