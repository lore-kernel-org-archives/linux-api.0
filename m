From: Joe Perches <joe@perches.com>
Subject: Re: [RFC v2 1/9] printk: move code regarding log message storing
 format
Date: Mon, 12 Oct 2015 07:20:28 -0700
Message-ID: <1444659628.2258.6.camel@perches.com>
References: <1444642157-32618-1-git-send-email-p.osmialowsk@samsung.com>
	 <1444642157-32618-2-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444642157-32618-2-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon, 2015-10-12 at 11:29 +0200, Paul Osmialowski wrote:
> From: Marcin Niesluchowski <m.niesluchow@samsung.com>
> 
> Preparation commit for future changes purpose.
> 
> Moves some code responsible for storing log messages in proper format.

Perhaps better still would be to move the code into
a separate file to reduce the bulk and complexity
of printk.c
