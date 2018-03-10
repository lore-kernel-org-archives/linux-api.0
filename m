From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Sat, 10 Mar 2018 14:08:43 +0000
Message-ID: <20180310140843.GP4449@wotan.suse.de>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
 <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net>
 <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
 <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>, Jessica Yu <jeyu@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 09, 2018 at 06:34:18PM -0800, Alexei Starovoitov wrote:
> On 3/9/18 11:38 AM, Linus Torvalds wrote:
> > On Fri, Mar 9, 2018 at 11:12 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > 
> > > How are you going to handle five processes doing the same setup
> > > concurrently?

Let's keep in mind we don't have a formal way to specify this as well
for modules as well, other than kconfig. Ie it'd be up to the author
of the modules to pick this up and make things mutually exclusive.

> > Side note: it's not just serialization. It's also "is it actually up
> > and running".
> > 
> > The rule for "request_module()" (for a real module) has been that it
> > returns when the module is actually alive and active and have done
> > their initcalls.

Unfortunately this is not accurate though, the loose grammar around this fact
is one of the reasons why long term I think either new API should be added, or
the existing request_module() API modified.

request_module() is not deterministic today, try_then_request_module() *is* but
its IMHO its a horrible grammatical solution, and I'm not a fan of the idea of
umh modules perpetuating this nonsense *long term*. Details below.

> > The UMH_WAIT_EXEC behavior (ignore the serialization - you could do
> > that in the caller) behavior doesn't actually have any semantics AT
> > ALL. It only means that you get the error returns from execve()
> > itself, so you know that the executable file actually existed and
> > parsed right enough to get started.
> > 
> > But you don't actually have any reason to believe that it has *done*
> > anything, and started processing any requests. There's no reason
> > what-so-ever to believe that it has registered itself for any
> > asynchronous requests or anything like that.
> 
> I agree that sync approach nicely fits this use case, but waiting
> for umh brings the whole set of suspend/resume issues that
> Luis explained earlier and if I understood his points that stuff
> is still not quite working right

It works enough that suspend works well enough on Linux today, but the primary
reason is that the big kernel/umh.c API user today is the firmware API for the
old fallback firmware interface and it has in place the sync
usermodehelper_read_trylock() and async async usermodehelper_read_lock_wait().
Note that in the fallback case there is just the uevent call.

> and he's planning a set of fixes.

The move of the umh locks out of the non-fallback case was a long term goal I
had which I was planning on doing slowly, but recently got jump started via
v4.14 via commit f007cad159e9 ("Revert "firmware: add sanity check on
shutdown/suspend"). As such that goal is now complete thanks to Linus correctly
pushing it forward.

> I really don't want the unknown timeline of fixes for 'waiting umh'
> to become a blocker for the bpfilter project ...

The reason for me to bring up the suspend stuff was that there no other
*heavy* UMH API users in the kernel today, and just to highlight that
care must be taken if we want to consider in the future further
possibly heavy UMH callers which we *can* expect to be called around
suspend and resume.

*Iff* that will be the case for these new umh userspace modules, we can
evaluate a future plan. But not that this is as vague as suggesting the
same for any further kernel future UMH API user! If the only umh module
we expect for a while will be bpfilter and it we don't expect heavy use
during suspend/resume this is a non-issue and likely won't be for a while,
and all that *should be done* is become aware of the today's limitations
as we *document* any new API, even if its the simple and easy
request_umh_module*() calls.

Today's use of the UMH API to always use helper_lock() and prevent suspend
while a call is being issued should suffice, so long as these umh modules don't
become heavy users during suspend/resume.

Note that there even *further* further advanced suspend/resume considerations
with filesystems but we have a reasonable hand on what to do there [0] and
it frankly isn't *that* much work as I have most of it done already.

The only other suspend optimization I could think of left to evaluate may be
whether or not to we should generalize something like the firmware cache for
other UMH callers but that's really a long term topic.

So I would not say there is pending work left to do, it should suffice
to document the semantics and limitations if the umh modules are to be
added. That's it.

Linus has proven me right that the *concerns* I've had for these corner
cases are just that, and I do believe documenting the limitations should
suffice for new APIs.

[0] https://lkml.kernel.org/r/20180126090923.GD12447@wotan.suse.de

> Also I like Luis suggestion to use some other name than request_module()
> Something like:
> request_umh_module_sync("foo");
> request_umh_module_nowait("foo");
> 
> in both cases the kernel would create a pipe, call umh either
> with UMH_WAIT_PROC or UMH_WAIT_EXEC and make sure that umh
> responds to first hello message.

Its not a widely known thing (and we can correct this with just slightly better
documentation) that contrary to what you might expect, today's synchronous
request_module() call in *now way* ensures the module requested got loaded,
even if 0 is returned, this *cannot* be guaranteed.

All that request_module() returning 0 tells us is that we found a
/sbin/modprobe, and kicked it off. We don't wait for a finit_module() to
complete.

We *could* add a generic form for this, *iff* this is is desirable. I have
enough random code on my development trees not submitted upstream which does
this *if we wanted it. I posted recently what I had stored in my kernel closet
for years about modules and aliases [1] simply because I figured Djalal may be
able to take advantage of aliases in-kernel for debugging purposes, but I had
*not yet* submitted code to actually make use of this for non-debugging
purposes and provide us with an optional way to truly get us that simple
deterministic API call that ensures a module *really* is loaded if the API
caller returns 0.

Today's *way* to resolve this was for Rusty to have added long ago the
try_then_request_module() helper. That is the real proper way to load modules
(TM) today *iff* you really needed to make sure that the service they provide
is loaded and available.

The beauty about it is its stupid simplicity -- try_then_request_module()
checks and enables for *any* service to be available in an argument and
if it got loaded, it'd be present.

While Rusty was content with it and its simplicity. I'm personally *not* a fan
of the loose ends it leaves behind. I believe it allows for sloppy programmers
and I don't think we should blame kernel developers today of believing that
request_module() *does* actually load their modules and its ready. The only way
to police this is manual code introspection, you can't even add generic
Coccinelle SmPL grammar rules to pick up if anyone used
try_then_request_module() or request_module() APIs properly if the goal was to
ensure the module was loaded. This is why I believe that this is sloppy and a
long term mistake.

But we haven't gotten the will to accept to change this. If others do believe
we *need this* in consideration for future uses of userspace modules, now would
be a good time to consider this *long term*.

The alternative to this would be a simple equivalent of try_then_request_module()
for UMH modules: try_umhm_then_request_umh_module() or whatever. So just as I
argued earlier over UMH limitations, this is not the end of the world for umh
modules, and it doesn't mean you can't get *properly* add umh modules upstream,
it would *just mean* we'd be perpetuating today's (IMHO) horrible and loose
semantics.

[1] https://lkml.kernel.org/r/20171130023605.29568-1-mcgrof@kernel.org

  Luis
