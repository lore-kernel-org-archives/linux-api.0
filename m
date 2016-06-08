From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/9] [v2] System Calls for Memory Protection Keys
Date: Wed, 8 Jun 2016 11:23:48 +0200
Message-ID: <6eaf31c0-0c94-6248-2ace-79e7c923a569@gmail.com>
References: <20160607204712.594DE00A@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160607204712.594DE00A@viggo.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
Cc: mtk.manpages@gmail.com, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On 06/07/2016 10:47 PM, Dave Hansen wrote:
> Are there any concerns with merging these into the x86 tree so
> that they go upstream for 4.8?  

I believe we still don't have up-to-date man pages, right?
Best from my POV to send them out in parallel with the 
implementation.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
