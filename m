From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 2/4] clone3: switch to copy_struct_from_user()
Date: Tue, 1 Oct 2019 04:32:36 +0200
Message-ID: <20191001023235.kbk3fiskulervlxz@wittgenstein>
References: <20191001011055.19283-1-cyphar@cyphar.com>
 <20191001011055.19283-3-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191001011055.19283-3-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 11:10:53AM +1000, Aleksa Sarai wrote:
> The change is very straightforward, and helps unify the syscall
> interface for struct-from-userspace syscalls. Additionally, explicitly
> define CLONE_ARGS_SIZE_VER0 to match the other users of the
> struct-extension pattern.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
