From: Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
Date: Wed, 9 Aug 2017 14:41:41 -0600
Message-ID: <20170809204141.x2nnpogjcok73d4f@smitten>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
 <20170809202230.ivyv2cdeknb4tyn7@smitten>
 <a0bddc6f-686e-2a5a-4833-acf04a10722f@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a0bddc6f-686e-2a5a-4833-acf04a10722f-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabricio Voznika <fvoznika-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hey Tyler :)

On Wed, Aug 09, 2017 at 03:33:28PM -0500, Tyler Hicks wrote:
> Hey Tycho!
> 
> On 08/09/2017 03:22 PM, Tycho Andersen wrote:
> > On Wed, Aug 09, 2017 at 12:01:53PM -0700, Kees Cook wrote:
> >> This series is the result of Fabricio and I going around a few times
> >> on possible solutions for finding a way to enhance RET_KILL to kill
> >> the process group. There's a lot of ways this could be done, but I
> >> wanted something that felt cleanest. As it happens, Tyler's recent
> >> patch series for logging improvement also needs to know a litte bit
> >> more during filter runs, and the solution for both is to pass back
> >> the matched filter. This lets us examine it here for RET_KILL and
> >> in the future for logging changes.
> >>
> >> The filter passing is patch 1, the new flag for RET_KILL is patch 2.
> >> Some test refactoring is in patch 3 for the RET_DATA ordering, and
> >> patch 4 is the test for the new RET_KILL flag.
> >>
> >> One thing missing is that CRIU will likely need to be updated, since
> >> saving/restoring seccomp filter _rules_ will not include the filter
> >> _flags_ for a process. This can be addressed separately.
> > 
> > Thanks for the heads up, I suppose PTRACE_SECCOMP_GET_FLAGS similar to
> > how PTRACE_SECCOMP_GET_FILTER works will be fine for this. One
> > question is: would we then also need to keep track of the TSYNC flag?
> > I don't think CRIU needs this to be correct, and we can grab the
> > KILL_PROCESS flag from filter->kill_process, so perhaps it's moot.
> 
> Note that the logging changes that I'm working on also introduce a new
> filter flag (as Kees mentioned above). My filter flag is a lot like the
> KILL_PROCESS filter flag in that it is stored as a member of the
> seccomp_filter struct.
> 
> I would think that you'd want to be able to do something like
> PTRACE_SECCOMP_GET_FILTER to (hopefully) future proof CRIU against all
> newly added filter flags.

Yep, the theoretical GET_FLAGS above would handle this, I think. What
I was wondering about is for TSYNC (or any future flags) which aren't
tracked in the struct seccomp_filter; would the existence of GET_FLAGS
mean we need to remember such flags as well somewhere? Not necessary
for CRIU's correctness right now at least, but...

Cheers,

Tycho
