From: Mike Rapoprt <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: make PR_SET_THP_DISABLE immediately active
Date: Sat, 03 Jun 2017 13:40:20 +0300
Message-ID: <495443D6-654F-4751-8279-FBB96E3D90B3@linux.vnet.ibm.com>
References: <1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com> <20170602125059.66209870607085b84c257593@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170602125059.66209870607085b84c257593@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org



On June 2, 2017 10:50:59 PM GMT+03:00, Andrew Morton <akpm@linux-foundatio=
n=2Eorg> wrote:
>On Fri,  2 Jun 2017 18:03:22 +0300 "Mike Rapoport"
><rppt@linux=2Evnet=2Eibm=2Ecom> wrote:
>
>> PR_SET_THP_DISABLE has a rather subtle semantic=2E It doesn't affect
>any
>> existing mapping because it only updated mm->def_flags which is a
>template
>> for new mappings=2E The mappings created after
>prctl(PR_SET_THP_DISABLE) have
>> VM_NOHUGEPAGE flag set=2E  This can be quite surprising for all those
>> applications which do not do prctl(); fork() & exec() and want to
>control
>> their own THP behavior=2E
>>=20
>> Another usecase when the immediate semantic of the prctl might be
>useful is
>> a combination of pre- and post-copy migration of containers with
>CRIU=2E  In
>> this case CRIU populates a part of a memory region with data that was
>saved
>> during the pre-copy stage=2E Afterwards, the region is registered with
>> userfaultfd and CRIU expects to get page faults for the parts of the
>region
>> that were not yet populated=2E However, khugepaged collapses the pages
>and
>> the expected page faults do not occur=2E
>>=20
>> In more general case, the prctl(PR_SET_THP_DISABLE) could be used as
>a
>> temporary mechanism for enabling/disabling THP process wide=2E
>>=20
>> Implementation wise, a new MMF_DISABLE_THP flag is added=2E This flag
>is
>> tested when decision whether to use huge pages is taken either during
>page
>> fault of at the time of THP collapse=2E
>>=20
>> It should be noted, that the new implementation makes
>PR_SET_THP_DISABLE
>> master override to any per-VMA setting, which was not the case
>previously=2E
>>
>> Fixes: a0715cc22601 ("mm, thp: add VM_INIT_DEF_MASK and
>PRCTL_THP_DISABLE")
>
>"Fixes" is a bit strong=2E  I'd say "alters"=2E  And significantly alteri=
ng
>the runtime behaviour of a three-year-old interface is rather a worry,
>no?

Well, there are people that consider current behavior as bug :)
One can argue we alter the implementation=E2=80=8Bdetails and users should=
 not rely on that=2E=2E=2E

>Perhaps we should be adding new prctl modes to select this new
>behaviour and leave the existing PR_SET_THP_DISABLE behaviour as-is?



--=20
Sincerely yours,
Mike=2E

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
