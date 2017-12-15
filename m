From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 0/2] mm: introduce MAP_FIXED_SAFE
Date: Fri, 15 Dec 2017 20:02:04 +1100
Message-ID: <876098ictv.fsf@concordia.ellerman.id.au>
References: <20171213092550.2774-1-mhocko@kernel.org> <CAGXu5jKjjsyYJTWTqzO0mQKM+9mCH=jY_x90wJpoXbsDcLSv+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAGXu5jKjjsyYJTWTqzO0mQKM+9mCH=jY_x90wJpoXbsDcLSv+Q@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Wed, Dec 13, 2017 at 1:25 AM, Michal Hocko <mhocko@kernel.org> wrote:
>>
>> Hi,
>> I am resending with some minor updates based on Michael's review and
>> ask for inclusion. There haven't been any fundamental objections for
>> the RFC [1] nor the previous version [2].  The biggest discussion
>> revolved around the naming. There were many suggestions flowing
>> around MAP_REQUIRED, MAP_EXACT, MAP_FIXED_NOCLOBBER, MAP_AT_ADDR,
>> MAP_FIXED_NOREPLACE etc...
>
> With this named MAP_FIXED_NOREPLACE (the best consensus we've got on a
> name), please consider this series:
>
> Acked-by: Kees Cook <keescook@chromium.org>

I don't feel like I'm actually qualified to ack the mm and binfmt
changes, but everything *looks* correct to me, and you've fixed the flag
numbering such that it can go in mman-common.h as I suggested.

So if the name was MAP_FIXED_NOREPLACE I would also be happy with it.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

I can resubmit with the name changed if that's what it takes.

cheers

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
