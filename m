From: Mark Williamson <mwilliamson@undo-software.com>
Subject: Re: [PATCH RFC 0/3] pagemap: make useable for non-privilege users
Date: Tue, 12 May 2015 12:13:30 +0100
Message-ID: <CAEVpBa+-wwf5Q3CwQAAad3V0pJ+uD50uaHKW=EnChLDLOLSAGg@mail.gmail.com>
References: <20150512090156.24768.2521.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150512090156.24768.2521.stgit@buzz>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Pavel Emelyanov <xemul@parallels.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Vlastimil Babka <vbabka@suse.cz>, Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel James <djames@undo-software.com>, Finn Grimwood <fgrimwood@undo-software.com>
List-Id: linux-api@vger.kernel.org

Hi Konstantin,

Thanks very much for continuing to look at this!  It's very much
appreciated.  I've been investigating from our end but got caught up
in some gnarly details of our pagemap-consuming code.

I like the approach and it seems like the information you're exposing
will be useful for our application.  I'll test the patch and see if it
works for us as-is.

Will follow up with any comments on the individual patches.

Thanks,
Mark

On Tue, May 12, 2015 at 10:43 AM, Konstantin Khlebnikov
<khlebnikov@yandex-team.ru> wrote:
> This patchset tries to make pagemap useable again in the safe way.
> First patch adds bit 'map-exlusive' which is set if page is mapped only here.
> Second patch restores access for non-privileged users but hides pfn if task
> has no capability CAP_SYS_ADMIN. Third patch removes page-shift bits and
> completes migration to the new pagemap format (flags soft-dirty and
> mmap-exlusive are available only in the new format).
>
> ---
>
> Konstantin Khlebnikov (3):
>       pagemap: add mmap-exclusive bit for marking pages mapped only here
>       pagemap: hide physical addresses from non-privileged users
>       pagemap: switch to the new format and do some cleanup
>
>
>  Documentation/vm/pagemap.txt |    3 -
>  fs/proc/task_mmu.c           |  178 +++++++++++++++++-------------------------
>  tools/vm/page-types.c        |   35 ++++----
>  3 files changed, 91 insertions(+), 125 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
