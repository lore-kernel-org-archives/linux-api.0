From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 24 Apr 2015 15:13:31 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504241512570.11839@gentwo.org>
References: <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com> <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com> <CALCETrWRHRVLotFs=Cpdr=7KjE7q52NdT62GxZg=xjv+LFZBqw@mail.gmail.com> <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
 <alpine.DEB.2.11.1503300754070.5031@gentwo.org> <CALCETrW9ckw=7-1JSyFkenhFu2_1MvVqjA+inOmsuuWemGaU0w@mail.gmail.com> <alpine.DEB.2.11.1504091024540.13650@gentwo.org> <alpine.DEB.2.11.1504230900260.32203@gentwo.org> <20150424175348.GL16377@ubuntumail>
 <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com> <20150424190935.GN16377@ubuntumail> <CALCETrV7S0dLkNWMSYsL7MFuLgdpQwUEAjW6zTwRE8uhh_AuBQ@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrV7S0dLkNWMSYsL7MFuLgdpQwUEAjW6zTwRE8uhh_AuBQ@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, 24 Apr 2015, Andy Lutomirski wrote:

> That's sort of what my patch does -- you need CAP_SETPCAP to switch
> the securebit.
>
> But Christoph's patch required it to add caps to the ambient set, right?

Yes but you seem to be just adding one additional step without too much of
a benefit because you still need CAP_SETPCAP.

