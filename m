From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and
 PR_GET_MAX_VADDR
Date: Fri, 17 Feb 2017 09:19:56 -0800
Message-ID: <ae15457f-731d-bb1b-c60d-14d641c265f0@intel.com>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com>
 <20170217141328.164563-34-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170217141328.164563-34-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/17/2017 06:13 AM, Kirill A. Shutemov wrote:
> +/*
> + * Default maximum virtual address. This is required for
> + * compatibility with applications that assumes 47-bit VA.
> + * The limit can be changed with prctl(PR_SET_MAX_VADDR).
> + */
> +#define MAX_VADDR_DEFAULT	((1UL << 47) - PAGE_SIZE)

This is a bit goofy.  It's not the largest virtual adddress that can be
accessed, but the beginning of the last page.

Isn't this easier to deal with in userspace if we make it a "limit", so
we can do:

	if (addr >= limit)
		// error

Now, we have to do:
	
	prctl(PR_GET_MAX_VADDR, &max_vaddr, 0, 0, 0);
	if (addr > (max_vaddr + PAGE_SIZE))
		// error

I don't care what you track in the kernel, but I think we need to
provide a more usable number out to userspace.
