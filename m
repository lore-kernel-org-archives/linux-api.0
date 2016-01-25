From: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v4 21/22] thermal/intel_powerclamp: Remove duplicated
 code that starts the kthread
Date: Mon, 25 Jan 2016 08:23:54 -0800
Message-ID: <20160125082354.02424350@icelake>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
	<1453736711-6703-22-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1453736711-6703-22-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org, jacob.jun.pan@linux.intel.com
List-Id: linux-api@vger.kernel.org

On Mon, 25 Jan 2016 16:45:10 +0100
Petr Mladek <pmladek@suse.com> wrote:

> This patch removes a code duplication. It does not modify
> the functionality.
> 
Acked-by:Jacob Pan <jacob.jun.pan@linux.intel.com>

> Signed-off-by: Petr Mladek <pmladek@suse.com>
> CC: Zhang Rui <rui.zhang@intel.com>
> CC: Eduardo Valentin <edubezval@gmail.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> CC: linux-pm@vger.kernel.org
> ---
>  drivers/thermal/intel_powerclamp.c | 45
> +++++++++++++++++--------------------- 1 file changed, 20
> insertions(+), 25 deletions(-)

[Jacob Pan]

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
