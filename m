From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [patch] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 14:40:42 +0200
Message-ID: <e301609c-b2ac-24d1-c349-8d25e5123258@redhat.com>
References: <20170915213745.6821-1-mike.kravetz@oracle.com>
 <a6e59a7f-fd15-9e49-356e-ed439f17e9df@oracle.com>
 <fb013ae6-6f47-248b-db8b-a0abae530377@redhat.com>
 <ee87215d-9704-7269-4ec1-226f2e32a751@oracle.com>
 <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
 <20170925123508.pzjbe7wgwagnr5li@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170925123508.pzjbe7wgwagnr5li@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 09/25/2017 02:35 PM, Michal Hocko wrote:
> What would be the usecase. I mean why don't you simply create a new
> mapping by a plain mmap when you have no guarantee about the same
> content?

I plan to use it for creating an unbounded number of callback thunks at 
run time, from a single set of pages in libc.so, in case we need this 
functionality.

The idea is to duplicate existing position-independent machine code in 
libc.so, prefixed by a data mapping which controls its behavior.  Each 
data/code combination would only give us a fixed number of thunks, so 
we'd need to create a new mapping to increase the total number.

Instead, we could re-map the code from the executable in disk, but not 
if chroot has been called or glibc has been updated on disk.  Creating 
an alias mapping does not have these problems.

Another application (but that's for anonymous memory) would be to 
duplicate class metadata in a Java-style VM, so that you can use bits in 
the class pointer in each Java object (which is similar to the vtable 
pointer in C++) for the garbage collector, without having to mask it 
when accessing the class metadata in regular (mutator) code.

Thanks,
Florian
