From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH V3 5/5] selftests: vm: Add tests for lock on fault
Date: Tue, 7 Jul 2015 14:51:42 -0700
Message-ID: <20150707145142.ccc0b63eb48a5e5dd307accf@linux-foundation.org>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
	<1436288623-13007-6-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436288623-13007-6-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue,  7 Jul 2015 13:03:43 -0400 Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> Test the mmap() flag, and the mlockall() flag.  These tests ensure that
> pages are not faulted in until they are accessed, that the pages are
> unevictable once faulted in, and that VMA splitting and merging works
> with the new VM flag.  The second test ensures that mlock limits are
> respected.  Note that the limit test needs to be run a normal user.

So we don't have tests for the new syscalls?

I have renumbered those syscalls (added 1) because of sys_userfaultfd.
