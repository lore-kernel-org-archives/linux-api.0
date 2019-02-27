From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 11/19] block: implement bio helper to add iter bvec pages
 to bio
Date: Wed, 27 Feb 2019 09:21:09 +0800
Message-ID: <CACVXFVNOFA8_p+hVvaCffWAQ7+dgn++0b4Wn3naJzyNZN=CoFg@mail.gmail.com>
References: <20190211190049.7888-1-axboe@kernel.dk> <20190211190049.7888-13-axboe@kernel.dk>
 <20190220225856.GB28313@ming.t460p> <b143e8c3-33d5-5f09-c441-98b3bf326d81@kernel.dk>
 <20190226034613.GA676@sol.localdomain> <aa1184bb-b482-0637-21e4-1ddb0e7aea90@kernel.dk>
 <1652577e-787b-638e-625d-c200fb144a9d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <1652577e-787b-638e-625d-c200fb144a9d@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Biggers <ebiggers@kernel.org>, Ming Lei <ming.lei@redhat.com>, "open list:AIO" <linux-aio@kvack.org>, linux-block <linux-block@vger.kernel.org>, linux-api@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, jannh@google.com, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 26, 2019 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/25/19 9:34 PM, Jens Axboe wrote:
> > On 2/25/19 8:46 PM, Eric Biggers wrote:
> >> Hi Jens,
> >>
> >> On Thu, Feb 21, 2019 at 10:45:27AM -0700, Jens Axboe wrote:
> >>> On 2/20/19 3:58 PM, Ming Lei wrote:
> >>>> On Mon, Feb 11, 2019 at 12:00:41PM -0700, Jens Axboe wrote:
> >>>>> For an ITER_BVEC, we can just iterate the iov and add the pages
> >>>>> to the bio directly. This requires that the caller doesn't releases
> >>>>> the pages on IO completion, we add a BIO_NO_PAGE_REF flag for that.
> >>>>>
> >>>>> The current two callers of bio_iov_iter_get_pages() are updated to
> >>>>> check if they need to release pages on completion. This makes them
> >>>>> work with bvecs that contain kernel mapped pages already.
> >>>>>
> >>>>> Reviewed-by: Hannes Reinecke <hare@suse.com>
> >>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>> ---
> >>>>>  block/bio.c               | 59 ++++++++++++++++++++++++++++++++-------
> >>>>>  fs/block_dev.c            |  5 ++--
> >>>>>  fs/iomap.c                |  5 ++--
> >>>>>  include/linux/blk_types.h |  1 +
> >>>>>  4 files changed, 56 insertions(+), 14 deletions(-)
> >>>>>
> >>>>> diff --git a/block/bio.c b/block/bio.c
> >>>>> index 4db1008309ed..330df572cfb8 100644
> >>>>> --- a/block/bio.c
> >>>>> +++ b/block/bio.c
> >>>>> @@ -828,6 +828,23 @@ int bio_add_page(struct bio *bio, struct page *page,
> >>>>>  }
> >>>>>  EXPORT_SYMBOL(bio_add_page);
> >>>>>
> >>>>> +static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
> >>>>> +{
> >>>>> + const struct bio_vec *bv = iter->bvec;
> >>>>> + unsigned int len;
> >>>>> + size_t size;
> >>>>> +
> >>>>> + len = min_t(size_t, bv->bv_len, iter->count);
> >>>>> + size = bio_add_page(bio, bv->bv_page, len,
> >>>>> +                         bv->bv_offset + iter->iov_offset);
> >>>>
> >>>> iter->iov_offset needs to be subtracted from 'len', looks
> >>>> the following delta change[1] is required, otherwise memory corruption
> >>>> can be observed when running xfstests over loop/dio.
> >>>
> >>> Thanks, I folded this in.
> >>>
> >>> --
> >>> Jens Axboe
> >>>
> >>
> >> syzkaller started hitting a crash on linux-next starting with this commit, and
> >> it still occurs even with your latest version that has Ming's fix folded in.
> >> Specifically, commit a566653ab5ab80a from your io_uring branch with commit date
> >> Sun Feb 24 08:20:53 2019 -0700.
> >>
> >> Reproducer:
> >>
> >> #define _GNU_SOURCE
> >> #include <fcntl.h>
> >> #include <linux/loop.h>
> >> #include <sys/ioctl.h>
> >> #include <sys/sendfile.h>
> >> #include <sys/syscall.h>
> >> #include <unistd.h>
> >>
> >> int main(void)
> >> {
> >>         int memfd, loopfd;
> >>
> >>         memfd = syscall(__NR_memfd_create, "foo", 0);
> >>
> >>         pwrite(memfd, "\xa8", 1, 4096);
> >>
> >>         loopfd = open("/dev/loop0", O_RDWR|O_DIRECT);
> >>
> >>         ioctl(loopfd, LOOP_SET_FD, memfd);
> >>
> >>         sendfile(loopfd, loopfd, NULL, 1000000);
> >> }
> >>
> >>
> >> Crash:
> >>
> >> page:ffffea0001a6aab8 count:0 mapcount:0 mapping:0000000000000000 index:0x0
> >> flags: 0x100000000000000()
> >> raw: 0100000000000000 ffffea0001ad2c50 ffff88807fca49d0 0000000000000000
> >> raw: 0000000000000000 0000000000000000 00000000ffffffff
> >> page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
> >
> > I see what this is, I'll cut a fix for this tomorrow.
>
> Folded in a fix for this, it's in my current io_uring branch and my for-next
> branch.

Hi Jens,

I saw the following change is added:

+ if (size == len) {
+ /*
+ * For the normal O_DIRECT case, we could skip grabbing this
+ * reference and then not have to put them again when IO
+ * completes. But this breaks some in-kernel users, like
+ * splicing to/from a loop device, where we release the pipe
+ * pages unconditionally. If we can fix that case, we can
+ * get rid of the get here and the need to call
+ * bio_release_pages() at IO completion time.
+ */
+ get_page(bv->bv_page);

Now the 'bv' may point to more than one page, so the following one may be
needed:

int i;
struct bvec_iter_all iter_all;
struct bio_vec *tmp;

mp_bvec_for_each_segment(tmp, bv, i, iter_all)
      get_page(tmp->bv_page);

Thanks,
Ming Lei

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
