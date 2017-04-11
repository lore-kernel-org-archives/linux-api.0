From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Mon, 10 Apr 2017 20:59:15 -0700
Message-ID: <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
	<CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
	<CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
	<CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
	<ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com>
	<CAGXu5j+qUOpnDeF4TMH2AXXgHZB_WfHHfxe3TBSShmneisR-Lg@mail.gmail.com>
	<a914076f-efb8-d867-f480-69addca4e628@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <a914076f-efb8-d867-f480-69addca4e628@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, linux-audit@redhat.com, John Crispin <john@phrozen.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 7, 2017 at 4:46 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 04/07/2017 05:46 PM, Kees Cook wrote:
>> Does the app-controlled bitmask apply to the filter, the process, the
>> process tree, or something else? e.g. systemd launches an app with a
>> filter, leaving the defaults alone, then later process installs a
>> filter and wants everything logged -- will things from the earlier
>> filter get logged?
>
> I think implementation preferences may decide many of these questions.
> As I see it, here are the options in order of my preference:
>
> A) Claim the MSB of the filter return value and make the app logging
>    preference per-rule
>    - If the bit is set, log the rule
>    - Provides very fine-grained logging control at the "high cost" of
>      the remaining free bit in the filter return bitmask
>    - The bit can be ignored in the case of RET_KILL
>    - Can be synced across all threads in the calling task with the
>      SECCOMP_FILTER_FLAG_TSYNC filter flag
>
> B) Claim a few bits in the filter flags and make the app logging
>    preference per-filter
>    - Something like SECCOMP_FILTER_FLAG_LOG_TRAP,
>      SECCOMP_FILTER_FLAG_LOG_ERRNO, and
>      SECCOMP_FILTER_FLAG_LOG_TRACE
>    - Logging for RET_KILL and RET_LOG can't be turned off
>    - I'd prefer not to waste a bit for RET_ALLOW in this case so it
>      simply won't be loggable
>    - Works with the SECCOMP_FILTER_FLAG_TSYNC filter flag
>    - Doesn't scale well if many new actions are added in the future
>
> C) A simplified version of 'B' where only a single mode bit is claimed
>    to enable logging for all actions except RET_ALLOW
>    - Something like SECCOMP_FILTER_FLAG_LOG_ACTIONS
>    - Filters without this flag only log RET_KILL and RET_LOG
>    - Scales much better than 'B' at the expense of less flexibility
>    - Works with the SECCOMP_FILTER_FLAG_TSYNC filter flag
>
> D) Claim a bit in the filter mode and make the app logging preference
>    per-process
>    - This new SECCOMP_MODE_ENABLE_LOGGING mode would take a bitmask of
>      actions that should be logged
>    - Incurs a small per-task increase in memory footprint in the form
>      of an additional member in 'struct seccomp'
>    - Has odd behavior you described above where launchers may set the
>      logging preference and then launched application may want
>      something different
>
> I think 'A' is the cleanest design but I don't know if highly
> configurable logging is deserving of the MSB bit in the filter return.
> I'd like to hear your thoughts there.
>
> I _barely_ prefer 'B' over 'C'. They're essential equal in my use case.
>
> To be honest, I haven't completely wrapped my head around how 'D' would
> actually work in practice so I may be writing it off prematurely.
>
> Am I missing any more clever options that you can think of? Let me know
> what you think of the possibilities.

Hmm, so, I think we can just make this a bitmask in the process
seccomp struct. It'll get inherited across forks, and any filter that
wants to make sure it never changes again can just blacklist the
seccomp syscall with that argument. I don't see anything about the
logging that should be considered private, considering the logs are
going through syslog or auditd. Since it's already out-of-band, this
won't change the behavior of ptrace monitors, etc.

So, how about seccomp(SECCOMP_SET_LOGGING, flags, user_ptr) and
...GET_LOGGING? flags likely 0, and user_ptr can point to:

struct seccomp_logging {
    u32 count;
    u32 values[];
};

Where each value entry is a filter return value to log. (That way
bitmasks are just an internal storage detail and we're allowed to add
new filter returns without breaking a bitmask UAPI.)

-Kees

-- 
Kees Cook
Pixel Security
