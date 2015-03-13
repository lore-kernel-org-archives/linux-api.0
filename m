From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 11:06:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1503131049150.13899@gentwo.org>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org> <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com> <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com> <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Jonathan Corbet <corbet@lwn.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 13 Mar 2015, Andrew G. Morgan wrote:

> > prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_SYS_ADMIN);
> > system("/bin/bash");
>
> Let's call the above two lines [a] and [b]. With this patch, you are
> encouraging folk to write programs that contain a line like [a]
> already. So, yes, I am saying that you are creating an exploitable
> path in these programs that says if someone can inject
> system("/bin/bash") into these programs they can get a new (because of
> this patch) privilege escalation.

Well this is what one naively expects capabilities to give you. An ability
to avoid full superuser binaries by segmenting off capabilities. Often
there is really no other choice. If you do not provide this mode then
the system will be even less secure since people run stuff as root.

This looks to many like the design of capabilties is inherent flawed since
it does not give you what you need. You experience a go around that leads
nowhere and just wastes your time.

> In the prevailing model, this kind of privilege escalation (resulting
> from naive inheritance) is designed out. I recognize that you want to
> add it back in, but I am concerned that you are not allowing for the
> possibility that some folk might still want to still be able to
> prevent it.

The functionalty here depends on CAP_SETPCAP. That was intended as some
point to be off by default? You can have distros/kernels with that being
off.
