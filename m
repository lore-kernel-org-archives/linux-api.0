From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH 2/4] vfs: Define new syscalls preadv2,pwritev2
Date: Fri, 24 Oct 2014 13:08:39 -0400
Message-ID: <CANP1eJEjZcmKRm-mgdUFJv7OY_qgjuatQOdiG+hO58R0OO8JNg@mail.gmail.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
	<20141024093659.GB29178@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20141024093659.GB29178@infradead.org>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 5:36 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index cb7f530..45964c8 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1735,7 +1735,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>>               }
>>       }
>>
>> -     retval = do_generic_file_read(file, ppos, iter, retval);
>> +     retval = do_generic_file_read(file, ppos, iter, retval, iocb->ki_rwflags);
>
> I think this belongs into the last patch, together with the last hunk
> from the first patch.
>
> Otherwise looks good to me:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I pushed the change from the previous patch to the prototype of
do_generic_file_read into this patch.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
