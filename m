From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Mon, 07 Jan 2019 21:10:46 +1100
Message-ID: <87y37waic9.fsf@concordia.ellerman.id.au>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com> <CAHk-=whL4sZiM=JcdQAYQvHm7h7xEtVUh+gYGYhoSk4vi38tXg@mail.gmail.com> <CAHk-=wg5Kk+r36=jcGBaLUj+gjopjgiW5eyvkdMqvn0jFkD_iQ@mail.gmail.com> <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wiMQeCEKESWTmm15x79NjEjNwFvjZ=9XenxY7yH8zqa7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>
Cc: Jiri Kosina <jikos@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, Jan 5, 2019 at 3:16 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> It goes back to forever, it looks like. I can't find a reason.
>
> mincore() was originally added in 2.3.52pre3, it looks like. Around
> 2000 or so. But sadly before the BK history.

Yeah, it's here in the commit titled "Import 2.3.52pre3" (takes a second
or two to load):

  https://github.com/mpe/linux-fullhistory/commit/a1bcda3256956318c95c8da8bee09f79190bb034#diff-fd2d793b8b4760b4887c8c7bbb3451d7R1730

But no further detail.

(Instructions for using that tree https://github.com/mpe/linux-fullhistory/wiki)

cheers
