From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm,mremap: Bail out earlier in mremap_to under map
 pressure
Date: Thu, 28 Feb 2019 09:06:54 +0100
Message-ID: <5edcfeb8-4f53-0fe6-1e5b-c1e485f91d0d@suse.cz>
References: <20190226091314.18446-1-osalvador@suse.de>
 <20190226140428.3e7c8188eda6a54f9da08c43@linux-foundation.org>
 <20190227213205.5wdjucqdgfqx33tr@d104.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190227213205.5wdjucqdgfqx33tr@d104.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, kirill@shutemov.name, joel@joelfernandes.org, jglisse@redhat.com, yang.shi@linux.alibaba.com, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

On 2/27/19 10:32 PM, Oscar Salvador wrote:
> On Tue, Feb 26, 2019 at 02:04:28PM -0800, Andrew Morton wrote:
>> How is this going to affect existing userspace which is aware of the
>> current behaviour?
> 
> Well, current behavior is not really predictable.
> Our customer was "surprised" that the call to mremap() failed, but the regions
> got unmapped nevertheless.
> They found it the hard way when they got a segfault when trying to write to those
> regions when cleaning up. 
> 
> As I said in the changelog, the possibility for false positives exists, due to
> the fact that we might get rid of several vma's when unmapping, but I do not
> expect existing userspace applications to start failing.
> Should be that the case, we can revert the patch, it is not that it adds a lot
> of churn.

Hopefully the only program that would start failing would be a LTP test
testing the current behavior near the limit (if such test exists). And
that can be adjusted.

>> And how does it affect your existing cleanup code, come to that?  Does
>> it work as well or better after this change?
> 
> I guess the customer can trust more reliable that the maps were left untouched.
> I still have my reserves though.
> 
> We can get as far as move_vma(), and copy_vma() can fail returning -ENOMEM.
> (Or not due to the "too small to fail" ?)
> 
