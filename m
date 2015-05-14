From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] pagemap: make useable for non-privilege users
Date: Thu, 14 May 2015 19:40:30 +0100
Message-ID: <CAEVpBaLPDa8tacKKeHmcLMdmYZ86aZBfGqCnAcQ8R=JKSUoagQ@mail.gmail.com>
References: <20150512090156.24768.2521.stgit@buzz>
	<CAEVpBa+-wwf5Q3CwQAAad3V0pJ+uD50uaHKW=EnChLDLOLSAGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEVpBa+-wwf5Q3CwQAAad3V0pJ+uD50uaHKW=EnChLDLOLSAGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Konstantin,

I modified our code to check for the map-exclusive flag where it used
to compare pageframe numbers.  First tests look pretty promising, so
this patch looks like a viable approach for us.

Is there anything further we can do to help?

Thanks,
Mark

On Tue, May 12, 2015 at 12:13 PM, Mark Williamson
<mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org> wrote:
> Hi Konstantin,
>
> Thanks very much for continuing to look at this!  It's very much
> appreciated.  I've been investigating from our end but got caught up
> in some gnarly details of our pagemap-consuming code.
>
> I like the approach and it seems like the information you're exposing
> will be useful for our application.  I'll test the patch and see if it
> works for us as-is.
>
> Will follow up with any comments on the individual patches.
>
> Thanks,
> Mark
>
> On Tue, May 12, 2015 at 10:43 AM, Konstantin Khlebnikov
> <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
>> This patchset tries to make pagemap useable again in the safe way.
>> First patch adds bit 'map-exlusive' which is set if page is mapped only here.
>> Second patch restores access for non-privileged users but hides pfn if task
>> has no capability CAP_SYS_ADMIN. Third patch removes page-shift bits and
>> completes migration to the new pagemap format (flags soft-dirty and
>> mmap-exlusive are available only in the new format).
>>
>> ---
>>
>> Konstantin Khlebnikov (3):
>>       pagemap: add mmap-exclusive bit for marking pages mapped only here
>>       pagemap: hide physical addresses from non-privileged users
>>       pagemap: switch to the new format and do some cleanup
>>
>>
>>  Documentation/vm/pagemap.txt |    3 -
>>  fs/proc/task_mmu.c           |  178 +++++++++++++++++-------------------------
>>  tools/vm/page-types.c        |   35 ++++----
>>  3 files changed, 91 insertions(+), 125 deletions(-)
