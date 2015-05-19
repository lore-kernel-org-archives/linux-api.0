From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 00/23] userfaultfd v4
Date: Tue, 19 May 2015 23:59:42 +0200
Message-ID: <CAFLxGvwGGZH1bbMw+qReZFMK+dc6zoOTCNsuOMdp+xw_jPzPDg@mail.gmail.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
	<20150519143801.8ba477c3813e93a2637c19cf@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150519143801.8ba477c3813e93a2637c19cf@linux-foundation.org>
Sender: kvm-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, qemu-devel@nongnu.org, kvm <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 19, 2015 at 11:38 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 14 May 2015 19:30:57 +0200 Andrea Arcangeli <aarcange@redhat.com> wrote:
>
>> This is the latest userfaultfd patchset against mm-v4.1-rc3
>> 2015-05-14-10:04.
>
> It would be useful to have some userfaultfd testcases in
> tools/testing/selftests/.  Partly as an aid to arch maintainers when
> enabling this.  And also as a standalone thing to give people a
> practical way of exercising this interface.
>
> What are your thoughts on enabling userfaultfd for other architectures,
> btw?  Are there good use cases, are people working on it, etc?

UML is using SIGSEGV for page faults.
i.e. the UML processes receives a SIGSEGV, learns the faulting address
from the mcontext
and resolves the fault by installing a new mapping.

If userfaultfd is faster that the SIGSEGV notification it could speed
up UML a bit.
For UML I'm only interested in the notification, not the resolving
part. The "missing"
data is present, only a new mapping is needed. No copy of data.

Andrea, what do you think?

-- 
Thanks,
//richard
