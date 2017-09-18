From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 18 Sep 2017 10:11:44 -0700
Message-ID: <ee87215d-9704-7269-4ec1-226f2e32a751@oracle.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
 <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Florian Weimer <fweimer@redhat.com>, mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 09/18/2017 06:45 AM, Florian Weimer wrote:
> On 09/15/2017 11:53 PM, Mike Kravetz wrote:
>> +If the value of \fIold_size\fP is zero, and \fIold_address\fP refers to
>> +a private anonymous mapping, then
>> +.BR mremap ()
>> +will create a new mapping of the same pages. \fInew_size\fP
>> +will be the size of the new mapping and the location of the new mapping
>> +may be specified with \fInew_address\fP, see the description of
>> +.B MREMAP_FIXED
>> +below.  If a new mapping is requested via this method, then the
>> +.B MREMAP_MAYMOVE
>> +flag must also be specified.  This functionality is deprecated, and no
>> +new code should be written to use this feature.  A better method of
>> +obtaining multiple mappings of the same private anonymous memory is via the
>> +.BR memfd_create()
>> +system call.
> 
> Is there any particular reason to deprecate this?
> 
> In glibc, we cannot use memfd_create and keep the file descriptor around because the application can close descriptors beneath us.
> 
> (We might want to use alias mappings to avoid run-time code generation for PLT-less LD_AUDIT interceptors.)
> 

Hi Florian,

When I brought up this mremap 'duplicate mapping' functionality on the mm
mail list, most developers were surprised.  It seems this functionality exists
mostly 'by chance', and it was not really designed.  It certainly was never
documented.  There were suggestions to remove the functionality, which led
to my claim that it was being deprecated.  However, in hindsight that may
have been too strong.

I can drop this wording, but would still like to suggest memfd_create as
the preferred method of creating duplicate mappings.  It would be good if
others on Cc: could comment as well.

Just curious, does glibc make use of this today?  Or, is this just something
that you think may be useful.

-- 
Mike Kravetz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
