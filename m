From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: io_pgetevents & aio fsync V2
Date: Fri, 06 Apr 2018 08:57:59 -0400
Message-ID: <x497epklcfc.fsf@segfault.boston.devel.redhat.com>
References: <20180328072639.16885-1-hch@lst.de>
	<20180406031630.GU30522@ZenIV.linux.org.uk>
	<20180406062700.GA20714@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180406062700.GA20714@lst.de> (Christoph Hellwig's message of
	"Fri, 6 Apr 2018 08:27:00 +0200")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Apr 06, 2018 at 04:16:30AM +0100, Al Viro wrote:
>> BTW, this is only tangentially related, but... does *anything* call
>> io_submit() for huge amounts of iocb?

I don't know.  If an application did that, as many I/Os as could fit
into the ring buffer would be submitted, and that's what gets returned
from the system call (the number of submitted iocbs).

>> Check in do_io_submit() is insane - "no more than MAX_LONG total of
>> _pointers_".  Compat variant goes for "no more than a page worth of
>> pointers" and there's a hard limit in ioctx_alloc() - we can't ever
>> get more than 8M slots in ring buffer...
>
> Logical upper bound for io_submit is nr_events passed to io_setup(),
> which is bound by aio_max_nr.  Except that we never actually check
> against nr_events (or max_reqs as it is known in kernel) in io_submit.
> Sigh..

io_submit_one calls aio_get_req which calls get_reqs_available, which is
what does the checking for an available ring buffer entry.

-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
