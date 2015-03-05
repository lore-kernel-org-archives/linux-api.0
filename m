From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Thu, 5 Mar 2015 10:15:17 +0100
Message-ID: <20150305091517.GA25158@gmail.com>
References: <cover.1424805740.git.jbaron@akamai.com>
 <20150225073814.GA14558@gmail.com>
 <54EDF7D8.60201@akamai.com>
 <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
 <54F0E93C.3010306@akamai.com>
 <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org>
 <20150305000225.GA27592@gmail.com>
 <54F7D343.5090106@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54F7D343.5090106@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org


* Jason Baron <jbaron@akamai.com> wrote:

> 2) We are using the wakeup in this case to 'assign' work more 
> permanently to the thread. That is, in the case of a listen socket 
> we then add the connected socket to the woken up threads local set 
> of epoll events. So the load persists past the wake up. And in this 
> case, doing the round robin wakeups, simply allows us to access more 
> cpu bandwidth. (I'm also looking into potentially using cpu affinity 
> to do the wakeups as well as you suggested.)

So this is the part that I still don't understand.

What difference does LIFO versus FIFO wakeups make to CPU utilization: 
a thread waiting for work is idle, no matter whether it ran most 
recently or least recently.

Once an idle worker thread is woken it will compute its own work, for 
whatever time it needs to, and won't be bothered by epoll again until 
it finished its work and starts waiting again.

So regardless the wakeup order it's the same principal bandwidth 
utilization, modulo caching artifacts [*] and modulo scheduling 
artifacts [**]:

[*]  Caching artifacts: in that sense Andrew's point stands: given 
     multiple equivalent choices it's more beneficial to pick a thread 
     that was most recently used (and is thus most cache-hot - i.e. 
     the current wakeup behavior), versus a thread that was least 
     recently used (and is thus the most cache-cold - i.e. the 
     round-robin wakeup you introduce).

[**] The hack patch I posted in my previous reply.

Thanks,

	Ingo
