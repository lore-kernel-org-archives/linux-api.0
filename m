From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 00:24:52 -0600
Message-ID: <20180108062452.GA21717@mail.hallyn.com>
References: <20171205223052.12687-1-mahesh@bandewar.net>
 <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost>
 <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.20.1801081131190.8436@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <james.l.morris@oracle.com>
Cc: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 08, 2018 at 11:35:26AM +1100, James Morris wrote:
> On Tue, 2 Jan 2018, Mahesh Bandewar (महेश बंडेवार) wrote:
> 
> > On Sat, Dec 30, 2017 at 12:31 AM, James Morris
> > <james.l.morris@oracle.com> wrote:
> > > On Wed, 27 Dec 2017, Mahesh Bandewar (महेश बंडेवार) wrote:
> > >
> > >> Hello James,
> > >>
> > >> Seems like I missed your name to be added into the review of this
> > >> patch series. Would you be willing be pull this into the security
> > >> tree? Serge Hallyn has already ACKed it.
> > >
> > > Sure!
> > >
> > Thank you James.
> 
> I'd like to see what Eric Biederman thinks of this.
> 
> Also, why do we need the concept of a controlled user-ns at all, if the 
> default whitelist maintains existing behavior?

In past discussions two uses have been brought up:

1. if an 0-day is discovered which is exacerbated by a specific
privilege in user namespaces, that privilege could be turned off until a
reboot with a fixed kernel is scheduled, without fully disabling all
containers.

2. some systems may be specifically designed to run software which
only requires a few capabilities in a userns.  In that case all others
could be disabled.
