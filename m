From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: aio poll and a new in-kernel poll API V13
Date: Sun, 27 May 2018 23:27:30 +0100
Message-ID: <20180527222730.GS30522@ZenIV.linux.org.uk>
References: <20180523192022.1703-1-hch@lst.de>
 <20180526001111.GL30522@ZenIV.linux.org.uk>
 <20180526070937.GA4188@ZenIV.linux.org.uk>
 <20180526072306.GA17313@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180526072306.GA17313@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

	OK, it's in -next now; there are several cleanups I'd put
into vfs.git#work.aio:
      aio: all callers of aio_{read,write,fsync,poll} treat 0 and -EIOCBQUEUED the same way
      aio_read_events_ring(): make a bit more readable
      aio: shift copyin of iocb into io_submit_one()
      aio: fold do_io_submit() into callers
Those are *not* on -next yet and if anybody has objections against
any of those, please yell.  Individual patches in followups...

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
