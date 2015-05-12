From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 0/3] pagemap: make useable for non-privilege users
Date: Tue, 12 May 2015 12:43:02 +0300
Message-ID: <20150512090156.24768.2521.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Williamson <mwilliamson@undo-software.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Vlastimil Babka <vbabka@suse.cz>, Pavel Machek <pavel@ucw.cz>, Mark Seaborn <mseaborn@chromium.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel James <djames@undo-software.com>, Finn Grimwood <fgrimwood@undo-software.com>
List-Id: linux-api@vger.kernel.org

This patchset tries to make pagemap useable again in the safe way.
First patch adds bit 'map-exlusive' which is set if page is mapped only here.
Second patch restores access for non-privileged users but hides pfn if task
has no capability CAP_SYS_ADMIN. Third patch removes page-shift bits and
completes migration to the new pagemap format (flags soft-dirty and
mmap-exlusive are available only in the new format).

---

Konstantin Khlebnikov (3):
      pagemap: add mmap-exclusive bit for marking pages mapped only here
      pagemap: hide physical addresses from non-privileged users
      pagemap: switch to the new format and do some cleanup


 Documentation/vm/pagemap.txt |    3 -
 fs/proc/task_mmu.c           |  178 +++++++++++++++++-------------------------
 tools/vm/page-types.c        |   35 ++++----
 3 files changed, 91 insertions(+), 125 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
