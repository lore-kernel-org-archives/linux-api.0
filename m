From: Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm,mremap: Bail out earlier in mremap_to under map
 pressure
Date: Wed, 27 Feb 2019 22:32:09 +0100
Message-ID: <20190227213205.5wdjucqdgfqx33tr@d104.suse.de>
References: <20190226091314.18446-1-osalvador@suse.de>
 <20190226140428.3e7c8188eda6a54f9da08c43@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190226140428.3e7c8188eda6a54f9da08c43@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, kirill@shutemov.name, vbabka@suse.cz, joel@joelfernandes.org, jglisse@redhat.com, yang.shi@linux.alibaba.com, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

On Tue, Feb 26, 2019 at 02:04:28PM -0800, Andrew Morton wrote:
> How is this going to affect existing userspace which is aware of the
> current behaviour?

Well, current behavior is not really predictable.
Our customer was "surprised" that the call to mremap() failed, but the regions
got unmapped nevertheless.
They found it the hard way when they got a segfault when trying to write to those
regions when cleaning up. 

As I said in the changelog, the possibility for false positives exists, due to
the fact that we might get rid of several vma's when unmapping, but I do not
expect existing userspace applications to start failing.
Should be that the case, we can revert the patch, it is not that it adds a lot
of churn.

> And how does it affect your existing cleanup code, come to that?  Does
> it work as well or better after this change?

I guess the customer can trust more reliable that the maps were left untouched.
I still have my reserves though.

We can get as far as move_vma(), and copy_vma() can fail returning -ENOMEM.
(Or not due to the "too small to fail" ?)

-- 
Oscar Salvador
SUSE L3
