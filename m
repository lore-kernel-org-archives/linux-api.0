From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 25/27] mm/mmap: Add Shadow stack pages to memory
 accounting
Date: Tue, 11 Jun 2019 12:22:48 -0700
Message-ID: <d3d027a903524729454efa235155e5db75216e66.camel@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
         <20190606200646.3951-26-yu-cheng.yu@intel.com>
         <1cfc7396-ca90-1933-34ad-b3d43ae52e08@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1cfc7396-ca90-1933-34ad-b3d43ae52e08@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2019-06-11 at 10:55 -0700, Dave Hansen wrote:
> On 6/6/19 1:06 PM, Yu-cheng Yu wrote:
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1703,6 +1703,9 @@ static inline int accountable_mapping(struct file
> > *file, vm_flags_t vm_flags)
> >  	if (file && is_file_hugepages(file))
> >  		return 0;
> >  
> > +	if (arch_copy_pte_mapping(vm_flags))
> > +		return 1;
> > +
> >  	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) ==
> > VM_WRITE;
> >  }
> >  
> > @@ -3319,6 +3322,8 @@ void vm_stat_account(struct mm_struct *mm, vm_flags_t
> > flags, long npages)
> >  		mm->stack_vm += npages;
> >  	else if (is_data_mapping(flags))
> >  		mm->data_vm += npages;
> > +	else if (arch_copy_pte_mapping(flags))
> > +		mm->data_vm += npages;
> >  }
> 
> This classifies shadow stack as data instead of stack.  That seems a wee
> bit counterintuitive.  Why did you make this choice?

I don't recall the reason; I will change it to stack and test it out.

Yu-cheng
