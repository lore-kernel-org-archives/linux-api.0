From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity (ADI)
Date: Mon, 7 Mar 2016 13:02:14 -0800
Message-ID: <CALCETrVAkRXQVot0KfJxxCxYtakHAvPsmdqpojgBF_CV_6FFpA@mail.gmail.com>
References: <56DDDA31.9090105@oracle.com> <CALCETrXXU0fs2ezq+Wn_kr4dZTO=0RJmt6b=XBSA-wM7W_9j9A@mail.gmail.com>
 <56DDE783.8090009@oracle.com> <20160307.155810.587016604208120674.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20160307.155810.587016604208120674.davem@davemloft.net>
Sender: linux-arch-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, dingel@linux.vnet.ibm.com, bob.picco@oracle.com, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org, Rob Gardner <rob.gardner@oracle.com>, Michal Hocko <mhocko@suse.cz>, chris.hyser@oracle.com, Richard Weinberger <richard@nod.at>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <koct9i@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>, xiexiuqi@huawei.com, Vineet.Gupta1@synopsys.com, Andrew Lutomirski <luto@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Benjamin Segall <bsegall@google.com>, Geert Uytterhoeven <geert@linux-m68k.>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 7, 2016 at 12:58 PM, David Miller <davem@davemloft.net> wrote:
> From: Khalid Aziz <khalid.aziz@oracle.com>
> Date: Mon, 7 Mar 2016 13:41:39 -0700
>
>> Shared data may not always be backed by a file. My understanding is
>> one of the use cases is for in-memory databases. This shared space
>> could also be used to hand off transactions in flight to other
>> processes. These transactions in flight would not be backed by a
>> file. Some of these use cases might not use shmfs even. Setting ADI
>> bits at virtual address level catches all these cases since what backs
>> the tagged virtual address can be anything - a mapped file, mmio
>> space, just plain chunk of memory.
>
> Frankly the most interesting use case to me is simply finding bugs
> and memory scribbles, and for that we're want to be able to ADI
> arbitrary memory returned from malloc() and friends.
>
> I personally see ADI more as a debugging than a security feature,
> but that's just my view.

The thing that seems awkward to me is that setting, say, ADI=1 seems
almost equivalent to remapping the memory up to 0x10...whatever, and
the latter is a heck of a lot simpler to think about.

-- 
Andy Lutomirski
AMA Capital Management, LLC
