From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 18 Sep 2017 10:19:09 -0700
Message-ID: <2d4ea731-5b8d-0aac-b5aa-57ff2d3d907a@oracle.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <CAG48ez0AAtzdQJPdW8sqj+mvYLdZezDe3x-_XgSvaN3ZwE=5GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAG48ez0AAtzdQJPdW8sqj+mvYLdZezDe3x-_XgSvaN3ZwE=5GQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Jann Horn <jannh@google.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-man@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 09/17/2017 06:52 PM, Jann Horn wrote:
> On Fri, Sep 15, 2017 at 2:37 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> [...]
>> A recent change was made to mremap so that an attempt to create a
>> duplicate a private mapping will fail.
>>
>> commit dba58d3b8c5045ad89c1c95d33d01451e3964db7
>> Author: Mike Kravetz <mike.kravetz@oracle.com>
>> Date:   Wed Sep 6 16:20:55 2017 -0700
>>
>>     mm/mremap: fail map duplication attempts for private mappings
>>
>> This return code is also documented here.
> [...]
>> diff --git a/man2/mremap.2 b/man2/mremap.2
> [...]
>> @@ -174,7 +189,12 @@ and
>>  or
>>  .B MREMAP_FIXED
>>  was specified without also specifying
>> -.BR MREMAP_MAYMOVE .
>> +.BR MREMAP_MAYMOVE ;
>> +or \fIold_size\fP was zero and \fIold_address\fP does not refer to a
>> +private anonymous mapping;
> 
> Shouldn't this be the other way around? "or old_size was zero and
> old_address refers to a private anonymous mapping"?

Thanks Jann,

Yes that is wrong.  In addition, the description of this functionality
in the section before this is also incorrect.

I will fix both in a new version of the patch.

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
