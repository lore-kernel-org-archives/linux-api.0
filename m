From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 28/32] aio: simplify cancellation
Date: Wed, 10 Jan 2018 17:50:43 -0500
Message-ID: <x49a7xl49bw.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
        <20180110155853.32348-29-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110155853.32348-29-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 10 Jan 2018 16:58:49 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> With the current aio code there is no need for the magic KIOCB_CANCELLED
> value, as a cancelation just kicks the driver to queue the completion
> ASAP, with all actual completion handling done in another thread. Given
> that both the completion path and cancelation take the context lock there
> is no need for magic cmpxchg loops either.

The cmpxchg was made unnecessary when the complementary xchg was removed
in commit bec68faaf ("aio: io_cancel() no longer returns the io_event").
There was no longer a need to ensure only the completion path or the
cancellation path delivered the completion event.  Now, the completion
is always delivered via aio_complete.

So yeah, we can get rid of this.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
