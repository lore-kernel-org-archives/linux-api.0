From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Fri, 06 Feb 2015 16:57:50 +0100
Message-ID: <54D4E47E.4020509@gmail.com>
References: <20150202165525.GM2395@suse.de> <54CFF8AC.6010102@intel.com> <54D08483.40209@suse.cz> <20150203105301.GC14259@node.dhcp.inet.fi> <54D0B43D.8000209@suse.cz> <54D0F56A.9050003@gmail.com> <54D22298.3040504@suse.cz> <CAKgNAkgOOCuzJz9whoVfFjqhxM0zYsz94B1+oH58SthC5Ut9sg@mail.gmail.com> <54D2508A.9030804@suse.cz> <CAKgNAkhNbHQX7RukSsSe3bMqY11f493rYbDpTOA2jH7vsziNww@mail.gmail.com> <20150205154102.GA20607@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150205154102.GA20607@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@suse.cz>
Cc: mtk.manpages@gmail.com, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

Hi Michael

On 02/05/2015 04:41 PM, Michal Hocko wrote:
> On Wed 04-02-15 20:24:27, Michael Kerrisk wrote:
> [...]
>> So, how about this text:
>>
>>               After a successful MADV_DONTNEED operation, the seman=E2=
=80=90
>>               tics  of  memory  access  in  the specified region are
>>               changed: subsequent accesses of  pages  in  the  range
>>               will  succeed,  but will result in either reloading of
>>               the memory contents from the  underlying  mapped  file
>=20
> "
> result in either providing the up-to-date contents of the underlying
> mapped file
> "

Thanks! I did something like that. See below.

> Would be more precise IMO because reload might be interpreted as a majo=
r
> fault which is not necessarily the case (see below).
>=20
>>               (for  shared file mappings, shared anonymous mappings,
>>               and shmem-based techniques such  as  System  V  shared
>>               memory  segments)  or  zero-fill-on-demand  pages  for
>>               anonymous private mappings.
>=20
> Yes, this wording is better because many users are not aware of
> MAP_ANON|MAP_SHARED being file backed in fact and mmap man page doesn't
> mention that.

(Michal, would you have a text to propose to add to the mmap(2) page?
Maybe it would be useful to add something there.)

>=20
> I am just wondering whether it makes sense to mention that MADV_DONTNEE=
D
> for shared mappings might be surprising and not freeing the backing
> pages thus not really freeing memory until there is a memory
> pressure. But maybe this is too implementation specific for a man
> page. What about the following wording on top of yours?
> "
> Please note that the MADV_DONTNEED hint on shared mappings might not
> lead to immediate freeing of pages in the range. The kernel is free to
> delay this until an appropriate moment. RSS of the calling process will
> be reduced however.
> "

Thanks! I added this, but dropped in the word "immediately" in the last=20
sentence, since I assume that was implied. So now we have:

              After  a  successful MADV_DONTNEED operation, the seman=E2=80=
=90
              tics of  memory  access  in  the  specified  region  are
              changed:  subsequent accesses of pages in the range will
              succeed, but will result in either repopulating the mem=E2=80=
=90
              ory  contents from the up-to-date contents of the under=E2=80=
=90
              lying mapped file  (for  shared  file  mappings,  shared
              anonymous  mappings,  and shmem-based techniques such as
              System V shared memory segments) or  zero-fill-on-demand
              pages for anonymous private mappings.

              Note  that,  when applied to shared mappings, MADV_DONT=E2=80=
=90
              NEED might not lead to immediate freeing of the pages in
              the  range.   The  kernel  is  free to delay freeing the
              pages until an appropriate  moment.   The  resident  set
              size  (RSS)  of  the calling process will be immediately
              reduced however.

The current draft of the page can be found in a branch,
http://git.kernel.org/cgit/docs/man-pages/man-pages.git/log/?h=3Ddraft_ma=
dvise

Thanks,

Michael



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
