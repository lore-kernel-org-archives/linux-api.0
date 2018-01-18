From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: aio poll, io_pgetevents and a new in-kernel poll API V3
Date: Thu, 18 Jan 2018 12:54:25 -0500
Message-ID: <x49zi5bt5m6.fsf@segfault.boston.devel.redhat.com>
References: <20180117192742.710-1-hch@lst.de>
        <x49bmhruq3k.fsf@segfault.boston.devel.redhat.com>
        <7f66bc5a-e9dd-fe4f-c07a-f3de3882365b@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <7f66bc5a-e9dd-fe4f-c07a-f3de3882365b@scylladb.com> (Avi Kivity's
        message of "Thu, 18 Jan 2018 19:51:09 +0200")
Sender: netdev-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Avi Kivity <avi@scylladb.com> writes:

> On 01/18/2018 05:46 PM, Jeff Moyer wrote:
>> FYI, this kernel has issues.  It will boot up, but I don't have
>> networking, and even rebooting doesn't succeed.  I'm looking into it.
>
> FWIW, I'm running an older version of this patchset on my desktop with
> no problems so far.

Right, it's worth mentioning that v1 worked fine for me.

-Jeff

>> Christoph Hellwig <hch@lst.de> writes:
>>
>>> Hi all,
>>>
>>> this series adds support for the IOCB_CMD_POLL operation to poll for the
>>> readyness of file descriptors using the aio subsystem.  The API is based
>>> on patches that existed in RHAS2.1 and RHEL3, which means it already is
>>> supported by libaio.  To implement the poll support efficiently new
>>> methods to poll are introduced in struct file_operations:  get_poll_head
>>> and poll_mask.  The first one returns a wait_queue_head to wait on
>>> (lifetime is bound by the file), and the second does a non-blocking
>>> check for the POLL* events.  This allows aio poll to work without
>>> any additional context switches, unlike epoll.
>>>
>>> To make the interface fully useful a new io_pgetevents system call is
>>> added, which atomically saves and restores the signal mask over the
>>> io_pgetevents system call.  It it the logical equivalent to pselect and
>>> ppoll for io_pgetevents.
>>>
>>> The corresponding libaio changes for io_pgetevents support and
>>> documentation, as well as a test case will be posted in a separate
>>> series.
>>>
>>> The changes were sponsored by Scylladb, and improve performance
>>> of the seastar framework up to 10%, while also removing the need
>>> for a privileged SCHED_FIFO epoll listener thread.
>>>
>>> The patches are on top of Als __poll_t annoations, so I've also
>>> prepared a git branch on top of those here:
>>>
>>>      git://git.infradead.org/users/hch/vfs.git aio-poll.3
>>>
>>> Gitweb:
>>>
>>>      http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-poll.3
>>>
>>> Libaio changes:
>>>
>>>      https://pagure.io/libaio.git io-poll
>>>
>>> Seastar changes (not updated for the new io_pgetevens ABI yet):
>>>
>>>      https://github.com/avikivity/seastar/commits/aio
>>>
>>> Changes since V2:
>>>   - removed a double initialization
>>>   - new vfs_get_poll_head helper
>>>   - document that ->get_poll_head can return NULL
>>>   - call ->poll_mask before sleeping
>>>   - various ACKs
>>>   - add conversion of random to ->poll_mask
>>>   - add conversion of af_alg to ->poll_mask
>>>   - lacking ->poll_mask support now returns -EINVAL for IOCB_CMD_POLL
>>>   - reshuffled the series so that prep patches and everything not
>>>     requiring the new in-kernel poll API is in the beginning
>>>
>>> Changes since V1:
>>>   - handle the NULL ->poll case in vfs_poll
>>>   - dropped the file argument to the ->poll_mask socket operation
>>>   - replace the ->pre_poll socket operation with ->get_poll_head as
>>>     in the file operations
>>>
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-aio' in
>>> the body to majordomo@kvack.org.  For more info on Linux AIO,
>>> see: http://www.kvack.org/aio/
>>> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
