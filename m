From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 23:44:04 +0300
Message-ID: <CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
	<20150429193622.GA11892@node.dhcp.inet.fi>
	<CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, Mark Seaborn <mseaborn@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, Finn Grimwood <fgrimwood@undo-software.com>, Daniel James <djames@undo-software.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 11:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 29, 2015 at 12:36 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>>
>> Emm.. I have hard time to understand how writable bit is enough to get
>> soft-dirty-alike functionality.
>
> I don't think it is.
>
> For anonymous pages, maybe you can play tricks with comparing the page
> 'anon_vma' with the vma->anon_vma.
>
> I haven't really thought that through, but does something like
>
>    static inline bool page_is_dirty_in_vma(struct page *page, struct
> vm_area_struct *vma)
>    {
>         struct anon_vma *anon_vma = vma->anon_vma;
>
>         return page->mapping == (void *)anon_vma + PAGE_MAPPING_ANON;
>    }
>
> end up working as a "page has been dirtied in this mapping"?

This's no longer true. After recent fixes for "anon_vma endless growing" new vma
might reuse old anon_vma from grandparent vma.

>
> If the page came from another process and hasn't been written to, it
> will have the anon_vma pointing to the originalting vma.
>
> I may be high on some bad drugs, though. As mentioned, I didn't really
> think this through.
>
>                         Linus
