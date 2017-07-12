From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH 1/1] mm/mremap: add MREMAP_MIRROR flag for existing
 mirroring functionality
Date: Wed, 12 Jul 2017 09:55:48 -0700
Message-ID: <3a2cfeae-520c-b6e5-2808-cf1bcf62b067@oracle.com>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
 <1499357846-7481-2-git-send-email-mike.kravetz@oracle.com>
 <20170711123642.GC11936@dhcp22.suse.cz>
 <7f14334f-81d1-7698-d694-37278f05a78e@oracle.com>
 <20170712114655.GG28912@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170712114655.GG28912@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On 07/12/2017 04:46 AM, Michal Hocko wrote:
> On Tue 11-07-17 11:23:19, Mike Kravetz wrote:
>> On 07/11/2017 05:36 AM, Michal Hocko wrote:
> [...]
>>> Anyway the patch should fail with -EINVAL on private mappings as Kirill
>>> already pointed out
>>
>> Yes.  I think this should be a separate patch.  As mentioned earlier,
>> mremap today creates a new/additional private mapping if called in this
>> way with old_size == 0.  To me, this is a bug.
> 
> Not only that. It clears existing ptes in the old mapping so the content
> is lost. That is quite unexpected behavior. Now it is hard to assume
> whether somebody relies on the behavior (I can easily imagine somebody
> doing backup&clear in atomic way) so failing with EINVAL might break
> userspace so I am not longer sure. Anyway this really needs to be
> documented.

I am pretty sure it does not clear ptes in the old mapping, or modify it
in any way.  Are you thinking they are cleared as part of the call to
move_page_tables?  Since old_size == 0 (len as passed to move_page_tables),
the for loop in move_page_tables is not run and it doesn't do much of
anything in this case.

My plan is to look into adding hugetlbfs support to memfd_create, as this
would meet the user's needs.  And, this is a much more sane API than this
mremap(old_size == 0) behavior.

If adding hugetlbfs support to memfd_create works out, I would like to
see mremap(old_size == 0) support dropped.  Nobody here (kernel mm
development) seems to like it.  However, as you note there may be somebody
depending on this behavior.  What would be the process for removing
such support?  AFAIK, it is not documented anywhere.  If we do document
the behavior, then we will certainly be stuck with it for a long time.

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
