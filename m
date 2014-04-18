From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
Date: Fri, 18 Apr 2014 09:33:32 -0700
Message-ID: <1397838812.19331.3.camel@buesod1.americas.hpqcorp.net>
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
	 <5350EFAA.2030607@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5350EFAA.2030607@colorfullife.com>
Sender: owner-linux-mm@kvack.org
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Greg Thelen <gthelen@google.com>, aswin@hp.com, LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2014-04-18 at 11:26 +0200, Manfred Spraul wrote:
> Hi Davidlohr,
> 
> On 04/18/2014 03:25 AM, Davidlohr Bueso wrote:
> > So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> > implies unlimited memory, as opposed to disabling sysv shared memory.
> That might be a second risk:
> Right now, a sysadmin can prevent sysv memory allocations with
> 
>      # sysctl kernel.shmall=0

Yeah, I had pointed this out previously, and it is addressed in the
changelog. shmall = 0 directly contradicts size < shmmin = 1, so I don't
know who's wrong there...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
