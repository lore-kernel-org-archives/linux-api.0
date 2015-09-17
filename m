From: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 9/9] s390/s390x: allocate sys_membarrier system
 call number
Date: Thu, 17 Sep 2015 13:39:30 +0200
Message-ID: <20150917133930.06c3b26b@mschwide>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1441642556-30972-10-git-send-email-mathieu.desnoyers@efficios.com>
	<1822824828.9340.1442416805361.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1822824828.9340.1442416805361.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: heiko carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 16 Sep 2015 15:20:05 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:

> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
> 
> > [ Untested on this architecture. To try it out: fetch linux-next/akpm,
> >  apply this patch, build/run a membarrier-enabled kernel, and do make
> >  kselftest. ]
> 
> Hi,
> 
> sys_membarrier has been merged into Linux 4.3-rc1. It can therefore
> be tested on top of Linus' master by applying this patch.

Successfully tested with todays Linus' master, membarrier_test has passed.
Patch applied to linux-s390 but with a different system call number.
#355 is already taken by sys_userfaultfd, the new one for membarrier is #356.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
