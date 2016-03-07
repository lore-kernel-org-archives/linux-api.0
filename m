From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity (ADI)
Date: Mon, 7 Mar 2016 09:53:54 -0800
Message-ID: <CALCETrWPeFsyGsDNyehMpub1QrjZxyWpG_x_2A0yKqROXYfJ5A@mail.gmail.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
 <20160305.230702.1325379875282120281.davem@davemloft.net> <56DD9949.1000106@oracle.com>
 <56DD9E94.70201@oracle.com> <CALCETrXey2_xEXhzjgHtZmf-dLp-9pec===d-8chLxrp8wgRXg@mail.gmail.com>
 <56DDA6FD.4040404@oracle.com> <56DDBE68.6080709@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <56DDBE68.6080709@linux.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Rob Gardner <rob.gardner@oracle.com>, David Miller <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, dingel@linux.vnet.ibm.com, zhenzhang.zhang@huawei.com, bob.picco@oracle.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, chris.hyser@oracle.com, Richard Weinberger <richard@nod.at>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <koct9i@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, Andrew Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, bsegall@goo
List-Id: linux-api@vger.kernel.org

On Mon, Mar 7, 2016 at 9:46 AM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 03/07/2016 08:06 AM, Khalid Aziz wrote:
>> Top 4-bits of sparc64 virtual address are used for version tag only when
>> a process has its PSTATE.mcde bit set and it is accessing a memory
>> region that has ADI enabled on it (TTE.mcd set) and a version tag was
>> set on the virtual address being accessed. These 4-bits retain their
>> original semantics in all other cases.
>
> OK, so this effectively reduces the address space of a process using the
> feature.  Do we need to do anything explicit to keep an app from using
> that address space?  Do we make sure the kernel doesn't place VMAs
> there?  Do we respect mmap() hints that try to place memory there?

Also, what happens when someone does this to an aliased page?  This
could be a MAP_SHARED mapping or a not-yet-COWed MAP_ANONYMOUS
mapping.

Also, what am I missing?  Tying these tags to the physical page seems
like a poor design to me.  This seems really awkward to use.

-- 
Andy Lutomirski
AMA Capital Management, LLC
