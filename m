From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: Re: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per
 syscall
Date: Wed, 31 Aug 2016 16:08:27 +0200
Message-ID: <0609be30-bfcd-40f3-ec00-2b8b056654bc@imgtec.com>
References: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
 <CALCETrW1m9ozck-ugX6AKnL7oNA8rvMTjhFGqtVSvKL9BMXMZA@mail.gmail.com>
 <f40020e1-200c-f113-5174-5fe4d4c000dc@imgtec.com>
 <CALCETrWy5cUDJmTVrjSSqWHc4KyxTPjoD7yU7iqTSHfkK4UwvA@mail.gmail.com>
 <20160830152955.17633511@gandalf.local.home>
 <CALCETrXA0XbYuqYzWMJA+KjFS31YL0cTVtrvCnmRY_GMK6oNpw@mail.gmail.com>
 <20160830165830.5e494c43@gandalf.local.home>
 <CALCETrW_bnmqBRp3qWoaWUu=m7Bi19VcH9kMBifyL06JuGGVzg@mail.gmail.com>
 <20160830180328.4e579db3@gandalf.local.home>
 <CALCETrWjpcKqFHvxS35Csd3An1QNMXW8yiHChuWfuWTvVu8_ig@mail.gmail.com>
 <20160830183030.3e9f67f0@gandalf.local.home>
 <CALCETrWx+1Pdob8mU_X1hOWPWqj31ihVL3Z1R0PqjVeExZ_HAA@mail.gmail.com>
 <20160830192818.4e16a674@gandalf.local.home>
 <CALCETrWjipqo3ZfbrrS4MkdFgcisrjvu=CcWe6T-h1HV7tzUrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <CALCETrWjipqo3ZfbrrS4MkdFgcisrjvu=CcWe6T-h1HV7tzUrg@mail.gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Andy Lutomirski <luto@amacapital.net>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, open list <linux-kernel@vger.kernel.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>
List-Id: linux-api@vger.kernel.org



On 31.08.2016 02:01, Andy Lutomirski wrote:
> On Tue, Aug 30, 2016 at 4:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Tue, 30 Aug 2016 16:09:04 -0700
>> Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>> But none of this should be a problem at all for MIPS, right?  AFAICT
>>> the only problem for MIPS is that there *is* a mapping from metadata
>>> to nr.  If that mapping got removed, MIPS should just work, right?
>>
>> Wait, where's the mapping of metadata to nr. I don't see that, nor do I
>> see a need for that. The issue is that we have metadata that expresses
>> how to record a syscall, and we map syscall nr to metadata, because
>> when tracing is active, the only thing we have to find that metadata is
>> the syscall nr.
>
> It's in init_ftrace_syscalls():
>
>         meta->syscall_nr = i;
>
> and everything that uses that.  I think that this is the main problem
> that the patch that started this thread changes, and I think that
> deleting it would be cleaner than this patch.
>
>>
>> Now if a syscall nr has more than one way to record (a single nr for
>> multiple syscalls), then we get into trouble. That's why we have
>> trouble with compat syscalls. The same number maps to different
>> syscalls, and we don't know how to differentiate that.
>
>>
>>
>>>
>>> For x86 compat, I think that adding arch should be sufficient.
>>> Specifically, rather than having just one enter_syscall_files array,
>>> have one per audit arch.  Then call syscall_get_arch() as well as
>>> syscall_get_nr() and use both to lookup the metadata.  AFAIK this
>>> should work on all architectures, although you might need some arch
>>> helpers to enumerate all the arches and their respective syscall
>>> tables (and max syscall nrs).
>>
>> OK, if the regs can get us to the arch, then this might work.
>>
>> That is, perhaps we can have multiple tables (not really sure how to
>> make that happen in an arch agnostic way), and then have two functions:
>>
>> trace_get_syscall_nr(current, regs)
>> trace_get_syscall_arch(current, regs)
>
> Sadly, syscall_get_arch() doesn't take a regs parameter -- it looks at
> current.  If it were made more general, it would need a task pointer,
> not a regs pointer, but would just looking at current be okay for
> tracing?

I think using current should be enough here? Anyway in all other cases 
where syscall_get_arch is used, any other methods that require a task 
pointer take it from current as well.


> syscall_get_arch() does work on all archs that support seccomp filters, though.

And as it happens I think it works on all archs that have COMPAT and 
that pose any problems here? So for any arch that doesn't support 
syscall_get_arch it should be safe to have a fallback that defaults to 
indicating a single arch type.

However, it seems to me that the method used currently for mapping the 
syscall metadata to the syscall numbers wouldn't be possible when the 
extra dimension of arch type is added? Would it require some sort of 
metadata pointer table generation at build time?
If all archs used the same method for building syscall tables (as 
suggested by Arnd) then we could have a single build-time method for 
adding the syscall metadata map to the syscall tables? (as all the 
symbol names are known at that time and could be coalesced to find the 
metadata location from a syscall number/arch and name)...

Marcin
