From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 4/9] sched: move no_new_privs into new atomic flags
Date: Wed, 25 Jun 2014 15:43:54 +0200
Message-ID: <20140625134354.GA7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-5-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403642893-23107-5-git-send-email-keescook@chromium.org>
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

On 06/24, Kees Cook wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1307,8 +1307,7 @@ struct task_struct {
>  				 * execve */
>  	unsigned in_iowait:1;
>
> -	/* task may not gain privileges */
> -	unsigned no_new_privs:1;
> +	unsigned long atomic_flags; /* Flags needing atomic access. */
>
>  	/* Revert to default priority/policy when forking */
>  	unsigned sched_reset_on_fork:1;

Agreed, personally I like it more than seccomp->flags.

But probably it would be better to place the new member before/after
other bitfields to save the space?

Oleg.
