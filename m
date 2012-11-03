From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] Volatile Ranges (v7) & Lots of words
Date: Sat, 3 Nov 2012 08:57:55 +0100
Message-ID: <CAHO5Pa2XiZ5_ZJ19amzKoRi=-=g2st-VahF1XHm9ovbYyPhgdw@mail.gmail.com>
References: <1348888593-23047-1-git-send-email-john.stultz@linaro.org>
 <20121002173928.2062004e@notabene.brown> <506B6CE0.1060800@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506B6CE0.1060800-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Robert Love <rlove-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Adamushko <dmitry.adamushko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Mike Hommey <mh-YmoObPS1fuhg9hUCZPvPmw@public.gmane.org>, Taras Glek <tglek-4eJtQOnFJqFBDgjK7y7TUQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jake Edge <jake-T1hC0tSOHrs@public.gmane.org>, Michael Kerrisk <mtk.linux.li>
List-Id: linux-api@vger.kernel.org

[CC += linux-api, since this is an API change.]

Hi John,

A couple of other questions that occurred to me...

What are the expected/planned semantics of volatile ranges for mlocked
pages? I noticed that Minchan's patch series
(https://lwn.net/Articles/522154/) gives an error on attempt to mark
locked pages as volatile (which seems sensible). I didn't see anything
similar in your patches. Perhaps it's not easy to do because of the
non-VMA-based implementation? Something to think about.

On Wed, Oct 3, 2012 at 12:38 AM, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 10/02/2012 12:39 AM, NeilBrown wrote:
>>
>> On Fri, 28 Sep 2012 23:16:30 -0400 John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> wrote:
>>
>>   For example, allowing sub-page volatile region seems to be above and
>> beyond
>>   the call of duty.  You cannot mmap sub-pages, so why should they be
>> volatile?
>
> Although if someone marked a page and a half as volatile, would it be
> reasonable to throw away the second half of that second page? That seems
> unexpected to me. So we're really only marking the whole pages specified as
> volatlie,  similar to how FALLOC_FL_PUNCH_HOLE behaves.
>
> But if it happens that the adjacent range is also a partial page, we can
> coalesce them possibly into an purgable whole page. I think it makes sense,
> especially from a userland point of view and wasn't really complicated to
> add.

I must confess that I'm puzzled by this facility to lock sub-page
range ranges as well. What's the use case? What I'm thinking is: the
goal of volatile ranges is to help improve system performance by
freeing up a (sizeable) block of pages. Why then would the user care
too much about marking with sub-page granularity, or that such ranges
might be merged? After all, the system calls to do this marking are
expensive, and so for performance reasons, I suppose that a process
would like to keep those system calls to a minimum.

[...]

>>   I think discarding whole ranges at a time is very sensible, and so
>> merging
>>   adjacent ranges is best avoided.  If you require page-aligned ranges
>> this
>>   becomes trivial - is that right?
>
> True. If we avoid coalescing non-whole page ranges, keeping non-overlapping
> ranges independent is fairly easy.

Regarding coalescing of adjacent ranges. Here's one possible argument
against it (Jake Edge alerted me to this). If an application marked
adjacent ranges using separate system calls, that might be an
indication that the application intends to to have different access
patterns against the two ranges: one frequent, the other rare. In that
case, I suppose it would be better if the ranges were not merged.

Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
