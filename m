From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [PATCH 96/98] HACK include/uapi/linux/coda_psdev.h: fix
 compilation in userspace
Date: Sun, 31 May 2015 07:19:13 -0400
Message-ID: <20150531111913.GA23377@cs.cmu.edu>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-97-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-97-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:39:28PM +0200, Mikko Rapeli wrote:
> Include linux/coda.h for caddr_t and use unsigned short type directly.
> Userspace headers do not have list_head and wait_queue_head_t so just
> ifdef them away which is a HACK. Any ideas how to fix this properly?

I grepped the Coda userspace sources and it doesn't look like this
particular struct is used there anyway, it is only used by the kernel
module to track which requests are waiting to be read by the Coda
userspace application and after that which requests are waiting for a
response.

I guess a proper fix would be to move this struct to a non-uapi header,
or maybe even to the (probably) only C file in the kernel where it is
used.

Jan
