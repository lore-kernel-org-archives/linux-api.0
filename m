From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH] mm: extend memfd with ability to create "secret"
 memory areas
Date: Wed, 12 Feb 2020 14:10:29 -0700
Message-ID: <20200212141029.7b89acee@lwn.net>
References: <20200130162340.GA14232@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200130162340.GA14232@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Christopher Lameter <cl@linux.com>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@tycho.ws>, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Thu, 30 Jan 2020 18:23:41 +0200
Mike Rapoport <rppt@kernel.org> wrote:

> Hi,
> 
> This is essentially a resend of my attempt to implement "secret" mappings
> using a file descriptor [1]. 

So one little thing I was curious about as I read through the patch...

> +static int secretmem_check_limits(struct vm_fault *vmf)
> +{
> +	struct secretmem_state *state = vmf->vma->vm_file->private_data;
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	unsigned long limit;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return -EINVAL;
> +
> +	limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +	if (state->nr_pages + 1 >= limit)
> +		return -EPERM;
> +
> +	return 0;
> +}

If I'm not mistaken, this means each memfd can be RLIMIT_MEMLOCK in length,
with no global limit on the number of locked pages.  What's keeping me from
creating 1000 of these things and locking down lots of RAM?

Thanks,

jon
