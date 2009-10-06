From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Date: Tue,  6 Oct 2009 19:27:56 +0900 (JST)
Message-ID: <20091006192454.1272.A69D9226@jp.fujitsu.com>
References: <20091006190938.126F.A69D9226@jp.fujitsu.com> <20091006102136.GH9832@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20091006102136.GH9832@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Gleb Natapov <gleb@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> On Tue, Oct 06, 2009 at 07:11:06PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > If application does mlockall(MCL_FUTURE) it is no longer possible to
> > > mmap file bigger than main memory or allocate big area of anonymous
> > > memory. Sometimes it is desirable to lock everything related to program
> > > execution into memory, but still be able to mmap big file or allocate
> > > huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> > > allows to do that.
> > > 
> > > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > 
> > Why don't you use explicit munlock()?
> Because mmap will fail before I'll have a chance to run munlock on it.
> Actually when I run my process inside memory limited container host dies
> (I suppose trashing, but haven't checked).
> 
> > Plus, Can you please elabrate which workload nedd this feature?
> > 
> I wanted to run kvm with qemu process locked in memory, but guest memory
> unlocked. And guest memory is bigger then host memory in the case I am
> testing. I found out that it is impossible currently.

1. process creation (qemu)
2. load all library
3. mlockall(MCL_CURRENT)
4. load guest OS

is impossible? why?




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
