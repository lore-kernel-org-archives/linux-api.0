From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op
 vector v11
Date: Tue, 27 Mar 2018 14:15:33 -0400 (EDT)
Message-ID: <1630439840.1550.1522174533412.JavaMail.zimbra@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ@mail.gmail.com> <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w@mail.gmail.com> <CAPM31RJJhtF3RR_Xf+kim-aas59eQ75AUJuu1qzBU_v0mE6sqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPM31RJJhtF3RR_Xf+kim-aas59eQ75AUJuu1qzBU_v0mE6sqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Turner <pjt@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

Hi Paul!

I guess stuff like Spectre/Meltdown can turn 1-2 days into months. ;-)

I did not want to distract you too much from that work, but you'll notice
I've sent an updated patch series against 4.16-rc7, aiming at 4.17 [1]
(it should be in your inbox).

I would really appreciate if you can find time to provide feedback on
that version.

Congratulations on the wedding!

Thanks,

Mathieu

[1] https://lkml.kernel.org/r/20180327160542.28457-1-mathieu.desnoyers@efficios.com

----- On Nov 14, 2017, at 4:32 PM, Paul Turner pjt@google.com wrote:

> I have some comments that apply to many of the threads.
> I've been fully occupied with a wedding and a security issue; but I'm
> about to be free to spend the majority of my time on RSEQ things.
> I was sorely hoping that day would be today.  But it's looking like
> I'm still a day or two from being free for this.
> Thank you for the extensive clean-ups and user-side development.  I
> have some updates on these topics also.
> 
> - Paul
> 
> On Tue, Nov 14, 2017 at 1:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Nov 14, 2017 at 1:08 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Tue, Nov 14, 2017 at 12:03 PM, Mathieu Desnoyers
>>> <mathieu.desnoyers@efficios.com> wrote:
>>>> Here is the last RFC round of the updated rseq patchset containing:
>>>
>>> Andy? You were the one with concerns here and said you'd have
>>> something else ready for comparison.
>>>
>>
>> I had a long discussion with Mathieu and KS and I think that this is a
>> good compromise.  I haven't reviewed the series all that carefully,
>> but I think the idea is sound.
>>
>> Basically, event_counter is gone (to be re-added in a later kernel if
>> it really ends up being necessary, but it looks like it may primarily
>> be a temptation to write subtly incorrect user code and to see
>> scheduling details that shouldn't be readily exposed rather than a
>> genuinely useful feature) and the versioning mechanism for the asm
>> critical section bit is improved.  My crazy proposal should be doable
>> on top of this if there's demand and if anyone wants to write the
>> gnarly code involved.
>>
>> IOW no objection from me as long as those changes were made, which I
> > *think* they were.  Mathieu?

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
