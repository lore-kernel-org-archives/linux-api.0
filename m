From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 09:57:11 -0700
Message-ID: <CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw@mail.gmail.com>
References: <20150114095019.GC4706@dhcp22.suse.cz>
	<1430223111-14817-1-git-send-email-mhocko@suse.cz>
	<CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
	<20150428164302.GI2659@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150428164302.GI2659@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, Cyril Hrubis <chrubis@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 28, 2015 at 9:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> Hmm, no other thread has the address from the current mmap call except
> for MAP_FIXED (more on that below).

With things like opportunistic SIGSEGV handlers that map/unmap things
as the user takes faults, that's actually not at all guaranteed.

Yeah, it's unusual, but I've seen it, with threaded applications where
people play games with user-space memory management, and do "demand
allocation" with mmap() in response to signals.

Admittedly we already do bad things in mmap(MAP_FIXED) for that case,
since we dropped the vm lock. But at least it shouldn't be any worse
than a thread speculatively touching the pages..

                      Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
