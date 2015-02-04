From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Wed, 4 Feb 2015 20:24:27 +0100
Message-ID: <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com>
References: <20150202165525.GM2395@suse.de> <54CFF8AC.6010102@intel.com>
 <54D08483.40209@suse.cz> <20150203105301.GC14259@node.dhcp.inet.fi>
 <54D0B43D.8000209@suse.cz> <54D0F56A.9050003@gmail.com> <54D22298.3040504@suse.cz>
 <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com> <54D2508A.9030804@suse.cz>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D2508A.9030804-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 4 February 2015 at 18:02, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
> On 02/04/2015 03:00 PM, Michael Kerrisk (man-pages) wrote:
>>
>> Hello Vlastimil,
>>
>> On 4 February 2015 at 14:46, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>>>>>
>>>>> - that covers mlocking ok, not sure if the rest fits the "shared =
pages"
>>>>> case
>>>>> though. I dont see any check for other kinds of shared pages in t=
he
>>>>> code.
>>>>
>>>>
>>>> Agreed. "shared" here seems confused. I've removed it. And I've
>>>> added mention of "Huge TLB pages" for this error.
>>>
>>>
>>> Thanks.
>>
>>
>> I also added those cases for MADV_REMOVE, BTW.
>
>
> Right. There's also the following for MADV_REMOVE that needs updating=
:
>
> "Currently, only shmfs/tmpfs supports this; other filesystems return =
with
> the error ENOSYS."
>
> - it's not just shmem/tmpfs anymore. It should be best to refer to
> fallocate(2) option FALLOC_FL_PUNCH_HOLE which seems to be (more) up =
to
> date.
>
> - AFAICS it doesn't return ENOSYS but EOPNOTSUPP. Also neither error =
code is
> listed in the ERRORS section.

Yup, I recently added that as well, based on a patch from Jan Chaloupka=
=2E

>>>>>>> - The word "will result" did sound as a guarantee at least to m=
e. So
>>>>>>> here it
>>>>>>> could be changed to "may result (unless the advice is ignored)"=
?
>>>>>>
>>>>>> It's too late to fix documentation. Applications already depends=
 on
>>>>>> the
>>>>>> beheviour.
>>>>>
>>>>> Right, so as long as they check for EINVAL, it should be safe. It
>>>>> appears
>>>>> that
>>>>> jemalloc does.
>>>>
>>>> So, first a brief question: in the cases where the call does not e=
rror
>>>> out,
>>>> are we agreed that in the current implementation, MADV_DONTNEED wi=
ll
>>>> always result in zero-filled pages when the region is faulted back=
 in
>>>> (when we consider pages that are not backed by a file)?
>>>
>>> I'd agree at this point.
>>
>> Thanks for the confirmation.
>>
>>> Also we should probably mention anonymously shared pages (shmem). I=
 think
>>> they behave the same as file here.
>>
>> You mean tmpfs here, right? (I don't keep all of the synonyms straig=
ht.)
>
> shmem is tmpfs (that by itself would fit under "files" just fine), bu=
t also
> sys V segments created by shmget(2) and also mappings created by mmap=
 with
> MAP_SHARED | MAP_ANONYMOUS. I'm not sure if there's a single manpage =
to
> refer to the full list.

So, how about this text:

              After a successful MADV_DONTNEED operation, the seman=E2=80=
=90
              tics  of  memory  access  in  the specified region are
              changed: subsequent accesses of  pages  in  the  range
              will  succeed,  but will result in either reloading of
              the memory contents from the  underlying  mapped  file
              (for  shared file mappings, shared anonymous mappings,
              and shmem-based techniques such  as  System  V  shared
              memory  segments)  or  zero-fill-on-demand  pages  for
              anonymous private mappings.

Thanks,

Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
