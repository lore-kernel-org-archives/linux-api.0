From: Mike Rapoprt <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 15:25:43 +0300
Message-ID: <D593CAD3-C8AB-479F-970C-AF67F00CEF3A@linux.vnet.ibm.com>
References: <a9e74c22-1a07-f49a-42b5-497fee85e9c9@suse.cz> <20170524075043.GB3063@rapoport-lnx> <c59a0893-d370-130b-5c33-d567a4621903@suse.cz> <20170524103947.GC3063@rapoport-lnx> <20170524111800.GD14733@dhcp22.suse.cz> <20170524142735.GF3063@rapoport-lnx> <20170530074408.GA7969@dhcp22.suse.cz> <20170530101921.GA25738@rapoport-lnx> <20170530103930.GB7969@dhcp22.suse.cz> <20170531090844.GA25375@rapoport-lnx> <20170531120533.GK27783@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170531120533.GK27783@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



On May 31, 2017 3:05:56 PM GMT+03:00, Michal Hocko <mhocko@kernel=2Eorg> w=
rote:
>On Wed 31-05-17 12:08:45, Mike Rapoport wrote:
>> On Tue, May 30, 2017 at 12:39:30PM +0200, Michal Hocko wrote:
>[=2E=2E=2E]
>> > Also do you expect somebody else would use new madvise? What would
>be the
>> > usecase?
>>=20
>> I can think of an application that wants to keep 4K pages to save
>physical
>> memory for certain phase, e=2Eg=2E until these pages are populated with
>very
>> few data=2E After the memory usage increases, the application may wish
>to
>> stop preventing khugepged from merging these pages, but it does not
>have
>> strong inclination to force use of huge pages=2E
>
>Well, is actually anybody going to do that?

Well, I don't=E2=80=8B know, it's pretty much future telling :)
For sure, without the new madvise nobody will be even able to do that=2E

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
