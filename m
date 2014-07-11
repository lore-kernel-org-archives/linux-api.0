From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
Date: Fri, 11 Jul 2014 18:49:31 +0200
Message-ID: <20140711164931.GA18473@redhat.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1405017631-27346-1-git-send-email-keescook@chromium.org>
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
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/10, Kees Cook wrote:
>
> This adds the ability for threads to request seccomp filter
> synchronization across their thread group (at filter attach time).
> For example, for Chrome to make sure graphic driver threads are fully
> confined after seccomp filters have been attached.
>
> To support this, locking on seccomp changes via thread-group-shared
> sighand lock is introduced, along with refactoring of no_new_privs. Races
> with thread creation are handled via delayed duplication of the seccomp
> task struct field and cred_guard_mutex.
>
> This includes a new syscall (instead of adding a new prctl option),
> as suggested by Andy Lutomirski and Michael Kerrisk.

I do not not see any problems in this version,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
