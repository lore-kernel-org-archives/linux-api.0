From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] mm,mremap: Bail out earlier in mremap_to under map pressure
Date: Thu, 28 Feb 2019 12:44:11 -0800
Message-ID: <CAEXW_YQFDJUjHmjE+aF6RkBxO8fzF2j5M1Tufj12MUuvouyOsA@mail.gmail.com>
References: <20190226091314.18446-1-osalvador@suse.de> <20190226140428.3e7c8188eda6a54f9da08c43@linux-foundation.org>
 <20190227213205.5wdjucqdgfqx33tr@d104.suse.de> <5edcfeb8-4f53-0fe6-1e5b-c1e485f91d0d@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5edcfeb8-4f53-0fe6-1e5b-c1e485f91d0d@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, jglisse@redhat.com, Yang Shi <yang.shi@linux.alibaba.com>, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

On Thu, Feb 28, 2019 at 12:06 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 2/27/19 10:32 PM, Oscar Salvador wrote:
> > On Tue, Feb 26, 2019 at 02:04:28PM -0800, Andrew Morton wrote:
> >> How is this going to affect existing userspace which is aware of the
> >> current behaviour?
> >
> > Well, current behavior is not really predictable.
> > Our customer was "surprised" that the call to mremap() failed, but the regions
> > got unmapped nevertheless.
> > They found it the hard way when they got a segfault when trying to write to those
> > regions when cleaning up.
> >
> > As I said in the changelog, the possibility for false positives exists, due to
> > the fact that we might get rid of several vma's when unmapping, but I do not
> > expect existing userspace applications to start failing.
> > Should be that the case, we can revert the patch, it is not that it adds a lot
> > of churn.
>
> Hopefully the only program that would start failing would be a LTP test
> testing the current behavior near the limit (if such test exists). And
> that can be adjusted.
>

IMO the original behavior is itself probably not a big issue because
if userspace wanted to mremap over something, it was prepared to lose
the "over something" mapping anyway. So it does seem to be a stretch
to call the behavior a "bug". Still I agree with the patch that mremap
should not leave any side effects after returning error.

thanks,

 - Joel
