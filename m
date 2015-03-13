From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 12:03:25 -0700
Message-ID: <CALCETrV7vDJVhM_AgtGn8ENStcyxZBwCw3zhSn-whArT_XPg8A@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
 <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
 <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
 <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
 <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com> <CAGXu5jLiLsXN2-RAbPJh7ZursuTroi5DAs=VTz2kyAZ2urNvgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLiLsXN2-RAbPJh7ZursuTroi5DAs=VTz2kyAZ2urNvgA@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 11:52 AM, Kees Cook <keescook@chromium.org> wrote:
>
> All this said, almost half of the capabilities, if passed to flawed
> children with attacker controlled execution, can be elevated to full
> root privileges pretty easily[1], so I think any documentation around
> this feature should include some pretty dire warnings about using
> this.

That's a good point.  I'll make sure to document that.

It's worth noting that, for many applications, that list is
overstated.  For example, many of the suggested privilege escalations
don't work if you're in a sufficiently restrictive mount namespace.

For my own use, I plan on adding only CAP_NET_BIND_SERVICE and
CAP_NET_RAW to pA, and I'll be layering seccomp on top to the extent
possible.

--Andy

>
> -Kees
>
> [1] https://forums.grsecurity.net/viewtopic.php?f=7&t=2522
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC
