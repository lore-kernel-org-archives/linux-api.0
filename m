From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 0/2] mm: introduce MAP_FIXED_SAFE
Date: Wed, 06 Dec 2017 15:51:44 +1100
Message-ID: <87wp20e9wf.fsf@concordia.ellerman.id.au>
References: <20171129144219.22867-1-mhocko@kernel.org> <CAGXu5jLa=b2HhjWXXTQunaZuz11qUhm5aNXHpS26jVqb=G-gfw@mail.gmail.com> <20171130065835.dbw4ajh5q5whikhf@dhcp22.suse.cz> <20171201152640.GA3765@rei>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171201152640.GA3765@rei>
Sender: owner-linux-mm@kvack.org
To: Cyril Hrubis <chrubis@suse.cz>, Michal Hocko <mhocko@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>
List-Id: linux-api@vger.kernel.org

Cyril Hrubis <chrubis@suse.cz> writes:

> Hi!
>> > MAP_FIXED_UNIQUE
>> > MAP_FIXED_ONCE
>> > MAP_FIXED_FRESH
>> 
>> Well, I can open a poll for the best name, but none of those you are
>> proposing sound much better to me. Yeah, naming sucks...
>
> Given that MAP_FIXED replaces the previous mapping MAP_FIXED_NOREPLACE
> would probably be a best fit.

Yeah that could work.

I prefer "no clobber" as I just suggested, because the existing
MAP_FIXED doesn't politely "replace" a mapping, it destroys the current
one - which you or another thread may be using - and clobbers it with
the new one.

cheers

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
