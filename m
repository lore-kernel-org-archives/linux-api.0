From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] pkeys: Introduce PKEY_ALLOC_SIGNALINHERIT and change
 signal semantics
Date: Tue, 8 May 2018 14:40:46 +0200
Message-ID: <314e1a48-db94-9b37-8793-a95a2082c9e2@redhat.com>
References: <20180502132751.05B9F401F3041@oldenburg.str.redhat.com>
 <248faadb-e484-806f-1485-c34a72a9ca0b@intel.com>
 <822a28c9-5405-68c2-11bf-0c282887466d@redhat.com>
 <57459C6F-C8BA-4E2D-99BA-64F35C11FC05@amacapital.net>
 <6286ba0a-7e09-b4ec-e31f-bd091f5940ff@redhat.com>
 <CALCETrVrm6yGiv6_z7RqdeB-324RoeMmjpf1EHsrGOh+iKb7+A@mail.gmail.com>
 <b2df1386-9df9-2db8-0a25-51bf5ff63592@redhat.com>
 <CALCETrW_Dt-HoG4keFJd8DSD=tvyR+bBCFrBDYdym4GQbfng4A@mail.gmail.com>
 <20180503021058.GA5670@ram.oc3035372033.ibm.com>
 <CALCETrXRQF08exQVZqtTLOKbC8Ywq5x4EYH_1D7r5v9bdOSwbg@mail.gmail.com>
 <927c8325-4c98-d7af-b921-6aafcf8fe992@redhat.com>
 <CALCETrX46wR_MDW=m9SVm=ejQmPAmD3+2oC3iapf75bPhnEAWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CALCETrX46wR_MDW=m9SVm=ejQmPAmD3+2oC3iapf75bPhnEAWQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, linuxram@us.ibm.com, Dave Hansen <dave.hansen@intel.com>, linux-x86_64@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On 05/08/2018 04:49 AM, Andy Lutomirski wrote:
> On Mon, May 7, 2018 at 2:48 AM Florian Weimer <fweimer@redhat.com> wrote:
> 
>> On 05/03/2018 06:05 AM, Andy Lutomirski wrote:
>>> On Wed, May 2, 2018 at 7:11 PM Ram Pai <linuxram@us.ibm.com> wrote:
>>>
>>>> On Wed, May 02, 2018 at 09:23:49PM +0000, Andy Lutomirski wrote:
>>>>>
>>>>>> If I recall correctly, the POWER maintainer did express a strong
>>> desire
>>>>>> back then for (what is, I believe) their current semantics, which my
>>>>>> PKEY_ALLOC_SIGNALINHERIT patch implements for x86, too.
>>>>>
>>>>> Ram, I really really don't like the POWER semantics.  Can you give
> some
>>>>> justification for them?  Does POWER at least have an atomic way for
>>>>> userspace to modify just the key it wants to modify or, even better,
>>>>> special load and store instructions to use alternate keys?
>>>
>>>> I wouldn't call it POWER semantics. The way I implemented it on power
>>>> lead to the semantics, given that nothing was explicitly stated
>>>> about how the semantics should work within a signal handler.
>>>
>>> I think that this is further evidence that we should introduce a new
>>> pkey_alloc() mode and deprecate the old.  To the extent possible, this
>>> thing should work the same way on x86 and POWER.
> 
>> Do you propose to change POWER or to change x86?
> 
> Sorry for being slow to reply.  I propose to introduce a new
> PKEY_ALLOC_something variant on x86 and POWER and to make the behavior
> match on both.

So basically implement PKEY_ALLOC_SETSIGNAL for POWER, and keep the 
existing (different) behavior without the flag?

Ram, would you be okay with that?  Could you give me a hand if 
necessary?  (I assume we have silicon in-house because it's a 
long-standing feature of the POWER platform which was simply dormant on 
Linux until now.)

> It should at least update the values loaded when a signal
> is delivered and it should probably also update it for new threads.

I think we should keep inheritance for new threads and fork.  pkey_alloc 
only has a single access rights argument, which makes it hard to reuse 
this interface if there are two (three) separate sets of access rights.

Is there precedent for process state reverting on fork, besides 
MADV_WIPEONFORK?  My gut feeling is that we should avoid that.

> For glibc, for example, I assume that you want signals to be delivered with
> write access disabled to the GOT.  Otherwise you would fail to protect
> against exploits that occur in signal context.  Glibc controls thread
> creation, so the initial state on thread startup doesn't really matter, but
> there will be more users than just glibc.

glibc does not control thread, or more precisely, subprocess creation. 
Otherwise we wouldn't have face that many issues with our PID cache. 8-/

Thanks,
Florian
