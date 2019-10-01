From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 1/4] lib: introduce copy_struct_from_user() helper
Date: Tue, 1 Oct 2019 09:28:42 -0700
Message-ID: <201910010928.243849D@keescook>
References: <20191001011055.19283-1-cyphar@cyphar.com>
 <20191001011055.19283-2-cyphar@cyphar.com>
 <201909301856.01255535BD@keescook>
 <20191001023126.qhzeiwmtoo4agy7t@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191001023126.qhzeiwmtoo4agy7t@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 04:31:27AM +0200, Christian Brauner wrote:
> On Mon, Sep 30, 2019 at 06:58:39PM -0700, Kees Cook wrote:
> > On Tue, Oct 01, 2019 at 11:10:52AM +1000, Aleksa Sarai wrote:
> > > +static __always_inline
> > > +int copy_struct_from_user(void *dst, size_t ksize,
> > > +			  const void __user *src, size_t usize)
> > 
> > And of course I forgot to realize both this and check_zeroed_user()
> > should also have the __must_check attribute. Sorry for forgetting that
> > earlier!
> 
> Just said to Aleksa that I'll just fix this up when I apply so he
> doesn't have to resend. You ok with this, Kees?

Yup; that's totally fine. Thanks!

-- 
Kees Cook
