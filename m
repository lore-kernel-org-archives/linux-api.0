From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 12:51:57 -0800
Message-ID: <CALCETrUB1bb4TiiBgdAMVtRJcEAoDzuOH+StTLPVL8QiXXdOfQ@mail.gmail.com>
References: <20150224154715.GA20682@mail.hallyn.com> <alpine.DEB.2.11.1502240956400.29006@gentwo.org>
 <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org>
 <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com> <alpine.DEB.2.11.1502261224580.7451@gentwo.org>
 <20150226193200.GA17709@mail.hallyn.com> <alpine.DEB.2.11.1502261412250.7451@gentwo.org>
 <20150226203405.GB18926@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150226203405.GB18926@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christoph Lameter <cl@linux.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 12:34 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, Feb 26, 2015 at 02:13:00PM -0600, Christoph Lameter wrote:
>> On Thu, 26 Feb 2015, Serge E. Hallyn wrote:
>>
>> > Andrew Morgan was against that.  What if we changed
>> >
>> > pE' = pP' & (fE | pA)
>> >
>> > to
>> >
>> >     if (pA)
>> >             pE' = pP' & fE
>> >     else
>> >             pE' = pP'
>> >
>>
>> Same problem as before. The ambient bits will not be set in pE'.
>
> And what if I weren't scatterbrained and we did
>
>         if (pA)
>                 pE' = pP'
>         else
>                 pE' = pP' & fE
>
> All pP' bits would be set in pE'.

That seems reasonable to me, except for my paranoia:

What if there's a program with CAP_DAC_OVERRIDE in fP and fE set to
the empty set (i.e. the magic effective bit cleared), and the program
relies on that.  A malicious user has CAP_NET_BIND and sets pA =
CAP_NET_BIND.  Boom!

If we changed that to if (pA') and zeroed pA if fP is non-empty then
this problem goes away.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
