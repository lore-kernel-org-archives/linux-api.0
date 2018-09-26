From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [patch v3] mm, thp: always specify disabled vmas as nh in smaps
Date: Wed, 26 Sep 2018 08:12:47 +0200
Message-ID: <20180926061247.GB18685@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1809241054050.224429@chino.kir.corp.google.com>
 <e2f159f3-5373-dda4-5904-ed24d029de3c@suse.cz>
 <alpine.DEB.2.21.1809241215170.239142@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1809241227370.241621@chino.kir.corp.google.com>
 <20180924195603.GJ18685@dhcp22.suse.cz>
 <20180924200258.GK18685@dhcp22.suse.cz>
 <0aa3eb55-82c0-eba3-b12c-2ba22e052a8e@suse.cz>
 <alpine.DEB.2.21.1809251248450.50347@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1809251449060.96762@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1809251449060.96762@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 25-09-18 14:50:52, David Rientjes wrote:
[...]
Let's put my general disagreement with the approach asside for a while.
If this is really the best way forward the is the implementation really
correct?

> +	/*
> +	 * Disabling thp is possible through both MADV_NOHUGEPAGE and
> +	 * PR_SET_THP_DISABLE.  Both historically used VM_NOHUGEPAGE.  Since
> +	 * the introduction of MMF_DISABLE_THP, however, userspace needs the
> +	 * ability to detect vmas where thp is not eligible in the same manner.
> +	 */
> +	if (vma->vm_mm && test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)) {
> +		flags &= ~VM_HUGEPAGE;
> +		flags |= VM_NOHUGEPAGE;
> +	}

Do we want to report all vmas nh? Shouldn't we limit that to THP-able
mappings? It seems quite strange that an application started without
PR_SET_THP_DISABLE wouldn't report nh for most mappings while it would
otherwise. Also when can we have vma->vm_mm == NULL?

> +
>  	seq_puts(m, "VmFlags: ");
>  	for (i = 0; i < BITS_PER_LONG; i++) {
>  		if (!mnemonics[i][0])
>  			continue;
> -		if (vma->vm_flags & (1UL << i)) {
> +		if (flags & (1UL << i)) {
>  			seq_putc(m, mnemonics[i][0]);
>  			seq_putc(m, mnemonics[i][1]);
>  			seq_putc(m, ' ');

-- 
Michal Hocko
SUSE Labs
