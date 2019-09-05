From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 12:57:49 +0200
Message-ID: <20190905105749.GW2386@hirez.programming.kicks-ass.net>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905073205.GY2332@hirez.programming.kicks-ass.net>
 <20190905092622.tlb6nn3uisssdfbu@yavin.dot.cyphar.com>
 <20190905094305.GJ2349@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190905094305.GJ2349@hirez.programming.kicks-ass.net>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Aleksa Sarai <asarai@suse.de>, Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Shuah Khan <skhan@lin>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 05, 2019 at 11:43:05AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 05, 2019 at 07:26:22PM +1000, Aleksa Sarai wrote:
> > On 2019-09-05, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> > > > +/**
> > > > + * copy_struct_to_user: copy a struct to user space
> > > > + * @dst:   Destination address, in user space.
> > > > + * @usize: Size of @dst struct.
> > > > + * @src:   Source address, in kernel space.
> > > > + * @ksize: Size of @src struct.
> > > > + *
> > > > + * Copies a struct from kernel space to user space, in a way that guarantees
> > > > + * backwards-compatibility for struct syscall arguments (as long as future
> > > > + * struct extensions are made such that all new fields are *appended* to the
> > > > + * old struct, and zeroed-out new fields have the same meaning as the old
> > > > + * struct).
> > > > + *
> > > > + * @ksize is just sizeof(*dst), and @usize should've been passed by user space.
> > > > + * The recommended usage is something like the following:
> > > > + *
> > > > + *   SYSCALL_DEFINE2(foobar, struct foo __user *, uarg, size_t, usize)
> > > > + *   {
> > > > + *      int err;
> > > > + *      struct foo karg = {};
> > > > + *
> > > > + *      // do something with karg
> > > > + *
> > > > + *      err = copy_struct_to_user(uarg, usize, &karg, sizeof(karg));
> > > > + *      if (err)
> > > > + *        return err;
> > > > + *
> > > > + *      // ...
> > > > + *   }
> > > > + *
> > > > + * There are three cases to consider:
> > > > + *  * If @usize == @ksize, then it's copied verbatim.
> > > > + *  * If @usize < @ksize, then kernel space is "returning" a newer struct to an
> > > > + *    older user space. In order to avoid user space getting incomplete
> > > > + *    information (new fields might be important), all trailing bytes in @src
> > > > + *    (@ksize - @usize) must be zerored
> > > 
> > > s/zerored/zero/, right?
> > 
> > It should've been "zeroed".
> 
> That reads wrong to me; that way it reads like this function must take
> that action and zero out the 'rest'; which is just wrong.
> 
> This function must verify those bytes are zero, not make them zero.
> 
> > > >                                          , otherwise -EFBIG is returned.
> > > 
> > > 'Funny' that, copy_struct_from_user() below seems to use E2BIG.
> > 
> > This is a copy of the semantics that sched_[sg]etattr(2) uses -- E2BIG for
> > a "too big" struct passed to the kernel, and EFBIG for a "too big"
> > struct passed to user-space. I would personally have preferred EMSGSIZE
> > instead of EFBIG, but felt using the existing error codes would be less
> > confusing.
> 
> Sadly a recent commit:
> 
>   1251201c0d34 ("sched/core: Fix uclamp ABI bug, clean up and robustify sched_read_attr() ABI logic and code")
> 
> Made the situation even 'worse'.

And thinking more about things; I'm not convinced the above patch is
actually right.

Do we really want to simply truncate all the attributes of the task?

And should we not at least set sched_flags when there are non-default
clamp values applied?

See; that is I think the primary bug that had chrt failing; we tried to
publish the default clamp values as !0.
