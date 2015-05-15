From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/23] userfaultfd: add new syscall to provide memory externalization
Date: Fri, 15 May 2015 11:22:09 -0700
Message-ID: <CA+55aFyPY9PtGLaK=TxBX_bU44MBCe53yLXDFzU43zJqbwzQ6Q@mail.gmail.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
	<1431624680-20153-11-git-send-email-aarcange@redhat.com>
	<CA+55aFwCODeiXUPDR7-Y-=2xE2abmVuCnmVV=ezFqhO+JkaW=A@mail.gmail.com>
	<20150515160426.GD19097@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150515160426.GD19097@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 9:04 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> To fix it I added this along a comment:

Ok, this looks good as a explanation/fix for the races (and also as an
example of my worry about waitqueue_active() use in general).

However, it now makes me suspect that the optimistic "let's check if
they are even active" may not be worth it any more. You're adding a
"smp_mb()" in order to avoid taking the real lock. Although I guess
there are two locks there (one for each wait-queue) so maybe it's
worth it.

                    Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
