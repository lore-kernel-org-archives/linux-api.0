From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 1/4] lib: introduce copy_struct_from_user() helper
Date: Thu, 10 Oct 2019 09:43:26 -0700
Message-ID: <201910100943.4C6AB66@keescook>
References: <20191001011055.19283-1-cyphar@cyphar.com>
 <20191001011055.19283-2-cyphar@cyphar.com>
 <87eezkx2y7.fsf@mpe.ellerman.id.au>
 <20191010114007.o3bygjf4jlfk242e@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-105849-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191010114007.o3bygjf4jlfk242e@yavin.dot.cyphar.com>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 10, 2019 at 10:40:07PM +1100, Aleksa Sarai wrote:
> Yeah, it takes about 5-10s on my laptop. We could switch it to just
> everything within a 4K block, but the main reason for testing with
> 2*PAGE_SIZE is to make sure that check_nonzero_user() works across page
> boundaries. Though we could only do check_nonzero_user() in the region
> of the page boundary (maybe i E (PAGE_SIZE-512,PAGE_SIZE+512]?)

Yeah, I like this idea: just poke at the specific edge-case.

-- 
Kees Cook
