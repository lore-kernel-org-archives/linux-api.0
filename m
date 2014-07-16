From: Hugh Dickins <hughd@google.com>
Subject: Re: [RFC v3 6/7] shm: wait for pins to be released when sealing
Date: Wed, 16 Jul 2014 03:09:58 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1407160308550.1775@eggly.anvils>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <1402655819-14325-7-git-send-email-dh.herrmann@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1402655819-14325-7-git-send-email-dh.herrmann@gmail.com>
Sender: owner-linux-mm@kvack.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>, john.stultz@linaro.org, Lennart Poettering <lennart@poettering.net>, Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>, Hugh Dickins <hughd@google.com>, Tony Battersby <tonyb@cybernetics.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Fri, 13 Jun 2014, David Herrmann wrote:

> We currently fail setting SEAL_WRITE in case there're pending page
> references. This patch extends the pin-tests to wait up to 150ms for all
> references to be dropped. This is still not perfect in that it doesn't
> account for harmless read-only pins, but it's much better than a hard
> failure.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Right, I didn't look through the patch itself, just compared the result
with what I sent.  Okay, you prefer to separate out shmem_tag_pins().

Yes, it looks fine.  There's just one change I'd like at this stage,
something I realized shortly after sending the code fragment: please
add a call to lru_add_drain() at the head of shmem_tag_pins().  The
reason being that lru_add_drain() is local to the cpu, so cheap, and
in many cases will bring down all the raised refcounts right then.

Whereas lru_add_drain_all() in the first scan of shmem_wait_for_pins()
is much more expensive, involving inter-processor interrupts to do
that on all cpus: it is appropriate to call it at that point, but we
really ought to try the cheaper lru_add_drain() at the earlier stage.

I would also like never to embark on this scan of the radix_tree
and wait for pins, if the pages were never given out in a VM_SHARED
mapping - or is that unrealistic, because every memfd is read-write,
and typical initialization expected to be by mmap() rather than write()?
But anyway, you're quite right not to get into that at this stage:
it's best left as an optimization once the basics are safely in.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
