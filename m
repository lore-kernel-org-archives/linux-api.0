From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
Date: Fri, 14 Nov 2014 13:46:38 -0500
Message-ID: <CANP1eJEhbE3xWYkJyj3ebhPdRLM3Gj+bBxWz40tvB5HXbzgWZg@mail.gmail.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
	<20141114163912.GA23769@redhat.com>
	<x491tp5ybcc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x491tp5ybcc.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 14, 2014 at 11:51 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Jones <davej@redhat.com> writes:
>
>> On Fri, Nov 14, 2014 at 11:32:53AM -0500, Jeff Moyer wrote:
>>
>>  > > Can you write a test (or set of) for fstests that exercises this new
>>  > > functionality? I'm not worried about performance, just
>>  > > correctness....
>>  >
>>  > On the subject of testing, I added support to trinity (attached,
>>  > untested).  That did raise one question.  Do we expect applications to
>>  > #include <linux/fs.h> to get the RWF_NONBLOCK definition?
>>
>> Trinity will at least need an addition to include/compat.h for
>> older headers that won't have the definition.  Looks ok otherwise.
>
> OK, I'll add that.
>
>> Also, I usually sit on stuff like this until the syscall numbers are
>> in Linus tree. This is 3.19 stuff I presume ?
>> istr akpm picked up execveat recently, so if that goes in first, we'll
>> need to respin this anyway..
>
> Sure.  I just wanted to test with trinity *before* it makes it into the
> kernel.  Crazy, I know.  ;-)

I am happy to help out to make sure it's solid... although deep down
inside I secretly wish that now wasn't the time we decided to start
doing it :)

>
> Cheers,
> Jeff



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
