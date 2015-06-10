From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RESEND PATCH V2 0/3] Allow user to request memory to be locked
 on page fault
Date: Wed, 10 Jun 2015 14:59:29 -0700
Message-ID: <20150610145929.b22be8647887ea7091b09ae1@linux-foundation.org>
References: <1433942810-7852-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433942810-7852-1-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 10 Jun 2015 09:26:47 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> mlock() allows a user to control page out of program memory, but this
> comes at the cost of faulting in the entire mapping when it is

s/mapping/locked area/

> allocated.  For large mappings where the entire area is not necessary
> this is not ideal.
> 
> This series introduces new flags for mmap() and mlockall() that allow a
> user to specify that the covered are should not be paged out, but only
> after the memory has been used the first time.

The comparison with MCL_FUTURE is hiding over in the 2/3 changelog. 
It's important so let's copy it here.

: MCL_ONFAULT is preferrable to MCL_FUTURE for the use cases enumerated
: in the previous patch becuase MCL_FUTURE will behave as if each mapping
: was made with MAP_LOCKED, causing the entire mapping to be faulted in
: when new space is allocated or mapped.  MCL_ONFAULT allows the user to
: delay the fault in cost of any given page until it is actually needed,
: but then guarantees that that page will always be resident.

I *think* it all looks OK.  I'd like someone else to go over it also if
poss.


I guess the 2/3 changelog should have something like

: munlockall() will clear MCL_ONFAULT on all vma's in the process's VM.

It's pretty obvious, but the manpage delta should make this clear also.


Also the changelog(s) and manpage delta should explain that munlock()
clears MCL_ONFAULT.

And now I'm wondering what happens if userspace does
mmap(MAP_LOCKONFAULT) and later does munlock() on just part of that
region.  Does the vma get split?  Is this tested?  Should also be in
the changelogs and manpage.

Ditto mlockall(MCL_ONFAULT) followed by munlock().  I'm not sure that
even makes sense but the behaviour should be understood and tested.


What's missing here is a syscall to set VM_LOCKONFAULT on an arbitrary
range of memory - mlock() for lock-on-fault.  It's a shame that mlock()
didn't take a `mode' argument.  Perhaps we should add such a syscall -
that would make the mmap flag unneeded but I suppose it should be kept
for symmetry.
