From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/23] userfaultfd: add new syscall to provide memory
 externalization
Date: Tue, 23 Jun 2015 23:41:41 +0200
Message-ID: <20150623214141.GB4312@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-11-git-send-email-aarcange@redhat.com>
 <5589ACC3.3060401@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5589ACC3.3060401-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Dave,

On Tue, Jun 23, 2015 at 12:00:19PM -0700, Dave Hansen wrote:
> Down in userfaultfd_wake_function(), it looks like you intended for a
> len=0 to mean "wake all".  But the validate_range() that we do from
> userspace has a !len check in it, which keeps us from passing a len=0 in
> from userspace.
> Was that "wake all" for some internal use, or is the check too strict?

It's for internal use or userfaultfd_release that has to wake them all
(after setting ctx->released) if the uffd is closed. It avoids to
enlarge the structure by depending on the invariant that userland
cannot pass len=0.

If we'd accept len=0 from userland as valid, I'd be safer if it does
nothing like in madvise, I doubt we want to expose this non standard
kernel internal behavior to userland.

> I was trying to use the wake ioctl after an madvise() (as opposed to
> filling things in using a userfd copy).

madvise will return 0 if len=0, mremap would return -EINVAL if new_len
is zero, mmap also returns -EINVAL if len is 0, not all MM syscalls
are as permissive as madvise. Can't you pass the same len you pass to
madvise to UFFDIO_WAKE (or just skip the call if the madvise len is
zero)?

Thanks,
Andrea
