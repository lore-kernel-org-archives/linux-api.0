From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: futex(2) man page update help request
Date: Mon, 19 Jan 2015 15:07:36 +0100
Message-ID: <54BD0FA8.60606@gmail.com>
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos> <54B92B71.2090509@gmail.com> <alpine.DEB.2.11.1501161618080.5526@nanos> <54B97A72.2050205@gmail.com> <D0DEECA2.B7EAD%dvhart@linux.intel.com> <alpine.DEB.2.11.1501191144320.5526@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1501191144320.5526@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>
Cc: mtk.manpages@gmail.com, Carlos O'Donell <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Torvald Riegel <triegel@redhat.com>, Roland McGrath <roland@redhat.com>, Darren Hart <dvhart@infradead.org>, Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>, Eric Dumazet <edumazet@google.com>, bill o gallmeister <bgallmeister@gmail.com>, Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>, Rich Felker <dalias@libc.org>
List-Id: linux-api@vger.kernel.org

On 01/19/2015 11:45 AM, Thomas Gleixner wrote:
> On Fri, 16 Jan 2015, Darren Hart wrote:
>> On 1/16/15, 12:54 PM, "Michael Kerrisk (man-pages)"
>> <mtk.manpages@gmail.com> wrote:
>>
>>> On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
>>>> On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
>>>>
>>>>> Hello Thomas,
>>>>>
>>>>> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
>>>>>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
>>>>>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
>>>>>>>
>>>>>>> ??? I added this, but does this error not occur only for PI requeues?
>>>>>>
>>>>>> It's equally wrong for normal futexes. And its actually the same code
>>>>>> checking for this for all variants.
>>>>>
>>>>> I don't understand "equally wrong" in your reply, I'm sorry. Do you
>>>>> mean:
>>>>>
>>>>> a) This error text should be there for both normal and PI requeues
>>>>
>>>> It is there for both. The requeue code has that check independent of
>>>> the requeue type (normal/pi). It never makes sense to requeue
>>>> something to itself whether normal or pi futex. We added this for PI,
>>>> because there it is harmful, but we did not special case it. So normal
>>>> futexes get the same treatment.
>>>
>>> Hello Thomas, 
>>>
>>> Color me stupid, but I can't see this in futex_requeue(). Where is that
>>> check that is "independent of the requeue type (normal/pi)"?
>>>
>>> When I look through futex_requeue(), all the likely looking sources
>>> of EINVAL are governed by a check on the 'requeue_pi' argument.
>>
>>
>> Right, in the non-PI case, I believe there are valid use cases: move to
>> the back of the FIFO, for example (OK, maybe the only example?). Both
>> tests ensuring uaddr1 != uaddr2 are under the requeue_pi conditional
>> block. The second compares the keys in case they are not FUTEX_PRIVATE
>> (uaddrs would be different, but still the same backing store).
>>
>> Thomas, am I missing a test for this someplace else?
> 
> No, I had a short look at the code misread it. So, yes, it's a valid
> operation for the non PI case. Sorry for the confusion.

Thanks for the confirmation, Thomas. Page updated to remove 
FUTEX_CMP_REQUEUE from that error case.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
