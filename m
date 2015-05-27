From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Wed, 27 May 2015 15:35:58 -0700
Message-ID: <CALCETrUS7vMODCDTrd2XHd4CRW46=7DFCt-Bg94L7UOKrN_H1Q@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <alpine.DEB.2.11.1505150921040.20285@gentwo.org> <CALCETrU5B3aR0s9c7qsktLJ4hiBfs0+LqyVNmq1ZVNfF0zFECQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrU5B3aR0s9c7qsktLJ4hiBfs0+LqyVNmq1ZVNfF0zFECQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, May 18, 2015 at 12:43 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On May 15, 2015 11:31 PM, "Christoph Lameter" <cl@linux.com> wrote:
>>
>> It would be best to start a complete new thread about this. You
>> replied to earlier posts about ambient capabilities and
>> people may not see it as a new release.
>>
>> > pA obeys the invariant that no bit can ever be set in pA if it is
>> > not set in both pP and pI.  Dropping a bit from pP or pI drops that
>> > bit from pA.  This ensures that existing programs that try to drop
>> > capabilities still do so, with a complication.  Because capability
>>
>> Ok that is a good improvement.
>>
>> > inheritance is so broken, setting KEEPCAPS, using setresuid to
>> > switch to nonroot uids, or calling execve effectively drops
>> > capabilities.  Therefore, setresuid from root to nonroot
>> > conditionally clears pA unless SECBIT_NO_SETUID_FIXUP is set.
>> > Processes that don't like this can re-add bits to pA afterwards.
>> >
>> > The capability evolution rules are changed:
>> >
>> >   pA' = (file caps or setuid or setgid ? 0 : pA)
>> >   pP' = (X & fP) | (pI & fI) | pA'
>> >   pI' = pI
>> >   pE' = (fE ? pP' : pA')
>>
>> Isnt this equal to
>>
>>     pE' = (fE & pP') | pA'
>>
>> which does not require conditionals and is symmetric to how pP' is
>> calculated. Your formula seems to indicate that pA' bits are not set if
>> fE is set. However they are already set unconditionally in pP' regardless.
>> This makes it more explicit I think. And I thought we are dealing with
>> bitmask arithmetic here?
>
> I think you're right, except that fE is a Boolean, not a bit mask, so
> fE | pP' is an odd thing to talk about.
>
> We could say (fE ? pP' : 0) | pA', which could simplify the code a tiny bit.

It turns out that would be almost a pure addition of code, so I'll
leave it as is.

--Andy
