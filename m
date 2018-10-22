From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/3] printk: Introduce per-console loglevel setting
Date: Mon, 22 Oct 2018 11:37:31 +0900
Message-ID: <20181022023731.GA508@jagdpanzerIV>
References: <08c1dc1a96afd6b6aecc5ff3c7c0e62c36670893.1506644730.git.calvinowens@fb.com>
 <20181019000403.GB877@jagdpanzerIV>
 <20181019220314.GA8164@Haydn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181019220314.GA8164@Haydn>
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
List-Id: linux-api@vger.kernel.org

On (10/19/18 22:03), Calvin Owens wrote:
> Hi Sergey,
> 
> It's in-progress, I'm sorry it hasn't happened sooner.

Great!

> By embedding the kobject in the console struct, we end up needing to refactor
> the console drivers to use the kobject refcount instead of simply calling
> kfree(), which is what I'm working on. It ends up being tedious but not
> particularly complicated, my goal is to have this up soon :)

OK :)

	-ss
