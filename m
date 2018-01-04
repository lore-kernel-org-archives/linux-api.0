From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API
Date: Thu, 4 Jan 2018 10:09:24 +0100
Message-ID: <20180104090924.GA3674@lst.de>
References: <20180104080043.14506-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180104080043.14506-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

And of coure I should have added linux-api to the series.

Note that the libaio patches include documenting io_pgetevents in the
io_getevents man page.

On Thu, Jan 04, 2018 at 09:00:12AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds support for the IOCB_CMD_POLL operation to poll for the
> readyness of file descriptors using the aio subsystem.  The API is based
> on patches that existed in RHAS2.1 and RHEL3, which means it already is
> supported by libaio.  To implement the poll support efficiently new
> methods to poll are introduced in struct file_operations:  get_poll_head
> and poll_mask.  The first one returns a wait_queue_head to wait on
> (lifetime is bound by the file), and the second does a non-blocking
> check for the POLL* events.  This allows aio poll to work without
> any additional context switches, unlike epoll.
> 
> To make the interface fully useful a new io_pgetevents system call is
> added, which atomically saves and restores the signal mask over the
> io_pgetevents system call.  It it the logical equivalent to pselect and
> ppoll for io_pgetevents.
> 
> The corresponding libaio changes for io_pgetevents support and
> documentation, as well as a test case will be posted in a separate
> series.
> 
> The changes were sponsored by Scylladb, and improve performance
> of the seastar framework up to 10%, while also removing the need
> for a privileged SCHED_FIFO epoll listener thread.
> 
> The patches are on top of Als __poll_t annoations, so I've also
> prepared a git branch on top of those here:
> 
>     git://git.infradead.org/users/hch/vfs.git aio-poll
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-poll
> 
> Libaio changes:
> 
>     http://git.infradead.org/users/hch/libaio.git/shortlog/refs/heads/aio-poll
> 
> Seastar changes:
> 
>     https://github.com/avikivity/seastar/commits/aio
---end quoted text---

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
