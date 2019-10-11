From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 1/2] pidfd: show pids for nested pid namespaces in
 fdinfo
Date: Fri, 11 Oct 2019 15:17:01 +0200
Message-ID: <20191011131659.pqzmrh2527l2oz7b@wittgenstein>
References: <20191009160532.20674-1-ckellner@redhat.com>
 <20191011122323.7770-1-ckellner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191011122323.7770-1-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kellner <ckellner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Christian Kellner <christian@kellner.me>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 02:23:20PM +0200, Christian Kellner wrote:
> From: Christian Kellner <christian@kellner.me>
> 
> The fdinfo file for a process file descriptor already contains the
> pid of the process in the callers namespaces. Additionally, if pid
> namespaces are configured, show the process ids of the process in
> all nested namespaces in the same format as in the procfs status
> file, i.e. "NSPid:\t%d\%d...". This allows the easy identification
> of the processes in nested namespaces.
> 
> Signed-off-by: Christian Kellner <christian@kellner.me>

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

If I hear no technical objections I'll pick this up targeting the 5.5
merge window.

Thanks!
Christian
