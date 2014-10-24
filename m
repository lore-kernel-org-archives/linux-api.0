From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Date: Fri, 24 Oct 2014 13:16:04 -0400
Message-ID: <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
	<x49k33po42c.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 11:55 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> Filesystems that generic_file_read_iter will not be allowed to perform
>> non-blocking reads. This only will read data if it's in the page cache and if
>> there is no page error (causing a re-read).
>>
>> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>
> Add in the 2 hunks from the other patches, as suggested by Christoph,
> and you can add my:
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

I'm aware of the 3 patch series that Christoph sent out shortly after
the previous version of the patchset. Wasn't sure what to do about it.

Christoph, should I apply your last 3 patches to the end of this tree
and send it along with the next submission? Or should I take the first
two combine them with this change and then apply RWF_DSYNC ontop of
it?

- M

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
