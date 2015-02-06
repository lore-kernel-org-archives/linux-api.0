From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: memcg && uaccess (Was: [PATCH 1/2] kernel/fork: handle put_user
	errors for CLONE_CHILD_SETTID/CLEARTID)
Date: Fri, 6 Feb 2015 21:32:46 +0100
Message-ID: <20150206203246.GA16924@redhat.com>
References: <20150206162301.18031.32251.stgit@buzz> <20150206194405.GA13960@redhat.com> <20150206195529.GA15517@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150206195529.GA15517-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add cc's.

On 02/06, Oleg Nesterov wrote:
>
> And in fact I think that this is not set_child_tid/etc-specific. Perhaps
> I am totally confused, but I think that put_user() simply should not fail
> this way. Say, why a syscall should return -EFAULT if memory allocation
> "silently" fails? Confused.

Seriously. I must have missed something, but I can't understand 519e52473eb
"mm: memcg: enable memcg OOM killer only for user faults".

The changelog says:

	System calls and kernel faults (uaccess, gup) can handle an out of
	memory situation gracefully and just return -ENOMEM.

How can a system call know it should return -ENOMEM if put_user() can only
return -EFAULT ?

Oleg.
