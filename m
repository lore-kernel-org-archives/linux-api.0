From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/8] Additional kmsg devices
Date: Sat, 27 Feb 2016 06:54:15 -0500
Message-ID: <20160227115415.GA3965@htj.duckdns.org>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
 <20160225214714.GJ6092@mtj.duckdns.org>
 <56D051A2.6050106@samsung.com>
 <20160226144718.GF3305@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160226144718.GF3305@pathway.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Kazimierz Krosman <k.krosman@samsung.com>, akpm@linux-foundation.org, peter@hurleysoftware.com, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, k.lewandowsk@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, Feb 26, 2016 at 03:47:18PM +0100, Petr Mladek wrote:
> > Could you explain in more detail what did you mean by IPC problems?
> 
> I guess that the idea was to make IPC more effective in general.
> You definitely could not move all functionality that needs IPC
> into the kernel.

1. There are multiple ways to do IPC and I don't think what was
   implemented as the comparison is optimal.

2. If that were optimal, we have an a lot larger general IPC problem
   than logging.  We can't possibly implement custom solution for each
   specific IPC use case in kernel.

Thanks.

-- 
tejun
