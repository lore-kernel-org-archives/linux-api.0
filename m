From: Johannes Hirte <johannes.hirte@datenkhaos.de>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Sun, 8 Dec 2019 18:56:02 +0100
Message-ID: <20191208175602.GA1844@latitude>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <20191206214725.GA2108@latitude>
 <CAHk-=wga0MPEH5hsesi4Cy+fgaaKENMYpbg2kK8UA0qE3iupgw@mail.gmail.com>
 <20191207000015.GA1757@latitude>
 <CAHk-=wjEa5oNcQ9+9fai1Awqktf+hzz_HZmChi8HZJWcL62+Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wjEa5oNcQ9+9fai1Awqktf+hzz_HZmChi8HZJWcL62+Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2019 Dez 06, Linus Torvalds wrote:
> On Fri, Dec 6, 2019 at 4:00 PM Johannes Hirte
> <johannes.hirte@datenkhaos.de> wrote:
> >
> > Tested with 5.4.0-11505-g347f56fb3890 and still the same wrong behavior.
> 
> Ok, we'll continue looking.
> 
> That said, your version string is strange.
> 
> Commit 347f56fb3890 should be  "v5.4.0-13174-g347f56fb3890", the fact
> that you have "11505" confuses me.
> 
> The hash is what matters, but I wonder what is going on that you have
> the commit count in that version string so wrong.
> 
>                    Linus

Yes, something got messed up here. After last pull, git describe says:

drm-next-2019-12-06-11662-g9455d25f4e3b

whereas with a fresh cloned repo I get:

v5.4-13331-g9455d25f4e3b

I assume the later is right. With this version the bug seems to be
fixed, regardless of the commit count. Tested with different websites
and firefox works as expected again.


-- 
Regards,
  Johannes Hirte
