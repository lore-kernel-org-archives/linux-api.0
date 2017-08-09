From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
Date: Wed, 9 Aug 2017 13:40:08 -0700
Message-ID: <CAGXu5jJwYdESzw8rDrz1=kFNsHc72q-agXWqNFjtj-HPtkewiw@mail.gmail.com>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
 <20170809202230.ivyv2cdeknb4tyn7@smitten> <a0bddc6f-686e-2a5a-4833-acf04a10722f@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a0bddc6f-686e-2a5a-4833-acf04a10722f@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, Fabricio Voznika <fvoznika@google.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 9, 2017 at 1:33 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> Hey Tycho!
>
> On 08/09/2017 03:22 PM, Tycho Andersen wrote:
>> On Wed, Aug 09, 2017 at 12:01:53PM -0700, Kees Cook wrote:
>>> This series is the result of Fabricio and I going around a few times
>>> on possible solutions for finding a way to enhance RET_KILL to kill
>>> the process group. There's a lot of ways this could be done, but I
>>> wanted something that felt cleanest. As it happens, Tyler's recent
>>> patch series for logging improvement also needs to know a litte bit
>>> more during filter runs, and the solution for both is to pass back
>>> the matched filter. This lets us examine it here for RET_KILL and
>>> in the future for logging changes.
>>>
>>> The filter passing is patch 1, the new flag for RET_KILL is patch 2.
>>> Some test refactoring is in patch 3 for the RET_DATA ordering, and
>>> patch 4 is the test for the new RET_KILL flag.
>>>
>>> One thing missing is that CRIU will likely need to be updated, since
>>> saving/restoring seccomp filter _rules_ will not include the filter
>>> _flags_ for a process. This can be addressed separately.
>>
>> Thanks for the heads up, I suppose PTRACE_SECCOMP_GET_FLAGS similar to
>> how PTRACE_SECCOMP_GET_FILTER works will be fine for this. One
>> question is: would we then also need to keep track of the TSYNC flag?
>> I don't think CRIU needs this to be correct, and we can grab the
>> KILL_PROCESS flag from filter->kill_process, so perhaps it's moot.

It does not need to track TSYNC (since the results of that flag are
represented in the filter tree itself).

> Note that the logging changes that I'm working on also introduce a new
> filter flag (as Kees mentioned above). My filter flag is a lot like the
> KILL_PROCESS filter flag in that it is stored as a member of the
> seccomp_filter struct.
>
> I would think that you'd want to be able to do something like
> PTRACE_SECCOMP_GET_FILTER to (hopefully) future proof CRIU against all
> newly added filter flags.

I didn't see an obvious way to extend the existing
PTRACE_SECCOMP_GET_FILTER to also return flags, so I think either a
new function for just flags or a new versioned function for rules and
flags will be needed.

>> Anyway, happy to do this and the userspace part when this lands.

Okay, great! Thanks!

-Kees

-- 
Kees Cook
Pixel Security
