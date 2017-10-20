From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Fri, 20 Oct 2017 10:05:01 +0200
Message-ID: <20171020080501.GD29163@pathway.suse.cz>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <b6faa2e2-1480-c306-9c3f-9329d4c5b62d@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b6faa2e2-1480-c306-9c3f-9329d4c5b62d@fb.com>
Sender: linux-doc-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

On Thu 2017-10-19 16:40:45, Calvin Owens wrote:
> On 09/28/2017 05:43 PM, Calvin Owens wrote:
> >Not all consoles are created equal: depending on the actual hardware,
> >the latency of a printk() call can vary dramatically. The worst examples
> >are serial consoles, where it can spin for tens of milliseconds banging
> >the UART to emit a message, which can cause application-level problems
> >when the kernel spews onto the console.
> 
> Any thoughts on this series? Happy to resend again, but if there are no
> objections I'd love to see it merged sooner rather than later :)
> 
> Happy to resend too, just let me know.

There is no need to resend the patch. It is on my radar and I am
going to look at it.

Please, be patient, you hit conference, illness, after vacation
season. We do not want to unnecessarily delay it but it is
not a trivial change that might be accepted within minutes.

Best Regards,
Petr
