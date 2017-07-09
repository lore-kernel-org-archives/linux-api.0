From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/1] mm/mremap: add MREMAP_MIRROR flag for existing
 mirroring functionality
Date: Sun, 9 Jul 2017 12:53:30 +0530
Message-ID: <37f275bb-57c2-1485-02f2-dc71021f612a@linux.vnet.ibm.com>
References: <1499357846-7481-1-git-send-email-mike.kravetz@oracle.com>
 <1499357846-7481-2-git-send-email-mike.kravetz@oracle.com>
 <ea962c4b-3d47-2a95-7697-2efb4e8cd2f0@linux.vnet.ibm.com>
 <3a43d5fa-223d-1315-513b-85d3a09a07b6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <3a43d5fa-223d-1315-513b-85d3a09a07b6@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 07/07/2017 10:44 PM, Mike Kravetz wrote:
> On 07/07/2017 01:45 AM, Anshuman Khandual wrote:
>> On 07/06/2017 09:47 PM, Mike Kravetz wrote:
>>> The mremap system call has the ability to 'mirror' parts of an existing
>>> mapping.  To do so, it creates a new mapping that maps the same pages as
>>> the original mapping, just at a different virtual address.  This
>>> functionality has existed since at least the 2.6 kernel.
>>>
>>> This patch simply adds a new flag to mremap which will make this
>>> functionality part of the API.  It maintains backward compatibility with
>>> the existing way of requesting mirroring (old_size == 0).
>>>
>>> If this new MREMAP_MIRROR flag is specified, then new_size must equal
>>> old_size.  In addition, the MREMAP_MAYMOVE flag must be specified.
>>
>> Yeah it all looks good. But why is this requirement that if
>> MREMAP_MAYMOVE is specified then old_size and new_size must
>> be equal.
> 
> No real reason.  I just wanted to clearly separate the new interface from
> the old.  On second thought, it would be better to require old_size == 0
> as in the legacy interface.

That would be redundant. Mirroring will just happen because old_size is
0 whether we mention the MREMAP_MIRROR flag or not. IMHO it should just
mirror if the flag is specified irrespective of the old_size value.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
