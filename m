From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: selective block polling and preadv2/pwritev2 revisited V2
Date: Mon, 29 Feb 2016 09:59:02 -0500
Message-ID: <x49oaazmukp.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<x497fhrmaps.fsf@segfault.boston.devel.redhat.com>
	<20160227085744.GC4255@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160227085744.GC4255@lst.de> (Christoph Hellwig's message of
	"Sat, 27 Feb 2016 09:57:44 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Fri, Feb 26, 2016 at 04:18:55PM -0500, Jeff Moyer wrote:
>> Christoph Hellwig <hch@lst.de> writes:
>> 
>> > This series allows to selectively enable/disable polling for completions
>> > in the block layer on a per-I/O basis.  For this it resurrects the
>> > preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which
>> > are much simpler now due to VFS changes that happened in the meantime).
>> > That approach also had a man page update prepared, which I will resubmit
>> > with the current flags once this series makes it in.
>> 
>> It would be helpful for reviewers if you submitted the man page at the
>> same time, in my opinion.
>
> Ok.
>
>> Do you have any plans on adding polling support to the buffered path?
>
> How would that even make sense?

I admit I haven't looked into the implementation details, but I was
thinking about O_SYNC writes or reads that missed the cache.

Thinking about this some more, it occurs to me that a file opened with
O_SYNC will still incur context switching.  Do you think we should add
that to the NOTES section of the man page?

Cheers,
Jeff
