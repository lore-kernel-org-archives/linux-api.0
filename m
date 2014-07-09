From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
Date: Wed, 9 Jul 2014 20:42:15 +0200
Message-ID: <20140709184215.GA4866@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org> <1403911380-27787-10-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403911380-27787-10-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/27, Kees Cook wrote:
>
>  static u32 seccomp_run_filters(int syscall)
>  {
> -	struct seccomp_filter *f;
> +	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);

I am not sure...

This is fine if this ->filter is the 1st (and only) one, in this case
we can rely on rmb() in the caller.

But the new filter can be installed at any moment. Say, right after that
rmb() although this doesn't matter. Either we need smp_read_barrier_depends()
after that, or smp_load_acquire() like the previous version did?

Oleg.
