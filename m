From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET v4 0/5] pagemap: make useable for non-privilege users
Date: Tue, 14 Jul 2015 23:15:41 +0300
Message-ID: <CALYGNiPidOy47E5ArW28ny4m+nTN5P8gAjYZtdC2_C1nV-yomQ@mail.gmail.com>
References: <20150714152516.29844.69929.stgit@buzz>
	<20150714115252.8f21cfa864935a4b403c3d8d@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714115252.8f21cfa864935a4b403c3d8d-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 9:52 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, 14 Jul 2015 18:37:34 +0300 Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
>
>> This patchset makes pagemap useable again in the safe way (after row hammer
>> bug it was made CAP_SYS_ADMIN-only). This patchset restores access for
>> non-privileged users but hides PFNs from them.
>
> Documentation/vm/pagemap.txt hasn't been updated to describe these
> privilege issues?

Will do. Too much time passed between versions, I planned but forgot about that.

>
>> Also it adds bit 'map-exlusive' which is set if page is mapped only here:
>> it helps in estimation of working set without exposing pfns and allows to
>> distinguish CoWed and non-CoWed private anonymous pages.
>>
>> Second patch removes page-shift bits and completes migration to the new
>> pagemap format: flags soft-dirty and mmap-exlusive are available only
>> in the new format.
>
> I'm not really seeing a description of the new format in these
> changelogs.  Precisely what got removed, what got added and which
> capabilities change the output in what manner?

Now pfn (bits 0-54) is zero if task who opened pagemap has no
CAP_SYS_ADMIN (system-wide).

in v2 format page-shift (bits 55-60) now used for flags:
55 - soft-dirty (added for checkpoint-restore, I guess)
56 - mmap-exclusive (added in last patch)
57-60 - free for use

I'll document the history of these changes.

>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
