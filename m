From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] prctl: implement PR_GET_ENDIAN for all architectures
Date: Wed, 1 Feb 2017 21:08:06 -0800
Message-ID: <CALCETrWgoaFHP4BBfJ==p+EhO8mKaKkh-MwuT_Z+hkavYib0FQ@mail.gmail.com>
References: <20170128111310.GA13389@ls3530.fritz.box> <20170131162624.5a85ec47c6ee22e5cc03c4eb@linux-foundation.org>
 <1485990732.2322.40.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1485990732.2322.40.camel@HansenPartnership.com>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org, Michael Kerrisk <mtk.manpages@googlemail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 1, 2017 at 3:12 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2017-01-31 at 16:26 -0800, Andrew Morton wrote:
>> On Sat, 28 Jan 2017 12:13:10 +0100 Helge Deller <deller@gmx.de>
>> wrote:
>>
>> > The prctl(PR_GET_ENDIAN) syscall was added to Kernel 2.6.18, but
>> > implemented for PowerPC only. This trivial patch adds support for
>> > this syscall for all other architectures.
>>
>> Seems reasonable.  I guess.  Why is this needed?
>
> I don't think it is other than for PPC.  If you're not variable endian
> (which is only PPC to date), then you should know a priori what endian
> you are from the #defines in userspace.

I find it vaguely odd even on PPC.  Surely you can tell what your
endianness is directly.  (An API to query the endianness of another
task would be useful, though.)
