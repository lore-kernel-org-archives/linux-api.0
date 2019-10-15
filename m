From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 2/2] pidfd: add tests for NSpid info in fdinfo
Date: Tue, 15 Oct 2019 12:07:44 +0200
Message-ID: <20191015100743.t6gowsic7c347ldv@wittgenstein>
References: <20191011122323.7770-1-ckellner@redhat.com>
 <20191014162034.2185-1-ckellner@redhat.com>
 <20191014162034.2185-2-ckellner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191014162034.2185-2-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kellner <ckellner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jann Horn <jannh@google.com>, Christian Kellner <christian@kellner.me>, Christian Brauner <christian@ubuntu.com>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 14, 2019 at 06:20:33PM +0200, Christian Kellner wrote:
> From: Christian Kellner <christian@kellner.me>
> 
> Add a test that checks that if pid namespaces are configured the fdinfo
> file of a pidfd contains an NSpid: entry containing the process id in
> the current and additionally all nested namespaces. In the case that
> a pidfd is from a pid namespace not in the same namespace hierarchy as
> the process accessing the fdinfo file, ensure the 'NSpid' shows 0 for
> that pidfd, analogous to the 'Pid' entry.
> 
> Signed-off-by: Christian Kellner <christian@kellner.me>

That looks reasonable to me.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
