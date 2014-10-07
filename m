From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 10/17] mm: rmap preparation for
 remap_anon_pages
Date: Tue, 7 Oct 2014 15:37:10 +0200
Message-ID: <20141007133710.GA2342@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
 <20141007111026.GD30762@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141007111026.GD30762@node.dhcp.inet.fi>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>, Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>, Andrew Jones <drjones@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Michel Lespinasse <walken@google.com>, Taras Glek <tglek@mozilla.com>, Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>, Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, Android Kernel Team <kernel-team@android.com>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Andres Lagar-Cavilla <andres>
List-Id: linux-api@vger.kernel.org

Hi Kirill,

On Tue, Oct 07, 2014 at 02:10:26PM +0300, Kirill A. Shutemov wrote:
> On Fri, Oct 03, 2014 at 07:08:00PM +0200, Andrea Arcangeli wrote:
> > There's one constraint enforced to allow this simplification: the
> > source pages passed to remap_anon_pages must be mapped only in one
> > vma, but this is not a limitation when used to handle userland page
> > faults with MADV_USERFAULT. The source addresses passed to
> > remap_anon_pages should be set as VM_DONTCOPY with MADV_DONTFORK to
> > avoid any risk of the mapcount of the pages increasing, if fork runs
> > in parallel in another thread, before or while remap_anon_pages runs.
> 
> Have you considered triggering COW instead of adding limitation on
> pages' mapcount? The limitation looks artificial from interface POV.

I haven't considered it, mostly because I see it as a feature that it
returns -EBUSY. I prefer to avoid the risk of userland getting a
successful retval but internally the kernel silently behaving
non-zerocopy by mistake because some userland bug forgot to set
MADV_DONTFORK on the src_vma.

COW would be not zerocopy so it's not ok. We get sub 1msec latency for
userfaults through 10gbit and we don't want to risk wasting CPU
caches.

I however considered allowing to extend the strict behavior (i.e. the
feature) later in a backwards compatible way. We could provide a
non-zerocopy beahvior with a RAP_ALLOW_COW flag that would then turn
the -EBUSY error into a copy.

It's also more complex to implement the cow now, so it would make the
code that really matters, harder to review. So it may be preferable to
extend this later in a backwards compatible way with a new
RAP_ALLOW_COW flag.

The current handling the flags is already written in a way that should
allow backwards compatible extension with RAP_ALLOW_*:

#define RAP_ALLOW_SRC_HOLES (1UL<<0)

SYSCALL_DEFINE4(remap_anon_pages,
		unsigned long, dst_start, unsigned long, src_start,
		unsigned long, len, unsigned long, flags)
[..]
	long err = -EINVAL;
[..]
	if (flags & ~RAP_ALLOW_SRC_HOLES)
		return err;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
