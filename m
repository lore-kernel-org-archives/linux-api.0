From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] arm: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 23:51:47 +0100
Message-ID: <20150827225147.GG21084@n2100.arm.linux.org.uk>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1440698215-8355-3-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440698215-8355-3-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 27, 2015 at 01:56:48PM -0400, Mathieu Desnoyers wrote:
> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>   apply this patch, build/run a membarrier-enabled kernel, and do make
>   kselftest. ]

But note: the system call is not guaranteed to be allocated at that number
until I've merged the patch.  I believe that there's other system calls
which are pending during the next merge window.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
