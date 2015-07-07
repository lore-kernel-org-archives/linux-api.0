From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH V3 0/5] Allow user to request memory to be locked on
 page fault
Date: Tue, 7 Jul 2015 14:16:13 -0700
Message-ID: <20150707141613.f945c98279dcb71c9743d5f2@linux-foundation.org>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436288623-13007-1-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue,  7 Jul 2015 13:03:38 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> mlock() allows a user to control page out of program memory, but this
> comes at the cost of faulting in the entire mapping when it is
> allocated.  For large mappings where the entire area is not necessary
> this is not ideal.  Instead of forcing all locked pages to be present
> when they are allocated, this set creates a middle ground.  Pages are
> marked to be placed on the unevictable LRU (locked) when they are first
> used, but they are not faulted in by the mlock call.
> 
> This series introduces a new mlock() system call that takes a flags
> argument along with the start address and size.  This flags argument
> gives the caller the ability to request memory be locked in the
> traditional way, or to be locked after the page is faulted in.  New
> calls are added for munlock() and munlockall() which give the called a
> way to specify which flags are supposed to be cleared.  A new MCL flag
> is added to mirror the lock on fault behavior from mlock() in
> mlockall().  Finally, a flag for mmap() is added that allows a user to
> specify that the covered are should not be paged out, but only after the
> memory has been used the first time.

Thanks for sticking with this.  Adding new syscalls is a bit of a
hassle but I do think we end up with a better interface - the existing
mlock/munlock/mlockall interfaces just aren't appropriate for these
things.

I don't know whether these syscalls should be documented via new
manpages, or if we should instead add them to the existing
mlock/munlock/mlockall manpages.  Michael, could you please advise?
