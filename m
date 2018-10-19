From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Fri, 19 Oct 2018 09:04:03 +0900
Message-ID: <20181019000403.GB877@jagdpanzerIV>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On (09/28/17 17:43), Calvin Owens wrote:
> Not all consoles are created equal: depending on the actual hardware,
> the latency of a printk() call can vary dramatically. The worst examples
> are serial consoles, where it can spin for tens of milliseconds banging
> the UART to emit a message, which can cause application-level problems
> when the kernel spews onto the console.
> 
> At Facebook we use netconsole to monitor our fleet, but we still have
> serial consoles attached on each host for live debugging, and the latter
> has caused problems. An obvious solution is to disable the kernel
> console output to ttyS0, but this makes live debugging frustrating,
> since crashes become silent and opaque to the ttyS0 user. Enabling it on
> the fly when needed isn't feasible, since boxes you need to debug via
> serial are likely to be borked in ways that make this impossible.
> 
> That puts us between a rock and a hard place: we'd love to set
> kernel.printk to KERN_INFO and get all the logs. But while netconsole is
> fast enough to permit that without perturbing userspace, ttyS0 is not,
> and we're forced to limit console logging to KERN_WARNING and higher.
> 
> This patch introduces a new per-console loglevel setting, and changes
> console_unlock() to use max(global_level, per_console_level) when
> deciding whether or not to emit a given log message.
> 
> This lets us have our cake and eat it too: instead of being forced to
> limit all consoles verbosity based on the speed of the slowest one, we
> can "promote" the faster console while still using a conservative system
> loglevel setting to avoid disturbing applications.

Hi Calvin,

Do you have time to address the review feedback and re-spin v2?

	-ss
