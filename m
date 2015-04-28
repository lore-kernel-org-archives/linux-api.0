From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 18:43:03 +0200
Message-ID: <20150428164302.GI2659@dhcp22.suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
 <1430223111-14817-1-git-send-email-mhocko@suse.cz>
 <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, Cyril Hrubis <chrubis@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-04-15 09:01:59, Linus Torvalds wrote:
[...]
> Your code is also fundamentally buggy in that it tries to do unmap()
> after it has dropped all locks, and things went wrong. So you may nto
> be unmapping some other threads data.

Hmm, no other thread has the address from the current mmap call except
for MAP_FIXED (more on that below).

Well I can imagine userspace doing nasty things like watching
/proc/self/maps and using the address from there or using an address as
an mmap hint and then using it before mmap returns by other threads. But
would those be valid usecases? They sound crazy and buggy to me.

Another nasty case would be MAP_FIXED from a different thread destroying
the mmap I am trying to poppulate but that is not so interesting because
nothing protects from that even now.
Or this being MAP_FIXED|MAP_LOCKED which has already destroyed a part
of somebody's else mapping and the cleanup would lead to an unexpected
SIGSEGV for the other thread. Is this the case you are worried about?

Or am I missing other cases?
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
