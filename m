From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Allocating sys_membarrier syscall number on other archs
Date: Wed, 26 Aug 2015 21:15:24 -0700
Message-ID: <20150826211524.c45393c7.akpm@linux-foundation.org>
References: <1721242013.30076.1440648282669.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1721242013.30076.1440648282669.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 27 Aug 2015 04:04:42 +0000 (UTC) Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:

> Hi Andrew,
> 
> The sys_membarrier patches you have in your tree target
> x86 32-64 and generic, but I did not allocate the system call
> number on other architectures to minimize the amount of
> collisions, and because I do not have all those architectures
> handy.
> 
> How would you recommend to proceed to allocate those ?
> 

I don't think you need to do anything.  You've provided the selftest
code for the arch maintainers and the arch maintainers will get
"membarrier not implemented" warnings each time they build a kernel. 
The idea is that when they have time they'll wire it up, run the tests
then ship it.

If you want to help that process along a bit you could send patches to
the arch maintainers along with instructions on how to test the
syscall.  The less work they have to do, the more likely they are
to do it ;)
