From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Mon, 23 Feb 2015 08:33:58 -0800
Message-ID: <CALCETrW78805ayUL=ZYBdFwVdDvJZus2JL0VVmEBE8=L1Nm5Sw@mail.gmail.com>
References: <alpine.DEB.2.11.1502051554500.4876@gentwo.org>
 <alpine.DEB.2.11.1502230856400.21238@gentwo.org> <20150223161625.GD25477@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150223161625.GD25477@ubuntumail>
Sender: linux-kernel-owner@vger.kernel.org
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Christoph Lameter <cl@linux.com>, Serge Hallyn <serge.hallyn@canonical.com>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 23, 2015 at 8:16 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Christoph Lameter (cl@linux.com):
>> Ok 4.0-rc1 is out and this patch has been sitting here for a couple of
>> weeks without comment after an intensive discussion about the RFCs.
>>
>> Since there were no objections: Is there any chance to get this into -next
>> somehow?
>
> Andrew Morgan and Andy Lutomirski appear to have a similar concern
> but competing ideas on how to address them.  We need them to agree
> on an approach.
>
> The core concern for amorgan is that an unprivileged user not be
> able to cause a privileged program to run in a way that it fails to
> drop privilege before running unprivileged-user-provided code.
>
> Andy Lutomirski's concern is simply that code which is currently
> doing the right thing to drop privilege not be run in a way that
> it thinks it is dropping privilege, but in fact is not.
>

I share both concerns.

> (Please correct me where I've mis-spoken or misunderstood)
>
> Since your desire is precisely for a mode where dropping privilege
> works as usual, but exec then re-gains some or all of that privilege,
> we need to either agree on a way to enter that mode that ordinary
> use caes can't be tricked into using, or find a way for legacy
> users to be tpiped off as to what's going on (without having to be
> re-written)

Is there really a need to drop privilege and then regain it or is it
sufficient to keep the privilege permitted (and perhaps ambient, too)
and just to have execve not drop it for you?  I assume the latter.

--Andy
