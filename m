From: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 09:15:30 +0100
Message-ID: <20191030081529.GB20624@rapoport-lnx>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <085ed07e-e646-f7a4-0370-06f33a2a4e4a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <085ed07e-e646-f7a4-0370-06f33a2a4e4a@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 29, 2019 at 12:02:34PM +0100, David Hildenbrand wrote:
> On 27.10.19 11:17, Mike Rapoport wrote:
> >From: Mike Rapoport <rppt@linux.ibm.com>
> >
> >The mappings created with MAP_EXCLUSIVE are visible only in the context of
> >the owning process and can be used by applications to store secret
> >information that will not be visible not only to other processes but to the
> >kernel as well.
> >
> >The pages in these mappings are removed from the kernel direct map and
> >marked with PG_user_exclusive flag. When the exclusive area is unmapped,
> >the pages are mapped back into the direct map.
> >
> 
> Just a thought, the kernel is still able to indirectly read the contents of
> these pages by doing a kdump from kexec environment, right?

Right.

> Also, I wonder
> what would happen if you map such pages via /dev/mem into another user space
> application and e.g., use them along with kvm [1].

Do you mean that one application creates MAP_EXCLUSIVE and another
applications accesses the same physical pages via /dev/mem? 

With /dev/mem all physical memory is visible...
 
> [1] https://lwn.net/Articles/778240/
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.
