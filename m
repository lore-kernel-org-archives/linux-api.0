From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v42] proc: add /proc/*/stack (was Re: linux-next: proc
	tree build failure)
Date: Mon, 10 Nov 2008 09:49:00 +0100
Message-ID: <20081110084900.GF22392@elte.hu>
References: <20081110162941.e9e9ef3a.sfr@canb.auug.org.au> <20081110055311.GA3138@x200.localdomain> <20081110073623.GA475@elte.hu> <20081110084229.GA8690@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081110084229.GA8690@x200.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > Alexey, would you like to carry them for v2.6.29? They are in a 
> > separate tree here, the pull coordinates are below.
> > 
> > Please preserve the sha1's (do not rebase/cherry-pick, etc.) so 
> > that i can carry it too without causing confusion.
> 
> Sorry, I can't.

hm, git pull did not work?

> It's two commits, PROC_BLOCK_SIZE moving chunk is now unneeded, 
> because seqfiles are in use, grabbing tasklist_lock for protection 
> from task dissapearing is unneeded -- proc_single_show() pins 
> task_struct, entry is added only to tgid table.

hm, but these are small differences that do not impact bisectability, 
you could have done it ontop of what we have, instead of a rebase? Oh 
well.

> So, here is final version:

thanks!

I've rebased tip/core/stacktrace and zapped the history of the old 
commits from that branch. Would have been really nice to preserve the 
sha1 space and not force a rebase, like Linus is requesting it so 
frequently.

Had you done a git pull from me i could have carried this feature too 
without creating conflicts, instead of it disappearing in your tree 
for months and being hidden up until v2.6.29. This whole 'distributed 
development' stuff that's all the rage ;-)

i also regenerated tip-core, so it should now be conflict-free in 
Stephen's tree too. (Stephen, please holler if you still get 
conflicts)

	Ingo
