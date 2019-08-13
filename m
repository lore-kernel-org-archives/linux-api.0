From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH v5 2/6] mm/page_idle: Add support for handling swapped
 PG_Idle pages
Date: Tue, 13 Aug 2019 22:24:06 +0300
Message-ID: <CALYGNiOj4pxZAMvM_3fJZ0xJ0E5-FfSRQbGdxb4eFC37USCYvA@mail.gmail.com>
References: <20190807171559.182301-1-joel@joelfernandes.org>
 <20190807171559.182301-2-joel@joelfernandes.org> <20190813150450.GN17933@dhcp22.suse.cz>
 <20190813153659.GD14622@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813153659.GD14622@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Michal Hocko <mhocko@kernel.org>, =?UTF-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov@yandex-team.ru>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, Linux API <linux-api@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.or>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 6:37 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> On Tue, Aug 13, 2019 at 05:04:50PM +0200, Michal Hocko wrote:
> > On Wed 07-08-19 13:15:55, Joel Fernandes (Google) wrote:
> > > Idle page tracking currently does not work well in the following
> > > scenario:
> > >  1. mark page-A idle which was present at that time.
> > >  2. run workload
> > >  3. page-A is not touched by workload
> > >  4. *sudden* memory pressure happen so finally page A is finally swapped out
> > >  5. now see the page A - it appears as if it was accessed (pte unmapped
> > >     so idle bit not set in output) - but it's incorrect.
> > >
> > > To fix this, we store the idle information into a new idle bit of the
> > > swap PTE during swapping of anonymous pages.
> > >
> > > Also in the future, madvise extensions will allow a system process
> > > manager (like Android's ActivityManager) to swap pages out of a process
> > > that it knows will be cold. To an external process like a heap profiler
> > > that is doing idle tracking on another process, this procedure will
> > > interfere with the idle page tracking similar to the above steps.
> >
> > This could be solved by checking the !present/swapped out pages
> > right? Whoever decided to put the page out to the swap just made it
> > idle effectively.  So the monitor can make some educated guess for
> > tracking. If that is fundamentally not possible then please describe
> > why.
>
> But the monitoring process (profiler) does not have control over the 'whoever
> made it effectively idle' process.
>
> As you said it will be a guess, it will not be accurate.

Yep. Without saving idle bit in swap entry (and presuming that all swap is idle)
profiler could miss access. This patch adds accurate tracking almost for free.
After that profiler could work with any pace without races.

>
> I am curious what is your concern with using a bit in the swap PTE?
>
> (Adding Konstantin as well since we may be interested in this, since we also
> suggested this idea).
>
> thanks,
>
>  - Joel
>
>
