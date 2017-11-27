From: Mikael Pettersson <mikpelinux@gmail.com>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 20:36:55 +0100
Message-ID: <CAM43=SPgi9aXGFWYwpqeN26s5aUTdk7F6C+5wgrQOTq2QmvTzA@mail.gmail.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL> <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <87vahv8whv.fsf@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87vahv8whv.fsf@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Andi Kleen <ak@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 6:25 PM, Andi Kleen <ak@linux.intel.com> wrote:
> It's an arbitrary scaling limit on the how many mappings the process
> has. The more memory you have the bigger a problem it is. We've
> ran into this problem too on larger systems.
>
> The reason the limit was there originally because it allows a DoS
> attack against the kernel by filling all unswappable memory up with VMAs.
>
> The old limit was designed for much smaller systems than we have
> today.
>
> There needs to be some limit, but it should be on the number of memory
> pinned by the VMAs, and needs to scale with the available memory,
> so that large systems are not penalized.

Fully agreed.  One problem with the current limit is that number of VMAs
is only weakly related to the amount of memory one has mapped, and is
also prone to grow due to memory fragmentation.  I've seen processes
differ by 3X number of VMAs, even though they ran the same code and
had similar memory sizes; they only differed on how long they had been
running and which servers they ran on (and how long those had been up).

> Unfortunately just making it part of the existing mlock limit could
> break some existing setups which max out the mlock limit with something
> else. Maybe we need a new rlimit for this?
>
> -Andi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
