From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 4/4] perf_event_open: switch to copy_struct_from_user()
Date: Tue, 1 Oct 2019 04:36:07 +0200
Message-ID: <20191001023606.bkcji3tt6bgu6p5a@wittgenstein>
References: <20191001011055.19283-1-cyphar@cyphar.com>
 <20191001011055.19283-5-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <libc-alpha-return-105548-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191001011055.19283-5-cyphar@cyphar.com>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 11:10:55AM +1000, Aleksa Sarai wrote:
> The change is very straightforward, and helps unify the syscall
> interface for struct-from-userspace syscalls.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
