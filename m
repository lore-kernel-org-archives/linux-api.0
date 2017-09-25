From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 15:16:09 +0200
Message-ID: <765cd0cb-aa35-187c-456d-05d8752caa04@redhat.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
 <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
 <ee87215d-9704-7269-4ec1-226f2e32a751@oracle.com>
 <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
 <20170925123508.pzjbe7wgwagnr5li@dhcp22.suse.cz>
 <e301609c-b2ac-24d1-c349-8d25e5123258@redhat.com>
 <20170925125207.4tu24sbpnihljknu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170925125207.4tu24sbpnihljknu@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 09/25/2017 02:52 PM, Michal Hocko wrote:
> So, how are you going to deal with the CoW and the implementation which
> basically means that the newm mmap content is not the same as the
> original one?

I don't understand why CoW would kick in.  The approach I outlined is 
desirable because it avoids the need to modify any executable pages, so 
this is not a concern.  The point is to create a potentially unbounded 
number of thunks *without* run-time code generation.

If the file is rewritten on disk, that's already undefined today, so 
it's not something we need to be concerned with.  (Anything which 
replaces ELF files needs to use the rename-into-place approach anyway.)

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
