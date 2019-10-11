From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 2/2] pidfd: add tests for NSpid info in fdinfo
Date: Fri, 11 Oct 2019 15:18:37 +0200
Message-ID: <20191011131835.xzxxncgo67kzbemd@wittgenstein>
References: <20191009160532.20674-1-ckellner@redhat.com>
 <20191011122323.7770-1-ckellner@redhat.com>
 <20191011122323.7770-2-ckellner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191011122323.7770-2-ckellner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kellner <ckellner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Christian Kellner <christian@kellner.me>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 11, 2019 at 02:23:21PM +0200, Christian Kellner wrote:
> From: Christian Kellner <christian@kellner.me>
> 
> Add tests that check that if pid namespaces are configured the fdinfo
> file of a pidfd contains an NSpid: entry containing the process id
> in the current and additionally all nested namespaces.
> 
> Signed-off-by: Christian Kellner <christian@kellner.me>

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Shuah, can I get an Ack for you from this. If you have no objections I'd
queue up this patchset for the 5.5 merge window.

Thanks!
Christian
