From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v2 1/4] lib: introduce copy_struct_from_user() helper
Date: Fri, 27 Sep 2019 10:20:17 +0200
Message-ID: <20190927082016.jsis76s26uverj5r@wittgenstein>
References: <20190925230332.18690-1-cyphar@cyphar.com>
 <20190925230332.18690-2-cyphar@cyphar.com>
 <20190925232139.45sbhj34fj7yvxer@wittgenstein>
 <20190927010736.gy3vvvkjhwlybosj@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190927010736.gy3vvvkjhwlybosj@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 27, 2019 at 11:07:36AM +1000, Aleksa Sarai wrote:
> On 2019-09-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> > On Thu, Sep 26, 2019 at 01:03:29AM +0200, Aleksa Sarai wrote:
> > > +int is_zeroed_user(const void __user *from, size_t size)
> > > +{
> > > +	unsigned long val;
> > > +	uintptr_t align = (uintptr_t) from % sizeof(unsigned long);
> > > +
> > > +	if (unlikely(!size))
> > > +		return true;
> > 
> > You're returning "true" and another implicit boolean with (val == 0)
> > down below but -EFAULT in other places. But that function is int
> > is_zeroed_user() Would probably be good if you either switch to bool
> > is_zeroed_user() as the name suggests or rename the function and have
> > it return an int everywhere.
> 
> I just checked, and in C11 (and presumably in older specs) it is
> guaranteed that "true" and "false" from <stdbool.h> have the values 1
> and 0 (respectively) [§7.18]. So this is perfectly well-defined.
> 
If you declare a function as returning an int, return ints and don't mix
returning ints and "proper" C boolean types. This:

static int foo()
{
	if (bla)
		return true;
	return -1;
}

is just messy.

> 
> Personally, I think it's more readable to have:
> 
>   if (unlikely(size == 0))
>     return true;
>   /* ... */
>   return (val == 0);
> 
> compared to:
> 
>   if (unlikely(size == 0))
>     return 1;
>   /* ... */
>   return val ? 0 : 1;

Just do:

if (unlikely(size == 0))
	return 1;
/* ... */
return (val == 0);

You don't need to change the last return.

Also, as I said in a previous mail: Please wait for rc1 (that's just two
days) to be out so you can base your patchset on that as there are
changes in mainline that cause a merge conflict with your changes.

Thanks!
Christian
