From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Mon, 27 Apr 2015 09:55:51 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504270953470.28858@gentwo.org>
References: <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com> <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com> <CALCETrWRHRVLotFs=Cpdr=7KjE7q52NdT62GxZg=xjv+LFZBqw@mail.gmail.com> <CALQRfL7AyadFcu9JqtC6FGnuuqY7zbnFAL81XnwBvn0o6c6UWQ@mail.gmail.com>
 <alpine.DEB.2.11.1503300754070.5031@gentwo.org> <CALCETrW9ckw=7-1JSyFkenhFu2_1MvVqjA+inOmsuuWemGaU0w@mail.gmail.com> <alpine.DEB.2.11.1504091024540.13650@gentwo.org> <alpine.DEB.2.11.1504230900260.32203@gentwo.org> <20150424175348.GL16377@ubuntumail>
 <CALCETrW5_85mFFTkzCVNA5N1KQeNBrkw2d8FF3H3LYtmz6UAPw@mail.gmail.com> <20150424190935.GN16377@ubuntumail> <CALCETrV7S0dLkNWMSYsL7MFuLgdpQwUEAjW6zTwRE8uhh_AuBQ@mail.gmail.com> <alpine.DEB.2.11.1504241512570.11839@gentwo.org>
 <CALCETrUrFm9n_4xTj4ELkzTSnWHfxQtANqz2wpzU7riTihLDaA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALCETrUrFm9n_4xTj4ELkzTSnWHfxQtANqz2wpzU7riTihLDaA@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linuxfoundation.org>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, 24 Apr 2015, Andy Lutomirski wrote:

> Also, in my model you can do:
>
> $ sudo capset cap_whatever=eip something
> $ ./something
>
> and the program can make its cap be ambient and run a helper.  In the
> CAP_SETPCAP model, that doesn't work.

Dont see too much difference in setting caps and CAP_SETPCAP on
"./something" to allow it to set the ambient caps.
