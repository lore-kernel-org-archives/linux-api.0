From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Tue, 12 Mar 2019 15:50:43 +0000
Message-ID: <20190312155043.vj3fiutnsovjti2x@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190312152059.GA5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190312152059.GA5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 12-Mar 16:20, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> > +/* Integer ceil-rounded range for each bucket */
> > +#define UCLAMP_BUCKET_DELTA ((SCHED_CAPACITY_SCALE / UCLAMP_BUCKETS) + 1)
> 
> Uhm, should that not me ((x+y-1)/y), aka. DIV_ROUND_UP(x,y) ?

Well, there is certainly some rounding to be done...

> The above would give 4 for 9/3, which is clearly buggered.

.. still the math above should work fine within the boundaries we
define for UCLAMP_BUCKET_DELTA (5..20 groups) and considering that
SCHED_CAPACITY_SCALE will never be smaller then 1024.

The above is designed to shrink the topmost bucket wrt all the others
but it will never be smaller than ~30%.

Here are the start values computed for each bucket using the math
above and the computed shrinking percentage for the topmost bucket:

bukets size: 205, top bucket start@820 (err:  0.49%), buckets: {0: 0, 1: 205, 2: 410, 3: 615, 4: 820}
bukets size: 171, top bucket start@855 (err:  1.17%), buckets: {0: 0, 1: 171, 2: 342, 3: 513, 4: 684, 5: 855}
bukets size: 147, top bucket start@882 (err:  3.40%), buckets: {0: 0, 1: 147, 2: 294, 3: 441, 4: 588, 5: 735, 6: 882}
bukets size: 129, top bucket start@903 (err:  6.20%), buckets: {0: 0, 1: 129, 2: 258, 3: 387, 4: 516, 5: 645, 6: 774, 7: 903}
bukets size: 114, top bucket start@912 (err:  1.75%), buckets: {0: 0, 1: 114, 2: 228, 3: 342, 4: 456, 5: 570, 6: 684, 7: 798, 8: 912}
bukets size: 103, top bucket start@927 (err:  5.83%), buckets: {0: 0, 1: 103, 2: 206, 3: 309, 4: 412, 5: 515, 6: 618, 7: 721, 8: 824, 9: 927}
bukets size:  94, top bucket start@940 (err: 10.64%), buckets: {0: 0, 1:  94, 2: 188, 3: 282, 4: 376, 5: 470, 6: 564, 7: 658, 8: 752, 9: 846, 10: 940}
bukets size:  86, top bucket start@946 (err:  9.30%), buckets: {0: 0, 1:  86, 2: 172, 3: 258, 4: 344, 5: 430, 6: 516, 7: 602, 8: 688, 9: 774, 10: 860, 11: 946}
bukets size:  79, top bucket start@948 (err:  3.80%), buckets: {0: 0, 1:  79, 2: 158, 3: 237, 4: 316, 5: 395, 6: 474, 7: 553, 8: 632, 9: 711, 10: 790, 11: 869, 12: 948}
bukets size:  74, top bucket start@962 (err: 16.22%), buckets: {0: 0, 1:  74, 2: 148, 3: 222, 4: 296, 5: 370, 6: 444, 7: 518, 8: 592, 9: 666, 10: 740, 11: 814, 12: 888, 13: 962}
bukets size:  69, top bucket start@966 (err: 15.94%), buckets: {0: 0, 1:  69, 2: 138, 3: 207, 4: 276, 5: 345, 6: 414, 7: 483, 8: 552, 9: 621, 10: 690, 11: 759, 12: 828, 13: 897, 14: 966}
bukets size:  65, top bucket start@975 (err: 24.62%), buckets: {0: 0, 1:  65, 2: 130, 3: 195, 4: 260, 5: 325, 6: 390, 7: 455, 8: 520, 9: 585, 10: 650, 11: 715, 12: 780, 13: 845, 14: 910, 15: 975}
bukets size:  61, top bucket start@976 (err: 21.31%), buckets: {0: 0, 1:  61, 2: 122, 3: 183, 4: 244, 5: 305, 6: 366, 7: 427, 8: 488, 9: 549, 10: 610, 11: 671, 12: 732, 13: 793, 14: 854, 15: 915, 16: 976}
bukets size:  57, top bucket start@969 (err:  3.51%), buckets: {0: 0, 1:  57, 2: 114, 3: 171, 4: 228, 5: 285, 6: 342, 7: 399, 8: 456, 9: 513, 10: 570, 11: 627, 12: 684, 13: 741, 14: 798, 15: 855, 16: 912, 17: 969}
bukets size:  54, top bucket start@972 (err:  3.70%), buckets: {0: 0, 1:  54, 2: 108, 3: 162, 4: 216, 5: 270, 6: 324, 7: 378, 8: 432, 9: 486, 10: 540, 11: 594, 12: 648, 13: 702, 14: 756, 15: 810, 16: 864, 17: 918, 18: 972}
bukets size:  52, top bucket start@988 (err: 30.77%), buckets: {0: 0, 1:  52, 2: 104, 3: 156, 4: 208, 5: 260, 6: 312, 7: 364, 8: 416, 9: 468, 10: 520, 11: 572, 12: 624, 13: 676, 14: 728, 15: 780, 16: 832, 17: 884, 18: 936, 19: 988}

Does that makes sense?

-- 
#include <best/regards.h>

Patrick Bellasi
