From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: Kernel lockdown patch & IPAddressAllow/IPAddressDeny systemd
 feature with Secure Boot
Date: Wed, 15 Aug 2018 19:10:38 -0700
Message-ID: <20180816021037.6yxi5rqolhqxipza@ast-mbp.dhcp.thefacebook.com>
References: <20180807212531.25161.63476@mailman01.phx2.fedoraproject.org>
 <CALeDE9ORLoyiUcf8Bmwr2rPyo7-3d8Fo54WuPGWtv4ByE_JG=Q@mail.gmail.com>
 <CAObL_7GOOQ01NPf4y1MqRJh4S=CYV8NPmEGTbkrTcjrfUKc5LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAObL_7GOOQ01NPf4y1MqRJh4S=CYV8NPmEGTbkrTcjrfUKc5LA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, ast@kernel.org, Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Kernel Fedora <kernel@lists.fedoraproject.org>, daniel@iogearbox.net
List-Id: linux-api@vger.kernel.org

On Tue, Aug 14, 2018 at 07:14:00AM -0700, Andrew Lutomirski wrote:
> [Removed Fedora devel list because it's subscriber-only]
> 
> > On Aug 8, 2018, at 12:29 AM, Peter Robinson <pbrobinson@gmail.com> wrote:
> >
> > Probably a good idea to cc: this to the kernel list :-)
> >
> > I suspect it's intentional but with the planned changes for iptables
> > etc to be backed by bpf in the upstream kernel sometime in the future
> > it's likely going to need to be reviewed.
> >
> 
> I thought this got covered in review. I think this part of lockdown
> needs to get reverted or fixed ASAP.

I don't see lockdown in Linus's tree. Is this fedora only issue?

> (I definitely brought up multiple issues with the bpf lockdown stuff.
> It's clearly extremely broken right now in the "new kernel breaks
> *current* Linux distro" sense.)

+1
