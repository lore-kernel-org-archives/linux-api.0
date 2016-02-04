From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT
Date: Thu, 4 Feb 2016 14:59:52 -0800
Message-ID: <20160204145952.53f536f5d4cdef96844104b7@linux-foundation.org>
References: <1454600344-23655-1-git-send-email-jbaron@akamai.com>
	<00ac7df620d4d0500b18af4a30034815@silodev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <00ac7df620d4d0500b18af4a30034815@silodev.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Madars Vitolins <m@silodev.com>
Cc: Jason Baron <jbaron@akamai.com>, torvalds@linux-foundation.org, mtk.manpages@gmail.com, mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, normalperson@yhbt.net, corbet@lwn.net, luto@amacapital.net, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 04 Feb 2016 23:44:05 +0200 Madars Vitolins <m@silodev.com> wrote:

> Hi Jason,
> 
> 
> Just run off the original tests with this patch (eventpoll.c from 
> 4.5-rc2 + patch bellow). Got the same good results, no regression.
> 
> $ time ./bankcl
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 1359856158.04 USD
> Account balance is: 101528948.40 USD
> 
> real	0m41.826s
> user	0m29.513s
> sys	0m6.490s
> 
> 
> Test case: 
> https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclusive-flag/
> 
> PS,
> 
> Original cases 0m24.953s vs 0m41.826s now probably is related with my pc 
> setup. As I just now re-run test with original patch, got the same ~41 
> sec.
> 
> So I am fine with this patch!
> 

Thanks, I shall add your Tested-by:

One thing we're sorely missing is an epoll test suite, in
tools/testing/selftests.  If anyone has anything which we can use to
kick things off, please hand it over ;)
