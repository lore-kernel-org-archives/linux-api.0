From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 2/6] mm/page_idle: Add support for handling swapped
 PG_Idle pages
Date: Tue, 13 Aug 2019 17:04:50 +0200
Message-ID: <20190813150450.GN17933@dhcp22.suse.cz>
References: <20190807171559.182301-1-joel@joelfernandes.org>
 <20190807171559.182301-2-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190807171559.182301-2-joel@joelfernandes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, namhyung@google.com, paulmck@linux.ibm.com, Robin Murphy <robin.murphy@arm.com>, Roman Gushchin <guro@fb.com>, Ste
List-Id: linux-api@vger.kernel.org

On Wed 07-08-19 13:15:55, Joel Fernandes (Google) wrote:
> Idle page tracking currently does not work well in the following
> scenario:
>  1. mark page-A idle which was present at that time.
>  2. run workload
>  3. page-A is not touched by workload
>  4. *sudden* memory pressure happen so finally page A is finally swapped out
>  5. now see the page A - it appears as if it was accessed (pte unmapped
>     so idle bit not set in output) - but it's incorrect.
> 
> To fix this, we store the idle information into a new idle bit of the
> swap PTE during swapping of anonymous pages.
>
> Also in the future, madvise extensions will allow a system process
> manager (like Android's ActivityManager) to swap pages out of a process
> that it knows will be cold. To an external process like a heap profiler
> that is doing idle tracking on another process, this procedure will
> interfere with the idle page tracking similar to the above steps.

This could be solved by checking the !present/swapped out pages
right? Whoever decided to put the page out to the swap just made it
idle effectively.  So the monitor can make some educated guess for
tracking. If that is fundamentally not possible then please describe
why.
-- 
Michal Hocko
SUSE Labs
