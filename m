From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V2
Date: Wed, 10 Jan 2018 23:36:19 +0100
Message-ID: <7eda0558-dc70-2d0c-5eca-ca4c3036585d@gmail.com>
References: <20180110155853.32348-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-1-hch@lst.de>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk
Cc: mtk.manpages@gmail.com, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Christoph,

On 01/10/2018 04:58 PM, Christoph Hellwig wrote:
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
>     http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-poll.2
> 
> Libaio changes:
> 
>     http://git.infradead.org/users/hch/libaio.git/shortlog/refs/heads/aio-poll
> 
> Seastar changes:
> 
>     https://github.com/avikivity/seastar/commits/aio
> 
> Changes since V1:
>  - handle the NULL ->poll case in vfs_poll
>  - dropped the file argument to the ->poll_mask socket operation
>  - replace the ->pre_poll socket operation with ->get_poll_head as
>    in the file operations

Are there some man pages patches already for these changes?

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
