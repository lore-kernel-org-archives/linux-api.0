From: Gabriel Paubert <paubert@iram.es>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to, from}_user
 helpers
Date: Thu, 5 Sep 2019 12:13:15 +0200
Message-ID: <20190905101315.GA25637@lt-gp.iram.es>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <mvma7bj85yo.fsf@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <mvma7bj85yo.fsf@linux-m68k.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-mips@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Christian Brauner <christian@brauner.io>, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>Shua
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 11:09:35AM +0200, Andreas Schwab wrote:
> On Sep 05 2019, Aleksa Sarai <cyphar@cyphar.com> wrote:
> 
> > diff --git a/lib/struct_user.c b/lib/struct_user.c
> > new file mode 100644
> > index 000000000000..7301ab1bbe98
> > --- /dev/null
> > +++ b/lib/struct_user.c
> > @@ -0,0 +1,182 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Copyright (C) 2019 SUSE LLC
> > + * Copyright (C) 2019 Aleksa Sarai <cyphar@cyphar.com>
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/export.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +
> > +#define BUFFER_SIZE 64
> > +
> > +/*
> > + * "memset(p, 0, size)" but for user space buffers. Caller must have already
> > + * checked access_ok(p, size).
> > + */
> > +static int __memzero_user(void __user *p, size_t s)
> > +{
> > +	const char zeros[BUFFER_SIZE] = {};
> 
> Perhaps make that static?

On SMP? It should at least be per cpu, and I'm not even sure
with preemption.

	Gabriel

> 
> Andreas.
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
> "And now for something completely different."
