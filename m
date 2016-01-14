From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 22/22] thermal/intel_powerclamp: Convert the kthread
 to kthread worker API
Date: Thu, 14 Jan 2016 16:37:54 +0100
Message-ID: <20160114153754.GU3178@pathway.suse.cz>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
 <1447853127-3461-23-git-send-email-pmladek@suse.com>
 <20160107115531.34279a9b@icelake>
 <20160108164931.GT3178@pathway.suse.cz>
 <20160111181718.0ace4a58@yairi>
 <20160112101129.GN731@pathway.suse.cz>
 <20160112082021.6a28dc66@icelake>
 <20160113101831.GQ731@pathway.suse.cz>
 <20160113095353.5231c28f@yairi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160113095353.5231c28f@yairi>
Sender: linux-kernel-owner@vger.kernel.org
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-01-13 09:53:53, Jacob Pan wrote:
> On Wed, 13 Jan 2016 11:18:31 +0100
> Petr Mladek <pmladek@suse.com> wrote:
> > Otherwise, I will keep the conversion into the kthread worker as is
> > for now. Please, let me know if you are strongly against the split
> > into the two works.
> I am fine with the split now.

Great.

> Another question, are you planning to convert acpi_pad.c as well? It
> uses kthread similar way.

Yup. I would like to convert as many kthreads as possible either to
the kthread worker or workqueue APIs in the long term.

Best Regards,
Petr
