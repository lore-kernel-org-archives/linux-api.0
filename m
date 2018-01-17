From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 32/32] aio: implement io_pgetevents
Date: Wed, 17 Jan 2018 08:51:28 -0500
Message-ID: <x49fu741tlr.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-33-hch@lst.de>
	<x49k1wmdcxn.fsf@segfault.boston.devel.redhat.com>
	<20180115085310.GB32532@lst.de> <20180116120433.GA14579@lst.de>
	<x493735b9l7.fsf@segfault.boston.devel.redhat.com>
	<20180117073652.GA27389@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180117073652.GA27389@lst.de> (Christoph Hellwig's message of
	"Wed, 17 Jan 2018 08:36:52 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Tue, Jan 16, 2018 at 07:41:24PM -0500, Jeff Moyer wrote:
>> I'd be willing to bet the issue is in your io_syscall6 implementation.
>> You pass in arg5 where arg6 should be used.  Don't feel bad, it took me
>> the better part of today to figure that out.  :)
>> 
>> Here's an incremental diff on top of what you've posted.  Feel free to
>> fold it into your patch (and format however you like).  You can find the
>> libaio changes in my 'aio-poll' branch:
>>   https://pagure.io/libaio/commits/aio-poll
>> 
>> These changes were run through the libaio test harness, 64 bit and 32
>> bit, so the compat system call was tested.
>
> Oops, yes.  Although I prefer the copy_from_user version, this is what
> I had:

Much cleaner.

Thanks!
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
