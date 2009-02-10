From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Tue, 10 Feb 2009 09:05:47 -0800
Message-ID: <1234285547.30155.6.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Tue, 2009-01-27 at 12:07 -0500, Oren Laadan wrote:
> Checkpoint-restart (c/r): a couple of fixes in preparation for 64bit
> architectures, and a couple of fixes for bugss (comments from Serge
> Hallyn, Sudakvev Bhattiprolu and Nathan Lynch). Updated and tested
> against v2.6.28.
> 
> Aiming for -mm.

Is there anything that we're waiting on before these can go into -mm?  I
think the discussion on the first few patches has died down to almost
nothing.  They're pretty reviewed-out.  Do they need a run in -mm?  I
don't think linux-next is quite appropriate since they're not _quite_
aimed at mainline yet.

-- Dave

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
