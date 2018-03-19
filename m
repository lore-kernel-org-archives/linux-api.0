From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V5
Date: Mon, 19 Mar 2018 09:35:48 +0100
Message-ID: <20180319083548.GA21224@lst.de>
References: <20180305212743.16664-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi everyone,

this posting has been out for 2 weeks now, without any replies except
for Jeff reminding of the missing reviews he already gave me in the
previous version.

Canwe make some progress on this?  Especially as all the aio bits
have gotten reviews from Jeff.

On Mon, Mar 05, 2018 at 01:27:07PM -0800, Christoph Hellwig wrote:
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
>     git://git.infradead.org/users/hch/vfs.git aio-poll.5
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-poll.5
> 
> Libaio changes:
> 
>     https://pagure.io/libaio.git io-poll
> 
> Seastar changes (not updated for the new io_pgetevens ABI yet):
> 
>     https://github.com/avikivity/seastar/commits/aio
> 
> Changes since V4:
>  - rebased ontop of Linux 4.16-rc4
> 
> Changes since V3:
>  - remove the pre-sleep ->poll_mask call in vfs_poll,
>    allow ->get_poll_head to return POLL* values.
> 
> Changes since V2:
>  - removed a double initialization
>  - new vfs_get_poll_head helper
>  - document that ->get_poll_head can return NULL
>  - call ->poll_mask before sleeping
>  - various ACKs
>  - add conversion of random to ->poll_mask
>  - add conversion of af_alg to ->poll_mask
>  - lacking ->poll_mask support now returns -EINVAL for IOCB_CMD_POLL
>  - reshuffled the series so that prep patches and everything not
>    requiring the new in-kernel poll API is in the beginning
> 
> Changes since V1:
>  - handle the NULL ->poll case in vfs_poll
>  - dropped the file argument to the ->poll_mask socket operation
>  - replace the ->pre_poll socket operation with ->get_poll_head as
>    in the file operations
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
---end quoted text---

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
