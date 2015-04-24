From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 24 Apr 2015 11:41:39 -0700
Message-ID: <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com>
References: <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com>
 <CALQRfL5FGGUnK7+Ss=MSDGmxpAERTUjezardGnH3QouBwhbZ4A@mail.gmail.com>
 <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com>
 <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com>
 <CALCETrWRHRVLotFs=Cpdr=7KjE7q52NdT62GxZg=xjv+LFZBqw@mail.gmail.com>
 <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
 <alpine.DEB.2.11.1503300754070.5031@gentwo.org> <CALCETrW9ckw=7-1JSyFkenhFu2_1MvVqjA+inOmsuuWemGaU0w@mail.gmail.com>
 <alpine.DEB.2.11.1504091024540.13650@gentwo.org> <alpine.DEB.2.11.1504230900260.32203@gentwo.org>
 <20150424175348.GL16377@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150424175348.GL16377@ubuntumail>
Sender: linux-kernel-owner@vger.kernel.org
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Christoph Lameter <cl@linux.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 24, 2015 at 10:53 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Christoph Lameter (cl@linux.com):
>> On Thu, 9 Apr 2015, Christoph Lameter wrote:
>>
>> > > I'll submit a new version this week with the securebits.  Sorry for the delay.
>>  > Are we going to get a new version?
>>
>> Replying to my own here. Cant we simply use the SETPCAP approach as per
>> the patch I posted?
>
> Andy had objections to that, but it seems ok to me.
>

I object because CAP_SETPCAP is very powerful whereas
CAP_NET_BIND_SERVICE, for example, isn't.  I'm fine with having a
switch to turn off ambient caps, but requiring the "on" state to give
processes superpowers seems unfortunate.

Sorry for the huge delay.  I got caught up with travel and the merge
window.  Here's a sneak peek:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=cap_ambient

I need to write the user code to go with it and test it a bit before
sending it out for real.

--Andy
