From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Fri, 6 Dec 2019 17:03:40 -0800
Message-ID: <CAHk-=wjEa5oNcQ9+9fai1Awqktf+hzz_HZmChi8HZJWcL62+Cw@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <20191206214725.GA2108@latitude> <CAHk-=wga0MPEH5hsesi4Cy+fgaaKENMYpbg2kK8UA0qE3iupgw@mail.gmail.com>
 <20191207000015.GA1757@latitude>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191207000015.GA1757@latitude>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
Cc: David Howells <dhowells@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 6, 2019 at 4:00 PM Johannes Hirte
<johannes.hirte@datenkhaos.de> wrote:
>
> Tested with 5.4.0-11505-g347f56fb3890 and still the same wrong behavior.

Ok, we'll continue looking.

That said, your version string is strange.

Commit 347f56fb3890 should be  "v5.4.0-13174-g347f56fb3890", the fact
that you have "11505" confuses me.

The hash is what matters, but I wonder what is going on that you have
the commit count in that version string so wrong.

                   Linus
