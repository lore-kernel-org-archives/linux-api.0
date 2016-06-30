From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/9] [v3] System Calls for Memory Protection Keys
Date: Thu, 30 Jun 2016 11:41:23 +0200
Message-ID: <20160630094123.GA29268@gmail.com>
References: <20160609000117.71AC7623@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160609000117.71AC7623@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, arnd@arndb.de, Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@techsingularity.net>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> Are there any concerns with merging these into the x86 tree so
> that they go upstream for 4.8?  The updates here are pretty
> minor.

>  include/linux/pkeys.h                         |   39 +-
>  include/uapi/asm-generic/mman-common.h        |    5 +
>  include/uapi/asm-generic/unistd.h             |   12 +-
>  mm/mprotect.c                                 |  134 +-

So I'd love to have some high level MM review & ack for these syscall ABI 
extensions.

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
