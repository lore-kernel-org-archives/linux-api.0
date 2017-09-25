From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [patch v2] mremap.2: Add description of old_size == 0 functionality
Date: Mon, 25 Sep 2017 14:40:59 +0200
Message-ID: <CAKgNAkhEc2S2XhT10OtMXBwu08ggB9XkRrYmm27JSaW6yZEYrw@mail.gmail.com>
References: <a5d279cb-a015-f74c-2e40-a231aa7f7a8c@redhat.com>
 <20170919214224.19561-1-mike.kravetz@oracle.com> <6fafdae8-4fea-c967-f5cd-d22c205608fa@gmail.com>
 <20170925123621.35godwzhvw4wbisc@dhcp22.suse.cz>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170925123621.35godwzhvw4wbisc@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-man <linux-man@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On 25 September 2017 at 14:36, Michal Hocko <mhocko@kernel.org> wrote:
> On Wed 20-09-17 09:25:42, Michael Kerrisk wrote:
> [...]
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
> sorry to be late but yes this wording makes perfect sense to me.

Thanks, Michal.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
