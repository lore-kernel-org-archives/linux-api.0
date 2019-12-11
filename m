From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH NOTFORMERGE 0/5] Extend remote madvise API to KSM hints
Date: Tue, 10 Dec 2019 17:35:03 -0800
Message-ID: <20191211013503.GA134194@google.com>
References: <20190616085835.953-1-oleksandr@redhat.com>
 <20191210104939.jauw5hnv3smhtvtr@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191210104939.jauw5hnv3smhtvtr@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Oleksandr,

On Tue, Dec 10, 2019 at 11:49:39AM +0100, Oleksandr Natalenko wrote:
> Hello, Minchan.
> 
> On Sun, Jun 16, 2019 at 10:58:30AM +0200, Oleksandr Natalenko wrote:
> > This is a set of commits based on our discussion on your submission [1].
> > 
> > First 2 implement minor suggestions just for you to not forget to take
> > them into account.
> > 
> > uio.h inclusion was needed for me to be able to compile your series
> > successfully. Also please note I had to enable "Transparent Hugepage
> > Support" as well as "Enable idle page tracking" options, otherwise the
> > build failed. I guess this can be addressed by you better since the
> > errors are introduced with MADV_COLD introduction.
> > 
> > Last 2 commits are the actual KSM hints enablement. The first one
> > implements additional check for the case where the mmap_sem is taken for
> > write, and the second one just allows KSM hints to be used by the remote
> > interface.
> > 
> > I'm not Cc'ing else anyone except two mailing lists to not distract
> > people unnecessarily. If you are fine with this addition, please use it
> > for your next iteration of process_madvise(), and then you'll Cc all the
> > people needed.
> > 
> > Thanks.
> > 
> > [1] https://lore.kernel.org/lkml/20190531064313.193437-1-minchan@kernel.org/
> > 
> > Oleksandr Natalenko (5):
> >   mm: rename madvise_core to madvise_common
> >   mm: revert madvise_inject_error line split
> >   mm: include uio.h to madvise.c
> >   mm/madvise: employ mmget_still_valid for write lock
> >   mm/madvise: allow KSM hints for remote API
> > 
> >  mm/madvise.c | 23 ++++++++++++++---------
> >  1 file changed, 14 insertions(+), 9 deletions(-)
> > 
> > -- 
> > 2.22.0
> > 
> 
> This is a gentle ping. Are you still planning to submit process_madvise() solution?

I'm really sorry for being slow progress.
I am stuck with internal stuff of company.
I will do best effort to send it within one or two weeks.

Thanks.
