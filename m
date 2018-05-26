From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: aio poll and a new in-kernel poll API V13
Date: Sat, 26 May 2018 08:09:37 +0100
Message-ID: <20180526070937.GA4188@ZenIV.linux.org.uk>
References: <20180523192022.1703-1-hch@lst.de>
 <20180526001111.GL30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180526001111.GL30522@ZenIV.linux.org.uk>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, May 26, 2018 at 01:11:11AM +0100, Al Viro wrote:
> On Wed, May 23, 2018 at 09:19:49PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series adds support for the IOCB_CMD_POLL operation to poll for the
> > readyness of file descriptors using the aio subsystem.  The API is based
> > on patches that existed in RHAS2.1 and RHEL3, which means it already is
> > supported by libaio.  To implement the poll support efficiently new
> > methods to poll are introduced in struct file_operations:  get_poll_head
> > and poll_mask.  The first one returns a wait_queue_head to wait on
> > (lifetime is bound by the file), and the second does a non-blocking
> > check for the POLL* events.  This allows aio poll to work without
> > any additional context switches, unlike epoll.
> > 
> > This series sits on top of the aio-fsync series that also includes
> > support for io_pgetevents.
> 
> OK, I can live with that, except for one problem - the first patch shouldn't
> be sitting on top of arseloads of next window fodder.
> 
> Please, rebase the rest of the series on top of merge of vfs.git#fixes
> (4faa99965e02) with your aio-fsync.4 and tell me what to pull.

UGH

You've based it on vfs.git#hch.aio (== your aio-fsync.4) + baf10564fbb6
(== vfs.git#fixes^), *and* started with cherry-pick of vfs.git#fixes
on top of that, followed by your series.

That makes no sense whatsoever.  Please, take your aio-fsync.4, merge
vfs.git#fixes (== 4faa99965e02, "fix io_destroy()/aio_complete() race",
same change as your 4e79230e5254) into it and rebase the rest of your
branch on top of that (from "uapi: turn __poll_t sparse checkin
on by default" to "random: convert to ->poll_mask").  BTW, you probably
want s/checkin/checks/ in the first one of those...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
