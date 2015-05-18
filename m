From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 00/23] userfaultfd v4
Date: Mon, 18 May 2015 17:24:26 +0300
Message-ID: <5559F61A.2020206@parallels.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org

On 05/14/2015 08:30 PM, Andrea Arcangeli wrote:
> Hello everyone,
> 
> This is the latest userfaultfd patchset against mm-v4.1-rc3
> 2015-05-14-10:04.
> 
> The postcopy live migration feature on the qemu side is mostly ready
> to be merged and it entirely depends on the userfaultfd syscall to be
> merged as well. So it'd be great if this patchset could be reviewed
> for merging in -mm.
> 
> Userfaults allow to implement on demand paging from userland and more
> generally they allow userland to more efficiently take control of the
> behavior of page faults than what was available before
> (PROT_NONE + SIGSEGV trap).

Not to spam with 23 e-mails, all patches are

Acked-by: Pavel Emelyanov <xemul@parallels.com>

Thanks!

-- Pavel

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
