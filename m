From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 12/17] mm: sys_remap_anon_pages
Date: Sat, 04 Oct 2014 06:13:27 -0700
Message-ID: <87iok0q8p4.fsf@tassilo.jf.intel.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-13-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1412356087-16115-13-git-send-email-aarcange@redhat.com> (Andrea
	Arcangeli's message of "Fri, 3 Oct 2014 19:08:02 +0200")
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> This new syscall will move anon pages across vmas, atomically and
> without touching the vmas.
>
> It only works on non shared anonymous pages because those can be
> relocated without generating non linear anon_vmas in the rmap code.

...

> It is an alternative to mremap.

Why a new syscall? Couldn't mremap do this transparently?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
