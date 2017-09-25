From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v2] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 21:26:42 +0200
Message-ID: <CAKgNAkhJEyK=LhFj9W-RgSv+ET64d+MaEAQ41y5eximfQmYPDw@mail.gmail.com>
References: <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
 <20170919214224.19561-1-mike.kravetz@oracle.com> <6fafdae8-4fea-c967-f5cd-d22c205608fa@gmail.com>
 <83b023da-e9f5-2957-981e-5b0e71e9bf1b@oracle.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <83b023da-e9f5-2957-981e-5b0e71e9bf1b-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Mike,

On 25 September 2017 at 18:33, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/20/2017 12:25 AM, Michael Kerrisk (man-pages) wrote:

[...]

>> I've applied this, and added Reviewed-by tags for Florian and Jann.
>> But, I think it's also worth noting the older, now disallowed, behavior,
>> and why the behavior was changed. So I added a note in BUGS:
>>
>>     BUGS
>>        Before Linux 4.14, if old_size was zero and the  mapping  referred
>>        to  by  old_address  was  a private mapping (mmap(2) MAP_PRIVATE),
>>        mremap() created a new private mapping unrelated to  the  original
>>        mapping.   This behavior was unintended and probably unexpected in
>>        user-space applications (since the intention  of  mremap()  is  to
>>        create  a new mapping based on the original mapping).  Since Linux
>>        4.14, mremap() fails with the error EINVAL in this scenario.
>>
>> Does that seem okay?
>
> Sorry for the late reply Michael,  I've been away for a few days.
>
> Yes, the above seems okay.  Thanks for your help with this.

You're welcome. Thanks for checking it over!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
