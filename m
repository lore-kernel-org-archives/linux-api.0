From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 18/27] x86/cet/shstk: User-mode shadow stack
 support
Date: Wed, 03 Oct 2018 08:12:29 -0700
Message-ID: <c4d78905d1914fc1d15c919fabff6f83756e4ab4.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-19-yu-cheng.yu@intel.com>
         <20181003150754.GC32759@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003150754.GC32759@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Wed, 2018-10-03 at 17:08 +0200, Eugene Syromiatnikov wrote:
> On Fri, Sep 21, 2018 at 08:03:42AM -0700, Yu-cheng Yu wrote:
> 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 5ea1d64cb0b4..b20450dde5b7 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -652,6 +652,9 @@ static void show_smap_vma_flags(struct seq_file *m,
> > struct vm_area_struct *vma)
> >  		[ilog2(VM_PKEY_BIT4)]	= "",
> >  #endif
> >  #endif /* CONFIG_ARCH_HAS_PKEYS */
> > +#ifdef CONFIG_X86_INTEL_SHADOW_STACK_USER
> > +		[ilog2(VM_SHSTK)]	= "ss"
> > +#endif
> 
> It's probably makes sense to have this hunk as a part of "x86/cet/shstk:
> Add Kconfig option for user-mode shadow stack", where VM_SHSTK was
> initially introduced.

Yes, move it to "mm/Introduce VM_SHSTK for shadow stack memory".

Yu-cheng
