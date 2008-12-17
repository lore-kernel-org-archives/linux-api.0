From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
	restart
Date: Tue, 16 Dec 2008 16:13:03 -0800
Message-ID: <1229472783.17206.358.camel@nimitz>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
	 <49482394.10006@google.com> <1229465641.17206.350.camel@nimitz>
	 <49482F14.1040407@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <49482F14.1040407@google.com>
Sender: owner-linux-mm@kvack.org
To: Mike Waychison <mikew@google.com>
Cc: jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Linux Torvalds <torvalds@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Tue, 2008-12-16 at 14:43 -0800, Mike Waychison wrote:
> Hmm, if I'm understanding you correctly, adding ref counts explicitly 
> (like you suggest below)  would be used to let a lower layer defer 
> writes.  Seems like this could be just as easily done with explicits 
> kmallocs and transferring ownership of the allocated memory to the 
> in-kernel representation handling layer below (which in turn queues the 
> data structures for writes).

Yup, that's true.  We'd effectively shift the burden of freeing those
buffers into the cr_write() (or whatever we call it) function.  

But, I'm just thinking about the sys_checkpoint() side.  I need to go
look at the restart code too.

-- Dave

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
