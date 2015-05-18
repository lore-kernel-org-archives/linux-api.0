From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 0/2] man-pages: clarify MAP_LOCKED semantic
Date: Mon, 18 May 2015 11:12:15 +0200
Message-ID: <20150518091214.GB6393@dhcp22.suse.cz>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Wed 13-05-15 16:38:10, Michal Hocko wrote:
> Hi,
> during the previous discussion http://marc.info/?l=linux-mm&m=143022313618001&w=2
> it was made clear that making mmap(MAP_LOCKED) semantic really have
> mlock() semantic is too dangerous. Even though we can try to reduce the
> failure space the mmap man page should make it really clear about the
> subtle distinctions between the two. This is what that first patch does.
> The second patch is a small clarification for MAP_POPULATE based on
> David Rientjes feedback.

I have completely forgot about the in kernel doc.
---
>From 9d1478ccd036f84e50da906e39cd1e7bcb94cecd Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 18 May 2015 11:07:00 +0200
Subject: [PATCH] Documentation/vm/unevictable-lru.txt: clarify MAP_LOCKED
 behavior

There is a very subtle difference between mmap()+mlock() vs
mmap(MAP_LOCKED) semantic. The former one fails if the population of the
area fails while the later one doesn't. This basically means that
mmap(MAPLOCKED) areas might see major fault after mmap syscall returns
which is not the case for mlock. mmap man page has already been altered
but Documentation/vm/unevictable-lru.txt deserves a clarification as
well.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/vm/unevictable-lru.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index 3be0bfc4738d..32ee3a67dba2 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -467,7 +467,13 @@ mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 
 In addition the mlock()/mlockall() system calls, an application can request
 that a region of memory be mlocked supplying the MAP_LOCKED flag to the mmap()
-call.  Furthermore, any mmap() call or brk() call that expands the heap by a
+call. There is one important and subtle difference here, though. mmap() + mlock()
+will fail if the range cannot be faulted in (e.g. because mm_populate fails)
+and returns with ENOMEM while mmap(MAP_LOCKED) will not fail. The mmaped
+area will still have properties of the locked area - aka. pages will not get
+swapped out - but major page faults to fault memory in might still happen.
+
+Furthermore, any mmap() call or brk() call that expands the heap by a
 task that has previously called mlockall() with the MCL_FUTURE flag will result
 in the newly mapped memory being mlocked.  Before the unevictable/mlock
 changes, the kernel simply called make_pages_present() to allocate pages and
-- 
2.1.4


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
